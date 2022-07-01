//
//  CategoryModel.swift
//  jamit
//
//  Created by Do Trung Bao on 8/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class CategoryModel: JsonModel {

    var categoryID = ""
    var name = ""
    var slug = ""
    
    override func initFromDict(_ dict: [String : Any]?) {
        super.initFromDict(dict)
        self.categoryID = self.parseValueFromDict("categoryID") ?? ""
        self.name = self.parseValueFromDict("name") ?? ""
        self.slug = self.parseValueFromDict("slug") ?? ""
    }
    
    override func createDictToSave() -> [String : Any]? {
        var dicts = super.createDictToSave()
        dicts!.updateValue(self.categoryID, forKey: "categoryID")
        dicts!.updateValue(self.name, forKey: "name")
        dicts!.updateValue(self.slug, forKey: "slug")
        return dicts
    }
    
    override func equalElement(_ otherModel: JsonModel?) -> Bool {
        if let catModel = otherModel as? CategoryModel {
            return !categoryID.isEmpty  && catModel.categoryID.elementsEqual(categoryID)
        }
        return false
    }
    
}
