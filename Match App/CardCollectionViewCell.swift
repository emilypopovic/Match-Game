//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Emily Popovic on 2017-12-26.
//  Copyright © 2017 Emily Popovic. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    //set the card to display
    func setCard(_ card:Card){
        
        //keep track of card passed in
        self.card = card
        
        //check if card is matched already
        if card.isMatched == true{
            
            //set the image views for the card
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        //make the cards visible
        else{
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //determine if card flipped up or down
        if card.isFlipped == true{
            
            //make sure front image view is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else{
            //make sure back image view is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
    }
    
    //flip from back to front image view of card
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    //flip from front to back image view of card
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            
            //the animation of the card
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    //remove both image views from being visible
    func remove(){
        
        //set to 0 to make invisible
        backImageView.alpha = 0
        
        //animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            //add self to say it is a property of the card collection view cell
            self.frontImageView.alpha = 0
        }, completion: nil)
        
        
    }
    
    
}
