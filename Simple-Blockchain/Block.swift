//
//  Block.swift
//  SimpleBlockchain
//
//  Created by Lu Jack on 2019-03-16.
//  Copyright © 2019 Lu Jack. All rights reserved.
//

import UIKit

class Block {
    // declare the attributes of a hash
    var hash: String!
    var data: String!
    var previousHash: String!
    var index: Int!
    
    // use the NSUUID object to randomly generate a hash when data is tampered
    func generateHash() -> String {
        return NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}



