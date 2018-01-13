//
//  CardModel.swift
//  Match App
//
//  Created by Emily Popovic on 2017-12-26.
//  Copyright © 2017 Emily Popovic. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        
        //declare array to store generated cards
        var generatedCardsArray = [Card]()
        
        //randomly generate pairs of cards
        for _ in 1...8{
            
            //get a random number
            let randomNumber = arc4random_uniform(13)+1
            
            print(randomNumber)
            
            //create first card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardOne)
            
            //create second card object
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardTwo)
            
            //OPTIONAL: only unique pairs
            
        }
        
        //TODO: randomize the array
        
        //return the array
        return generatedCardsArray
    }
    
    
}

