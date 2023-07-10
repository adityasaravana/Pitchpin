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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioManager: AudioManager
    @State var recording = Recording(audio: nil)
    @State var recordingNameLocal = "Untitled Recording"
    @State var recordingDescriptionLocal = ""
    @State var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .red, width: 3, spacing: 3))
    )
    
    @State var showActionButtons = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("", text: $recordingNameLocal).bold().font(.title).padding()
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
                        withAnimation {
                            showActionButtons = true
                        }
                        print("ending recording session")
                    }
                    .frame(width: 70, height: 70)
                } else {
                    HStack {
                        Button {
                            recording = Recording(audio: nil)
                            withAnimation {
                                showActionButtons = false
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 70, height: 70)
                                Image(systemName: "trash").font(.system(size: 25))
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            recording.name = recordingNameLocal
                            recording.description = recordingDescriptionLocal
                            recording.created = Date()
                            audioManager.recordings.append(recording)
                            dismiss()
//                            recording = Recording(audio: nil)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 70, height: 70)
                                Text("Save".uppercased())
                            }
                        }
                        
                        
                    }.padding(.horizontal)
                }
            }
            .padding()
            .multilineTextAlignment(.center)
            .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark").fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(showActionButtons: true).environmentObject(AudioManager.shared)
    }
}

