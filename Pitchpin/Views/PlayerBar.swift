//
//  PlayerBar.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI

#warning("TODO: Dragging the slider produces this weird glitch, try in sim.")
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
                    GeometryReader { gr in
                                        Capsule()
                                            .stroke(Color.blue, lineWidth: 2)
                                            .background(
                                                Capsule()
                                                    .foregroundColor(Color.blue)
                                                    .frame(width: gr.size.width * (audioPlayer.audioPlayer.currentTime / audioPlayer.audioPlayer.duration) , height: 8), alignment: .leading)
                                    }
                                    .frame( height: 8)
                    // Slider
                    Slider(value: $sliderValue, in: 0...(audioPlayer.audioPlayer.duration )) { dragging in
                        print("Editing the slider: \(dragging)")
                        print(audioPlayer.audioPlayer.duration)
                        isDragging = dragging
//                        if !dragging {
                            audioPlayer.audioPlayer.currentTime = sliderValue
//                        }
                        
                        print(sliderValue)
                    }
                    .tint(.accentColor)
                    
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
