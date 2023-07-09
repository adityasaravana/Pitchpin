//
//  RecordView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/9/23.
//

import SwiftUI
import DSWaveformImageViews
import DSWaveformImage

struct RecordView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State var recording = Recording(audio: nil)
    @State var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .red, width: 3, spacing: 3))
    )
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                
                WaveformLiveCanvas(
                    samples: audioManager.samples,
                    configuration: liveConfiguration,
                    renderer: LinearWaveformRenderer(),
                    shouldDrawSilencePadding: true
                )
                
                
                RecordButton(isRecording: $audioManager.isRecording) {
                    print("recording")
                    audioManager.record(to: &recording)
                } stopAction: {
                    audioManager.stopRecording()
                    print("ending recording session")
                }
                .frame(width: 70, height: 70)
            }
            .padding()
            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing, content: {
                //                    NavigationLink(destination: RecordingsView().environmentObject(audioManager), label: {
                //                        Image(systemName: "archivebox")
                //                    })
                //                })
            }
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView().environmentObject(AudioManager.shared)
    }
}

