import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var workoutTime = 20.0
    @State private var restTime = 5.0
    @State private var numberOfSessions = 8
    @State private var hasLeadIn = true
    @State private var isTimerRunning = false
    @State private var secondsPassed = 0.0
    
    let tickPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "AnalogTimerTick", ofType: "aac")!))
    let gongSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Gong", ofType: "mp3")!))
    
    var body: some View {
        TabView {
            VStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                        .background(Circle().foregroundColor(.red))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(timePassedInThisSegment(secondsPassed: secondsPassed) / timeInThisSegment(secondsPassed: secondsPassed)))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .round))
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(-90))
                    //                        .animation(.easeInOut, value: secondsPassed)
                    
                    Text("\(String(format: "%.1f", total() - secondsPassed))s")
                        .font(.largeTitle)
                }
                .padding()
                
                SegmentedProgressBar(hasLeadIn: hasLeadIn, workoutTime: workoutTime, restTime: restTime, current: $secondsPassed, sessions: numberOfSessions, isTimerRunning: $isTimerRunning)
                    .frame(height: 20)
                    .padding()
                
                Text("Total time: \(String(format: "%1.f", total()))s")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Button(action: {
                        isTimerRunning.toggle()
                        startTimer()
                    }) {
                        Text(isTimerRunning ? "Pause" : "Start")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(isTimerRunning ? Color.black : Color.red)
                            .cornerRadius(10)
                    }.padding()
                    
                    Button(action: {
                        resetTimer()
                    }) {
                        Text("Reset")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }.padding()
                }
                
                HStack {
                    Text("Workout Time:")
                    Stepper(value: $workoutTime, in: 5...3600, step: 5) {
                        Text("\(Int(workoutTime))s")
                    }
                }.padding(.vertical, 5).padding(.horizontal, nil)
                
                HStack {
                    Text("Rest Time:")
                    Stepper(value: $restTime, in: 5...3600, step: 5) {
                        Text("\(Int(restTime))s")
                    }
                }.padding(.vertical, 5).padding(.horizontal, nil)
                
                HStack {
                    Text("Lead-in:")
                    Toggle("", isOn: $hasLeadIn)
                        .tint(Color.red)
                }.padding(.vertical, 5).padding(.horizontal, nil)
                
                HStack {
                    Text("Sessions:")
                    Stepper(value: $numberOfSessions, in: 1...20, step: 1) {
                        Text("\(numberOfSessions)")
                    }
                }.padding(.vertical, 5).padding(.horizontal, nil)
                
                Spacer()
            }
            .tabItem{
                Label("Home", systemImage: "house")
            }
            
            VStack {
                Text("Forskellige youtube videoer")
                    .padding()
                
                Link("Japanske ord og fraser", destination: URL(string: "https://www.youtube.com/watch?v=YbNNXeGhRY0")!)
                    .padding()
                
                Link("Tæl til 10 på japansk", destination: URL(string: "https://www.youtube.com/watch?v=qqT1oL7Edyk&t=60")!)
                    .padding()
                
                Spacer() // Tilføj en mellemrum for at adskille indholdet fra tab baren
            }
            .tabItem {
                Label("Japanese", systemImage: "brain")
            }
            
            VStack {
                Text("Setup")
                    .padding()
                
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
            .tabItem {
                Label("Setup", systemImage: "gear")
            }
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
    
    func startTimer() {
        if isTimerRunning {
            let deadline = DispatchTime.now() + .milliseconds(100)
            if(abs(secondsPassed - round(secondsPassed)) < 0.05 && isTimerRunning) {
                playTickSound()
            }
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                if secondsPassed < total() {
                    secondsPassed += 0.1
                    startTimer()
                } else {
                    secondsPassed = 0.0
                    isTimerRunning = false
                    gongSound.play()
                }
            }
        } else {
            tickPlayer.stop()
        }
    }
    
    func playTickSound() {
        tickPlayer.play()
    }
    
    func resetTimer() {
        isTimerRunning = false
        secondsPassed = 0.0
    }
    
    func total() -> Double {
        return (hasLeadIn ? 5.0:0.0) + Double(numberOfSessions) * workoutTime + Double(numberOfSessions - 1) * restTime
    }
    
    func timePassedInThisSegment(secondsPassed : Double) -> Double {
        var time: Double = 5.0
        var timeToSubtract = 5.0
        if(hasLeadIn) {
            if(secondsPassed < 5.0) {
                return secondsPassed
            }
        } else {
            time = 0.0
        }
        for _ in (0..<numberOfSessions) {
            time += workoutTime
            if (secondsPassed < time) {
                return secondsPassed - timeToSubtract
            }
            timeToSubtract += workoutTime
            
            time += restTime
            if (secondsPassed < time) {
                return secondsPassed - timeToSubtract
            }
            timeToSubtract += restTime
        }
        
        return 0.0
    }
    
    func timeInThisSegment(secondsPassed : Double) -> Double {
        var time: Double = 5.0
        if(hasLeadIn) {
            if(secondsPassed < 5.0) {
                return 5.0
            }
        } else {
            time = 0.0
        }
        for _ in (0..<numberOfSessions) {
            time += workoutTime
            if (secondsPassed < time) {
                return workoutTime
            }
            time += restTime
            if (secondsPassed < time) {
                return restTime
            }
        }
        
        return 20.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
