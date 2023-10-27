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
    
    let timer = Timer
        .publish(every: 0.025, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        if let player = audioPlayer.audioPlayer {
            VStack {
//                HStack(spacing: 15) {
//                    // Play/Pause Button
//                    Button {
//                        if audioPlayer.isPlaying {
//                            // Pause
//                            audioPlayer.pausePlayback()
//                        } else {
//                            // Play
//                            audioPlayer.resumePlayback()
//                        }
//                    } label: {
//                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
//                            .font(.title2)
//                            .imageScale(.large)
//                            .foregroundColor(.white)
//                    }
//                    
//                    // Recording name
//                    Text(currentlyPlaying.name)
//                        .fontWeight(.semibold)
//                        .lineLimit(1)
//                        .foregroundColor(.white)
//                    
//                    Spacer()
//                    
//                    // Stop button
//                    Button {
//                        audioPlayer.stopPlayback()
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                            .imageScale(.large)
//                            .symbolRenderingMode(.hierarchical)
//                    }
//                    
//                }
//                .padding(.top, 10)
                // Slider
                Slider(value: $sliderValue, in: 0...player.duration) { dragging in
                    print("Editing the slider: \(dragging)")
                    isDragging = dragging
                    if !dragging {
                        player.currentTime = sliderValue
                    }
                }
                .tint(.accentColor)
                
                // Time passed & Time remaining
                HStack {
                    Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                    Spacer()
                    Text("-\(DateComponentsFormatter.positional.string(from: (player.duration - player.currentTime) ) ?? "0:00")")
                }
                .font(.caption)
                .foregroundColor(.white)
                
                
            }
            .padding()
            .foregroundColor(.primary)
            .onAppear {
                sliderValue = 0
            }
            .onReceive(timer) { _ in
                guard let player = audioPlayer.audioPlayer, !isDragging else { return }
                sliderValue = player.currentTime
            }
//            .transition(.scale(scale: 0, anchor: .bottom))
        }
    }
}

struct PlayerBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayerBar(audioPlayer: AudioPlayer())
    }
}
