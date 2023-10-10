//
//  Pin.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/8/23.
//

import Foundation
import Defaults

struct Pin: Codable, Defaults.Serializable {
    var notes: String
    var timestamp: TimeInterval?
    var time = Date()
}
