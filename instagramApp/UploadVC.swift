//
//  UploadVC.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 26/05/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit

class UploadVC: UIViewController {

    @IBOutlet weak var selectedImageBtn: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postBtn: UIButton!
    
    var picker = UIImagePickerController() // instance class from imagePickerController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
    }
    
    // When the user pressed the btn
    @IBAction func selectedPressed(_ sender: Any) {
        
        // Configure picker controller
        self.picker.allowsEditing = true
        self.picker.sourceType = .photoLibrary
        
        // present picker controller
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func postPressed(_ sender: Any) {
        
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate
extension UploadVC : UIImagePickerControllerDelegate{
    
    // This funtion is call when the user selected a image in the photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // set the image in the imageView
        if let imageFromLibary = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            self.postImageView.image = imageFromLibary
            self.selectedImageBtn.isHidden = true
            self.postBtn.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

// MARK: - UINavigationControllerDelegate
extension UploadVC : UINavigationControllerDelegate{


}
