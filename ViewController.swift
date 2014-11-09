//
//  ViewController.swift
//  AudioServicesTest
//
//  Created by Julius Parishy on 11/9/14.
//  Copyright (c) 2014 Julius Parishy. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    var functionPointer: AudioServicesCompletionFunctionPointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let inSystemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
        
        let block = {
            (systemSoundID: SystemSoundID, userData: UnsafeMutablePointer<Void>) in
            println("Completed!")
        }
        
        var vself = self
        let userData = withUnsafePointer(&vself, {
            (ptr: UnsafePointer<ViewController>) -> UnsafeMutablePointer<Void> in
            return unsafeBitCast(ptr, UnsafeMutablePointer<Void>.self)
        })
        
        self.functionPointer = AudioServicesCompletionFunctionPointer(systemSoundID: inSystemSoundID, block: block, userData: userData)
        AudioServicesAddSystemSoundCompletion(inSystemSoundID, CFRunLoopGetMain(), kCFRunLoopCommonModes, AudioServicesCompletionFunctionPointer.completionHandler(), userData)
    }
    
    @IBAction func vibrateButtonPressed(button: UIButton) {
        let systemSoundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(systemSoundID)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

