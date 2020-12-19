//
//  AudioCell.swift
//  AuChat
//
//  Created by Hanan on 04/12/2020.
//

import UIKit
import AVFoundation
import FirebaseStorage

class AudioCell: UITableViewCell {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet var friendNameLabel: UILabel!
    @IBOutlet var friendImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    
    var player = AVPlayer()
    var timer = Timer()
    var audioPath: String!
    
    
    @IBAction func playAudioButton(_ sender: UIButton) {
      
        player.pause()

        sender.setImage(#imageLiteral(resourceName: "pauseBig-1"), for: .normal)
            let downloadRef = Storage.storage().reference(withPath: "audios").child("\(self.audioPath!)")
            downloadRef.downloadURL { (hardUrl, error) in
                if error != nil {
                    print(error)
                }
                if let url = hardUrl {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    }
                    catch {
                        
                    }
                    self.player = AVPlayer(url: url)
                    
                    self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: .main) { time in
            
                        let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(self.player.currentItem!.duration)
            
                        self.slider.value = Float(fraction)
                    }
                    
                    self.player.play()
                }
            }
        
        }
    }
    





