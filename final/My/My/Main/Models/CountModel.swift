//
//  CountModel.swift
//  jamit
//
//  Created by Do Trung Bao on 28/04/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class CountModel: JsonModel {
    
    var tracked = false
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.tracked = self.parseValueFromDict("tracked") ?? false
    }
}
