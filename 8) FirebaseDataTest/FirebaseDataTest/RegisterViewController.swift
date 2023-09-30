//
//  RegisterViewController.swift
//  FirebaseDataTest
//
//  Created by César Manuel on 07/09/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController{
    
    
    @IBOutlet weak var textKey: UITextField!
    
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textArea: UITextField!
    
    @IBOutlet weak var textStatus: UITextField!
    
    let ref = Database.database().reference(withPath: "Employees")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveEmployee(_ sender: Any) {
        
        let key = self.textKey.text!
        let object: [String:Any] = [
            "name": self.textName.text!,
            "area": self.textArea.text!,
            "status": self.textStatus.text!
        ]
        
        ref.child(key).setValue(object){ (error: Error?, ref:DatabaseReference) in
            
            var message = ""
            
            if let error  = error{
                message = "An error ocurred!!"
                print(error)
            }
            else{
                message = "Data saved successfully!! :D"
            }
            
            let alertController = UIAlertController(title: "App message", message: message, preferredStyle: .alert)
            
            let OKAction  = UIAlertAction(title: "OK", style: .default){ (action: UIAlertAction!) in
                
                print("OK was pressed")
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
}
