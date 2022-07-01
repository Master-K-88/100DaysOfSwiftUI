//
//  TopicModel.swift
//  jamit
//
//  Created by Do Trung Bao on 27/04/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation

public class TopicModel: JsonModel {
    var rootId = ""
    var topicID = ""
    var name = ""
    var slug = ""
    var image = ImageModel()
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.rootId = self.parseValueFromDict("_id") ?? ""
        self.topicID = self.parseValueFromDict("topicID") ?? ""
        self.name = self.parseValueFromDict("name") ?? ""
        self.slug = self.parseValueFromDict("slug") ?? ""
        if let dict = dictionary?["image"] as? [String: Any]{
            self.image.initFromDict(dict)
        }
    }
    
    func getImage() -> String {
        return image.url
    }
    
}
