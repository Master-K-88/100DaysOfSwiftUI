//
//  CheckTokenModel.swift
//  jamit
//
//  Created by Do Trung Bao on 8/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class CheckTokenModel: JsonModel {
    var activeToken = false
    var verifiedData: UserModel?
    
    override func initFromDict(_ dict: [String : Any]?) {
        super.initFromDict(dict)
        self.activeToken = self.parseValueFromDict("activeToken") ?? false
        self.verifiedData = self.parseModelFromDict("verifiedData")
    }
}
