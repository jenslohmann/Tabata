//
//  SoundPlayer.swift
//  Tabata
//
//  Created by Jens Lohmann on 05/06/2024.
//

import SwiftUI
import Foundation
import AVFoundation

class SoundPlayer: ObservableObject {
    @Published var beepOnly = false
    
    let ichiSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ichi", ofType: "aac")!))
    let niSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ni", ofType: "aac")!))
    let sanSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "san", ofType: "aac")!))
    let yonSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "yon", ofType: "aac")!))

    let beepSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "short-beep", ofType: "mp3")!))

    // From: https://www.youtube.com/watch?v=vmS67wmynrQ
    let whistleSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Whistle", ofType: "mp3")!))
    
    // From; https://www.youtube.com/watch?v=wgOwzF0Y2yI
    let tickPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "AnalogTimerTick", ofType: "aac")!))
    
    // From: https://www.youtube.com/watch?v=VaN5aiO3Qcg
    let gongSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Gong", ofType: "mp3")!))
    
    func beep() {
        beepSound.play()
    }
    
    func ichi() {
        if(beepOnly) {
            beepSound.play()
        } else {
            ichiSound.play()
        }
    }
    
    func ni() {
        if(beepOnly) {
            beepSound.play()
        } else {
            niSound.play()
        }
    }
    
    func san() {
        if(beepOnly) {
            beepSound.play()
        } else {
            sanSound.play()
        }
    }
    
    func yon() {
        if(beepOnly) {
            beepSound.play()
        } else {
            yonSound.play()
        }
    }
    
    func whistle() {
        whistleSound.play()
    }
    
    func tick() {
        tickPlayer.play()
    }
    
    func stopTick() {
        tickPlayer.stop()
    }
    
    func gong() {
        gongSound.play()
    }
}
