//
//  SingUpVC.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 19/05/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit
import Firebase

class SingUpVC: UIViewController {


    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let picker = UIImagePickerController()
    
    var userStorage : FIRStorageReference!
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        
        // Create a root reference from Firebase storage
        let storage = FIRStorage.storage().reference(forURL: "gs://instagramapp-5ac2d.appspot.com/")
        
        // create a child reference in the firebase storage
        userStorage = storage.child("users")
        
        // child reference of the root from Firebase Database
        ref = FIRDatabase.database().reference()

        

    }
    

    // MARK: - IBActions
    @IBAction func selectedimagePressed(_ sender: UIButton) {
        
        //set the picker configuration
        self.picker.allowsEditing = true
        self.picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil) //Presents a view controller modally.

    }
    
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        // Check the textFields are not empty
        guard fullNameField.text != "",
            emailField.text != "",
            passField.text != "",
            confirmPassField.text != "" else {return}
        
        if passField.text == confirmPassField.text{
        
            // Create the user in Firebase
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                }
                
                if let user = user{
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.fullNameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    // 1. Create a child reference with the uid of the user
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    // 2. Configure the data image
                    let imageUpload = self.imageView.image!
                    let imageData = UIImageJPEGRepresentation(imageUpload, 0.5)
                    
                    // Upload the data image with the child user.uid reference
                    let uploadImageTask = imageRef.put(imageData!, metadata: nil, completion: { (metaData, error) in
                        
                        if let error = error{
                            print(error.localizedDescription)
                            return
                        }
                        
                        // get the url of the image
                        imageRef.downloadURL(completion: { (url, error) in
                            
                            if let error = error{
                                print(error.localizedDescription)
                                return
                            }
                            
                            if let url = url{
                                
                                // CREATE THE USER
                                
                                // create a dictionary from the user values
                                let userInfo : [String : Any] = ["uid" : user.uid,
                                                                 "full-name" : self.fullNameField.text!,
                                                                 "urlToImage" : url.absoluteString]
                                
                                // create a child reference where it will has the user info
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                
                                // Call the VC when the user is created
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                            
                        })
                        
                        
                    })
                    
                    uploadImageTask.resume()
                }
                
            })
                        
        }else{
            print("VIKTOR : Password is not match")
        }
        
        
    }


}

// MARK: - UIImagePickerControllerDelegate
extension SingUpVC : UIImagePickerControllerDelegate{

    // This function is called when the user selected a picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageView.image = image
            nextBtn.isHidden = false
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

// MARK: - UIImagePickerControllerDelegate
extension SingUpVC : UINavigationControllerDelegate{


}
