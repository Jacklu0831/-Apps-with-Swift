//
//  CardCollectionViewCell.swift
//  Matcher
//
//  Created by Lu Jack on 2019-02-21.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        
        // keep track of what is passed on
        self.card = card;
        
        // card matched -> make invisible, vice versa
        if card.isFlipped == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }

        frontImageView.image = UIImage(named: card.imageName)
        
        // determine whether card flipped up or down
        if card.isFlipped == true {
            // make sure front on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            // make sure back on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(){
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        
        // delay
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove(){
        
        backImageView.alpha = 0
        
        // remove both views (animated)
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
