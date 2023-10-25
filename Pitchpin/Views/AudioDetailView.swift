//
//  AudioDetailView.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 10/24/23.
//

import SwiftUI

struct AudioDetailView: View {
    var recording: Recording
    var body: some View {
        VStack {
            Text(recording.name)
                .bold()
                .font(.title)
            
            HStack {
                
            }
        }
    }
}

#Preview {
    AudioDetailView(recording: .init(name: "test", created: Date(), pins: [.init(notes: "", timestamp: 0.71333)]))
}
