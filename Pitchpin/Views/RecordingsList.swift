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
    @State var search = ""
    enum SortOption {
        case name, createdLatestToFirst, createdFirstToLatest
    }
    
    @State private var sortOption: SortOption = .createdLatestToFirst
    
    var sortedTasks: [Recording] {
        switch sortOption {
        case .name:
            return recordings.recordings.sorted { $0.name < $1.name }
        case .createdLatestToFirst:
            return recordings.recordings.sorted { $0.created < $1.created }
        case .createdFirstToLatest:
            return recordings.recordings.sorted { $1.created < $0.created }
        }
    }
    
    var body: some View {
        
        NavigationView {
            List {
                if recordings.recordings.isEmpty {
                    Text("↓ Why not record something special? ↓")
                }
                ForEach($recordings.recordings, id: \.id) { recording in
                    RecordingRow(recording: recording)
                    
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Recordings")
            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    List Sorter here
//                }
                EditButton()
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
        HStack {
            VStack(alignment: .leading) {
                Text(recording.name)
                Group {
                    if let recordingData = recording.data, let duration = getDuration(of: recordingData) {
                        Text(DateComponentsFormatter.positional.string(from: duration) ?? "0:00")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            Button {
                showDetailView = true
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .sheet(isPresented: $showDetailView) {
                AudioDetailView(recording: $recording)
            }
            
        }
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
