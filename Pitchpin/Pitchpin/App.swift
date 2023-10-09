//
//  VoiceRecTestApp.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import SwiftUI

@main
struct PitchpinApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Recordings.shared)
        }
    }
}
