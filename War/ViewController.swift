//
//  ViewController.swift
//  War
//
//  Created by Lu Jack on 2019-02-21.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftScoreLabel: UILabel!
    
    @IBOutlet weak var rightScoreLabel: UILabel!
    
    var leftScore=0
    var rightScore=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be created
    }
   
    
    @IBAction func dealTapped(_ sender: Any) {
        
        let leftRandomNumber = arc4random_uniform(13)+2
        //print("left num: \(leftRandomNumber)")
        let rightRandomNumber = arc4random_uniform(13)+2
        //print("right num: \(leftRandomNumber)")
        
        leftImageView.image = UIImage(named: "card\(leftRandomNumber)")
        rightImageView.image = UIImage(named: "card\(rightRandomNumber)")
        
        if (leftRandomNumber>rightRandomNumber){
            leftScore+=1
            leftScoreLabel.text=String(leftScore)
        }
        else if (rightRandomNumber>leftRandomNumber){
            rightScore+=1
            rightScoreLabel.text=String(rightScore)
        }
    }
}

