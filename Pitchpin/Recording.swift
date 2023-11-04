//
//  Recording.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/8/23.
//

import Foundation
import Defaults
import UIKit

struct Recording: Codable, Defaults.Serializable, Identifiable {
    var id = UUID()
    var name: String
    var created: Date
    var data: Data?
    var pins: [Pin]
    var audioURL: URL?
//    var waveformData: Data?
//    var waveformImage: UIImage? {
//        if let waveformData {
//            return UIImage(data: waveformData)!
//        } else {
//            return nil
//        }
//    }
    
    var duration: TimeInterval? {
        if let audio = self.data {
            return getDuration(of: audio)
        } else {
            return nil
        }
    }
    
    func getDuration(of recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(self.name)")
            return nil
        }
    }
}
