//
//  DolbyMessage.swift
//  jamit
//
//  Created by Do Trung Bao on 25/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import VoxeetSDK

public class DolbyMessage: NSObject{
    
    var participant: VTParticipant!
    
    var message: String?
    var realMessage: String?
    var command = 0
    var confId: String?
    var payloadUserId: String?
    
    var userName: String {
        get {
            return participant?.info.name ?? ""
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
    
    var isHostMessage: Bool {
        get {
            return message?.starts(with: IDolbyConstant.SCHEME_HOST_URI) ?? false
        }
    }
    
    var isListenerMessage: Bool {
        get {
            return message?.starts(with: IDolbyConstant.SCHEME_LISTENER_URI) ?? false
        }
    }
    
    var isSpeakerMessage: Bool {
        get {
            return message?.starts(with: IDolbyConstant.SCHEME_SPEAKER_URI) ?? false
        }
    }
    
    var isCommandMsg: Bool {
        get {
            return command > 0 && payloadUserId != nil && !payloadUserId!.isEmpty
        }
    }
    
    init(_ participant: VTParticipant, _ confId: String) {
        super.init()
        self.participant = participant
        self.confId = confId
    }
  
    func setMessage(message: String?){
        self.message = message
        if self.isHostMessage || self.isListenerMessage || self.isSpeakerMessage {
            self.realMessage = message?.replacingOccurrences(of: IDolbyConstant.SCHEME_HOST_URI, with: "")
                                    .replacingOccurrences(of: IDolbyConstant.SCHEME_SPEAKER_URI, with: "")
                                    .replacingOccurrences(of: IDolbyConstant.SCHEME_LISTENER_URI, with: "")
                                    .replacingOccurrences(of: IDolbyConstant.URI_HOST_REQUEST, with: "")
            if let dataArray = realMessage?.split(separator: "/") {
                if dataArray.count >= 2 {
                    self.payloadUserId = String(dataArray[0])
                    let commandStr = String(dataArray[1])
                    if commandStr.isNumber() {
                        self.command = Int(commandStr) ?? 0
                    }
                    JamitLog.logD("=====>payloadUserId=\(String(describing: payloadUserId))==>command=\(command)")
                }
            }
            
        }
    }
    
    public static func buildCommandMsg(_ scheme: String,
                                  _ userId: String,
                                  _ command: Int) -> String {
        return scheme + IDolbyConstant.URI_HOST_REQUEST + userId + "/" + String(command)
     }

}
