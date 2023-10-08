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
    @ObservedObject var audioPlayer: AudioPlayer
    @EnvironmentObject var recordings: Recordings
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recordings.recordings, id: \.id) { recording in
                    RecordingRow(audioPlayer: audioPlayer, recording: recording)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Recordings")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        recordings.recordings.remove(atOffsets: offsets)
    }
}

struct RecordingRow: View {
    @ObservedObject var audioPlayer: AudioPlayer
    var recording: Recording
    
    var isPlayingThisRecording: Bool {
        audioPlayer.currentlyPlaying?.id == recording.id
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recording.name ?? "Recording")
                    .fontWeight(isPlayingThisRecording ? .bold : .regular)
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
                audioPlayer.startPlayback(recording: recording)
            } label: {
                Image(systemName: "play.circle.fill")
                    .imageScale(.large)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary, .tertiary)
            }
        }
        .tint(isPlayingThisRecording ? .green : .blue)
    }
    
    func getDuration(of recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(recording.name ?? "")")
            return nil
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioPlayer: AudioPlayer()).environmentObject(Recordings.shared)
    }
}
