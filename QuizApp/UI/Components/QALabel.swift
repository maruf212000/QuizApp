//
//  QALabel.swift
//  QuizApp
//
//  Created by Maruf Memon on 09/04/24.
//

import UIKit

class QALabel: UILabel {

    @IBInspectable var accessibilityFormat: String!
    
    override public var text: String? {
        set {
            super.text = newValue
            updateAccessibilityLabel()
        }
        get {
            return super.text
        }
    }
    
    func updateAccessibilityLabel() {
        if let accessibilityFormat = accessibilityFormat, accessibilityFormat.count > 0  {
            self.accessibilityLabel = accessibilityFormat.replacingOccurrences(of: "%@", with: self.text ?? "")
        }
    }

}
