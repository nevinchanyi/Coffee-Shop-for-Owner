//
//  OrderDetailView.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import SwiftUI

struct OrderDetailView: View {
    var order: Order
    
    @State var alert = false
    
    var body: some View {
        
        VStack {
            List {
                Section(header: Text("Customer")) {
                    NavigationLink(destination: UserDetailView(order: order)) {
                        Text(order.customerName)
                    }
                }
                
                Section(header: Text("Order Items")) {
                    ForEach(order.orderItems.sorted(by: { $0.name < $1.name })) { drink in
                        HStack {
                            Text(drink.name)
                            Spacer()
                            Text("$\(drink.price.clean)")
                        }
                    }
                }
            } // list
        } // vstack
        
        .alert(isPresented: $alert) {
            Alert(title: Text("Order mark as Completed"), message: Text("Order numder \(order.id) completed!"), dismissButton: .cancel(Text("Ok")))
        }
        
        .navigationBarTitle("Order", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    markAsCompleted()
                                    alert.toggle()
                                    
                                }, label: {
                                    Text(order.isCompleted ? "" : "Complete Order")
                                        .foregroundColor(.green)
                                })
                            
        )
    }
    private func markAsCompleted() {
        if !order.isCompleted {
            order.isCompleted = true
            order.saveOrderToFirestore()
        }
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order())
    }
}
