//
//  Pin.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/8/23.
//

import Foundation
import Defaults

class Pin: Codable, Defaults.Serializable {
    var notes: String
    var timestamp: TimeInterval
    
    init(notes: String, timestamp: TimeInterval) {
        self.notes = notes
        self.timestamp = timestamp
    }
}

extension Pin: Equatable {
    static func == (lhs: Pin, rhs: Pin) -> Bool {
        lhs === rhs
    }
}

extension Pin: Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
