//
//  RecordingsList.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI
import CoreData
import AVFoundation

struct RecordingsList: View {
    @EnvironmentObject var recordings: Recordings
    
    var body: some View {
        
        NavigationView {
            if recordings.recordings.isEmpty {
                VStack {
                    Text("↓ Why not record something special? ↓")
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding()
                .navigationTitle("Recordings")
            } else {
                List {
                    ForEach($recordings.recordings, id: \.id) { recording in
                        RecordingRow(recording: recording)
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Recordings")
                .toolbar {
                    EditButton()
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        recordings.recordings.remove(atOffsets: offsets)
    }
}

struct RecordingRow: View {
    @State var showDetailView = false
    @Binding var recording: Recording
    
    
    var body: some View {
        Button {
            showDetailView = true
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(recording.name).foregroundStyle(.foreground)
                    Group {
                        if let recordingData = recording.data, let duration = getDuration(of: recordingData) {
                            Text(DateComponentsFormatter.positional.string(from: duration) ?? "0:00")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
        }
        .sheet(isPresented: $showDetailView) {
            AudioDetailView(recording: $recording)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
        
        //        .tint(isPlayingThisRecording ? .green : .blue)
    }
    
    func getDuration(of recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(recording.name)")
            return nil
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList().environmentObject(Recordings.shared)
    }
}
