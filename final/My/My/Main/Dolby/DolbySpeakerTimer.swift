//
//  DolbySpeakerTimer.swift
//  jamit
//
//  Created by Do Trung Bao on 28/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import VoxeetSDK

protocol ActiveSpeakerDelegate {
    func onActiveSpeakerUpdated(_ participant:VTParticipant?)
}

public class DolbySpeakerTimer: NSObject {
    
    static let shared = DolbySpeakerTimer()
    
    private let REFRESH_METER = TimeInterval(5) // 5 seconds
    private let OTHER_USER_AUDIO_LEVEL: Float = 0.001
    private let CURRENT_USER_AUDIO_LEVEL: Float = 0.0015
    
    private var timer: Timer?
    private var currentActiveSpeaker: String?
    var delegate: ActiveSpeakerDelegate?
    
    private var isEmptySpeaker = false
    
    func start() {
        self.cancelTimer()
        self.timer = Timer.scheduledTimer(timeInterval: REFRESH_METER, target: self, selector: #selector(onFindSpeakerLoop), userInfo: nil, repeats: false)
    }
    
    func stop() {
        self.cancelTimer()
        self.delegate = nil
    }
    
    private func cancelTimer(){
        let isValid = self.timer?.isValid ?? false
        if isValid {
            self.timer?.invalidate()
        }
        self.timer = nil
    }
    
    @objc func onFindSpeakerLoop() {
        let currentSpeaker = self.getCurrentSpeaker()
        let lastActiveSpeaker = currentSpeaker?.id
        
        if lastActiveSpeaker == nil && self.currentActiveSpeaker == nil && !self.isEmptySpeaker {
            self.isEmptySpeaker = true
            self.sendActiveSpeakersUpdated()
            self.start()
            return
        }
        
        //TODO check if we got have no speaker
        if self.currentActiveSpeaker != nil && lastActiveSpeaker == nil {
            self.currentActiveSpeaker = nil
            self.isEmptySpeaker = true
            self.sendActiveSpeakersUpdated()
            self.start()
            return
        }
        //TODO check if we got new speaker
        if lastActiveSpeaker != nil && (currentActiveSpeaker == nil || !currentActiveSpeaker!.elementsEqual(lastActiveSpeaker!)) {
            //if we had a previous active speaker
            if let participant = self.findParticipant(lastActiveSpeaker), participant.type != .mixer {
                self.currentActiveSpeaker = lastActiveSpeaker
            }
            self.sendActiveSpeakersUpdated()
            self.isEmptySpeaker = false
        }
        self.start()
    }
    
    func getCurrentSpeaker() -> VTParticipant? {
        if let participants = VoxeetSDK.shared.conference.current?.participants, !participants.isEmpty {
            if let currentUserId = VoxeetSDK.shared.session.participant?.id {
                return participants.first { participant in
                    let id = participant.id ?? ""
                    if !id.isEmpty && participant.type != .mixer {
                        let audioLevels = VoxeetSDK.shared.conference.audioLevel(participant: participant)
                        let isCurrentUser = id.elementsEqual(currentUserId)
                        return self.isSpeakingWithAudioLevel(audioLevels,isCurrentUser)
                    }
                    return false
                }
            }
        }
        return nil
    }
    
    private func sendActiveSpeakersUpdated() {
        let participantSpeaker = self.findParticipant(currentActiveSpeaker)
        self.delegate?.onActiveSpeakerUpdated(participantSpeaker)
    }
    
    private func findParticipant(_ id: String?) -> VTParticipant? {
        if id == nil || id!.isEmpty { return nil }
        let participants = VoxeetSDK.shared.conference.current?.participants
        return participants?.first(where: { participant in
            let cpId = participant.id ?? ""
            return cpId.elementsEqual(id!)
        })
    }
    
    func isSpeakingWithAudioLevel(_ audioLevels: Float, _ isCurrentUser: Bool) -> Bool {
        if isCurrentUser && audioLevels >= CURRENT_USER_AUDIO_LEVEL {
            return true
        }
        return !isCurrentUser && audioLevels > OTHER_USER_AUDIO_LEVEL
    }
    
}
