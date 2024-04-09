//
//  OptionTableViewCell.swift
//  QuizApp
//
//  Created by Maruf Memon on 06/04/24.
//

import UIKit

enum OptionState: Int {
    case none = 0
    case correct
    case incorrect
}

class OptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.layer.borderColor = UIColor.primary.cgColor
    }
    
    func update(with answer: String, state: OptionState, idx: Int) {
        self.answerLabel.text = answer
        self.accessibilityLabel = self.isAccessibilityElement ? "Option \(idx + 1): \(answer)" : nil
        parentView.layer.backgroundColor = UIColor.white.cgColor
        answerLabel.textColor = UIColor.black
        if (state == .correct) {
            parentView.layer.borderColor = UIColor.systemGreen.cgColor
            parentView.layer.backgroundColor = UIColor.systemGreen.cgColor
            answerLabel.textColor = UIColor.white
        } else if (state == .incorrect) {
            parentView.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            parentView.layer.borderColor = UIColor.primary.cgColor
        }
    }

}
