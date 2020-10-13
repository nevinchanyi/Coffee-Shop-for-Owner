//
//  Order.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import Foundation

class Order: Identifiable {
    var id: String!
    var customerID: String!
    var orderItems: [Drink] = []
    var amount: Double!
    var customerName: String!
    var isCompleted: Bool!
    
    func saveOrderToFirestore() {
        firebaseReference(.Order).document(id).setData(orderDictionaryFrom(self)) { error in
            if error != nil {
                print("### Error saving order to firestore", error!.localizedDescription)
            }
        }
    }
}

func orderDictionaryFrom(_ order: Order) -> [String: Any] {
    var allDrinkIds: [String] = []
    
    for drink in order.orderItems {
        allDrinkIds.append(drink.id)
    }
    
    return NSDictionary(objects: [order.id,
                                  order.customerID,
                                  allDrinkIds,
                                  order.amount,
                                  order.customerName,
                                  order.isCompleted
                                ],
                        forKeys: [kID as NSCopying,
                                  kCUSTOMERID as NSCopying,
                                  kDRINKIDS as NSCopying,
                                  kAMOUNT as NSCopying,
                                  kCUSTOMERNAME as NSCopying,
                                  kISCOMPLETED as NSCopying
    
    ]) as! [String : Any]
}
