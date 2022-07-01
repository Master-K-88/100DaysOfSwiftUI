//
//  SeriesModel.swift
//  jamit
//
//  Created by Do Trung Bao on 28/04/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation

public class SeriesModel: JsonModel {
    
    var id = ""
    var title = ""
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.id = self.parseValueFromDict("_id") ?? ""
        self.title = self.parseValueFromDict("title") ?? ""
    }
}
