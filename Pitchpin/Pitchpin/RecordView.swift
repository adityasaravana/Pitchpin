//
//  RecordView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/9/23.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State var recording = Recording(audio: nil)
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                
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
