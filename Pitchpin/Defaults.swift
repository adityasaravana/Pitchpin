//
//  Defaults.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/8/23.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let recordings = Key<[Recording]>("recordings", default: [])
    //            ^            ^         ^                ^
    //           Key          Type   UserDefaults name   Default value
}
