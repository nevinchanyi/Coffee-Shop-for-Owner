//
//  FUser.swift
//  Coffee Shop Admin
//
//  Created by constantine kos on 09.10.2020.
//

import Foundation
import Firebase

class FUser {
    let id: String
    var email: String
    var firsName: String
    var lastName: String
    var fullName: String
    var phoneNumber: String
    
    var fullAddress: String?
    var onboarding: Bool
    
    init(id: String, email: String, firstName: String, lastName: String, fullName: String, phoneNumber: String) {
        self.id = id
        self.email = email
        self.firsName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.phoneNumber = phoneNumber
        onboarding = false
    }
    
    init(_ dictionary: NSDictionary) {
        id = dictionary[kID] as? String ?? ""
        email = dictionary[kEMAIL] as? String ?? ""
        firsName = dictionary[kFIRSTNAME] as? String ?? ""
        lastName = dictionary[kLASTNAME] as? String ?? ""
        
        fullName = firsName + " " + lastName
        fullAddress = dictionary[kFULLADDRESS] as? String ?? ""
        phoneNumber = dictionary[kPHONENUMBER] as? String ?? ""
        onboarding = dictionary[kONBOARD] as? Bool ?? false
    }
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser.init(dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    class func loginUser(email: String, password: String, competion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    //download FUser object and save it locally
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email) { (error) in
                        
                        competion(error, true)
                    }
                } else {
                    competion(error, false)
                }
            } else {
                competion(error, false)
            }
        }
    }
    
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            completion(error)
            
            if error == nil {
                authDataResult!.user.sendEmailVerification { (error) in
                    print("### VERIFICATION EMAIL SENT, ERROR IS: ", error?.localizedDescription)
                }
            }
        }
    }
    
    class func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func logoutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            
            completion(nil)
        } catch let error as Error {
            completion(error)
        }
        
    }
    
}

func downloadUserFromFirestore(userId: String, email: String, completion: @escaping (_ error: Error?) -> Void) {
    firebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary) // save user locally
        } else {
            
            let user = FUser(id: userId, email: email, firstName: "", lastName: "", fullName: "", phoneNumber: "") // create user
            saveUserLocally(userDictionary: userDictionaryFrom(user: user) as NSDictionary)
            saveUserRoFirestore(fUser: user)
        }
        
        completion(error)
    }
}

func saveUserRoFirestore(fUser: FUser) {
    firebaseReference(.User).document(fUser.id).setData(userDictionaryFrom(user: fUser)) { (error) in
        if error != nil {
            print("### ERROR: creating fUser object",error?.localizedDescription)
        }
    }
}

func saveUserLocally(userDictionary: NSDictionary) {
    userDefaults.set(userDictionary, forKey: kCURRENTUSER)
    userDefaults.synchronize()
}

func userDictionaryFrom(user: FUser) -> [String: Any] {
    
    return NSDictionary(objects: [user.id,
                                  user.email,
                                  user.firsName,
                                  user.lastName,
                                  user.fullName,
                                  user.fullAddress ?? "",
                                  user.onboarding,
                                  user.phoneNumber],
                        forKeys: [kID as NSCopying,
                                  kEMAIL as NSCopying,
                                  kFIRSTNAME as NSCopying,
                                  kLASTNAME as NSCopying,
                                  kFULLNAME as NSCopying,
                                  kFULLADDRESS as NSCopying,
                                  kONBOARD as NSCopying,
                                  kPHONENUMBER as NSCopying
                        ]) as! [String : Any]
}

func updateCurrentUser(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        userObject.setValuesForKeys(withValues)
        firebaseReference(.User).document(FUser.currentId()).updateData(withValues) { (error) in
            completion(error)
            
            if error == nil {
                saveUserLocally(userDictionary: userObject)
            }
        }
    }
}
