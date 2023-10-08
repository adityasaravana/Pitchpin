//
//  VoiceRecTestApp.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI

@main
struct PitchpinApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Recordings.shared)
        }
    }
}
