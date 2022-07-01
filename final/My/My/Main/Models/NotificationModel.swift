//
//  NotificationModel.swift
//  jamit
//
//  Created by Do Trung Bao on 16/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class NotificationModel: JamitResponce {
 
    var results = 0
    
    var isHasNoti: Bool {
        get {
            return results > 0
        }
    }
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.results = self.parseValueFromDict("results") ?? 0
    }
    
}
