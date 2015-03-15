//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ben Scott on 14/03/2015.
//  Copyright (c) 2015 Schmurgon Pty Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate
{
    
    var audioEngine: AVAudioEngine!
    var audioPlayer: AVAudioPlayer!
    var audioFile:AVAudioFile!
    var audioPlayerNodeCompletionHandler: AVAudioNodeCompletionHandler!

    var receivedAudio: RecordedAudio!
    
    @IBOutlet weak var rabbit: UIButton!
    @IBOutlet weak var snail: UIButton!
    @IBOutlet weak var vader: UIButton!
    @IBOutlet weak var chipmunk: UIButton!
    @IBOutlet weak var stopAudio: UIButton!
    @IBOutlet weak var echo: UIButton!
    @IBOutlet weak var reverb: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate=true
        audioPlayer.volume = 1.0
        audioPlayer.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        resetSounds()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton)
    {
        resetSounds()
        
        sender.userInteractionEnabled = false
        
        playAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton)
    {
        resetSounds()
        
        sender.userInteractionEnabled = false
        
        playAudio(2.0)
    }
    
    @IBAction func playVader(sender: UIButton)
    {
        resetSounds()
        
        sender.userInteractionEnabled = false

        playAudioWithPitchAndEffect(-900, effect: nil)
    }
    
    @IBAction func playChipmunk(sender: UIButton)
    {
        resetSounds()
     
        sender.userInteractionEnabled = false
        
        playAudioWithPitchAndEffect(1200, effect: nil)
    }
    
    @IBAction func echo(sender: UIButton)
    {
        resetSounds()
        
        sender.userInteractionEnabled = false
        
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 1
        echoEffect.feedback = 20
        echoEffect.wetDryMix=75
        
        playAudioWithPitchAndEffect(0, effect: echoEffect)
    }
    
    @IBAction func reverb(sender: UIButton)
    {
        resetSounds()
        
        sender.userInteractionEnabled = false
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        reverbEffect.wetDryMix=70
        
        playAudioWithPitchAndEffect(0, effect: reverbEffect)
    }
    
    @IBAction func stopAudio(sender: UIButton)
    {
        stopAllAudioPlayers()
        
        resetSounds()
    }
    
    func playAudioWithPitchAndEffect(pitch: Float, effect: AVAudioUnitEffect?)
    {
        stopAllAudioPlayers()

        audioEngine.reset()
        
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(playerNode, to: changePitchEffect, format: nil)
        
        if ( effect != nil )
        {
            audioEngine.attachNode(effect)
            audioEngine.connect(changePitchEffect, to: effect, format: nil)
            audioEngine.connect(effect, to: audioEngine.outputNode, format:nil)
        }
        else
        {
            audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        }
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: audioPlayerNodeCompleted)
        playerNode.volume=90
        
        audioEngine.startAndReturnError(nil)

        stopAudio.enabled = true

        playerNode.play()
    }
    
    func playAudio(rate: Float)
    {
        stopAllAudioPlayers()
        
        audioPlayer.currentTime=0.0
        audioPlayer.rate=rate

        stopAudio.enabled = true
        audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool)
    {
        resetSounds()
    }
    
    func audioPlayerNodeCompleted()
    {
        resetSounds()
    }
    
    func stopAllAudioPlayers()
    {
        stopAudio.enabled = false
        
        audioPlayer.stop()
        audioEngine.stop()
        
    }
    
    func resetSounds()
    {
        stopAudio.enabled = false
        
        snail.userInteractionEnabled = true
        rabbit.userInteractionEnabled = true
        chipmunk.userInteractionEnabled = true
        vader.userInteractionEnabled = true
        echo.userInteractionEnabled = true
        reverb.userInteractionEnabled = true
    }

}
