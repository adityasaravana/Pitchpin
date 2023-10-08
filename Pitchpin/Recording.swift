//
//  Recording.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/8/23.
//

import Foundation
import Defaults

struct Recording: Codable, Defaults.Serializable {
    var id = UUID()
    var name: String
    var created: Date
    var data: Data?
    var pins: [Pin] = []
}
