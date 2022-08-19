//
//  GameView.swift
//  Challenge3
//
//  Created by Allan Amaral on 11/08/22.
//

import UIKit

protocol GameViewDelegate: AnyObject {
    func letterButttonTapped(at index: Int, with text: String)
}

class GameView: UIView {
    
    weak var delegate: GameViewDelegate?
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Score: 0"
        label.textAlignment = .right
        
        return label
    }()

    lazy var clueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36)
        label.numberOfLines = 0
        label.text = "CLUES"
        label.textAlignment = .center
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        return label
    }()
    
    lazy var currentAnswerField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tap letters to guess"
        textField.isUserInteractionEnabled = false
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 44)
        
        return textField
    }()
    
    lazy var chancesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.text = "6 Chances left"
        label.textAlignment = .center
        label.textColor = .lightGray
        
        return label
    }()
    
    lazy var buttonsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    var letterButtons = [UIButton]()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupVisualElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupVisualElements()
    }
    
    // MARK: - Setup Visual Elements
    
    private func setupVisualElements() {
        backgroundColor = .white
        
        setupScoreLabel()
        setupCluesLabel()
        setupCurrentAnswerField()
        setupChancesLabel()
        setupButtonsContainer()
        setupLetterButtons()
    }
    
    private func setupScoreLabel() {
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupCluesLabel() {
        addSubview(clueLabel)
        
        NSLayoutConstraint.activate([
            clueLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            clueLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 100),
            clueLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -100)
        ])
    }
    
    private func setupCurrentAnswerField() {
        addSubview(currentAnswerField)
        
        NSLayoutConstraint.activate([
            currentAnswerField.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: 20),
            currentAnswerField.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            currentAnswerField.widthAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func setupChancesLabel() {
        addSubview(chancesLabel)
        
        NSLayoutConstraint.activate([
            chancesLabel.topAnchor.constraint(equalTo: currentAnswerField.bottomAnchor, constant: 20),
            chancesLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 100),
            chancesLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -100)
        ])
    }
    
    private func setupButtonsContainer() {
        addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            buttonsContainer.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: chancesLabel.bottomAnchor, constant: 120),
            buttonsContainer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupLetterButtons() {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
        let columns = 7
        let rows = Int(ceil((Double(letters.count) / Double(columns))))
        let buttonWidth = 750 / columns
        let buttonHeight = 320 / rows
        
        for row in 0 ..< 5 {
            for column in 0 ..< columns {
                let index = row * columns + column
                if index >= letters.count {
                    break
                }
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = .systemFont(ofSize: 36)
                letterButton.setTitle(letters[index], for: .normal)
                letterButton.addTarget(self, action: #selector(letterButtonTapped(_:)), for: .touchUpInside)
                letterButton.tag = letterButtons.count
                
                let frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                letterButton.frame = frame
                buttonsContainer.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        delegate?.letterButttonTapped(at: sender.tag, with: sender.titleLabel?.text ?? "")
    }
    
    // MARK: - View Data Setters
    
    func set(clue: String) {
        clueLabel.text = clue
    }
    
    func set(currentAnswer: String) {
        currentAnswerField.text = currentAnswer
            .map { String($0) }
            .joined(separator: " ")
    }
    
    func set(score: Int) {
        scoreLabel.text = "Score \(score)"
    }
    
    func set(chances: Int) {
        chancesLabel.text = "\(chances) Chances left"
    }
    
    func resetButtons() {
        for i in 0 ..< letterButtons.count {
            letterButtons[i].isHidden = false
        }
    }
    
    func hideButton(at index: Int) {
        letterButtons[index].isHidden = true
    }
    
    func showButton(at index: Int) {
        letterButtons[index].isHidden = false
    }
    
}
