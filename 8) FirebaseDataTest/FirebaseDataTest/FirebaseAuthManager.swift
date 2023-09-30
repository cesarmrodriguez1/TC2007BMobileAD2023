//
//  FirebaseAuthManager.swift
//  FirebaseDataTest
//
//  Created by César Manuel on 07/09/23.
//

import FirebaseAuth

class FirebaseAuthManager{
    func createEmployee(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password){ (authResult, error) in
            
            if let employee = authResult?.user{
                print(employee)
                completionBlock(true)
            }
            else{
                completionBlock(false)
            }
        }
        
    }
    
    func logIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){ (authResult, error) in
            
            if let employee = authResult?.user{
               print(employee)
                completionBlock(true)
            }
            else{
                completionBlock(false)
            }
        }
    }
}
