//
//  AudioDetailView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/24/23.
//

import SwiftUI

struct AudioDetailView: View {
    @Binding var recording: Recording
    
    // Playback Progress
    @State var sliderValue: Double = 0.0
    @State private var isDragging = false
    
    
    
    
    var body: some View {
        ZStack {
            Color.pitchpinGray.edgesIgnoringSafeArea(.all)
            
            VStack {
                RecordingTitleView(name: $recording.name)
                
                Spacer()
                
                AudioPlaybackView(recording: $recording)
            }
            .padding()
        }
    }
}

struct AudioPlaybackView: View {
    @Binding var recording: Recording
    @ObservedObject var audioPlayer: AudioPlayer
    
    init(recording: Binding<Recording>) {
        self._recording = recording
        self.audioPlayer = AudioPlayer(recording: recording.wrappedValue)
    }
    
    
    // View Updating
    
//    let timer = Timer.publish(every: timerLatency, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            PlayerBar(audioPlayer: audioPlayer, recording: $recording)
                .overlay (
                    PinDisplay(timestamps: recording.pins, totalDuration: recording.duration ?? 0)
                )
            
            HStack {
                Button {
                    audioPlayer.audioPlayer.currentTime -= 15
                } label: {
                    Image(systemName: "gobackward.15").font(.system(size: 40)).padding()
                }
                
                
                
                Button {
                    switch audioPlayer.state {
                    case .notPlaying:
                        audioPlayer.startPlayback(recording: recording)
                    case .playing:
                        
                        audioPlayer.pausePlayback()
                    case .paused:
                        
                        audioPlayer.resumePlayback()
                    case .finished:
                        audioPlayer.startPlayback(recording: recording)
                    }
                } label: {
                    var icon: String {
                        switch audioPlayer.state {
                        case .notPlaying:
                            return "play.fill"
                        case .playing:
                            return "pause.fill"
                        case .paused:
                            return "play.fill"
                        case .finished:
                            return "play.fill"
                        }
                    }
                    
                    Image(systemName: icon)
                        .foregroundColor(.pitchpinGray)
                        .font(.system(size: 50))
                        .padding(30)
                        .background(Color.accentColor.clipShape(Circle()))
                }
                
                Button {
                    audioPlayer.audioPlayer.currentTime += 15
                } label: {
                    Image(systemName: "goforward.15").font(.system(size: 40)).padding()
                }
                
            }
            
            Button {
                    recording.pins.append(.init(notes: "", timestamp: audioPlayer.audioPlayer.currentTime))
                
            } label: {
                ZStack {
                    
                    Image(systemName: "pin.fill").font(.system(size: 30))
                }
            }
            .buttonStyle(PinButtonStyle())
            .padding()
        }
        .onAppear {
            audioPlayer.initialize(recording: recording)
        }
        .onDisappear {
            if audioPlayer.state == .playing {
                audioPlayer.pausePlayback()
            }
        }
    }
}

#Preview {
    AudioDetailView(recording: .constant(.init(name: "test", created: Date(), pins: [.init(notes: "", timestamp: 0.71333)])))
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

struct RecordingTitleView: View {
    @State var editingName = false
    @Binding var name: String
    var body: some View {
        HStack {
            if !editingName {
                Text(name)
                    .bold()
                    .font(.title)
                    .foregroundStyle(.white)
                    .lineLimit(1)
            } else {
                TextField("Name", text: $name)
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
    }
}
