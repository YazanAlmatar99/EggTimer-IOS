//
//  ViewController.swift
//  EggTimer
//
//  Created by Yazan Almatar on 04/19/2019.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var totalTime = 0
    var secondsPassed = 0
    var timer = Timer()
    var player: AVAudioPlayer?
    
    
    let eggTimes:[String: Int] = ["Soft":240,"Medium":360,"Hard":720]
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        //the invalidate function will deactivate the previous timer so we only have 1 timer runnning at atime
        let hardness = sender.currentTitle!
        progressBar.progress = 0
        secondsPassed = 0
        titleLabel.text = hardness
        timer.invalidate()
     
        totalTime = eggTimes[hardness]!
               timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    @objc func updateCounter() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)

            progressBar.progress = percentageProgress
        } else {
            timer.invalidate()
            titleLabel.text = "Done"
            playSound()
            
        }
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
