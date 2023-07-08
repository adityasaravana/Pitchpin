//
//  File.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/8/23.
//

import Foundation

struct File: Codable {
    var id = UUID()
    var created = Date()
    
    var name: String? = nil
    var description: String? = nil
    
    var pins: [Pin] = []
    var audio: URL
}
