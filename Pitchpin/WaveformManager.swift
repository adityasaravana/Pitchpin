//
//  WaveformManager.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/10/23.
//

import Foundation

class WaveformManager: NSObject, ObservableObject {
    static let shared = WaveformManager()
    
    private let waveformManager: SCAudioManager
    @Published var samples: [Float] = []
    @Published var recordingTime: TimeInterval = 0
    
    override init() {
        waveformManager = SCAudioManager()
        
        super.init()
        
        waveformManager.prepareAudioRecording()
        waveformManager.recordingDelegate = self
    }
    
    func activate() {
        samples = []
        
        waveformManager.startRecording()
    }
    
    func stop() {
        waveformManager.stopRecording()
    }
}


extension WaveformManager: RecordingDelegate {
    // MARK: - RecordingDelegate
    
    func audioManager(_ manager: SCAudioManager!, didAllowRecording flag: Bool) {}
    
    func audioManager(_ manager: SCAudioManager!, didFinishRecordingSuccessfully flag: Bool) {}
    
    func audioManager(_ manager: SCAudioManager!, didUpdateRecordProgress progress: CGFloat) {
        let linear = 1 - pow(10, manager.lastAveragePower() / 20)
        
        // Here we add the same sample 3 times to speed up the animation.
        // Usually you'd just add the sample once.
        recordingTime = waveformManager.currentRecordingTime
        samples += [linear, linear, linear]
        print(samples)
    }
}
