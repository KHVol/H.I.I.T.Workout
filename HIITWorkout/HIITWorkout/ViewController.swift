//
//  ViewController.swift
//  HIITWorkout
//
//  Created by Kenton Horton and John David Griffin on 4/30/19.
//  Copyright © 2019 Kenton Horton and John David Griffin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import UICircularProgressRing

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var startOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet weak var timeDecreaseOutlet: UIButton!
    @IBOutlet weak var timeIncreaseOutlet: UIButton!
    @IBOutlet weak var sprintDecreaseOutlet: UIButton!
    @IBOutlet weak var sprintIncreaseOutlet: UIButton!
    @IBOutlet weak var restDecreaseOutlet: UIButton!
    @IBOutlet weak var restIncreaseOutlet: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var sprintTimeLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var timerRing: UICircularProgressRing!
    
    let defaults = UserDefaults.standard
    
    var audioPlayer = AVAudioPlayer()
    
    var sprintStartTime = 0
    var restStartTime = 0
    
    var timeTarget = 1200
    var time = 1200
    var sprint = 30
    var rest = 30
    var timer = Timer()
    
    var timerStarted = false
    var sprintTimerStarted = false
    var restTimerStarted = false
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        
    }
    
    func convertSeconds() {
        if (time < 60) {
            timeLeft.text = String(time) + "s"
        } else if (time >= 60) {
            let minutes = time / 60
            let seconds = time % 60
            
            if (seconds == 0) {
                timeLeft.text = String(minutes) + "m"
            } else {
                timeLeft.text = String(minutes) + "m " + String(seconds) + "s"
            }
        }
    }
    
    @IBAction func StartTimer(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.decrement), userInfo: nil, repeats: true)
        
        sprintStartTime = time
        timerStarted = true
        sprintTimerStarted = true
        startOutlet.isHidden = true
        stopOutlet.isHidden = false
        turnArrows(false)
        stopOutlet.titleLabel?.text = "STOP"
        settingLabel.text = "SPRINT"
    }
    
    
    @IBAction func StopTimer(_ sender: UIButton) {
        startOutlet.isHidden = false
        stopOutlet.isHidden = true
        timerStop()
    }
    
    func timerStop() {
        timer.invalidate()
        timerStarted = false
        settingLabel.text = ""
        time = timeTarget
        convertSeconds()
        turnArrows(true)
        timerRing.value = CGFloat(100.00)
    }
    
    @objc func decrement() {
        time -= 1
        let progress = (Double(time) / Double(timeTarget)) * 100
        timerRing.value = CGFloat(progress)
        convertSeconds()
        
        if (time == 0) {
            audioPlayer.play()
            timerStop()
        } else if (sprintTimerStarted && (sprintStartTime - sprint == time)) {
            audioPlayer.play()
            sprintTimerStarted = false
            restStartTime = time
            restTimerStarted = true
            settingLabel.text = "REST"
        } else if (restTimerStarted && (restStartTime - rest == time)) {
            audioPlayer.play()
            restTimerStarted = false
            sprintStartTime = time
            sprintTimerStarted = true
            settingLabel.text = "SPRINT"
        }
    }
    
    func turnArrows(_ isEnabled: Bool) {
        timeDecreaseOutlet.isEnabled = isEnabled
        timeIncreaseOutlet.isEnabled = isEnabled
        
        sprintDecreaseOutlet.isEnabled = isEnabled
        sprintIncreaseOutlet.isEnabled = isEnabled
        
        restDecreaseOutlet.isEnabled = isEnabled
        restIncreaseOutlet.isEnabled = isEnabled
        
        startOutlet.isEnabled = isEnabled
    }
    
    @IBAction func totalTimeDecreaseBtn(_ sender: UIButton) {
        if (time > (5 * 60)) {
            time = time - (60 * 5)
        }
        timeTarget = time
        checkButtons("total")
        totalTimeLabel.text = String(time / 60) + "m"
        convertSeconds()
        saveUserDefaults()
    }
    
    @IBAction func totalTimeIncreaseBtn(_ sender: UIButton) {
        if (time < (60 * 60)) {
            time = time + (60 * 5)
        }
        timeTarget = time
        checkButtons("total")
        totalTimeLabel.text = String(time / 60) + "m"
        convertSeconds()
        saveUserDefaults()
    }
    
    @IBAction func sprintTimeDecreaseBtn(_ sender: UIButton) {
        if (sprint > 15) {
            sprint = sprint - 15
        }
        checkButtons("sprint")
        sprintTimeLabel.text = String(sprint) + "s"
        saveUserDefaults()
    }
    
    @IBAction func sprintTimeIncreaseBtn(_ sender: UIButton) {
        if (sprint < 60) {
            sprint = sprint + 15
        }
        checkButtons("sprint")
        sprintTimeLabel.text = String(sprint) + "s"
        saveUserDefaults()
    }
    
    @IBAction func restTimeDecreaseBtn(_ sender: UIButton) {
        if (rest > 15) {
            rest = rest - 15
        }
        checkButtons("rest")
        restTimeLabel.text = String(rest) + "s"
        saveUserDefaults()
    }
    
    @IBAction func restTimeIncreaseBtn(_ sender: UIButton) {
        if (rest < 60) {
            rest = rest + 15
        }
        checkButtons("rest")
        restTimeLabel.text = String(rest) + "s"
        saveUserDefaults()
    }
    
    func saveUserDefaults() {
        var saveString: String
        
        saveString = "\(timeTarget)|\(sprint)|\(rest)"
        
        defaults.set(saveString, forKey: "settings")
        defaults.synchronize()
    }
    
    func loadUserDefaults() {
        if let settingsString = defaults.string( forKey: "settings" ) {
            let components = settingsString.components( separatedBy: "|" )
            timeTarget = Int(components[0])!
            time = Int(components[0])!
            sprint = Int(components[1])!
            rest = Int(components[2])!
            convertSeconds()
            totalTimeLabel.text = "\(timeTarget / 60)m"
            sprintTimeLabel.text = "\(sprint)s"
            restTimeLabel.text = "\(rest)s"
            checkButtons("total")
            checkButtons("sprint")
            checkButtons("rest")
        }
    }
    
    func checkButtons(_ type: String) {
        switch type {
        case "total": // Total Time
            if (timeTarget == 300) {
                timeDecreaseOutlet.isEnabled = false
                timeIncreaseOutlet.isEnabled = true
            } else if (timeTarget == 3600) {
                timeDecreaseOutlet.isEnabled = true
                timeIncreaseOutlet.isEnabled = false
            } else {
                timeDecreaseOutlet.isEnabled = true
                timeIncreaseOutlet.isEnabled = true
            }
        case "sprint": // Sprint Time
            if (sprint == 15) {
                sprintDecreaseOutlet.isEnabled = false
                sprintIncreaseOutlet.isEnabled = true
            } else if (sprint == 60) {
                sprintDecreaseOutlet.isEnabled = true
                sprintIncreaseOutlet.isEnabled = false
            } else {
                sprintDecreaseOutlet.isEnabled = true
                sprintIncreaseOutlet.isEnabled = true
            }
        case "rest": // Rest Time
            if (rest == 15) {
                restDecreaseOutlet.isEnabled = false
                restIncreaseOutlet.isEnabled = true
            } else if (rest == 60) {
                restDecreaseOutlet.isEnabled = true
                restIncreaseOutlet.isEnabled = false
            } else {
                restDecreaseOutlet.isEnabled = true
                restIncreaseOutlet.isEnabled = true
            }
        default:
            turnArrows(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopOutlet.isHidden = true
       
        // Keeps background audio playing and make the alarm play louder and then resume volume for background audio
        do {
            _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.multiRoute, options: AVAudioSession.CategoryOptions.duckOthers)
        } catch {
            print(error)
        }

        let audioPath = Bundle.main.path(forResource: "1", ofType: ".mp3")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            } catch {
                print(error)
            }
        
        view.setGradientBackground(colorOne: UIColor(red: 58/255, green: 97/255, blue: 134/255, alpha: 1.0), colorTwo: UIColor(red: 137/255, green: 37/255, blue: 62/255, alpha: 1.0))
    }
    
    override func viewDidAppear( _ animated: Bool ) {
        super.viewDidAppear( animated )
        
        loadUserDefaults()
    }
    
    override func viewWillDisappear( _ animated: Bool ) {
        super.viewWillDisappear( animated )
        
        saveUserDefaults()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
