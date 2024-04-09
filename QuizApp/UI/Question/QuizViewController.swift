//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Maruf Memon on 10/04/24.
//

import UIKit
import Combine

class QuizViewController: UIViewController, OptionSelectionDelegate {

    
    @IBOutlet weak var pointsLabel: QALabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var questionView: CustomView!
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionTableView: OptionsTableView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var loadingIndicator: UIActivityIndicatorView?
    
    private var cancellables = Set<AnyCancellable>()
    var questions: [Question] = []
    var answers: [String] = []
    var correctAnswers: Int = 0
    var currentIdx: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionTableView.answerDelegate = self
        setupLoadingIndicator()
        startQuiz()
    }

    func setupLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.color = UIColor.black
        questionView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.isHidden = true
        questionView.addConstraints([
            loadingIndicator.centerXAnchor.constraint(equalTo: questionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: questionView.centerYAnchor)
        ])
        self.loadingIndicator = loadingIndicator
    }
    
    func stopLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
    
    func startQuiz() {
        questionLabel.text = ""
        questionNoLabel.text = ""
        answers = []
        questions = []
        nextBtn.isHidden = true
        nextBtn.setTitle("Next Question", for: .normal)
        loadingIndicator?.isHidden = false
        loadingIndicator?.startAnimating()
        progressView.progress = 0
        pointsLabel.text = "0"
        
        QuizService.shared.fetchQuestions()
            .sink { [unowned self] completion in
                stopLoadingIndicator()
                if case let .failure(error) = completion {
                    self.showErrorView(error: error)
                }
            } receiveValue: { questions in
                self.questions = questions
                self.showNextQuestion()
            }
            .store(in: &self.cancellables)
    }
    
    func showNextQuestion() {
        let idx = answers.count
        if (currentIdx == idx) {
            return
        }
        currentIdx = idx
        let question = questions[idx]
        self.questionNoLabel.text = "Question \(idx + 1) of \(questions.count)".uppercased()
        self.questionLabel.text = question.question
        self.optionTableView.update(question: question)
        self.nextBtn.isHidden = true
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if (questions.count == 0) {
            kPanes.showStartQuizView()
        }
        if (currentIdx + 1 < questions.count) {
            showNextQuestion()
            self.nextBtn.setTitle(answers.count + 1 == questions.count ? "Submit" : "Next Question", for: .normal)
        } else if (answers.count == questions.count) {
            kPanes.showCompletionQuizView(points: pointsLabel.text ?? "0")
        }
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
    
    func selectedAnswer(_ answer: String) {
        let correctAnswer = questions[answers.count].correctAnswer
        answers.append(answer)
        let isAnswerCorrect = correctAnswer == answer
        if (isAnswerCorrect) {
            correctAnswers += 1
        }
        self.nextBtn.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: "\(isAnswerCorrect ? "Correct" : "Incorrect") Answer. You get \(isAnswerCorrect ? 10 : 0) points")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIAccessibility.post(notification: .layoutChanged, argument: self.nextBtn)
            }
        }
        updateProgress()
    }
    
    func updateProgress() {
        progressView.progress = Float(answers.count) / Float(questions.count)
        pointsLabel.text = String(correctAnswers * 10)
    }
    
}
