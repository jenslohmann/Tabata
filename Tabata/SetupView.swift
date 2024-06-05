//
//  SetupView.swift
//  Tabata
//
//  Created by Jens Lohmann on 05/06/2024.
//

import Foundation
import SwiftUI

struct SetupView: View {
    
    @StateObject var soundPlayer : SoundPlayer
    
    var body: some View {
        VStack {
            Text("Setup")
                .padding()
            
            HStack {
                Text("Beep only:")
                Toggle("", isOn: $soundPlayer.beepOnly)
                    .tint(Color.red)
            }.padding(.vertical, 5).padding(.horizontal, nil)
            
            Link("Bushikan karate-dō (web)", destination: URL(string: "https://bushikan.dk/")!)
                .padding()
            
            Link("Bushikan karate-dō (facebook)", destination: URL(string: "fb://profile/1288067101336760")!)
                .padding()
            
            Spacer()
            
            Link("Source code (github)", destination: URL(string: "https://github.com/jenslohmann/Tabata")!)
                .padding()
            
            Button("iOS Settings") {
                openAppSettings()
            }.padding()
        }
    }
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}
