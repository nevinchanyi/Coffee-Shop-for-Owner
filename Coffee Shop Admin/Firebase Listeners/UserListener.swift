//
//  UserListener.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import Foundation
import Firebase

func downloadUser(userId: String, completion: @escaping (_ user: FUser?) -> Void) {
    firebaseReference(.User).whereField(kID, isEqualTo: userId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            let userData = snapshot.documents.first!.data()
            
            completion(FUser(userData as NSDictionary))
        } else {
            completion(nil)
        }
    }
}
