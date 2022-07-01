//
//  ImageModel.swift
//  jamit
//
//  Created by Do Trung Bao on 27/04/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class ImageModel: JsonModel {
    var url = ""
    var key = ""
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.url = self.parseValueFromDict("url") ?? ""
        self.key = self.parseValueFromDict("key") ?? ""
    }
}
