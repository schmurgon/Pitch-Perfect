//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ben Scott on 15/03/2015.
//  Copyright (c) 2015 Schmurgon Pty Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio?

    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        progress.hidden = false
        progress.text = "Tap to record"
        stopRecordingButton.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "stopRecording")
        {
            let playSoundsViewController: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            
            let data = sender as RecordedAudio
            
            playSoundsViewController.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: UIButton)
    {
        
        if ( audioRecorder == nil )
        {
            prepareAudioSession()
            startRecording()
        }
        else
        {
            if (!audioRecorder.recording)
            {
                startRecording()
            }
            else
            {
                audioRecorder.pause()
                progress.text = "Tap to restart recording"
            }
        }
    }
    
    @IBAction func stopAudio(sender: UIButton)
    {
        progress.hidden = true
        stopRecordingButton.hidden = true
        recordButton.enabled = true

        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    func startRecording()
    {
        progress.text = "Tap to pause"
        stopRecordingButton.hidden = false
        audioRecorder.record()
    }
    
    func createNewRecording() -> NSURL!
    {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        println(filePath)
        
        return filePath
    }
    
    func prepareAudioSession()
    {
        let filePath = createNewRecording()
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if (flag)
        {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url!, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }        
    }    
}
