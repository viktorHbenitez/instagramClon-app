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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self

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
        
        if passField == confirmPassField{
        
            // Create the user in Firebase
            

            
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
