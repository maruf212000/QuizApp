//
//  PanesManager.swift
//  QuizApp
//
//  Created by Maruf Memon on 09/04/24.
//

import UIKit

let kPanes = PanesManager.shared

class PanesManager: NSObject {
    static let shared = PanesManager()
    
    var navigationController: UINavigationController?
    
    private override init() {
        
    }
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: Bundle.main)
    }
    
    func showMainQuizView() {
        let vc = mainStoryboard().instantiateViewController(withIdentifier: "Quiz Screen")
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showStartQuizView() {
        let vc = mainStoryboard().instantiateViewController(withIdentifier: "Start Quiz")
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showCompletionQuizView(points: String) {
        let vc = mainStoryboard().instantiateViewController(withIdentifier: "Complete Quiz") as! QuizCompletionViewController
        vc.points = points
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
