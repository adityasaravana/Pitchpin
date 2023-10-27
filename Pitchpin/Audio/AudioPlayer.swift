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
    @Published var currentlyPlaying: Recording?
    @Published var isPlaying = false
    @Published var state: AudioPlayerState = .notPlaying
    
    var recording: Recording?
    
    var audioPlayer: AVAudioPlayer?
    
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
                audioPlayer?.delegate = self
                
            } catch {
                print("init Recording - docatch failed: - \(error)")
            }
        }
    }
    
    func startPlayback(recording: Recording) {
        audioPlayer?.play()
        isPlaying = true
        state = .playing
        print("Play Recording - Playing")
        withAnimation(.spring()) {
            currentlyPlaying = recording
        }
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
        state = .paused
        print("Play Recording - Paused")
    }
    
    func resumePlayback() {
        audioPlayer?.play()
        isPlaying = true
        state = .playing
        print("Play Recording - Resumed")
    }
    
    func stopPlayback() {
        if audioPlayer != nil {
            audioPlayer?.stop()
            isPlaying = false
            state = .finished
            print("Play Recording - Stopped")
            withAnimation(.spring()) {
                self.currentlyPlaying = nil
            }
        } else {
            print("Play Recording - Failed to Stop playing - Coz the recording is not playing")
        }
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
