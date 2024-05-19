//
//  SplashView.swift
//  Tabata
//
//  Created by Jens Lohmann on 15/05/2024.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            // Add your splash screen content here
            Image("splashImage")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Text("Tabata")
                .font(.title)
                .fontWeight(.bold)
                .padding()
        }
    }
}
