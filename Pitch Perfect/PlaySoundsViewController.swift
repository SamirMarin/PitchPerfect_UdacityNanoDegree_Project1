//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Samir Marin on 2015-11-15.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import UIKit
import AVFoundation

//used http://www.jawadrashid.com/swift-tutorial-udacity-7/ to help with coding of pitch
//then followed along with code given in video for the course too

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayerEcho:AVAudioPlayer!
    var receiveAudio: RecordedAudio!
    
    //adding for pitch effects
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        audioFile = try! AVAudioFile(forReading: receiveAudio.filePathUrl)
        
        //audio player for echo effects
        audioPlayerEcho = try! AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl)
    }
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(2.0)
    }
    private func playAudio(theRate: Float){
        stopAllAudio()
        audioPlayer.currentTime = 0
        audioPlayer.rate = theRate
        audioPlayer.play()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    private func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let audioUnitTimePitch = AVAudioUnitTimePitch()
        audioUnitTimePitch.pitch = pitch
        
        audioEngine.attachNode(audioUnitTimePitch)
        
        audioEngine.connect(audioPlayerNode, to: audioUnitTimePitch, format: nil)
        audioEngine.connect(audioUnitTimePitch, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    @IBAction func playEchoSound(sender: UIButton) {
        //used thoughts and logs blog at http://sandmemory.blogspot.ca/2014/12/how-would-you-add-reverbecho-to-audio.html as a source for playing with echo affects
        
        playAudio(1)
        
        let delayTime: NSTimeInterval = 0.5
        let playTimeDelay: NSTimeInterval = audioPlayerEcho.deviceCurrentTime + delayTime

        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 0.7
        
        //play delay usig playTimeDelay for echo affect
        audioPlayerEcho.playAtTime(playTimeDelay)
    }
    @IBAction func stopAllAudio(sender: UIButton) {
        stopAllAudio()
    }
    private func stopAllAudio(){
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
   }
