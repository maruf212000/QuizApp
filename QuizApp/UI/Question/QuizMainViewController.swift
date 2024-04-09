//
//  QuizMainViewController.swift
//  QuizApp
//
//  Created by Maruf Memon on 06/04/24.
//

import UIKit
import Combine

class QuizMainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, QuestionCollectionViewCellDelegate {

    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private var cancellables = Set<AnyCancellable>()
    var questions: [Question] = []
    var answers: [String] = []
    var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionCollectionView.dataSource = self
        questionCollectionView.delegate = self
        setupLoadingIndicator()
        startQuiz()
    }
    
    func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.isHidden = true
        view.addConstraints([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func startQuiz() {
        answers = []
        questions = []
        nextBtn.isHidden = true
        nextBtn.setTitle("Next Question", for: .normal)
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        progressView.progress = 0
        pointsLabel.text = "0"
        
        QuizService.shared.fetchQuestions()
            .sink { [unowned self] completion in
                loadingIndicator.stopAnimating()
                if case let .failure(error) = completion {
                    self.showErrorView(error: error)
                }
                self.nextBtn.isHidden = false
            } receiveValue: { questions in
                self.questions = questions
                self.questionCollectionView.reloadData()
            }
            .store(in: &self.cancellables)
    }

    func showErrorView(error: Error) {
        nextBtn.setTitle("Retry", for: .normal)
        let errorLabel = UILabel()
        errorLabel.text = "Oops! Something went wrong"
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        print("Error: \(error)")
    }
    
    func updateProgress() {
        progressView.progress = Float(answers.count) / Float(questions.count)
        pointsLabel.text = String(correctAnswers * 10)
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if (questions.count == 0) {
            kPanes.showStartQuizView()
        }
        if (answers.count < questions.count) {
            let indexPath = IndexPath(item: answers.count, section: 0)
            if let cell = self.questionCollectionView.cellForItem(at: indexPath) {
                self.questionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                UIAccessibility.post(notification: .layoutChanged, argument: cell)
            }
            self.nextBtn.setTitle(answers.count + 1 == questions.count ? "Submit" : "Next Question", for: .normal)
        } else if (answers.count == questions.count) {
            kPanes.showCompletionQuizView(points: pointsLabel.text ?? "0")
        }
    }
    
    func selectedAnswer(_ answer: String) {
        let correctAnswer = questions[answers.count].correctAnswer
        answers.append(answer)
        if (correctAnswer == answer) {
            correctAnswers += 1
        }
        updateProgress()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIAccessibility.post(notification: .screenChanged, argument: self.nextBtn)
        }
    }
    
    // MARK: - Collection View Delegate & Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question: Question = self.questions[indexPath.item]
        let cell: QuestionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Question Cell", for: indexPath) as! QuestionCollectionViewCell
        cell.update(with: question, index: indexPath.item, total: questions.count)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
