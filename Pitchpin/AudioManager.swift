//
//  AudioManager.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/8/23.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private let jsonURL = URL(fileURLWithPath: "Pitchpin Recording Data", relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
    static let shared = AudioManager()
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    @Published var isRecording: Bool = false
    @Published var recordings: [Recording] = [] {
        didSet {
            saveJSON()
        }
    }
    
    
    override init() {
        super.init()
        loadJSON()
    }
    
    func record(to recording: inout Recording) {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let path = FileManager.documentsDirectoryURL
        let filePath = path.appendingPathComponent("Pitchpin Recording - ID: \(recording.id.uuidString).m4a")
        
        recording.audio = filePath
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
//            isRecording = true
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    
    func stopRecording() {
        audioRecorder.stop()
//        isRecording = false
    }
    
    func getFileCreationDate(from file: URL) -> Date {
            if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
                let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                return creationDate
            } else {
                return Date()
            }
        }
    
//    func fetchRecordings() {
//
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
//
//
//        for url in directoryContents {
//
//            recordings.append(Recording(created: getFileCreationDate(from: url), audio: url))
//        }
//
//        recordings.sort(by: { $0.created.compare($1.created) == .orderedDescending})
//    }
    
    func play(from url: URL) {
      
        let playSession = AVAudioSession.sharedInstance()
            
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
            
        do {
            audioPlayer = try AVAudioPlayer(contentsOf : url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
                
            for i in 0 ..< recordings.count{
                if recordings[i].audio == url {
                    recordings[i].playing = true
                }
            }
                
        } catch {
            print("Playing Failed")
        }
                
    }

    func stopPlaying(from url: URL) {
      
        audioPlayer.stop()
      
        for recording in 0 ..< recordings.count {
            if recordings[recording].audio == url {
                recordings[recording].playing = false
            }
        }
    }
    
    func deleteRecording(url : URL){
            
        do {
            try FileManager.default.removeItem(at : url)
        } catch {
            print("Can't delete")
        }
            
        for i in 0 ..< recordings.count {
            if recordings[i].audio != nil {
                if recordings[i].audio == url {
                    if recordings[i].playing == true {
                        stopPlaying(from: recordings[i].audio!)
                    }
                    
                    recordings.remove(at: i)
                    
                    break
                }
            }
        }
    }
}

extension AudioManager {
    func loadJSON() {
        guard FileManager.default.fileExists(atPath: jsonURL.path) else {
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: jsonURL)
            recordings = try decoder.decode([Recording].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(recordings)
            try data.write(to: jsonURL, options: .atomicWrite)
        } catch {
            print(error.localizedDescription)
        }
    }
}
