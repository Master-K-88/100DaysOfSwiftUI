//
//  DolbyParticipant.swift
//  jamit
//
//  Created by Do Trung Bao on 25/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import VoxeetSDK

public class DolbyParticipant: NSObject {
    
    var participant: VTParticipant!
    var isMicOn = false
    var isSpeaking = false
    var userType = 0
    
    var isHost: Bool {
        get {
            return userType == IDolbyConstant.DLB_USER_TYPE_HOST
        }
    }
    
    var isSpeaker: Bool {
        get {
            return userType == IDolbyConstant.DLB_USER_TYPE_SPEAKER
        }
    }
    
    var isListener: Bool {
        get {
            return userType == IDolbyConstant.DLB_USER_TYPE_LISTENER
        }
    }
    
    init(_ participant: VTParticipant, _ userType: Int) {
        super.init()
        self.participant = participant
        self.userType = userType
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if object is DolbyParticipant {
            let objectCp = object as! DolbyParticipant
            
            let objectCpId = objectCp.participant.id ?? ""
            let currentId = self.participant.id ?? ""
            let isEqualId = !currentId.isEmpty && currentId.elementsEqual(objectCpId)
            
            let objectCpExternalId = objectCp.participant.info.externalID ?? ""
            let currentExternalId = self.participant.info.externalID ?? ""
            let isEqualExternalId = !currentExternalId.isEmpty && currentExternalId.elementsEqual(objectCpExternalId)
            
            return isEqualId  && isEqualExternalId
            
        }
        return false
    }
    
}
