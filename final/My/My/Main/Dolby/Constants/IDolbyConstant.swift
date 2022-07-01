//
//  IDolbyConstant.swift
//  jamit
//
//  Created by Do Trung Bao on 24/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation

public class IDolbyConstant {
    
    static let DLB_USER_TYPE_HOST = 1
    static let DLB_USER_TYPE_LISTENER = 2
    static let DLB_USER_TYPE_SPEAKER = 3
    
    static let ID_EMPTY = "00000000-0000-0000-0000-000000000000"
    static let TYPE_ADDED_STREAM = 1
    static let TYPE_REMOVED_STREAM = 2
    
    static let SCHEME_HOST_URI = "hst://"
    static let SCHEME_LISTENER_URI = "lst://"
    static let SCHEME_SPEAKER_URI = "spk://"
    
    static let CMD_REQUEST_RAISE_HAND = 100
    static let CMD_ACCEPT_RAISE_HAND = 101
    static let CMD_DECLINE_RAISE_HAND = 102
    static let CMD_REMOVED_SPEAKER = 103
    static let CMD_RESET_RAISE_HAND = 104
    
    static let URI_HOST_REQUEST = "jam.cmd/"
}
