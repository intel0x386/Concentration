//
//  Concentration.swift
//  Concentration
//
//  Created by ankit on 08/05/19.
//  Copyright © 2019 ankit. All rights reserved.
//

import Foundation

class Concentration {
    static var identifier = 0
    var cards = [Card]()
    var misses: Int
    
    var theFirstCard: Int!
    
    func flipCard(index: Int) {
        
        if cards[index].isMatched {
            return
        }
        
        if theFirstCard == nil {
            
            for card in cards {
                if !card.isMatched {
                    card.isFaceUp = false
                }
            }
            
            if cards[index].isMatched {
                return
            }
            
            theFirstCard = index
        } else {
            if theFirstCard == index {
                return
            }
            
            // MARK: Logic to detect a match
            if cards[index].face == cards[theFirstCard].face {
                cards[index].isMatched = true
                cards[theFirstCard].isMatched = true
            } else {
                // MARK: Logic to detect a miss
                if cards[theFirstCard].cardPair.hasBeenOpened {
                    misses += 1
                }
            }
            theFirstCard = nil
        }
        cards[index].hasBeenOpened = true
        cards[index].isFaceUp = true
    }
    
    init(numberOfPairs: Int, fromValue: [String]) {
        misses = 0
        var faceDB = fromValue
        for _ in 0..<numberOfPairs {
            let cardOne = Card(face: faceDB.remove(at: Int.random(in: 0..<faceDB.count)))
            let cardTwo = Card(face: cardOne.face)
            cardOne.cardPair = cardTwo
            cardTwo.cardPair = cardOne
            cards += [cardOne, cardTwo]
        }
        cards.shuffle()
        
        for i in 0..<cards.count {
            print(" \(cards[i].face) ", terminator: " ")
            if (i+1)%4 == 0 {
                print()
            }
        }
    }
    
}
