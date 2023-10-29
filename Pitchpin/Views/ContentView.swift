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
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var body: some View {
        VStack {
            RecordingsList()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .environmentObject(recordings)
            bottomBar
        }
//            .safeAreaInset(edge: .bottom) {
//                bottomBar
//            }
    }
    
    var bottomBar: some View {
        VStack {
            RecorderBar()
        }
//        .frame(height: 0)
        .background (
            Color.pitchpinGray
//                .cornerRadius(15, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.all)
        )
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Recordings.shared)
    }
}
