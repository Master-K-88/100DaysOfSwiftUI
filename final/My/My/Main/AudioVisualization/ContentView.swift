//
//  ContentView.swift
//  jamit
//
//  Created by Prof K on 3/28/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // 1
//    @ObservedObject var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    @EnvironmentObject var mic: MicrophoneMonitor
    
    // 2
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.4, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        VStack {
             // 3
            HStack(spacing: 4) {
                 // 4
                ForEach(mic.soundSamples, id: \.self) { level in
                    BarView(value: self.normalizeSoundLevel(level: level))
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
