//
//  ContentView.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var orderListener = OrderListener()
    //@ObservedObject var userListener = UserListener()
    
    var body: some View {
        NavigationView() {
            List {
                Section(header: Text("New Orders")) {
                    ForEach(orderListener.activeOrders ?? []) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            HStack {
                                Text(order.customerName)
                                Spacer()
                                Text("$\(order.amount.clean)")
                            }
                        }
                    } // end of foreach
                } // end of section
                
                Section(header: Text("Completed Orders").foregroundColor(Color.green.opacity(0.7))) {
                    ForEach(orderListener.completedOrders ?? []) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            HStack {
                                Text(order.customerName)
                                Spacer()
                                Text("$\(order.amount.clean)")
                            }
                        }
                    } // end of foreach
                }
            } // end of list
            .navigationBarTitle(Text("Orders"))
            //.navigationBarItems(leading: <#T##View#>, trailing: <#T##View#>)
        } // end of NV
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
