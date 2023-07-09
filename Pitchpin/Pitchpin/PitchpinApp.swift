//
//  PitchpinApp.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/8/23.
//

import SwiftUI

@main
struct PitchpinApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AudioManager.shared)
        }
    }
}
