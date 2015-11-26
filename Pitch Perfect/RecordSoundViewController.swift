//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Samir Marin on 2015-11-08.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeRecordingButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
    
    //global declaration used to record sound
    var audioRecorder: AVAudioRecorder!
    var recordAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        pauseRecordingButton.enabled = false
        pauseRecordingButton.hidden = true
        resumeRecordingButton.enabled = false
        resumeRecordingButton.hidden = true
        tapToRecord.text = "Tap To Record"
    }
    @IBAction func recordAudio(sender: UIButton) {
        tapToRecord.text = "Recording"
        print("in recording")
        stopButton.hidden = false
        recordButton.enabled = false
        pauseRecordingButton.enabled = true
        pauseRecordingButton.hidden = false
        //recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings:[:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordAudio)
        }
        else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as!
                PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receiveAudio = data
            
        }
    }
    @IBAction func StopAudio(sender: UIButton) {
        print("stop recording")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        pauseRecordingButton.enabled = false
        pauseRecordingButton.hidden = true
        resumeRecordingButton.enabled = true
        resumeRecordingButton.hidden = false
        tapToRecord.text = "Paused"
    }
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        resumeRecordingButton.enabled = false
        resumeRecordingButton.hidden = true
        pauseRecordingButton.enabled = true
        pauseRecordingButton.hidden = false
        tapToRecord.text = "Recording"
    }
}

