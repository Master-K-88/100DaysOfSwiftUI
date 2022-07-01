//
//  ReviewModel.swift
//  jamit
//
//  Created by Do Trung Bao on 8/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
public class ReviewModel: JamitResponce {
    var id = ""
    var text = ""
    var created = ""
    var deleted = false
    var author = UserModel()
    var timeAgo = ""
    
    var heightText = DimenRes.pivot_review_height
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.id = self.parseValueFromDict("_id") ?? ""
        if let text = dictionary?["text"] as? String{
            self.text = text
        }
        if let comment = dictionary?["comment"] as? String{
            self.text = comment
        }
        self.created = self.parseValueFromDict("created") ?? ""
        self.deleted = self.parseValueFromDict("deleted") ?? false
        if let dict = dictionary?["postedBy"] as? [String: Any]{
            self.author.initFromDict(dict)
        }
    }
    
    func isMyComment(_ userId: String) -> Bool{
        let currentUserId = author.userID
        return currentUserId.elementsEqual(userId)
    }
    
    func getStrTimeAgo() -> String {
        if self.timeAgo.isEmpty && !created.isEmpty {
            if let parseDate = DateTimeUtils.getDateFromString(created, IJamitConstants.SERVER_NEW_DATE_PATTERN){
                let delaTimeInSecond = (DateTimeUtils.currentTimeMillis() - Double(parseDate.timeIntervalSince1970 * 1000)) / 1000
                self.timeAgo = DateTimeUtils.getStringTimeAgo(delaTimeInSecond)
            }
        }
        return self.timeAgo
    }
    
    override func equalElement(_ otherModel: JsonModel?) -> Bool {
        if let abModel = otherModel as? ReviewModel {
            return !id.isEmpty  && abModel.id.elementsEqual(id)
        }
        return false
    }
}
