//
//  UserVC.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 20/05/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var containerUsers = [User]()
    
    let identifierCell = "Cell"
    var isFollower : Bool!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        retrieveUsersFromFirebase()

    }
    
    
    func retrieveUsersFromFirebase() {
        
        // Create a root reference from Firebase Database
        let ref = FIRDatabase.database().reference()
        
        // retrieve the user of the child reference
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            // get the values of the dictionary
            let users = snapshot.value as! [String : AnyObject]
            
            self.containerUsers.removeAll() // Remove all users in the container
            
            // Loop the users and get the user are diferent of the current user
            for(_ , value) in users{
                
                // get the user
                if let uid = value["uid"] as? String{
                    
                    if uid != FIRAuth.auth()?.currentUser?.uid{
                        
                        let userToShow = User()
                        
                        // get the values of the user's dictionary
                        if let userName = value["full-name"] as? String,
                            let urlPath = value["urlToImage"] as? String{
                            
                            userToShow.userFullName = userName
                            userToShow.imagePath = urlPath
                            userToShow.userID = uid
                            
                            self.containerUsers.append(userToShow)
                        
                        }
                        
                    
                    
                    }
                    
                    
                }
            }
            
            self.tableView.reloadData()

        })
        ref.removeAllObservers()
        
    }
    
    // MARK: - IBActions
    @IBAction func logOutPressed(_ sender: Any) {
    }

}

// MARK: - UITableViewDataSource
extension UserVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.containerUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user : User = self.containerUsers[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! UserCell
        
        // Configure custom cell
        cell.configureUserCell(with: user)
        checkFollowingUser(with: indexPath)  //Track and check wich users are following by the current user
        
        return cell
        
    }
    
    func checkFollowingUser(with indexPath : IndexPath){
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()  // root reference
        
        // track the child reference :  followind child reference in the user ref
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject]{
                
                for(_ , value) in following{
                    // the user selected in the tableview from the current user is created in the following ref
                    if value as! String == self.containerUsers[indexPath.row].userID{
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                    
                }
                
            }
            
        })
        ref.removeAllObservers()
        
    }


}


// MARK: - UITableViewDelegate
extension UserVC : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()  // root reference
        
        let key = ref.child("users").childByAutoId().key  // automatic key created in the "user" child ref
        
        isFollower = false  // somebody is following someone = false
        
        
        // track the child reference :  followind child reference in the user ref
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject]{
                
                for(ke, value) in following{
                    // the user selected in the tableview from the current user is created in the following ref
                    if value as! String == self.containerUsers[indexPath.row].userID{
                        
                        self.isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.containerUsers[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                    
                }
            
            }
            
            if !self.isFollower{
                
                let following = ["following/\(key)" : self.containerUsers[indexPath.row].userID as String]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.containerUsers[indexPath.row].userID).updateChildValues(followers)
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
            }

        
        })
        ref.removeAllObservers()
        
        
        
        
        
    }
    
}
