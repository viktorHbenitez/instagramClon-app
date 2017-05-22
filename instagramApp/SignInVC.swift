//
//  SignInVC.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 21/05/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        print("VIKTOR: LOGIN BTN")
        
        // Check if fields are not empty if not empty  it'll continue otherwise return
        guard emailField.text != "", passField.text != "" else {return}
        
        //Call and check if the user is auth in the app
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
            
            if let error = error {
                print("VIKTOR: ",error.localizedDescription)
                return
            }
            
            if let user = user{
                
                // We'll go to the Main Page VC
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                self.present(vc, animated: true, completion: nil)
                
                print("VIKTOR user full name", user.displayName!)
            
            }
            
        })
        
        
        
    }
    

}
