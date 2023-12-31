//
//  AudioDetailView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/24/23.
//

import SwiftUI
import DSWaveformImage

struct AudioDetailView: View {
    @Binding var recording: Recording
    
    // Playback Progress
    @State var sliderValue: Double = 0.0
    @State private var isDragging = false
    @ObservedObject var audioPlayer: AudioPlayer
    
    init(recording: Binding<Recording>) {
        self._recording = recording
        self.audioPlayer = AudioPlayer(recording: recording.wrappedValue)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    RecordingTitleView(audioPlayer: audioPlayer, name: $recording.name)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    AudioPlaybackView(recording: $recording, audioPlayer: audioPlayer)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .padding()
        .background(Color.pitchpinGray.edgesIgnoringSafeArea(.all))
        .onAppear {
            if recording.waveformImage == nil {
                Task {
                    if let url = recording.audioURL {
                        let waveformImageDrawer = WaveformImageDrawer()
                        let image = try await waveformImageDrawer.waveformImage(
                            fromAudioAt: url,
                            with: .init(size: CGSize(width: 200, height: 50), style: .filled(UIColor.red)),
                            renderer: LinearWaveformRenderer()
                        )
                        recording.waveformData = image.pngData()!
                    }
                }
            }
        }
    }
}

struct AudioPlaybackView: View {
    @Binding var recording: Recording
    @ObservedObject var audioPlayer: AudioPlayer
    
    
    
    // View Updating
    
    //    let timer = Timer.publish(every: timerLatency, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            PlayerBar(audioPlayer: audioPlayer, recording: $recording)
            
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
                audioPlayer.pausePlayback()
                recording.pins.append(.init(notes: "", timestamp: audioPlayer.audioPlayer.currentTime))
                audioPlayer.audioPlayer.currentTime = 0
            } label: {
                ZStack {
                    Image(systemName: "pin.fill").font(.system(size: 30))
                }
            }
            .buttonStyle(PinButtonStyle())
            .padding()
        }
        .task {
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

struct RecordingTitleView: View {
    @ObservedObject var audioPlayer: AudioPlayer
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
                    .textFieldStyle(.plain)
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
                    audioPlayer.pausePlayback()
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
        }
        .padding()
        .ignoresSafeArea(.keyboard)
    }
}
