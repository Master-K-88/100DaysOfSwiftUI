//
//  ThemeModel.swift
//  Created by YPY Global on 12/28/18.
//  Copyright © 2018 YPY Global. All rights reserved.
//

import Foundation
public class ThemeModel : AbstractModel{
    
    var startColor = ""
    var endColor = ""
    var orientation = 0
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.startColor = self.parseValueFromDict("grad_start_color") ?? ""
        self.endColor = self.parseValueFromDict("grad_end_color") ?? ""
        self.orientation = self.parseValueFromDict("grad_orientation") ?? 0
    }
    
    override func createDictToSave() -> [String : Any]? {
        var dicts = super.createDictToSave()
        dicts?.updateValue(startColor, forKey: "grad_start_color")
        dicts?.updateValue(endColor, forKey: "grad_end_color")
        dicts?.updateValue(orientation, forKey: "grad_orientation")
        return dicts
    }

}
