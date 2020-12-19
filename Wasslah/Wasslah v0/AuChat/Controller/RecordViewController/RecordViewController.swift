//
//  RecordViewController.swift
//  AuChat
//
//  Created by Hanan on 04/12/2020.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var pulseLayers = [CAShapeLayer]()
    
    @IBOutlet var micImage: UIImageView!
    @IBOutlet var recoredButton: UIButton!
    @IBOutlet var stopRecordButton: UIButton!
    
    var userInfo: UserInfo!
    var myInfo: UserInfo!
    let myUid = Auth.auth().currentUser?.uid
    
    let db = Firestore.firestore()
    
    // declare properites to use it in recored and play audio
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyName() // load user name
        
        micImage.layer.cornerRadius = micImage.frame.size.width/2.0
        
        recoredButton.setTitle("start", for: .normal)
     
    }
    
    func getMyName() {
        
        let docRef = db.collection("users").document("\(myUid!)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                
                let myName = (dataDescription?["firstname"] as! String)
                
                self.myInfo = UserInfo(uid: self.myUid!, name: myName)
            }
        }
    }
    
    
    
    @IBAction func playButton(_ sender: UIButton) {
        if sender.title(for: .normal) == "start" {
            sender.setTitle("stop", for: .normal)

            startRecord()
 
        } else if sender.title(for: .normal) == "stop" {
            recoredButton.setTitle("start", for: .normal)
            stopRecord ()
        }
        
    }
    
    
     func startRecord(){
        recoredButton.setImage(#imageLiteral(resourceName: "StopButtonRecord"), for: .normal)
        recording()
        createPulse()
    }
    
    
    
     func stopRecord (){
        recoredButton.setImage(#imageLiteral(resourceName: "RecordButton"), for: .normal)
        
        audioRecorder.stop()
        
        let delayInSeconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.uploadRecord()
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func recording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:2,
            AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue]
            as [String : Any]
        
        recordingSession = AVAudioSession.sharedInstance()
        try! recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        audioRecorder = try! AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
    }
    
    func uploadRecord() {
        let filePath = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let randomID = "\(UUID.init().uuidString).m4a"
        let uploadRef = Storage.storage().reference(withPath: "audios/\(randomID)")
        
        uploadRef.putFile(from: filePath, metadata: nil) { (metadata, error) in
            if error != nil { print(error! )
            }
            uploadRef.downloadURL { (url, error) in
                if error != nil {
                    print(error!)
                } else {
                    let audioData = ["audioURL": "\(randomID)",
                                     "audioDate": "\(Date())",
                                     "recevierID": "\(self.userInfo.uid)",
                                     "senderID": "\(self.myUid!)",
                                     "senderName": "\(self.myInfo.name)" ]
                    
                    self.db.collection("audios").addDocument(data: audioData ) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
    
}


