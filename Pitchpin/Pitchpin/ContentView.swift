//
//  ContentView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/8/23.
//

import SwiftUI

    

struct ContentView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State var showRecordView = false
    
    func refresh() { audioManager.loadJSON() }
    
    var body: some View {
        NavigationStack {
            Group {
                if audioManager.recordings.count <= 0 {
                    VStack {
                        Text("Looks like you haven't recorded anything yet.").bold()
                        Button("Start Recording") { showRecordView = true }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                } else {
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
                }
            }
            .navigationTitle(Text("Recordings"))
            .onAppear { refresh() }
            .refreshable { refresh() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showRecordView = true } label: { Image(systemName: "plus") }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AudioManager.shared)
    }
}
