//
//  ViewController.swift
//  Match App
//
//  Created by Emily Popovic on 2017-12-19.
//  Copyright © 2017 Emily Popovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //timer label
    @IBOutlet weak var timerLabel: UILabel!
    
    
    //the card
    @IBOutlet weak var collectionView: UICollectionView!
    
    //initialize variables
    var model = CardModel()
    var cardArray = [Card]()
    
    //first card that is flipped over
    var firstFlippedCardIndex:IndexPath?
    
    //create a property to hold a reference to the timer
    var timer:Timer?
    var milliseconds:Float = 10*1000 //10 seconds
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        //call the card method to create the 8 pairs of cards
        cardArray = model.getCards()
        
        //create timer object
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
    
        RunLoop.main.add(timer!, forMode: .commonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Timer Methods
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        //convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //set label
        timerLabel.text = "Time Remaining \(seconds)"
        
        //when timer has reached 0
        if milliseconds <= 0{
            
            //stop timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //check if user has any cards remaining
            checkGameEnded()
        }
        
    }
    
    
    //MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //tell it is a type of card collection view cell
        //use ! because you know it is that type instead of ?
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //get the card from that index row to display
        let card = cardArray[indexPath.row]
        
        //set the cell as the specific card
        cell.setCard(card)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if there is any time left
        if milliseconds <= 0{
            return
        }
        
        //get the cell the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            
            //flip the card
            cell.flip()
            
            //set flipped to true
            card.isFlipped = true
            
            //determine if first card or second card that is flipped
            if firstFlippedCardIndex == nil{
                
                //this is the first card being flipped
                firstFlippedCardIndex = indexPath
            }
            else{
                //this is the second card being flipped
                
                //preform matching logic
                checkForMatches(indexPath)
                
            }
            
        }

    }
    
    
    //MARK: - Game Logic Methods
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        
        //get the cells for the two cards that were revealed
        //unwrap the optional(firstFlippedCardIndex) to get at the value inside
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //get the cards for the two cards that were revealed
        //row gets you the actual index of the cell
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName{
            
            //if its a match set the status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //check if any cards left unmatched
            checkGameEnded()
        }
        else{
            
            //if not a match set the status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        //tell the collectionview to reload the cell of the first card if nill
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //reset the first card flipped
        firstFlippedCardIndex = nil
        
    }
    
    
    //check if the game has ended
    func checkGameEnded(){
        
        //determine if any cards left unmatched
        var isWon = true
        
        for card in cardArray{
            
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        
        //message variation
        var title = ""
        var message = ""
        
        //if won is true then the user has won
        if isWon == true{
            
            if milliseconds>0{
                timer?.invalidate()
            }
            
            title = "Congratulations"
            message = "You've won"
            
        }
        //if there are cards left check if any time left
        else{
            
            if milliseconds>0{
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        //show if win or lost by calling alert function
        showAlert(title, message)
        
    }
    
    //show the alert for if won or lost game
    func showAlert(_ title:String, _ message:String){
        
        //show if win or lost
        //use UI alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        //add the action to the alert
        alert.addAction(alertAction)
        
        //present the alert controller
        present(alert, animated: true, completion: nil)
    }
    

}  //end

