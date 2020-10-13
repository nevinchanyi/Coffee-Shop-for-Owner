//
//  OrderListener.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import Foundation
import Firebase

class OrderListener: ObservableObject {
    
    @Published var activeOrders: [Order]!
    @Published var completedOrders: [Order]!
    
    init() {
        downloadOrder()
    }
    
    func downloadOrder() {
        firebaseReference(.Order).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            if !snapshot.isEmpty {
                self.activeOrders = []
                self.completedOrders = []
                
                for order in snapshot.documents {
                    let orderData = order.data()
                    
                    getDrinksFromFirestore(withIds: orderData[kDRINKIDS] as? [String] ?? []) { (allDrinks) in
                        let order = Order()
                        
                        order.customerID = orderData[kCUSTOMERID] as? String
                        order.id = orderData[kID] as? String
                        order.orderItems = allDrinks
                        order.amount = orderData[kAMOUNT] as? Double
                        order.customerName = orderData[kCUSTOMERNAME] as? String ?? ""
                        order.isCompleted = orderData[kISCOMPLETED] as? Bool ?? false
                        
                        if order.isCompleted {
                            self.completedOrders.append(order)
                        } else {
                            self.activeOrders.append(order)
                        }
                    }
                }
            }
        }
    }
}

func getDrinksFromFirestore(withIds: [String], completion: @escaping (_ drinkArray: [Drink]) -> Void) {
    var count = 0
    var drinkArray: [Drink] = []
    
    if withIds.count == 0 {
        completion(drinkArray)
        return
    }
    
    for drinkId in withIds {
        firebaseReference(.Menu).whereField(kID, isEqualTo: drinkId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            if !snapshot.isEmpty {
                let drinkData = snapshot.documents.first!
                drinkArray.append(Drink(id: drinkData[kID] as? String ?? UUID().uuidString,
                                        name: drinkData[kNAME] as? String ?? "unknown",
                                        imageName: drinkData[kIMAGENAME] as? String ?? "unknown",
                                        category: Category(rawValue: drinkData[kCATEGORY] as? String ?? "cold") ?? .cold,
                                        description: drinkData[kDESCRIPTION] as? String ?? "description is missing",
                                        price: drinkData[kPRICE] as? Double ?? 0.0))
                
                count += 1
            } else {
                print("have no drinks")
                completion(drinkArray)
            }
            
            if count == withIds.count {
                completion(drinkArray)
            }
        }
    }
}
