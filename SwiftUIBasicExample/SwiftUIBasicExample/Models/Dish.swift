//
//  Dish.swift
//  SwiftUIBasicExample
//
//  Created by Christian Quicano on 17/09/21.
//

import Foundation

struct Dish: Identifiable {
    
    let id = UUID()
    let name: String
    let imageURL: String
    let isSpicy: Bool
}

extension Dish {
    
    static func all() -> [Dish] {
        
        return [
        
            Dish(name: "Kung Pow Chicken", imageURL: "kungpow", isSpicy: true),
            Dish(name: "Sweet and Sour Chicken", imageURL: "sweet", isSpicy: false),
            Dish(name: "Spicy Red Chicken", imageURL: "spicy", isSpicy: true)
            
        ]
        
    }
    
}
