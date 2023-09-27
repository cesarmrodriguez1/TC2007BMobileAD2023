//
//  Item.swift
//  MyCoffeeApp
//
//  Created by César on 13/05/21.
//

import SwiftUI

struct Item: Identifiable{
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: String
    var item_quantity: NSNumber
    
    var isAdded: Bool
}
