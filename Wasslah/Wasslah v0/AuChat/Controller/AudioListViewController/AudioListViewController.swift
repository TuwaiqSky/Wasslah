//
//  AudioListViewController.swift
//  AuChat
//
//  Created by Hanan on 04/12/2020.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AudioListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var audioTableView: UITableView!
    
    let db = Firestore.firestore() // database
    let myUid = Auth.auth().currentUser?.uid // user id
    
    var audioList: [Audio] = [] // audios array
    var audioCell: AudioCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getAudioList() // load from database to audioList array
        
        updateAudioList()
        
        audioTableView.dataSource = self
        audioTableView.delegate = self
        audioTableView.rowHeight = 120
        
    }
    
    
    func updateAudioList() {
        let _ = db.collection("audios").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let data = diff.document.data()
                    
                    let audioURL = (data["audioURL"] as! String)
                    let audioDateString = (data["audioDate"] as! String)
                    let senderID = (data["senderID"] as! String)
                    let senderName = (data["senderName"] as! String)
                    let reciverID = (data["recevierID"] as! String)
                    
                    print(audioDateString)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss Z"
                    
                    if let date = dateFormatter.date(from: audioDateString) {
                        
                        print(date)

                        
                        let newAudio = Audio(audioURL: audioURL, audioDate: date, senderID: senderID, senderName: senderName ,reciverID: reciverID)
                        
                        if self.myUid == newAudio.reciverID {
                            self.audioList.append(newAudio)
                        }
                        self.audioList.sort(by: {$0.audioDate > $1.audioDate})
                    }
                    self.audioTableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioCell
        
        let audio = audioList[indexPath.row]
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let date = formatter.string(from: audio.audioDate)
        
        cell.date.text = date
        cell.friendNameLabel.text = audio.senderName
        cell.audioPath = audio.audioURL
        
        return cell
    }
}


