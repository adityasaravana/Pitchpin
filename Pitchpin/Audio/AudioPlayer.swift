//
//  AudioPlayer.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

enum AudioPlayerState {
    case notPlaying
    case playing
    case paused
    case finished
}

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var state: AudioPlayerState = .notPlaying
    
    var recording: Recording
    
    var audioPlayer: AVAudioPlayer
    
    init(recording: Recording) {
        self.recording = recording
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
            try playbackSession.setActive(true)
            print("Start Recording - Playback session setted")
        } catch {
            print("Play Recording - Failed to set up playback session")
        }
        audioPlayer = try! AVAudioPlayer(data: recording.data!)
        
        super.init()
        audioPlayer.delegate = self
    }
    
    func initialize(recording: Recording) {
        if let recordingData = recording.data {
            let playbackSession = AVAudioSession.sharedInstance()
            
            do {
                try playbackSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
                try playbackSession.setActive(true)
                print("Start Recording - Playback session setted")
            } catch {
                print("Play Recording - Failed to set up playback session")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(data: recordingData)
                audioPlayer.delegate = self
                
            } catch {
                print("init Recording - docatch failed: - \(error)")
            }
        }
    }
    
    func startPlayback(recording: Recording) {
        state = .playing
        audioPlayer.play()
        
    }
    
    func pausePlayback() {
        state = .paused
        audioPlayer.pause()
        
        Task { print("Play Recording - Paused") }
    }
    
    func resumePlayback() {
        state = .playing
        audioPlayer.play()
        
        Task { print("Play Recording - Resumed") }
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            state = .finished
//            isPlaying = false
//            print("Play Recording - Recoring finished playing")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                withAnimation(.spring()) {
//                    self.currentlyPlaying = nil
//                }
//            }
        }
    }
    
}
