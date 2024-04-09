//
//  StartQuizViewController.swift
//  QuizApp
//
//  Created by Maruf Memon on 06/04/24.
//

import UIKit

class StartQuizViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kPanes.navigationController = self.navigationController
    }

    @IBAction func didPressStartQuizBtn(_ sender: Any) {
        kPanes.showMainQuizView()
    }
    
}
