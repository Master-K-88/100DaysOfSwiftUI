//
//  AvatarModel.swift
//  jamit
//
//  Created by Do Trung Bao on 8/9/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class AvatarModel: JamitResponce {
    
    var avatarURl = ""
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.avatarURl = self.parseValueFromDict("avatar_url") ?? ""
    }
}
