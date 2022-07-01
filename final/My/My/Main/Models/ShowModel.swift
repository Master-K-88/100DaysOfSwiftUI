//
//  NewShowModel.swift
//  jamit
//  Created by Do Trung Bao on 8/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class ShowModel : JamitResponce {
    var id = ""
    var audioType = ""
    var audioId = ""
    var slug = ""
    var title = ""
    var summary = ""
    var description = ""
    var imageUrl = ""
    var imgFeatured = ""
    var numEpisodes = 0
    var author = ""
    var isPremium = false
    var subscribers: [UserModel]?
    var reviews: [ReviewModel]?
    var tipSupportUrl = ""
    
    public required init() {
        super.init()
    }
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.id = self.parseValueFromDict("_id") ?? ""
        self.audioType = self.parseValueFromDict("audio_type") ?? ""
        self.audioId = self.parseValueFromDict("audio_id") ?? ""
        self.slug = self.parseValueFromDict("slug") ?? ""
        self.title = self.parseValueFromDict("title") ?? ""
        self.summary = self.parseValueFromDict("summary") ?? ""
        self.description = self.parseValueFromDict("description") ?? ""
        self.imageUrl = self.parseValueFromDict("image_url") ?? ""
        self.imgFeatured = self.parseValueFromDict("featured_image_url") ?? ""
        self.numEpisodes = self.parseValueFromDict("episode_count") ?? 0
        self.tipSupportUrl = self.parseValueFromDict("creator_support_url") ?? ""
        self.author = self.parseValueFromDict("publisher") ?? ""
        self.isPremium = self.parseValueFromDict("is_premium") ?? false
        self.subscribers = self.parseListFromDict("subscribers")
        self.reviews = self.parseListFromDict("reviews")
        
    }
    
    func isSubscribed(_ userId: String) -> Bool {
        if !userId.isEmpty && self.subscribers != nil {
            for user in self.subscribers! {
                let compareId = user.userID
                if !compareId.isEmpty && compareId.elementsEqual(userId) {
                    return true
                }
            }
        }
        return false
    }

    override func clone() -> ShowModel? {
        let showModel = ShowModel()
        showModel.id = id
        showModel.title = title
        showModel.imageUrl = imageUrl
        showModel.audioId = audioId
        showModel.author = author
        showModel.summary = summary
        showModel.slug = slug
        showModel.description = description
        showModel.summary = summary
        showModel.audioType = audioType
        showModel.imgFeatured = imgFeatured
        showModel.numEpisodes = numEpisodes
        showModel.subscribers = subscribers?.clone()
        showModel.reviews = reviews?.clone()
        showModel.tipSupportUrl = tipSupportUrl
        return showModel
    }
    
    override func equalElement(_ otherModel: JsonModel?) -> Bool {
        if let abModel = otherModel as? ShowModel {
            return !id.isEmpty  && abModel.id.elementsEqual(id)
        }
        return false
    }
    
    override func createDictToSave() -> [String : Any]? {
        var dicts = super.createDictToSave()
        dicts?.updateValue(self.id, forKey: "_id")
        dicts?.updateValue(self.audioType, forKey: "audio_type")
        dicts?.updateValue(self.audioId, forKey: "audio_id")
        dicts?.updateValue(self.slug, forKey: "slug")
        dicts?.updateValue(self.title, forKey: "title")
        dicts?.updateValue(self.summary, forKey: "summary")
        dicts?.updateValue(self.description, forKey: "description")
        dicts?.updateValue(self.imageUrl, forKey: "image_url")
        dicts?.updateValue(self.imgFeatured, forKey: "featured_image_url")
        dicts?.updateValue(self.author, forKey: "publisher")
        dicts?.updateValue(self.isPremium, forKey: "is_premium")
        dicts?.updateValue(self.numEpisodes, forKey: "episode_count")

        let sizeSub = self.subscribers?.count ?? 0
        if sizeSub > 0 {
            let owners = UserModel.getDictFromList(self.subscribers!)
            dicts?.updateValue(owners, forKey: "subscribers")
        }
        let sizeReview = self.reviews?.count ?? 0
        if sizeReview > 0 {
            let reviews = UserModel.getDictFromList(self.reviews!)
            dicts?.updateValue(reviews, forKey: "reviews")
        }
        
        return dicts
    }
    
    override func buildUrlOpenLink() -> String? {
        if !audioType.isEmpty && !audioId.isEmpty {
            return String(format: IJamitConstants.URL_FORMAT_SHARE_SHOW, audioType,audioId)
        }
        return super.buildUrlOpenLink()
    }
    
    override func buildDynamicTitleLink() -> String? {
        return title
    }
    
    override func buildDynamicDesLink() -> String? {
        return summary
    }
    
    override func buildDynamicImageLink() -> String {
        return !imageUrl.isEmpty ? imageUrl : super.buildDynamicImageLink()
    }
    
}
