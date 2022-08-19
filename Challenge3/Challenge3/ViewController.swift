//
//  ViewController.swift
//  Challenge3
//
//  Created by Allan Amaral on 11/08/22.
//

import UIKit

struct Word {
    let answer: String
    let clue: String
}

class ViewController: UIViewController {
    
    // MARK: - Reactive Properties
    lazy var gameView = GameView()
    
    var currentAnswer = "" {
        didSet {
            gameView.set(currentAnswer: currentAnswer)
        }
    }
    
    var score = 0 {
        didSet {
            gameView.set(score: score)
        }
    }
    
    var clue = "" {
        didSet {
            gameView.set(clue: clue)
        }
    }
    
    var chances = 6 {
        didSet {
            gameView.set(chances: chances)
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
        
        performSelector(inBackground: #selector(loadWords), with: nil)
    }
    
    // MARK: - Game Logic
    var words = [Word]()
    var currentWord: Word?
    var activatedButtonsIndices = [Int]()
    var errors = 0

    @objc private func loadWords() {
        var levelWords = [Word]()
        
        if let levelFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                let lines = levelContents
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: "\n")
                    .shuffled()
                
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let word = Word(answer: parts[0], clue: parts[1])
                    
                    levelWords.append(word)
                }
            }
        }
        
        words = levelWords
        
        performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
    }
    
    @objc private func startGame() {
        currentWord = words.popLast()
        guard let currentWord = currentWord else { return }
        
        chances = 6
        clue = currentWord.clue
        currentAnswer = currentWord.answer
            .map { _ in return "_"}
            .joined(separator: "")
        gameView.resetButtons()
    }
    
    private func select(letter: String) {
        guard let currentWord = currentWord?.answer else { return }
        
        var answerCharacters = Array(currentAnswer)
        var foundMatch = false
        
        for (index, currentLetter) in currentWord.enumerated() {
            if letter == String(currentLetter) {
                foundMatch = true
                answerCharacters[index] = currentLetter
            }
        }
        
        if foundMatch {
            currentAnswer = String(answerCharacters)
            if currentAnswer == currentWord {
                score += 1
                startGame()
            }
        } else {
            chances -= 1
            if chances <= 0 {
                let alert = UIAlertController(title: "Game Over", message: "You are out of tries", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                    self?.score = 0
                    self?.loadWords()
                })
                present(alert, animated: true)
            }
        }
    }

}

extension ViewController: GameViewDelegate {
    
//    func submitTapped() {
//        if let solutionPosition = solutions.firstIndex(of: currentAnswer) {
//            currentAnswer = ""
//            score += 3
//            matches += 1
//            activatedButtonsIndices.removeAll()
//
//            if matches % 7 == 0 {
//                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "Let's go!", style: .default) { [weak self] _ in self?.levelUp() })
//                present(ac, animated: true)
//            }
//        } else {
//            score -= 1
//            let alertController = UIAlertController(title: "Nope!", message: "You entered a wrong answer.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
//            present(alertController, animated: true)
//        }
//    }
    
    func letterButttonTapped(at index: Int, with letter: String) {
        activatedButtonsIndices.append(index)
        gameView.hideButton(at: index)
        select(letter: letter)
    }
    
}

