//
//  FirebaseManager.swift
//  FocusStartProject
//
//  Created by Андрей Шамин on 12/8/20.
//

import Foundation
import Firebase

final class FirebaseManager {

    private var auth = Auth.auth()

    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    var userUID: String? {
        return auth.currentUser?.uid
    }

    var userEmail: String {
        guard let userEmail = auth.currentUser?.email else {
            assertionFailure("Something went wrong with userEmail")
            return ""
        }
        return userEmail
    }

    func createUser(loginEntitie: LoginEntitie,
                  completion: @escaping (() -> Void),
                  errorCompletion: @escaping ((Error) -> Void)) {
        auth.createUser(withEmail: loginEntitie.email, password: loginEntitie.password) { (result, error) in
            if let error = error {
                errorCompletion(error)
            } else {
                completion()
            }
        }
    }

    func signIn(loginEntitie: LoginEntitie,
                completion: @escaping (() -> Void),
                errorCompletion: @escaping ((Error) -> Void)) {
        Auth.auth().signIn(withEmail: loginEntitie.email ,
                           password: loginEntitie.password) { (result, error) in
            if let error = error {
                errorCompletion(error)
            } else {
                completion()
            }
        }
    }

    func logout(completion: (() -> Void),
                errorCompletion: ((Error) -> Void)) {
        do{
            try Auth.auth().signOut()
            completion()
        }catch{
            errorCompletion(error)
        }
    }
}
