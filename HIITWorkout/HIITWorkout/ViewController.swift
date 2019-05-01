//
//  ViewController.swift
//  HIITWorkout
//
//  Created by Kenton Horton on 4/30/19.
//  Copyright © 2019 Kenton Horton. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioPlayer = AVAudioPlayer()
    
    var sprintStartTime = 0
    var restStartTime = 0
    
    var time = 600
    var sprint = 30
    var rest = 30
    var timer = Timer()
    
    var timerStarted = false
    var sprintTimerStarted = false
    var restTimerStarted = false
    
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var totalTime: UITextField!
    @IBOutlet weak var sprintTime: UITextField!
    @IBOutlet weak var restTime: UITextField!
    @IBOutlet weak var startOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    
    func setTime()
    {
        let textFieldInt: Int? = Int(totalTime.text!)
        let num = (textFieldInt ?? 0) * 60
        let convertNum = String(num)

            time = num
            timeLeft.text = convertNum + " seconds"
    }
    
    @IBAction func StartTimer(_ sender: UIButton) {
        if(!timerStarted) {
            timerStarted = true
            sprintTimerStarted = true
            
            totalTime.isEnabled = false
            sprintTime.isEnabled = false
            restTime.isEnabled = false
            startOutlet.isEnabled = false
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.decrement), userInfo: nil, repeats: true)
            
            sprintStartTime = time
        }
    }
    
    func timerStop()
    {
        timer.invalidate()
        timerStarted = false
        setTime()
        
        totalTime.isEnabled = true
        sprintTime.isEnabled = true
        restTime.isEnabled = true
        startOutlet.isEnabled = true
    }
    
    @IBAction func StopTimer(_ sender: UIButton) {
        timerStop()
    }
    
    @IBAction func totalTimeEdit(_ sender: Any) {
        setTime()
    }
    @IBAction func sprintTimeEdit(_ sender: Any) {
        sprint = Int(sprintTime.text!) ?? 30
    }
    
    @IBAction func restTimeEdit(_ sender: Any) {
        rest = Int(restTime.text!) ?? 30
    }
    
    @objc func decrement() {
        time -= 1
        timeLeft.text = String(time) + " seconds"
        
        if(time == 0){
            //audioPlayer.play()
            timerStop()
        }
        else if(sprintTimerStarted && (sprintStartTime - sprint == time))
        {
            //audioPlayer.play()
            sprintTimerStarted = false
            restStartTime = time
            restTimerStarted = true
        }
        else if(restTimerStarted && (restStartTime - rest == time))
        {
            //audioPlayer.play()
            restTimerStarted = false
            sprintStartTime = time
            sprintTimerStarted = true
        }
    }
    @IBOutlet weak var subView: UIView!
    
    @IBAction func totalTimeDecreaseBtn(_ sender: UIButton) {
    }
    
    @IBAction func totalTimeIncreaseBtn(_ sender: UIButton) {
    }
    
    @IBAction func sprintTimeDecreaseBtn(_ sender: UIButton) {
    }
    
    @IBAction func sprintTimeIncreaseBtn(_ sender: UIButton) {
    }
    
    @IBAction func restTimeDecreaseBtn(_ sender: UIButton) {
    }
    
    @IBAction func restTimeIncreaseBtn(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //do
        //{
       //     let audioPath = Bundle.main.path(forResource: "1", ofType: ".mp3 ")
         //   try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        //}
        //catch
        //{
       //         print(error)
       // }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        view.setGradientBackground(colorOne: UIColor(red: 58/255, green: 97/255, blue: 134/255, alpha: 1.0), colorTwo: UIColor(red: 137/255, green: 37/255, blue: 62/255, alpha: 1.0))
    }
}

