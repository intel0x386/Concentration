//
//  ViewController.swift
//  Concentration
//
//  Created by ankit on 29/04/19.
//  Copyright © 2019 ankit. All rights reserved.
//

import UIKit

struct Pairs {
    var value: Int
    var emoji: String
    var opened: Bool
}

class ViewController: UIViewController {
    
    var neutralize: Bool = false
    var isFirst: Bool = true
    var firstOpened: UIButton!
    var secondOpened: UIButton!
    var misses: Int = -1
    var didUserMiss: Bool = false
    var database: [String] = [  "🐶", "🐻", "🐨", "🐸", "🐙", "🐕", "🐓", "🦜", "🎃", "😺", "🐥", "🐝", "🕷", "🦍", "🐄", "🐑", "💃🏻", "🦉", "🦋", "🏌🏻‍♂️", "🚴🏻‍♂️", "🚲", "🦕", "🐳", "🐊", "🐫", "🐾", "🌳", "⛄️"
    ]
    //var pairs: [Int] = Array<Int>(repeating: -1, count: 20)
    var pairs: [Pairs] = Array<Pairs>(repeating: Pairs(value: -1, emoji: "", opened: false), count: 20)
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var missesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is one-time activity. Hence, here; and not in startNewGame
        for button in cardButtons {
            button.layer.cornerRadius = 5.0
            button.clipsToBounds = true
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        startNewGame()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        print("launchedBefore: \(launchedBefore)")
        
        if !launchedBefore {
        
            performSegue(withIdentifier: "HowToSegue", sender: self)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HowToSegue" {
            if let controller = segue.destination as? HowToViewController {
                present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func stackComplete() -> Bool {
        for i in 0...19 {
            if pairs[i].value == -1 {
                return false
            }
        }
        return true
    }
    
    @IBAction func cardTouched(_ sender: UIButton) {
        neutralize = false
        //print("cardTouched(\(sender.tag))")
        if isFirst {
            
            if !isMatch(first: firstOpened, second: secondOpened) {
                neutralizeButton(button: firstOpened)
                neutralizeButton(button: secondOpened)
            }
            
            firstOpened = sender
            //print("Setting first button to \(pairs[sender.tag].emoji)")
            sender.isEnabled = false
            sender.setTitle(pairs[sender.tag].emoji, for: .normal)
            pairs[sender.tag].opened = true
            
            // Check if the user has already opened the other matching Card.
            // If so, increment his miss count if he still misses
            if(pairs[pairs[sender.tag].value].opened) {
                didUserMiss = true
            }
            
            isFirst = false
        } else {
            secondOpened = sender
            //print("Setting second button to \(pairs[sender.tag].emoji)")
            secondOpened.isEnabled = false
            secondOpened.setTitle(pairs[sender.tag].emoji, for: .normal)
            pairs[sender.tag].opened = true
            
            if isMatch(first: firstOpened, second: secondOpened) {
                secondOpened.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                firstOpened.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            } else {
                secondOpened.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                firstOpened.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                firstOpened.isEnabled = true
                secondOpened.isEnabled = true
                
                if (didUserMiss) {
                    misses += 1
                    updateMissLabel()
                }
                
            }
            
            isFirst = true
            didUserMiss = false
        }
        if gameComplete() {
            let alertController = UIAlertController(title: "Yay!", message: "You have matched all the cards!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Start New Game", style: .default) { (alertAction) in
                self.startNewGame()
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateMissLabel() {
        if misses == 0 {
            missesLabel.text = ""
        } else {
            missesLabel.text = "Misses: \(misses)"
        }
    }
    
    func neutralizeButton(button: UIButton!) {
        if let button = button {
            button.isEnabled = true
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.7347727418, blue: 0, alpha: 1)
        }
    }
    
    func gameComplete() -> Bool {
        for button in cardButtons {
            if button.backgroundColor != #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) {
                return false
            }
        }
        return true
    }

    func isMatch(first firstOpened: UIButton!, second secondOpened: UIButton!) -> Bool {
        if let button1 = firstOpened, let button2 = secondOpened {
//            print("isMatch? \(pairs[button1.tag].value) -- \(pairs[button2.tag].value)")
            return pairs[button1.tag].emoji == pairs[button2.tag].emoji ? true : false
        }
        return false
    }

    @IBAction func StartNewGameTouched(_ sender: UIButton) {
        startNewGame()
    }
    
    func startNewGame() {
        isFirst = true
        misses = 0
        updateMissLabel()
        firstOpened = nil
        secondOpened = nil
        pairs = Array<Pairs>(repeating: Pairs(value: -1, emoji: "", opened: false), count: 20)
        
        for button in cardButtons {
            neutralizeButton(button: button)
        }
        
        
        
        // Populate the pairs structure. Create mapping and all the non-UI stuff.
        while(!stackComplete()) {
            let randomL = Int.random(in: 0...19)
            if pairs[randomL].value == -1 {
                let randomR = Int.random(in: 0...19)
                if pairs[randomR].value == -1 {
                    if randomR != randomL {
                        pairs[randomL].value = randomR
                        pairs[randomL].emoji = database[randomL]
                        pairs[randomR].value = randomL
                        pairs[randomR].emoji = pairs[randomL].emoji
                    }
                }
            }
        }
        for i in 0..<cardButtons.count {
            //print("pairs[\(i)] -> \(pairs[i].value) -> \(pairs[i].emoji)")
            print(" \(pairs[i].emoji) ", separator: "", terminator: "")
            if (i+1)%4 == 0 {
                print("")
            }
        }
    }
    
}

