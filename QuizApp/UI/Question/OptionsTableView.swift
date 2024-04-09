//
//  OptionsTableView.swift
//  QuizApp
//
//  Created by Maruf Memon on 10/04/24.
//

import UIKit

protocol OptionSelectionDelegate {
    func selectedAnswer(_ answer: String)
}

class OptionsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var question: Question? = nil
    var answerIdx: Int = Int(arc4random_uniform(4))
    var selectedIdx: Int = -1
    var answerDelegate: OptionSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
    }
    
    func update(question: Question) {
        selectedIdx = -1
        answerIdx = Int(arc4random_uniform(4))
        self.question = question
        self.reloadData()
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
        answerDelegate?.selectedAnswer(option(for: indexPath))
        selectedIdx = indexPath.item
        tableView.reloadData()
    }
}
