//
//  DeepLinkModel.swift
//  JamIt
//
//  Created by JamIt on 8/23/20.
//  Copyright © 2020 JamIt. All rights reserved.
//

import Foundation

public class DeepLinkModel {
    
    var targetId = ""
    var type = ""
    
    init(_ type: String, _ targetId: String) {
        self.type = type
        self.targetId = targetId
    }
}
