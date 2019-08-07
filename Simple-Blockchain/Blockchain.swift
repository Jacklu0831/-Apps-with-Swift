//
//  Blockchain.swift
//  SimpleBlockchain
//
//  Created by Lu Jack on 2019-03-16.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import UIKit

class Blockchain {
    
    // initialize the chain of blocks
    var chain = [Block]()
    
    // the genesis block is first block in the chain of blocks
    func createGenesisBlock(data: String){
        let genesisBlock = Block()
        // initialize attributes to the genesis block object, note that it does not point to anything
        genesisBlock.hash = genesisBlock.generateHash()
        genesisBlock.data = data
        genesisBlock.previousHash = "0000"
        genesisBlock.index = 0
        chain.append(genesisBlock)
    }
    
    // this function is to simply make a new block and append it to the chain
    func createBlock(data:String){
        let newBlock = Block()
        newBlock.hash = newBlock.generateHash()
        newBlock.data = data
        // make newBlock point to the previous block
        // note that the index of the last item in the chain is one less the size of chain
        newBlock.previousHash = chain[chain.count-1].hash
        newBlock.index = chain.count
        chain.append(newBlock)
    }
}
