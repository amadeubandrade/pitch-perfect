//
//  AudioRecorder.swift
//  pitch-perfect
//
//  Created by Amadeu Andrade on 04/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorder: AVAudioRecorder, AVAudioRecorderDelegate {
    
    //PROPERTIES
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    
    let recorderSettings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000.0,
        AVNumberOfChannelsKey: 1 as NSNumber,
        AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
    ]
    
    //INITS
    override init() {
        super.init()
        setupAudioRecorder()
        setupAudioSession()
    }
    
    func setupAudioRecorder() {
        do {
            audioRecorder = try AVAudioRecorder(URL: UtilOthers().getDocumentsDirectory(), settings: recorderSettings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    //FUNCTIONS
    //PERMISSION
    func askUserPermissionToUseMicro() -> Bool {
        var permission: Bool!
        if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    permission = true
                } else {
                    print("Permission to record not granted")
                    permission = false
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
            permission = false
        }
        return permission
    }
    
    //RECORDING FUNCTIONS
    func beginRecording() {
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording")
        let notif = NSNotification(name: "finishRecording", object: nil, userInfo: ["url": recorder.url])
        NSNotificationCenter.defaultCenter().postNotification(notif)
    }
    
    
}
