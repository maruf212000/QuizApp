//
//  CustomView.swift
//  QuizApp
//
//  Created by Maruf Memon on 09/04/24.
//

import UIKit

enum cornerRadiusType: Int {
    case none
    case topRightCorner
    case topLeftCorner
    case bottomLeftCorner
    case bottomRightCorner
    case topCorners
    case bottomCorners
    case leftCorners
    case rightCorners
    case allCorners
}

class CustomView: UIView {
    
    var cornerMaskType: cornerRadiusType = .none
    @IBInspectable var cornerMask: Int {
        set {
            cornerMaskType = cornerRadiusType(rawValue: newValue) ?? .none
        }
        get {
            return cornerMaskType.rawValue
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        if (cornerMaskType != .none && cornerRadius > 0) {
            clipsToBounds = true
            layer.cornerRadius = self.cornerRadius
            var maskedCorners: CACornerMask = []
            if (cornerMaskType == .allCorners || cornerMaskType == .leftCorners || cornerMaskType == .topCorners || cornerMaskType == .topLeftCorner) {
                maskedCorners.insert(.layerMinXMinYCorner)
            }
            if (cornerMaskType == .allCorners || cornerMaskType == .rightCorners || cornerMaskType == .topCorners || cornerMaskType == .topRightCorner) {
                maskedCorners.insert(.layerMaxXMinYCorner)
            }
            if (cornerMaskType == .allCorners || cornerMaskType == .leftCorners || cornerMaskType == .bottomCorners || cornerMaskType == .bottomLeftCorner) {
                maskedCorners.insert(.layerMinXMaxYCorner)
            }
            if (cornerMaskType == .allCorners || cornerMaskType == .rightCorners || cornerMaskType == .bottomCorners || cornerMaskType == .bottomRightCorner) {
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
            layer.maskedCorners = maskedCorners
        }
    }

}
