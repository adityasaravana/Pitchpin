//
//  WaveformView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 7/9/23.
//

import SwiftUI
import UIKit
import FDWaveformView

struct WaveformView: UIViewControllerRepresentable {
    var recording: Recording
    
    init(from recording: Recording) {
        self.recording = recording
    }
    
    typealias UIViewControllerType = WaveformViewController
    
    func makeUIViewController(context: Context) -> WaveformViewController {
        let vc = WaveformViewController(from: recording.audio!)
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: WaveformViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

class WaveformViewController: UIViewController {
    @IBOutlet weak var mySampleWaveform: FDWaveformView!
    var url: URL
    
    init(from url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thisBundle = Bundle(for: type(of: self))
        let url = thisBundle.url(forResource: "myaudio", withExtension: "mp3")
        mySampleWaveform.audioURL = url
        mySampleWaveform.wavesColor = .green
        mySampleWaveform.doesAllowScrubbing = true
        mySampleWaveform.doesAllowStretch = true
        mySampleWaveform.doesAllowScroll = true
    }
}
