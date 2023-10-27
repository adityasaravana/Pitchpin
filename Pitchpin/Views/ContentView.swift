//
//  ContentView.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var recordings: Recordings
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var body: some View {
        RecordingsList(audioPlayer: audioPlayer)
            .environmentObject(recordings)
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
    }
    
    var bottomBar: some View {
        VStack {
            RecorderBar(audioPlayer: audioPlayer)
        }
        
        .background (
            Color.pitchpinGray
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.all)
        )
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Recordings.shared)
    }
}
