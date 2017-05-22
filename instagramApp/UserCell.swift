//
//  UserCell.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 22/05/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userID : String!
    
    func configureUserCell(with user : User) {
        
        self.userNameLabel.text = user.userFullName
        self.userID = user.userID
        self.userImageView.downloadImageFrom(FirebasePath: user.imagePath)
        
    }
    
}


extension UIImageView{

    func downloadImageFrom(FirebasePath imgURL : String) {
        
        let urlFromString = URL(string: imgURL)!
        let url = URLRequest(url: urlFromString)
        
        // Request of the server
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.sync {  //reload image in the main thread
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
        
    }
    
}
