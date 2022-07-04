//
//  ViewController.swift
//  Project2
//
//  Created by Allan Amaral on 03/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var optionsContainer: UIView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var countries = [String]()
    var questionsSoFar = 0
    let numberOfQuestions = 3
    var correctAnswer = 0 {
        didSet {
            countryLabel.text = countries[correctAnswer].uppercased()
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
        }
        
        optionsContainer.layer.cornerRadius = 32
        optionsContainer.clipsToBounds = true
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        questionsSoFar += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        for index in buttons.indices {
            buttons[index].setImage(UIImage(named: countries[index]), for: .normal)
        }
    }
    
    func answerQuestion(with index: Int) {
        var title: String
        var message: String
        
        if index == correctAnswer {
            score += 1
            title = "Correct!"
            message = "Your score is \(score)"
        } else {
            score -= 1
            title = "Wrong!"
            message = "That's the flag of \(countries[index].uppercased())"
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            if self.questionsSoFar >= self.numberOfQuestions {
                self.endGame()
            } else {
                self.askQuestion()
            }
        }))
        
        present(ac, animated: true)
    }
    
    func endGame() {
        let title = "Game Over!"
        let message = "Your score is \(score)/\(numberOfQuestions)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: {_ in
            self.questionsSoFar = 0
            self.score = 0
            self.askQuestion()
        }))
        
        present(ac, animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        answerQuestion(with: sender.tag)
    }
    
}

