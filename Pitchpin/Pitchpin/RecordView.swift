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
    @State var recordingNameLocal = "Untitled Recording"
    @State var recordingDescriptionLocal = ""
    @State var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .red, width: 3, spacing: 3))
    )
    
    @State var showActionButtons = false
    
    var body: some View {
        VStack {
            TextField("", text: $recordingNameLocal).bold().font(.title)
            TextField("", text: $recordingDescriptionLocal)
                .placeholder(when: recordingDescriptionLocal.isEmpty) {
                       Text("Notes...").foregroundColor(.gray)
                }
            
            WaveformLiveCanvas(
                samples: audioManager.samples,
                configuration: liveConfiguration,
                renderer: LinearWaveformRenderer(),
                shouldDrawSilencePadding: true
            )
            
            if !showActionButtons {
                RecordButton(isRecording: $audioManager.isRecording) {
                    print("recording")
                    audioManager.record(to: &recording)
                } stopAction: {
                    audioManager.stopRecording()
                    print("ending recording session")
                }
                .frame(width: 70, height: 70)
            } else {
                Button {
                    #error("add save and delete buttons")
                } label: {
                    
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView().environmentObject(AudioManager.shared)
    }
}

