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
                        Text("Looks like you haven't recorded anything yet.").bold().multilineTextAlignment(.center)
                        Button("Start Recording") { showRecordView = true }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                } else {
                    List {
                        ForEach(audioManager.recordings) { recording in
                            RecordingRow(recording: recording)
                        }.onDelete { indexSet in
                            withAnimation {
                                #warning("delete the audio file if available")
                                audioManager.recordings.remove(atOffsets: indexSet)
                            }
                        }
                    }.toolbar {
                        EditButton()
                    }
                }
            }
            .navigationTitle(Text("Recordings"))
            .onAppear { refresh() }
            .refreshable { refresh() }
            .sheet(isPresented: $showRecordView) { RecordView().environmentObject(audioManager) }
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
        ContentView().environmentObject(AudioManager(recordings: [Recording(name: "Recording", description: "Description"), Recording(name: "Recording", description: "Description")]))
        RecordingRow(recording: Recording(name: "Name", audio: URL(string: "hallo")!))
    }
}

struct RecordingRow: View {
    @EnvironmentObject var audioManager: AudioManager
    var recording: Recording
    
    var body: some View {
        Group {
            HStack {
                VStack {
                    Text(recording.name ?? "Untitled Recording")
                    if !(recording.description?.isEmpty ?? true) && recording.description != nil {
                        Text(recording.description!)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                if recording.audio != nil {
                    Button(action: {
                        if recording.playing == true {
                            audioManager.stopPlaying(from: recording.audio!)
                        } else {
                            audioManager.play(from: recording.audio!)
                        }
                    }) {
                        Image(systemName: recording.playing ? "stop.fill" : "play.fill")
                        //                            .foregroundColor(.white)
                            .font(.system(size:20))
                    }
                }
            }
        }
    }
}
