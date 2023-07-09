//
//  RecordingsView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/8/23.
//

import SwiftUI

struct RecordingsView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(audioManager.recordings) { recording in
                    Text(recording.name ?? "Recording - \(recording.id)").swipeActions(edge: .trailing) {
                        Button {
                            if let audio = recording.audio {
                                withAnimation {
                                    audioManager.deleteRecording(url: audio)
                                }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }.tint(.red)
                    }
                }
            }
            .navigationTitle(Text("Recordings"))
            .onAppear {
                audioManager.fetchRecordings()
            }
            .refreshable {
                audioManager.fetchRecordings()
            }
        }
    }
}

struct RecordingsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsView().environmentObject(AudioManager.shared)
    }
}
