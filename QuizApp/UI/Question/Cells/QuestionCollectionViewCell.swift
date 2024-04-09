//
//  QuestionCollectionViewCell.swift
//  QuizApp
//
//  Created by Maruf Memon on 06/04/24.
//

import UIKit

protocol QuestionCollectionViewCellDelegate {
    func selectedAnswer(_ answer: String)
}

class QuestionCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    
    var question: Question? = nil
    var answerIdx: Int = Int(arc4random_uniform(4))
    var selectedIdx: Int = -1
    var delegate: QuestionCollectionViewCellDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(with question: Question, index: Int, total: Int) {
        self.question = question
        answerIdx = Int(arc4random_uniform(4))
        selectedIdx = -1
        questionNoLabel.text = "Question \(index + 1) of \(total)".uppercased()
        questionLabel.text = question.question
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.reloadData()
    }
    
    func option(for indexPath: IndexPath) -> String {
        guard let question = question else {
            return ""
        }
        if (indexPath.item == answerIdx) {
            return question.correctAnswer
        } else if (indexPath.item > answerIdx) {
            return question.incorrectAnswers[indexPath.item - 1]
        } else {
            return question.incorrectAnswers[indexPath.item]
        }
    }
    
    func state(for indexPath: IndexPath) -> OptionState {
        if (indexPath.item == answerIdx && selectedIdx != -1) {
            return OptionState.correct
        }
        if (indexPath.item == selectedIdx && indexPath.item != answerIdx) {
            return OptionState.incorrect
        }
        return OptionState.none
    }
    
    // MARK: - Table View Delegate & Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (question?.incorrectAnswers.count ?? -1) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = option(for: indexPath)
        let cell: OptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Option Cell", for: indexPath) as! OptionTableViewCell
        cell.isAccessibilityElement = selectedIdx == -1
        cell.update(with: option, state: state(for: indexPath), idx: indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectedIdx != -1) {
            return
        }
        delegate?.selectedAnswer(option(for: indexPath))
        selectedIdx = indexPath.item
        tableView.reloadData()
        self.isAccessibilityElement = true
        self.accessibilityLabel = "\(answerIdx == selectedIdx ? "Correct" : "Incorrect") Answer. You get \(answerIdx == selectedIdx ? 10 : 0) points"
    }
}
