//
//  AudioDetailView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/24/23.
//

import SwiftUI

struct AudioDetailView: View {
    @State var audioPlayer = AudioPlayer()
    @State var sliderValue: Double = 0.0
    @State private var isDragging = false
    var timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var isPlayingThisRecording: Bool {
        audioPlayer.currentlyPlaying?.id == recording.id
    }
    
    var playing: Bool {
        if audioPlayer.isPlaying {
            // Pause
            return true
        } else {
            // Play
            return false
        }
    }
    
    @Binding var recording: Recording
    
    enum ViewState {
        case waitingForPlayStart
        case playback
    }
    
    @State var viewState: ViewState = .playback
    @State var editingName = false
    
    var body: some View {
        ZStack {
            Color.pitchpinGray.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    if !editingName {
                        Text(recording.name)
                            .bold()
                            .font(.title)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    } else {
                        TextField("Name", text: $recording.name)
                            .font(.title)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    
                    if !editingName {
                        Spacer()
                    }
                    
                    if !editingName {
                        Button {
                            editingName = true
                        } label: {
                            Image(systemName: "square.and.pencil").font(.title)
                        }
                    } else {
                        Button {
                            editingName = false
                        } label: {
                            Image(systemName: "checkmark.square").font(.title)
                        }
                    }
                }.padding()
                
                Spacer()
                
                
                       
                            PlayerBar(audioPlayer: audioPlayer).overlay(
                                PinDisplay(timestamps: recording.pins, totalDuration: recording.duration ?? 0)
                            )
                                      
                    
                
                
                HStack {
                    if viewState == .playback {
                        Button {
                            audioPlayer.audioPlayer?.currentTime -= 15
                        } label: {
                            Image(systemName: "gobackward.15").font(.system(size: 40)).padding()
                        }
                    }
                    
                    if audioPlayer.state == .notPlaying || audioPlayer.state == .finished {
                        Button {
                            audioPlayer.startPlayback(recording: recording)
                            withAnimation {
                                viewState = .playback
                            }
                        } label: {
                            Image(systemName: "play.fill")
                                .foregroundColor(.pitchpinGray)
                                .font(.system(size: 40))
                                .padding(30)
                                .background(Color.accentColor.clipShape(Circle()))
                        }
                    } else if audioPlayer.state == .paused || audioPlayer.state == .playing {
                        Button {
                            if audioPlayer.isPlaying {
                                // Pause
                                audioPlayer.pausePlayback()
                                
                                
                            } else {
                                // Play
                                audioPlayer.resumePlayback()
                            }
                        } label: {
                            var icon: String {
                                if audioPlayer.isPlaying {
                                    // Pause
                                    return "pause.fill"
                                } else {
                                    // Play
                                    return "play.fill"
                                }
                            }
                            
                            Image(systemName: icon)
                                .foregroundColor(.pitchpinGray)
                                .font(.system(size: 50))
                                .padding(30)
                                .background(Color.accentColor.clipShape(Circle()))
                        }
                    }
                    
                    if viewState == .playback {
                        Button {
                            audioPlayer.audioPlayer?.currentTime += 15
                        } label: {
                            Image(systemName: "goforward.15").font(.system(size: 40)).padding()
                        }
                    }
                }
                
                if viewState == .playback {
                    Button {
                        if let currentTime = audioPlayer.audioPlayer?.currentTime {
                            recording.pins.append(.init(notes: "", timestamp: currentTime))
                        }
                    } label: {
                        ZStack {
                            
                            Image(systemName: "pin.fill").font(.system(size: 30))
                        }
                    }
                    .buttonStyle(PinButtonStyle())
                    .padding()
                }
                
            }
            .padding()
        }
        .onAppear {
            audioPlayer.initialize(recording: recording)
        }
        .onDisappear {
            if viewState == .playback {
                audioPlayer.pausePlayback()
            }
        }
    }
}

#Preview {
    AudioDetailView(audioPlayer: AudioPlayer(), recording: .constant(.init(name: "test", created: Date(), pins: [.init(notes: "", timestamp: 0.71333)])))
}

struct PinDisplay: View {
    let timestamps: [Pin]
    let totalDuration: TimeInterval
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(timestamps, id: \.self) { timestamp in
                    Image(systemName: "pin.fill")
                        .frame(width: 5, height: 15)
                        .foregroundColor(.yellow)
                        .offset(x: CGFloat(timestamp.timestamp / totalDuration) * geometry.size.width, y: 12.5)
                }
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        PinDisplay(timestamps: [.init(notes: "", timestamp: 12)], totalDuration: 14)
        Spacer()
    }
}
