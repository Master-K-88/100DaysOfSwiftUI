//
//  JamitResultModel.swift
//  jamit
//
//  Created by Do Trung Bao on 5/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class JamitResultModel: JsonModel {
    
    var error = ""
    var message = ""
    var model: JsonModel?
        
    public required init() {
        super.init()
    }
    
    init(message: String = "", error: String =  "") {
        super.init()
        self.message = message
        self.error = error
    }
 
    
    func initFromDict(_ dictionary: [String : Any]?,_ keyModel: String , _ classType: JsonModel.Type) {
        super.initFromDict(dictionary)
        self.error = self.parseValueFromDict("error") ?? ""
        self.message = self.parseValueFromDict("message") ?? ""
        if let dict = dictionary?[keyModel] as? [String: Any]{
            self.model = classType.init()
            self.model?.initFromDict(dict)
        }
    }
    
}
