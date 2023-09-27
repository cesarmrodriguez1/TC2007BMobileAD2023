//
//  Cart.swift
//  MyCoffeeApp
//
//  Created by César on 18/05/21.
//

import SwiftUI

struct Cart: Identifiable{
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
}

