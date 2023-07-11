//
//  RecorderBar.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-22.
//

import SwiftUI
import DSWaveformImageViews
import DSWaveformImage

struct RecorderBar: View {
    @ObservedObject var waveformManager = WaveformManager.shared
    @ObservedObject var audioRecorder = AudioRecorder()
    @ObservedObject var audioPlayer: AudioPlayer
    
    @State var buttonSize: CGFloat = 1
    @State var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .red, width: 3, spacing: 3))
    )
    
    var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
        .repeatForever()
    }
    
    var body: some View {
        VStack {
            
            WaveformLiveCanvas(
                samples: waveformManager.samples,
                configuration: liveConfiguration,
                renderer: LinearWaveformRenderer(),
                shouldDrawSilencePadding: true
            )
            
            if let audioRecorder = audioRecorder.audioRecorder, audioRecorder.isRecording {
                TimelineView(.periodic(from: .now, by: 1)) { _ in
                    // recording duration
                    Text(DateComponentsFormatter.positional.string(from: audioRecorder.currentTime) ?? "0:00")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .transition(.scale)
            }
            
            recordButton
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var recordButton: some View {
        Button {
            if audioRecorder.isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        } label: {
            Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipped()
                .foregroundColor(.red)
                .scaleEffect(buttonSize)
                .onChange(of: audioRecorder.isRecording) { isRecording in
                    if isRecording {
                        withAnimation(repeatingAnimation) { buttonSize = 1.1 }
                    } else {
                        withAnimation { buttonSize = 1 }
                    }
                }
        }
    }
    
    func startRecording() {
        if audioPlayer.audioPlayer?.isPlaying ?? false {
            // stop any playing recordings
            audioPlayer.stopPlayback()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Start Recording
                audioRecorder.startRecording()
            }
        } else {
            // Start Recording
            audioRecorder.startRecording()
        }
    }
    
    func stopRecording() {
        // Stop Recording
        audioRecorder.stopRecording()
    }
    
}

struct RecorderBar_Previews: PreviewProvider {
    static var previews: some View {
        RecorderBar(audioPlayer: AudioPlayer())
    }
}
