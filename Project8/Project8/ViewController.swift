//
//  ViewController.swift
//  Project8
//
//  Created by Allan Amaral on 11/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Reactive Properties
    lazy var gameView = GameView()
    
    var currentAnswer = "" {
        didSet {
            gameView.set(currentAnswer: currentAnswer)
        }
    }
    
    var clues = "" {
        didSet {
            gameView.set(clues: clues)
        }
    }
    
    var answers = "" {
        didSet {
            gameView.set(answer: answers)
        }
    }
    
    var letterBits = [String]() {
        didSet {
            gameView.set(letterBits: letterBits)
        }
    }
    
    var score = 0 {
        didSet {
            gameView.set(score: score)
        }
    }
    
    // MARK: - Life Cycle Methods

    override func loadView() {
        super.loadView()
        
        gameView.delegate = self
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    
    // MARK: - Game Logic
    var solutions = [String]()
    var activatedButtonsIndices = [Int]()
    
    var level = 1
    var matches = 0
    
    private func levelUp() {
        level += 1
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }

    @objc private func loadLevel() {
        var clueString = ""
        var answerString = ""
        var letterBitsArray = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                let lines = levelContents.components(separatedBy: "\n").shuffled()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    answerString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBitsArray += bits
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.clues = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answers = answerString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.letterBits = letterBitsArray.shuffled()
        }
    }

}

extension ViewController: GameViewDelegate {
    
    func submitTapped() {
        if let solutionPosition = solutions.firstIndex(of: currentAnswer) {
            var answerLines = answers.components(separatedBy: "\n")
            answerLines[solutionPosition] = currentAnswer
            answers = answerLines.joined(separator: "\n")
            
            currentAnswer = ""
            score += 3
            matches += 1
            activatedButtonsIndices.removeAll()
            
            if matches % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default) { [weak self] _ in self?.levelUp() })
                present(ac, animated: true)
            }
        } else {
            score -= 1
            let alertController = UIAlertController(title: "Nope!", message: "You entered a wrong answer.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            present(alertController, animated: true)
        }
    }
    
    func clearTapped() {
        currentAnswer = ""
        for index in activatedButtonsIndices {
            gameView.showButton(at: index)
        }
        activatedButtonsIndices.removeAll()
    }
    
    func letterButttonTapped(at index: Int, with text: String) {
        currentAnswer += text
        activatedButtonsIndices.append(index)
        gameView.hideButton(at: index)
    }
    
}

