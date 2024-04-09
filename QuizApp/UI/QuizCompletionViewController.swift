//
//  QuizCompletionViewController.swift
//  QuizApp
//
//  Created by Maruf Memon on 09/04/24.
//

import UIKit

class QuizCompletionViewController: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    var points: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfetti()
        pointsLabel.text = "You got \(points) Quiz points"
    }
    
    func setupConfetti() {
        let confettiView = ConfettiView(frame: outerView.bounds)
        outerView.addSubview(confettiView)
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            confettiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confettiView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confettiView.topAnchor.constraint(equalTo: view.topAnchor),
            confettiView.heightAnchor.constraint(equalToConstant: 30)
        ])
        confettiView.startConfetti()
    }

    @IBAction func didPressHomeBtn(_ sender: Any) {
        kPanes.showStartQuizView()
    }
}
