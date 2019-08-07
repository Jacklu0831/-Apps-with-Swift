//
//  CardModel.swift
//  Matcher
//
//  Created by Lu Jack on 2019-02-21.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // declare array of stuff generated
        var generatedNumbersArray = [Int]()
        
        // declare an array to store cards
        var generatedCardsArray = [Card]()
        
        // randomly generate pairs
        while generatedNumbersArray.count < 8 {
            
            let randomNumber = arc4random_uniform(13)+1
            
            // ensure number is unique
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                print(randomNumber)
                
                // store into generated array
                generatedNumbersArray.append(Int(randomNumber))
                
                // creates first card
                let cardOne = Card()
                cardOne.imageName="card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                // creates second card
                let cardTwo = Card()
                cardTwo.imageName="card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
                
            }
        }
        
        // randomize array
        for i in 0...generatedCardsArray.count-1 {
            // swap random indices of the array
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        return generatedCardsArray
    }
}
