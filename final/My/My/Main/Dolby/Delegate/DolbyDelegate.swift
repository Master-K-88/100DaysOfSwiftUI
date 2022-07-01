//
//  DolbyDelegate.swift
//  jamit
//
//  Created by Do Trung Bao on 25/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import VoxeetSDK

protocol DolbyConferenceDelegate {
    func onPreJoinConference()
    func onJoinedConference(_ conference: VTConference)
    func onJoinedError(_ error: NSError?)
}

protocol DolbyInviteUserDelegate {
    func onInviteUser(_ user: UserModel, _ participant: VTParticipant?)
    func onInviteError(_ error: NSError?)
}

protocol DolbyLoginDelegate {
    func onLoginDone()
    func onLoginError(_ error: NSError?)
}

protocol DolbyMessageDelegate {
    func onReceivedMessage(_ message: DolbyMessage)
}

protocol DolbyParticipantDelegate {
    func onUpdateParticipant(_ listParticipants: [DolbyParticipant])
    func onUpdateParticipantSpeaker(_ listSpeakers: [DolbyRequestSpeaker]?)
    func onKickedParticipant(_ participant: VTParticipant)
    func onEndedEvent()
    
    /**
     * This is listener for Host when they updated someone to be speaker or remove speaker
     * @param participant
     * @param isSpeaker
     */
    func onHostUpdatedSpeaker(_ participant: VTParticipant, _ isSpeaker: Bool)
}

protocol DolbyStreamUpdateDelegate {
    func onUpdateStream(_ participant: VTParticipant, _ state: Int)
}

protocol DolbyUserInvitedDelegate {
    func onUserInvited(_ confId: String, _ event: EventModel)
    func onUserDeclined(_ confId: String, _ event: EventModel)
    func onInvitedError(_ error: NSError?)
}

