//
//  FeddVC.swift
//  instagramApp
//
//  Created by Victor Hugo Benitez Bosques on 17/06/17.
//  Copyright © 2017 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit
import Firebase

class FeddVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var post = [Post]()
    var followingUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPost()

    }
    
    
    
    // retrieve and fetch the post from the followers
    func fetchPost(){
        
    
        // root reference of the Firebase Data base
        let ref = FIRDatabase.database().reference()
        
        
        // fetch the followers from the current user
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            
            for (_ , value) in users{
                
                //get the all uid of the users
                if let uid = value["uid"] as? String{
                    
                    // get the followers of the current user
                    if uid == FIRAuth.auth()?.currentUser?.uid{
                    
                        //create the array of the followers users
                        if let followingUsers = value["followers"] as? [String : String]{
                            for (_ , user) in followingUsers{
                                self.followingUsers.append(user)  // followingUsers array
                            }
                        
                        }
                        self.followingUsers.append(FIRAuth.auth()!.currentUser!.uid) // add the current user : followingUsers array
                        
                        // fetch all the post of the followers and himself
                        ref.child("post").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let postSnapshot = snapshot.value as! [String : AnyObject] // get the values of the query
                            
                            for(_ , postValue) in postSnapshot{
                                
                                if let userID = postValue["userID"] as? String{ // get uid from the post
                                    
                                    for eachFollowers in self.followingUsers{  // get the uid of the followers of the current user
                                        
                                        if  eachFollowers == userID{ // match the followers and his posts
                                            
                                            let newPost = Post()  // Create and instance
                                            
                                            // create a post object and append of the post array
                                            if let author = postValue["author"] as? String,
                                                let likes = postValue["likes"] as? Int,
                                                let pathImage = postValue["pathImage"] as? String,
                                                let postID = postValue["postID"] as? String,
                                                let userID = postValue["userID"] as? String{
                                                
                                                newPost.author = author
                                                newPost.likes = likes
                                                newPost.pathImage = pathImage
                                                newPost.postID = postID
                                                newPost.userID = userID
                                                
                                                self.post.append(newPost)
                                                
                                            }
                                        
                                        }
                                        
                                    }
                                    
                                    self.collectionView.reloadData()
                                    
                                }
                            }
                            
                            
                        })
                        
                    }
                    
                    
                
                }
            
            }
            
            
            
        
        
        })
        
        ref.removeAllObservers()
    
        
    }
    

}


extension FeddVC : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.post.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentPost = self.post[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCVCell
        
        // configure collection Cell
        cell.configureCell(with: currentPost)
        
        return cell
    }
    
    
}



extension FeddVC : UICollectionViewDelegate{
    
}



