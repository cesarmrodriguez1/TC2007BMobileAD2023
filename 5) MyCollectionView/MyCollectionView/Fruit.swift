//
//  Fruit.swift
//  MyCollectionView
//
//  Created by César Manuel on 21/08/23.
//

import Foundation
import UIKit

//This is our data model.

struct Fruit: Codable{
    let name: String
    let image: String
    let price: Int
}

struct Fruits: Codable{
    var fruits: [Fruit]
    
}
