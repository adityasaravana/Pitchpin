//
//  Recordings.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/8/23.
//

import Foundation
import Defaults

class Recordings: ObservableObject {
    static let shared = Recordings()

    @Published var recordings: [Recording] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func save() {
        Defaults[.recordings] = recordings
    }
    
    func load() {
        recordings = Defaults[.recordings]
    }
}
