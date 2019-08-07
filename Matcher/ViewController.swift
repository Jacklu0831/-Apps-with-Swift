//
//  ViewController.swift
//  Matcher
//
//  Created by Lu Jack on 2019-02-21.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
   
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?

    var timer:Timer?
    var milliseconds:Float = 30 * 1000  // 10 seconds
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // call getCard method of card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // create timer
        timer = Timer.init(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        // keep running when playing
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any sources that can be retreated
    }
    
    // MARK: timer methods
    
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        // convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // when the timer is zero
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // check if there are cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK: UIcollectionView Protocol methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get CardCollectionViewCell Object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // get card for collection view to display
        let card = cardArray[indexPath.row]
        
        // set card for cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // check if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        // get the user selected cell
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // get the user selected card
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            // flip card
            cell.flip()
            
            // play the file sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            // determine if first or second
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                
                // second being flipped
                checkForMatches(indexPath)
                
            }
        }
    } // end did didSelectItemAt method
    
    // MARK: game logic methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        
        // get cells of cards revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // get cards of cards revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // compare two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // play sound
            SoundManager.playSound(.match)
            
            // remove cells
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // check if any unmatched
            checkGameEnded()
        }
        else {
            
            // not a match
            
            // play sound
            SoundManager.playSound(.nomatch)
            
            // set status
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip both back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // tell collectionView to reload cell of first card if nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // reset property to track first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        
        // if no cards unmatched
        var isWon = true
        
        // check over every card in cardArray
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // message variables
        var title = ""
        var message = ""
        
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations"
            message = "You Have Won"
        }
        else {
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You Have Lost"
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String){
        
        // show won/lost message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
} // end ViewController class
