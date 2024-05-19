//
//  SegmentedProgressBar.swift
//  Tabata
//
//  Created by Jens Lohmann on 12/05/2024.
//

import Foundation
import SwiftUI

struct SegmentedProgressBar: View {
    var hasLeadIn: Bool
    var workoutTime: Double
    var restTime: Double
    @Binding var current: Double
    var sessions: Int
    @Binding var isTimerRunning: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<((hasLeadIn ? 1:0) + 2 * sessions - 1), id: \.self) { index in
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(segmentColor(at: index))
                            .frame(width: segmentWidth(for: index, total: geometry.size.width),
                                   height: segmentHeight(for: index))
                    }
                }
                Rectangle()
                    .frame(width: current / total() * geometry.size.width, height: 20)
                    .foregroundColor(Color.gray).opacity(0.5)
            }
        }
    }
    
    private func segmentColor(at index: Int) -> Color {
        let toHere = (0..<index).map{segmentTime(for: $0)}.reduce(0, +)
        
        if toHere < current {
            return .red
        } else {
            return .gray
        }
    }
    
    private func segmentTime(for index: Int) -> Double {
        if(hasLeadIn) {
            if(index == 0) {
                return 5.0
            }
            if(index % 2 == 0) {
                return restTime
            } else {
                return workoutTime
            }
        } else {
            if(index % 2 == 0) {
                return workoutTime
            } else {
                return restTime
            }
        }
    }
    
    func segmentWidth(for index: Int, total totalWidth: CGFloat) -> CGFloat {
        return segmentTime(for: index) / total() * totalWidth
    }
    
    private func segmentHeight(for index: Int) -> CGFloat {
        if(hasLeadIn) {
            if(index % 2 == 0) {
                return 20.0
            }
            return 10.0
        } else {
            if(index % 2 == 0) {
                return 10.0
            }
            return 20.0
        }
    }
    
    func total() -> Double {
        return (hasLeadIn ? 5.0:0.0) + Double(sessions) * workoutTime + Double(sessions - 1) * restTime
    }
}
