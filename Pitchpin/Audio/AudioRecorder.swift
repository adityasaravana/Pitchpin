//
//  AudioRecorder.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import CoreData
import DateHelper
import DSWaveformImage

class AudioRecorder: NSObject,ObservableObject {
    var recordings = Recordings.shared
    
    //    let moc = PersistenceController.shared.container.viewContext
    
    var audioRecorder: AVAudioRecorder?
    
    @Published private var recordingName = "Recording1"
    @Published private var recordingDate = Date()
    @Published private var recordingURL: URL?
    @Published private var recordingWaveformRender: UIImage?
    @Published private var timestamps: [TimeInterval] = []
    
    @Published var isRecording = false
    
    // MARK: - Pin
    
    func pin() {
        
        if let currentTime: TimeInterval = audioRecorder?.currentTime {
            // Do something with currentTime
            print("Current time of recording: \(currentTime) seconds")
            timestamps.append(currentTime)
        }
        
    }
    
    // MARK: - Start Recording
    
    func startRecording() {
        timestamps.removeAll()
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            print("Start Recording - Recording session setted")
        } catch {
            print("Start Recording - Failed to set up recording session")
        }
        
        let currentDateTime = Date.now
        
        recordingDate = currentDateTime
        recordingName = currentDateTime.toString(dateStyle: .medium, timeStyle: .short) ?? "Recording"
        
        // save the recording to the temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let recordingFileURL = tempDirectory.appendingPathComponent(recordingName).appendingPathExtension("m4a")
        recordingURL = recordingFileURL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingFileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            print("Start Recording - Recording Started")
        } catch {
            print("Start Recording - Could not start recording")
        }
    }
    
    // MARK: - Stop Recording
    
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        
        if let recordingURL {
            do {
                let recordingDate = try Data(contentsOf: recordingURL)
                print("Stop Recording - Saving to CoreData")
                // save the recording to CoreData
                saveRecording(recordingData: recordingDate)
            } catch {
                print("Stop Recording - Could not save to CoreData - Cannot get the recording data from URL: \(error)")
            }
        } else {
            print("Stop Recording -  Could not save to CoreData - Cannot find the recording URL")
        }
        
    }
    
    // MARK: - Saving Recordings --------------------------------------
    
    func saveRecording(recordingData: Data) {
        var pins: [Pin] = []
        
        for timestamp in timestamps {
            pins.append(.init(notes: "", timestamp: timestamp))
            print("!!!!!!!!!!!!!")
            print(timestamp)
            print("!!!!!!!!!!!!!")
        }
        
        let newRecording = Recording(name: recordingName, created: recordingDate, data: recordingData, pins: pins, audioURL: recordingURL)
        recordings.recordings.insert(newRecording, at: 0)
        
    }
    
    func deleteRecordingFile() {
        if let recordingURL {
            do {
                try FileManager.default.removeItem(at: recordingURL)
                print("Stop Recording - Successfully deleted the recording file")
            } catch {
                print("Stop Recording - Could not delete the recording file - Cannot find the recording URL")
            }
        }
    }
}
