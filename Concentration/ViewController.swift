//
//  ViewController.swift
//  Concentration
//
//  Created by ankit on 08/05/19.
//  Copyright © 2019 ankit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var missesLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    var concentration: Concentration!
    var database: [String] = [  "🐶", "🐻", "🐨", "🐸", "🐙", "🐕", "🐓", "🦜", "🎃", "😺", "🐥", "🐝", "🕷", "🦍", "🐄", "🐑", "💃🏻", "🦉", "🦋", "🏌🏻‍♂️", "🚴🏻‍♂️", "🚲", "🦕", "🐳", "🐊", "🐫", "🐾", "🌳", "⛄️"
    ]
    var misses = 0 {
        didSet {
            if oldValue != misses {
                missesLabel.text = "Misses: \(misses)"
            }
            if misses == 0 {
                missesLabel.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // MARK: OneTime Button setup. Adjusting the size of the font.
        for button in cardButtons {
            button.layer.cornerRadius = 5.0
            button.clipsToBounds = true
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        startNewGame()
        
    }
    
    func startNewGame() {
        for buttons in cardButtons {
            buttons.isEnabled = true
        }
        misses = 0
        concentration = Concentration(numberOfPairs: 10, fromValue: database)
        updateUI()
    }

    
    
    @IBAction func cardTouched(_ sender: UIButton) {
        concentration.flipCard(index: sender.tag)
        updateUI()
        misses = concentration.misses
        restartIfMatchEnded()
    }
    
    func restartIfMatchEnded() {
        if trackProgress() {
            let alertController = UIAlertController(title: "Yay!", message: "You have matched all the cards!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Start New Game", style: .default) { (alertAction) in
                self.startNewGame()
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func trackProgress()  -> Bool {
        for card in concentration.cards {
            if !card.isMatched {
                return false
            }
        }
        return true
    }
    
    func updateUI() {
        for but in cardButtons {

            if concentration.cards[but.tag].isFaceUp {
                but.backgroundColor = #colorLiteral(red: 1, green: 0.7347727418, blue: 0, alpha: 1)
                but.setTitle(concentration.cards[but.tag].face, for: .normal)
                if concentration.theFirstCard == nil {
                    but.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                }
                
            } else  {
                but.setTitle("", for: .normal)
                but.backgroundColor = #colorLiteral(red: 1, green: 0.7347727418, blue: 0, alpha: 1)
            }
            
            if concentration.cards[but.tag].isMatched {
                but.isEnabled = false
                but.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
        }
    }
    
    @IBAction func StartNewGameTouched(_ sender: UIButton) {
        startNewGame()
    }
    
}

