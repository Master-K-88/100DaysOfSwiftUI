//
//  MicMonitor.swift
//  jamit
//
//  Created by Prof K on 3/28/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
import Foundation
import AVFoundation

//class MicrophoneMonitor: ObservableObject {
//
//    // 1
//    private var audioRecorder: AVAudioRecorder
//    private var timer: Timer?
//
//    private var currentSample: Int
//    private let numberOfSamples: Int
//
//    // 2
//    @Published public var soundSamples: [Float]
//
//    init(numberOfSamples: Int) {
//        self.numberOfSamples = numberOfSamples // In production check this is > 0.
//        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
//        self.currentSample = 0
//
//        // 3
//        let audioSession = AVAudioSession.sharedInstance()
//        if audioSession.recordPermission != .granted {
//            audioSession.requestRecordPermission { (isGranted) in
//                if !isGranted {
//                    fatalError("You must allow audio recording for this demo to work")
//                }
//            }
//        }
//
//        // 4
//        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
//        let recorderSettings: [String:Any] = [
//            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
//            AVSampleRateKey: 22050.0,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
//        ]
//
//        // 5
//        do {
//            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
//            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
//
////            startMonitoring()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    // 6
////    private func startMonitoring() {
////        audioRecorder.isMeteringEnabled = true
////        audioRecorder.record()
////        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
////            // 7
////            self.audioRecorder.updateMeters()
////            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
////            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
////
////            print("This is the sound samples \(self.soundSamples)")
////        })
////    }
//
//    // 8
//    deinit {
//        timer?.invalidate()
//        audioRecorder.stop()
//    }
//}

//import Foundation
//import AVFoundation
//
class MicrophoneMonitor: ObservableObject {

    // 1
//    private var audioRecorder: AVAudioRecorder
//    private var timer: Timer?

//    var currentSample: Int = 0
//    let numberOfSamples: Int = 75

    // 2
    @Published var soundSamples: [Float] = [Float](repeating: .zero, count: numberOfSamples)

//    self.soundSamples =

//    init() {
////        self.numberOfSamples = numberOfSamples // In production check this is > 0.
//
////        self.currentSample = 0
//
//        // 3
////        let audioSession = AVAudioSession.sharedInstance()
////        if audioSession.recordPermission != .granted {
////            audioSession.requestRecordPermission { (isGranted) in
////                if !isGranted {
////                    fatalError("You must allow audio recording for this demo to work")
////                }
////            }
////        }
//
//        // 4
////        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
////        let recorderSettings: [String:Any] = [
////            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
////            AVSampleRateKey: 22050.0,
////            AVNumberOfChannelsKey: 1,
////            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
////        ]
//
//        // 5
////        do {
////            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
////            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
////
////            startMonitoring()
////        } catch {
////            fatalError(error.localizedDescription)
////        }
//    }

    // 6
//    func startMonitoring() {
//        audioRecorder.isMeteringEnabled = true
//        audioRecorder.record()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
//            // 7
//            self.audioRecorder.updateMeters()
//            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
//            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
//
//            print("This is the sound samples \(self.soundSamples)")
//        })
//    }

//    func stopMonitoring() {
//        timer?.invalidate()
//        audioRecorder.stop()
//    }
    // 8
//    deinit {
//        timer?.invalidate()
//        audioRecorder.stop()
//    }
}
