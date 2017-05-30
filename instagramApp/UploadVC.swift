//
//  UploadVC.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 26/05/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit
import Firebase

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
        
        AppDelegate.instance().showActivityIndicator()
        
        // upload image of the post and create a reference in the database in Firebase
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://instagramapp-5ac2d.appspot.com")
        
        let key = ref.child("post").childByAutoId().key // create auto id
        print("VIKTOR: key -> \(key)")
        
        let imageRef = storage.child("post").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.postImageView.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            // get the url from storage and create a ref of the post in Firebase database
            imageRef.downloadURL(completion: { (url, error) in
                
                if let url = url {
                    
                    let feed = ["userID" : uid,
                                "pathImage" : url.absoluteString,
                                "likes" :  0,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "postID" : key] as [String : Any]
                    
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("post").updateChildValues(postFeed)
                    
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
            })
            
        }
        
        uploadTask.resume()
        
        
        
        
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
