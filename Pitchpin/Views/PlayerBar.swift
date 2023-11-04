//
//  PlayerBar.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI

struct PlayerBar: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @State var sliderValue: Double = 0.0
    @State private var isDragging = false
    @Binding var recording: Recording
    
    let timer = Timer
        .publish(every: 0.025, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        Capsule()
                            .stroke(Color.red, lineWidth: 2)
                            .background(
                                Rectangle()
                                    .foregroundColor(Color.red)
                                    .frame(width: geometry.size.width * (audioPlayer.audioPlayer.currentTime / audioPlayer.audioPlayer.duration) , height: 8), alignment: .leading)
                        
                        PinMarks(recording: recording, totalDuration: audioPlayer.audioPlayer.duration)
                            .frame(width: geometry.size.width)
                        
                        ProgressSliderCapsuleView()
                            .position(x: geometry.size.width * CGFloat(sliderValue / audioPlayer.audioPlayer.duration), y: geometry.size.height / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let sliderWidth = geometry.size.width
                                        let newSliderPosition = value.location.x / sliderWidth
                                        sliderValue = min(max(0, Double(newSliderPosition) * audioPlayer.audioPlayer.duration), audioPlayer.audioPlayer.duration)
                                        audioPlayer.audioPlayer.currentTime = sliderValue
                                    }
                            )
                        // This modifier allows the knob to visually respond to taps and drags
//                            .animation(.easeInOut, value: sliderValue)
                    }
                }
                .frame(height: 8)
                // Time passed & Time remaining
                HStack {
                    Text(DateComponentsFormatter.positional.string(from: audioPlayer.audioPlayer.currentTime ) ?? "0:00")
                    Spacer()
                    Text("-\(DateComponentsFormatter.positional.string(from: ((audioPlayer.audioPlayer.duration ) - (audioPlayer.audioPlayer.currentTime )) ) ?? "0:00")")
                }
                .font(.caption)
                .foregroundColor(.white)
                
                
            }
            .padding()
            .foregroundColor(.primary)
            .onReceive(timer) { _ in
                sliderValue = audioPlayer.audioPlayer.currentTime
            }
            
        }.onAppear {
            audioPlayer.initialize(recording: recording)
        }
    }
}

struct PinMarks: View {
    let recording: Recording
    let totalDuration: TimeInterval
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(recording.pins, id: \.self) { timestamp in
                    PinView(timestamp: timestamp, totalDuration: totalDuration, geometry: geometry)
                }
            }
        }
    }
}

struct PinView: View {
    let timestamp: Pin
    let totalDuration: TimeInterval
    let geometry: GeometryProxy
    var body: some View {
        Capsule()
            .frame(width: 5, height: 25)
            .foregroundStyle(.yellow)
        //            .position(x: CGFloat(timestamp.timestamp / totalDuration) * geometry.size.width, y: 0)
            .position (
                x: CGFloat(timestamp.timestamp / totalDuration) * geometry.size.width,
                y: geometry.size.height / 2
            )
    }
}

struct ProgressSliderCapsuleView: View {
    var body: some View {
        Capsule()
            .frame(width: 5, height: 30)
            .foregroundStyle(.gray.opacity(0.2))
    }
}

#Preview {
    VStack {
        GeometryReader { geometry in
            PinView(timestamp: .init(notes: "", timestamp: 0.3), totalDuration: 1.0, geometry: geometry)
        }
        ProgressSliderCapsuleView()
    }
    
}
