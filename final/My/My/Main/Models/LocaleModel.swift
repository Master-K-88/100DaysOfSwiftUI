//
//  LocaleModel.swift
//  jamit
//
//  Created by Do Trung Bao on 27/04/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class LocaleModel : JsonModel {
    var code = ""
    var nativeName = ""
    var name = ""
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.code = self.parseValueFromDict("code") ?? ""
        self.nativeName = self.parseValueFromDict("nativeName") ?? ""
        self.name = self.parseValueFromDict("name") ?? ""
    }
    
    func getFullName() -> String {
        if !nativeName.isEmpty {
            return nativeName
        }
        if nativeName.isEmpty && !name.isEmpty {
            return name
        }
        return "Unknown"
    }
}
