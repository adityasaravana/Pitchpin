//
//  ContentView.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    var body: some View {
        NavigationView {
            RecordingsList(audioPlayer: audioPlayer)
                .safeAreaInset(edge: .bottom) {
                    bottomBar
                }
                .navigationTitle("Recordings")
        }
    }
    
    var bottomBar: some View {
        VStack {
            PlayerBar(audioPlayer: audioPlayer)
            RecorderBar(audioPlayer: audioPlayer)
        }
        .shadow(radius: 40)
        .background(Color.gray.opacity(0.4).cornerRadius(30, corners: [.topLeft, .topRight]).edgesIgnoringSafeArea(.all))
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
