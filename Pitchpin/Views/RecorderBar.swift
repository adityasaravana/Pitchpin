//
//  RecorderBar.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-22.
//

import SwiftUI
import DSWaveformImageViews
import DSWaveformImage

struct RecorderBar: View {
    @ObservedObject var waveformManager = WaveformManager.shared
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @State var buttonSize: CGFloat = 1
    @State var liveConfiguration: Waveform.Configuration = Waveform.Configuration (
        style: .striped(.init(color: .red, width: 3, spacing: 3))
    )
    
    var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
            .repeatForever()
    }
    
    let recordButtonSize: CGFloat = 105
    
    
    @State var showPinAddedText = false
    
    var body: some View {
        VStack {
            // TODO: - Only show this while recording but without making the button gigantic while it isn't.
            //            if audioRecorder.isRecording {
            //                WaveformLiveCanvas(
            //                    samples: waveformManager.samples,
            //                    configuration: liveConfiguration,
            //                    renderer: LinearWaveformRenderer(),
            //                    shouldDrawSilencePadding: true
            //                )
            //            }
            
            
            if let audioRecorder = audioRecorder.audioRecorder, audioRecorder.isRecording {
                TimelineView(.periodic(from: .now, by: 1)) { _ in
                    // recording duration
                    Text(DateComponentsFormatter.positional.string(from: audioRecorder.currentTime) ?? "0:00")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .transition(.scale)
            }
            
            
            ZStack {
                Button {
                    if audioRecorder.isRecording {
                        waveformManager.stop()
                        stopRecording()
                    } else {
                        waveformManager.activate()
                        startRecording()
                    }
                } label: {
                    RecordButtonShape(isRecording: audioRecorder.isRecording)
                        .fill(.red).frame(width: recordButtonSize)
                }
                
                Circle()
                    .strokeBorder(lineWidth: 5)
                    .frame(width: recordButtonSize)
                    .foregroundColor(.white)
                
                HStack {
                    VStack {
                        if showPinAddedText {
                            PinAddedText(showingPinAddedText: $showPinAddedText)
                        }
                        Button {
                            
                            if audioRecorder.isRecording {
                                
                                audioRecorder.pin()
                                showPinAddedText = true
                            }
                        } label: {
                            ZStack {
                                
                                Image(systemName: "pin.fill").font(.system(size: 30))
                            }
                        }
                        .buttonStyle(PinButtonStyle())
                        .padding()
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .frame(maxHeight: 200, alignment: .center)
        .onDisappear { waveformManager.stop() }
    }
    
    
    func startRecording() {
        
        audioRecorder.startRecording()
        
    }
    
    func stopRecording() {
        // Stop Recording
        audioRecorder.stopRecording()
    }
    
}

fileprivate struct PreviewView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Hello, world!")
            Spacer()
        }.safeAreaInset(edge: .bottom) {
            RecorderBar()
                .shadow(radius: 40)
                .background(
                    .pitchpinGray
                    //                .cornerRadius(30, corners: [.topLeft, .topRight]).edgesIgnoringSafeArea(.all)
                )
        }
    }
}

#Preview {
    PreviewView()
}

struct RecordButtonShape: Shape {
    var shapeRadius: CGFloat
    var distanceFromCardinal: CGFloat
    var b: CGFloat
    var c: CGFloat
    
    init(isRecording: Bool) {
        self.shapeRadius = isRecording ? 1.0 : 0.0
        self.distanceFromCardinal = isRecording ? 1.0 : 0.0
        self.b = isRecording ? 0.90 : 0.55
        self.c = isRecording ? 1.00 : 0.99
    }
    
    var animatableData: AnimatablePair<Double, AnimatablePair<Double, AnimatablePair<Double, Double>>> {
        get {
            AnimatablePair(Double(shapeRadius),
                           AnimatablePair(Double(distanceFromCardinal),
                                          AnimatablePair(Double(b), Double(c))))
        }
        set {
            shapeRadius = Double(newValue.first)
            distanceFromCardinal = Double(newValue.second.first)
            b = Double(newValue.second.second.first)
            c = Double(newValue.second.second.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let minDimension = min(rect.maxX, rect.maxY)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (minDimension / 2 * 0.82) - (shapeRadius * minDimension * 0.22)
        let movementFactor = 0.65
        
        let rightTop = CGPoint(x: center.x + radius, y: center.y - radius * movementFactor * distanceFromCardinal)
        let rightBottom = CGPoint(x: center.x + radius, y: center.y + radius * movementFactor * distanceFromCardinal)
        
        let topRight = CGPoint(x: center.x + radius * movementFactor * distanceFromCardinal, y: center.y - radius)
        let topLeft = CGPoint(x: center.x - radius * movementFactor * distanceFromCardinal, y: center.y - radius)
        
        let leftTop = CGPoint(x: center.x - radius, y: center.y - radius * movementFactor * distanceFromCardinal)
        let leftBottom = CGPoint(x: center.x - radius, y: center.y + radius * movementFactor * distanceFromCardinal)
        
        let bottomRight = CGPoint(x: center.x + radius * movementFactor * distanceFromCardinal, y: center.y + radius)
        let bottomLeft = CGPoint(x: center.x - radius * movementFactor * distanceFromCardinal, y: center.y + radius)
        
        let topRightControl1 = CGPoint(x: center.x + radius * c, y: center.y - radius * b)
        let topRightControl2 = CGPoint(x: center.x + radius * b, y: center.y - radius * c)
        
        let topLeftControl1 = CGPoint(x: center.x - radius * b, y: center.y - radius * c)
        let topLeftControl2 = CGPoint(x: center.x - radius * c, y: center.y - radius * b)
        
        let bottomLeftControl1 = CGPoint(x: center.x - radius * c, y: center.y + radius * b)
        let bottomLeftControl2 = CGPoint(x: center.x - radius * b, y: center.y + radius * c)
        
        let bottomRightControl1 = CGPoint(x: center.x + radius * b, y: center.y + radius * c)
        let bottomRightControl2 = CGPoint(x: center.x + radius * c, y: center.y + radius * b)
        
        var path = Path()
        
        path.move(to: rightTop)
        path.addCurve(to: topRight, control1: topRightControl1, control2: topRightControl2)
        path.addLine(to: topLeft)
        path.addCurve(to: leftTop, control1: topLeftControl1, control2: topLeftControl2)
        path.addLine(to: leftBottom)
        path.addCurve(to: bottomLeft, control1: bottomLeftControl1, control2: bottomLeftControl2)
        path.addLine(to: bottomRight)
        path.addCurve(to: rightBottom, control1: bottomRightControl1, control2: bottomRightControl2)
        path.addLine(to: rightTop)
        
        return path
    }
}

struct PinAddedText: View {
    @Binding var showingPinAddedText: Bool
    var body: some View {
        Text("🎉 Pin added! 🎉")
            .bold()
            .font(.caption2)
            .foregroundStyle(.white)
            .transition(.scale)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation {
                        self.showingPinAddedText = false
                    }
                })
            }
    }
}

#Preview {
    PinAddedText(showingPinAddedText: .constant(true))
}
