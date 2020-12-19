//
//  FriendListViewController.swift
//  AuChat
//
//  Created by Hanan on 04/12/2020.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore 

class FriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var FriendTableView: UITableView!
    
    let db = Firestore.firestore()
    let myUid = Auth.auth().currentUser?.uid
    
    var friendList: [UserInfo] = []  // friends array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendList() // load from database to friendList array
        
        FriendTableView.dataSource = self
        FriendTableView.delegate = self
        FriendTableView.rowHeight = 120
       
    }
    
    func getFriendList() {
        let docRef = db.collection("users").document("\(myUid!)").collection("friendsList")
        docRef.getDocuments { [self] (querySnapshot, error) in
            if let error = error {
                print("Document does not exist \(error)")
            } else {
                for doc in querySnapshot!.documents {
                    let friendName = (doc["firstname"] as! String)
                    let frindUserid = (doc["userid"] as! String)
                    let userInfo = UserInfo(uid: frindUserid, name: friendName)
                    
                    friendList.append(userInfo)
                    FriendTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecored":
            if let row = FriendTableView.indexPathForSelectedRow?.row {
                let userInfo = friendList[row]
                let recoredVC = segue.destination as! RecordViewController
                recoredVC.userInfo = userInfo
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendCell
        let friend = friendList[indexPath.row]
        cell.friendNameLabel.text = friend.name
        
        cell.layer.cornerRadius = 20
       
        cell.background.backgroundColor = .white
        cell.background.layer.cornerRadius = 10
        cell.background.layer.borderWidth = 5.0
        cell.background.layer.borderColor = UIColor.gray.cgColor
        cell.background.layer.shadowColor = UIColor.gray.cgColor
        cell.background.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.background.layer.shadowOpacity = 0.2
        cell.background.layer.shadowRadius = 4.0
        
        return cell
    }
}

