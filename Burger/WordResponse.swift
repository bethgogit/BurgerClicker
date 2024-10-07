//
//  WordResponse.swift
//  Burger
//
//  Created by Lab3student on 2024-04-06.
//

import UIKit

class WordResponse: Decodable {
    var word: String
    var score: Int
    var tags: [String]
}
