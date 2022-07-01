//
//  DolbyRequestSpeaker.swift
//  jamit
//
//  Created by Do Trung Bao on 25/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import VoxeetSDK

public class DolbyRequestSpeaker: JsonModel {
    
    var participant: VTParticipant!
    var isHasPermission = false
    
    var userName: String {
        get {
            return participant?.info.name ?? ""
        }
    }
    
    var userAvatar: String {
        get {
            return participant?.info.avatarURL ?? ""
        }
    }
    
    var userId: String {
        get {
            return participant?.id ?? ""
        }
    }
    
    var externalId: String {
        get {
            return participant?.info.externalID ?? ""
        }
    }
    
    required init() {
        
    }
    
    init(_ participant: VTParticipant, _ isHasPermission: Bool) {
        super.init()
        self.participant = participant
        self.isHasPermission = isHasPermission
    }
    
    override func equalElement(_ object: JsonModel?) -> Bool {
        if object is DolbyRequestSpeaker {
            let objectCp = object as! DolbyRequestSpeaker
            
            let objectCpId = objectCp.userId
            let isEqualId = !self.userId.isEmpty && self.userId.elementsEqual(objectCpId)
            
            let objectCpExternalId = objectCp.externalId
            let isEqualExternalId = !self.externalId.isEmpty && self.externalId.elementsEqual(objectCpExternalId)
            
            return isEqualId  && isEqualExternalId
            
        }
        return false
    }

    
}
