//
//  ViewController.swift
//  SimpleBlockchain
//
//  Created by Lu Jack on 2019-03-16.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blueAmount: UITextField!
    @IBOutlet weak var redAmount: UITextField!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    let firstAccount = 1234
    let secondAccount = 4321
    let bitcoinChain = Blockchain()
    let reward = 100
    var accounts: [String: Int] = ["0000": 1000000]

    // define error alert
    let invalidAlert = UIAlertController(title: "Invalid Transaction", message: "Error in processing transaction", preferredStyle: .alert)

    override func viewDidLoad() {
        // initialize the accounts for account 0000 to send 50 to first qccount and for first account to give 10 to second account

        super.viewDidLoad()
        transaction(from: "0000", to: "\(firstAccount)", amount: 50, type: "genesis")
        transaction(from: "\(firstAccount)", to: "\(secondAccount)", amount: 10, type: "normal")
        chainState()
        self.invalidAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func transaction(from: String, to: String, amount: Int, type: String) {
        // this function is for handling transaction, keeping the total BTC at equilibrium

        // validate giving account and the amount of money in the account
        if accounts[from] != nil && accounts[from]! >= amount {
            accounts.updateValue(accounts[from]! - amount, forKey: from)
        } else {
            self.present(invalidAlert, animated: true, completion: nil)
            return
        }

        // validate the receiving account
        if accounts[to] != nil {
            accounts.updateValue(accounts[to]! + amount, forKey: to)
        } else {
            accounts.updateValue(amount, forKey: to)
        }

        // two types of blocks can be used (refer to Blockchain.swift
        if type == "genesis" {
            bitcoinChain.createGenesisBlock(data: "From: \(from); To: \(to); Amount: \(amount)BTC")
        } else if type == "normal" {
            bitcoinChain.createBlock(data: "From: \(from); To: \(to); Amount: \(amount)BTC")
        }
    }

    func chainValidity() -> String {
        // this function is to check if the entire chain is valid (hash value match the previous block)

        var isValid = true
        // note that the first block does not have a previous, so start from index 1
        for i in 1...bitcoinChain.chain.count - 1 {
            if bitcoinChain.chain[i].previousHash != bitcoinChain.chain[i - 1].hash {
                isValid = false
            }
        }
        if isValid == true {
            return "Chain is valid"
        } else {
            return "Chain is not valid"
        }
    }

    func chainState() {
        // this function is to update the chain status in UI

        // print all blocks, their hash values, their previous blocks, and their previous blocks' hash values
        for i in 0...bitcoinChain.chain.count - 1 {
            print("\tBlock: \(bitcoinChain.chain[i].index!)\n\tHash: \(bitcoinChain.chain[i].hash!)\n\tPreviousHash: \(bitcoinChain.chain[i].previousHash!)\n\tData: \(bitcoinChain.chain[i].data!)")
        }
        // update UI so they show correct amount of BTC in each account
        redLabel.text = "Balance: \(accounts[String(describing: firstAccount)]!) BTC"
        blueLabel.text = "Balance: \(accounts[String(describing: secondAccount)]!) BTC"
        print(accounts)
        print(chainValidity())
    }


    @IBAction func redMine(_ sender: Any) {
        // mining functions to simulate transactions, from account 0000 to first account
        transaction(from: "0000", to: "\(firstAccount)", amount: 100, type: "normal")
        print("New block mined by: \(firstAccount)")
        chainState()
    }

    @IBAction func blueMine(_ sender: Any) {
        // mining functions to simulate transactions, from account 0000 to second account
        transaction(from: "0000", to: "\(secondAccount)", amount: 100, type: "normal")
        print("New block mined by: \(secondAccount)")
        chainState()
    }

    @IBAction func redSend(_ sender: Any) {
        // this function simulates a transaction where red is the giver and blue is the receiver
        if redAmount.text == "" {
            present(invalidAlert, animated: true, completion: nil)
        } else {
            transaction(from: "\(firstAccount)", to: "\(secondAccount)", amount: Int(redAmount.text!)!, type: "normal")
            print("\(redAmount.text!) BTC sent from \(firstAccount) to \(secondAccount)")
            chainState()
            redAmount.text = ""
        }
    }

    @IBAction func blueSend(_ sender: Any) {
        // this function simulates a transaction where blue is the giver and red is the receiver
        if blueAmount.text == "" {
            present(invalidAlert, animated: true, completion: nil)
        } else {
            transaction(from: "\(secondAccount)", to: "\(firstAccount)", amount: Int(blueAmount.text!)!, type: "normal")
            print("\(blueAmount.text!) BTC sent from \(secondAccount) to \(firstAccount)")
            chainState()
            blueAmount.text = ""
        }
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
