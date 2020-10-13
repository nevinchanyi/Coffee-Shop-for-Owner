//
//  UserDetailView.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import SwiftUI

struct UserDetailView: View {
    var order: Order
    
    @State var user: FUser?
    
    var body: some View {
        List {
            Section {
                Text(user?.fullName ?? "")
                Text(user?.fullAddress ?? "")
                Text(user?.phoneNumber ?? "")
                Text(user?.email ?? "")
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("User Profile")
        .onAppear {
            getUser()
        }
    }
    private func getUser() {
        downloadUser(userId: order.customerID) { (fuser) in
            user = fuser
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(order: Order())
    }
}
