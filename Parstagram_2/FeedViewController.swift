//
//  FeedViewController.swift
//  Parstagram_2
//
//  Created by Michelle Vasquez-Aleman on 2/24/20.
//  Copyright © 2020 Michelle Vasquez-Aleman. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView : UIView? {
        return commentBar
    }
  
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // query
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, errr) in
            if posts != nil {
                print("sucess")
                self.posts = posts!
                self.tableView.reloadData()
            }else {
               print("error~")
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        print("loggin out")
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        self.view.window?.rootViewController = loginViewController
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        // number of comments + 2
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            // post cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
             
             let user = post["author"] as! PFUser
             
             cell.userLabel.text = user.username!
             cell.captionLabel.text = post["caption"] as! String
             let imageFile = post["image"] as! PFFileObject
             let urlString = imageFile.url!
             print(urlString)
             let url = URL(string: urlString)!
             cell.photoView.af_setImage(withURL: url)
             return cell
            
        }else if indexPath.row <=  comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row-1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username! 
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell 
        }
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comment = PFObject(className: "Comments")
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
//        comment["text"] = "This is a random comment"
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//        post.saveInBackground { (success, error) in
//            if success {
//                print("comment saved")
//            }else{
//                print("error saving comment")
//            }
//        }
//
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
