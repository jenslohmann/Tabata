//
//  TabataApp.swift
//  Tabata
//
//  Created by Jens Lohmann on 08/02/2024.
//

import SwiftUI

@main
struct TabataApp: App {
    @State var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if(showSplash) {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showSplash = false
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
