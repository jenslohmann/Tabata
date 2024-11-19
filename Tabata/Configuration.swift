//
//  Configuration.swift
//  Tabata
//
//  Created by Jens Lohmann on 21/10/2024.
//

import UIKit
import Foundation

class Configuration : Codable {
    var beepOnly : Bool = false
    var sessions : [Session] = []
    
    func read() -> Configuration {
        // Sti til iCloud-dokumenter
        if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            let fileURL = iCloudURL.appendingPathComponent("configuration.json")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // Læs data fra filen
                    let data = try Data(contentsOf: fileURL)
                    
                    // Dekod JSON til User objekt
                    let configuration = try JSONDecoder().decode(Configuration.self, from: data)
                    print("Brugerdata: \(configuration)")
                    return configuration
                } catch {
                    print("Fejl under læsning af fil: \(error.localizedDescription)")
                }
            } else {
                print("Filen findes ikke i iCloud.")
            }
        } else {
            print("Kunne ikke få adgang til iCloud-dokumenter.")
        }
        return Configuration()
    }
    
    func write() {
        // Sti til iCloud-dokumenter
        if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            do {
                // Sikr, at mappen eksisterer
                try FileManager.default.createDirectory(at: iCloudURL, withIntermediateDirectories: true, attributes: nil)
                
                let fileURL = iCloudURL.appendingPathComponent("configuration.json")
                
                do {
                    // Kod User objekt til JSON
                    let data = try JSONEncoder().encode(self)
                    
                    // Gem data til fil
                    try data.write(to: fileURL, options: .atomic)
                    print("Data er gemt.")
                } catch {
                    print("Fejl under skrivning af fil: \(error.localizedDescription)")
                }
            } catch {
                print("Fejl under oprettelse af mappe: \(error.localizedDescription)")
            }
        } else {
            print("Kunne ikke få adgang til iCloud-dokumenter.")
        }
    }
}

class Session : Codable {
    var name: String
    var duration: Double
}
