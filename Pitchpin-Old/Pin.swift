//
//  Pin.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/8/23.
//

import Foundation

struct Pin: Codable, Identifiable {
    var id = UUID()
    var title: String 
    var notes: String
}
