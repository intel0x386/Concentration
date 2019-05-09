//
//  Card.swift
//  Concentration
//
//  Created by ankit on 08/05/19.
//  Copyright © 2019 ankit. All rights reserved.
//

import Foundation


// This is a class and not a struct because structs do not allow
//  references to itself. Need one here to link to a matching pair.
class Card {
    let face: String
    var hasBeenOpened: Bool = false
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    weak var cardPair: Card!
    
    init(face: String) {
        self.face = face
    }
}

