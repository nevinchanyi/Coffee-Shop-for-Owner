//
//  Drink.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import Foundation
import Firebase

struct Drink: Identifiable, Hashable {
    var id: String
    var name: String
    var imageName: String
    var category: Category
    var description: String
    var price: Double
}

enum Category: String, CaseIterable, Codable, Hashable {
    case hot
    case cold
    case filter
}

func drinkDictionaryFrom(drink: Drink) -> [String: Any] {
    
    return NSDictionary(objects: [drink.id,
                                  drink.name,
                                  drink.imageName,
                                  drink.category.rawValue,
                                  drink.description,
                                  drink.price],
                        forKeys: [kID as NSCopying,
                                 kNAME as NSCopying,
                                 kIMAGENAME as NSCopying,
                                 kCATEGORY as NSCopying,
                                 kDESCRIPTION as NSCopying,
                                 kPRICE as NSCopying
    ]) as! [String : Any]
}

func createMenu() {
    for drink in drinkData {
        
        firebaseReference(.Menu).addDocument(data: drinkDictionaryFrom(drink: drink))
    }
}

let drinkData = [
    //HOT
    Drink(id: UUID().uuidString, name: "Espresso", imageName: "espresso", category: Category.hot, description: "Espresso is the purest distillation of the coffee bean. It doesn’t refer to a bean or blend, but actually the preparation method.", price: 2.50),
    
    Drink(id: UUID().uuidString, name: "Americano", imageName: "americano", category: Category.hot, description: "An Americano Coffee is an Espresso-based coffee drink with no special additions. Actually it is a shot of Espresso with hot water poured in it. A well-prepared Americano has the subtle aroma and flavour like Espresso. Benefits of Americano Coffee it has a lighter body and less bitterness.", price: 2.00),
    
    Drink(id: UUID().uuidString, name: "Cappuccino", imageName: "cappuccino", category: Category.hot, description: "Outside of Italy, cappuccino is a coffee drink that today is typically composed of double espresso and hot milk, with the surface topped with foamed milk. Cappuccinos are most often prepared with an espresso machine.", price: 2.50),
    
    Drink(id: UUID().uuidString, name: "Latte", imageName: "latte", category: Category.hot, description: "A typical latte is made with six to eight ounces of steamed milk and one shot of espresso. Larger lattes are often made with a double shot of espresso.", price: 2.50),
        
                    
    //FILTER
    Drink(id: UUID().uuidString, name: "Filter Classic", imageName: "filter coffee", category: Category.filter, description: "Filter coffee brewing involves pouring hot water over coffee grounds. Gravity then pulls the water through the grounds, facilitating extraction, and dispenses it into a mug or carafe placed below.", price: 2.00),
    
    Drink(id: UUID().uuidString, name: "Filter Decaf", imageName: "decaf", category: Category.filter, description: "Filter coffee brewing involves pouring hot water over coffee grounds. Gravity then pulls the water through the grounds, facilitating extraction, and dispenses it into a mug or carafe placed below.", price: 2.00),

    Drink(id: UUID().uuidString, name: "Cold Brew", imageName: "cold brew", category: Category.filter, description: "Cold brew is really as simple as mixing ground coffee with cool water and steeping the mixture in the fridge overnight.", price: 2.50),

    Drink(id: UUID().uuidString, name: "Cold Brew Latte", imageName: "brew latte", category: Category.filter, description: "To make a weaker brew, add 2 parts cold brew coffee to 1 part hot water. For a stronger brew, use a 4:1 ratio. Cold Brew Concentrate for Iced Lattes: use 3 ounces coffee beans per 2.5 cups of water.", price: 2.00),

    
    
    //COLD
    Drink(id: UUID().uuidString, name: "Frappe", imageName: "frappe", category: Category.cold, description: "Frappé coffee is a Greek iced coffee drink made from instant coffee, water and sugar. Accidentally invented by a Nescafe representative in 1957 in Thessaloniki", price: 5.00),
    
    Drink(id: UUID().uuidString, name: "Freddo Espresso", imageName: "freddo espresso", category: Category.cold, description: "A Freddo Espresso is basically 1 shot of espresso poured hot into a metal canister. It's then mixed with an electric blender, using a couple of ice cubes, and sugar is also added during the mixing process.", price: 5.00),
    
    Drink(id: UUID().uuidString, name: "Freddo Cappucciono", imageName: "freddo cappuccino", category: Category.cold, description: "The Freddo Cappuccino is pretty much a Freddo Espresso with a lovely creamy foam layered on top, so if you prefer milk in your coffee, this one is for you!", price: 4.00),
    
    Drink(id: UUID().uuidString, name: "Americano", imageName: "ice americano", category: Category.cold, description: "An Americano Coffee is an Espresso-based coffee drink with no special additions. Actually it is a shot of Espresso with hot water poured in it. A well-prepared Americano has the subtle aroma and flavour like Espresso. Benefits of Americano Coffee it has a lighter body and less bitterness.", price: 2.00),
    
    Drink(id: UUID().uuidString, name: "Iced Latte", imageName: "iced latte", category: Category.cold, description: "The latte is one of the most iconic espresso drinks, favored for its frothy foam topping. In this refreshing iced version, you can easily create foam with cold milk—no steamer needed.", price: 2.50)
    
]
