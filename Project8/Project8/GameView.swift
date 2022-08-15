//
//  GameView.swift
//  Project8
//
//  Created by Allan Amaral on 11/08/22.
//

import UIKit

protocol GameViewDelegate: AnyObject {
    func submitTapped()
    func clearTapped()
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

    lazy var cluesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.text = "CLUES"
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        return label
    }()
    
    lazy var answersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.text = "ANSWERS"
        label.textAlignment = .right
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
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SUBMIT", for: .normal)
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLEAR", for: .normal)
        button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var buttonsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.borderWidth = 1
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
        setupAnswerLabel()
        setupCurrentAnswerField()
        setupSubmitButton()
        setupClearButton()
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
        addSubview(cluesLabel)
        
        NSLayoutConstraint.activate([
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100)
        ])
    }
    
    private func setupAnswerLabel() {
        addSubview(answersLabel)
        
        NSLayoutConstraint.activate([
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor)
        ])
    }
    
    private func setupCurrentAnswerField() {
        addSubview(currentAnswerField)
        
        NSLayoutConstraint.activate([
            currentAnswerField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswerField.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            currentAnswerField.widthAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func setupSubmitButton() {
        addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: currentAnswerField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupClearButton() {
        addSubview(clearButton)

        NSLayoutConstraint.activate([
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupButtonsContainer() {
        addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            buttonsContainer.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsContainer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupLetterButtons() {
        let buttonWidth = 150
        let buttonHeight = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = .systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
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
    
    @objc func clearTapped() {
        delegate?.clearTapped()
    }
    
    @objc func submitTapped() {
        delegate?.submitTapped()
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        delegate?.letterButttonTapped(at: sender.tag, with: sender.titleLabel?.text ?? "")
    }
    
    // MARK: - View Data Setters
    
    func set(clues: String) {
        cluesLabel.text = clues
    }
    
    func set(answer: String) {
        answersLabel.text = answer
    }
    
    func set(currentAnswer: String) {
        currentAnswerField.text = currentAnswer
    }
    
    func set(score: Int) {
        scoreLabel.text = "Score \(score)"
    }
    
    func set(letterBits: [String]) {
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
                letterButtons[i].isHidden = false
            }
        }
    }
    
    func hideButton(at index: Int) {
        letterButtons[index].isHidden = true
    }
    
    func showButton(at index: Int) {
        letterButtons[index].isHidden = false
    }
    
}
