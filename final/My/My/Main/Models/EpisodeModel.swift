//
//  NewEpisodeModel.swift
//  jamit
//
//  Created by Do Trung Bao on 8/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
//import GoogleMobileAds

public class EpisodeModel : JamitResponce {
    var id = ""
    var audioType = ""
    var format = ""
    var audioId = ""
    var audioSlug = ""
    var audioTitle = ""
    var slug = ""
    var slugId = ""
    var title = ""
    var urlInfo = ""
    var idForDeeplink = ""
    var createDate = ""
    var linkDownload = ""
    var summary = ""
    var description = ""
    var imageUrl = ""
    var duration = ""
    var author = ""
    var commentCount = ""
    var isPremium = false
    var path = ""
    var likes: [String]?
    var tags:[String]?
    var owners: [UserModel]?
    var credits: [UserModel]?
    var timeAgo = ""
    var realDuration: Int = 0
    
    var isShowAds: Bool  = false
    var isAdError = false
//    var nativeAd: GADNativeAd?
//    var adLoader: GADAdLoader?
    var showModel: ShowModel?
    
    public required init() {
        super.init()
    }
    
    init(_ isShowAds: Bool) {
        super.init()
        self.isShowAds = isShowAds
    }
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.id = self.parseValueFromDict("_id") ?? ""
        self.audioType = self.parseValueFromDict("audio_type") ?? ""
        self.audioSlug = self.parseValueFromDict("audio_slug") ?? ""
        self.format = self.parseValueFromDict("format") ?? ""
        self.audioId = self.parseValueFromDict("audio_id") ?? ""
        self.slug = self.parseValueFromDict("episode_slug") ?? ""
        self.slugId = self.parseValueFromDict("episode_slug_id") ?? ""
        self.title = self.parseValueFromDict("episode_title") ?? ""
        self.urlInfo = self.parseValueFromDict("episode_link") ?? ""
        self.idForDeeplink = self.parseValueFromDict("episode_id") ?? ""
        self.createDate = self.parseValueFromDict("release_date") ?? ""
        self.linkDownload = self.parseValueFromDict("download_url") ?? ""
        self.summary = self.parseValueFromDict("subtitle") ?? ""
        self.description = self.parseValueFromDict("show_notes") ?? ""
        self.imageUrl = self.parseValueFromDict("image_url") ?? ""
        self.duration = self.parseValueFromDict("duration") ?? ""
        self.author = self.parseValueFromDict("publisher") ?? ""
        self.audioTitle = self.parseValueFromDict("audio_title") ?? ""
        self.isPremium = self.parseValueFromDict("is_premium") ?? false
        self.path = self.parseValueFromDict("path") ?? ""
        self.likes = self.parseValueFromDict("likes")
        self.tags = self.parseValueFromDict("tags")
        self.commentCount = self.parseValueFromDict("comment_count") ?? ""
        self.owners = self.parseListFromDict("owner")
        self.credits = self.parseListFromDict("credits")
    }
    
    func getDuration() -> String {
        return duration
    }
    func getAuthor() -> String {
        let sizeOwner = owners?.count ?? 0
        if isStory() && sizeOwner > 0 {
            return owners![0].username
        }
        if !audioTitle.isEmpty {
            return audioTitle
        }
        return author
    }
    
    func isStory() -> Bool {
        return audioType.elementsEqual("story")
    }
    
    func isOfflineFile() -> Bool {
        return !path.isEmpty
    }
    
    func getStrTimeAgo() -> String {
        if self.timeAgo.isEmpty && !createDate.isEmpty {
            if let parseDate = DateTimeUtils.getDateFromString(createDate, IJamitConstants.SERVER_NEW_DATE_PATTERN){
                let delaTimeInSecond = (DateTimeUtils.currentTimeMillis() - Double(parseDate.timeIntervalSince1970 * 1000)) / 1000
                self.timeAgo = DateTimeUtils.getStringTimeAgo(delaTimeInSecond)
            }
        }
        return self.timeAgo
    }
    func isFavorite(_ userId : String) -> Bool {
        let sizeLikes = likes?.count ?? 0
        if userId.isEmpty || sizeLikes == 0 {
            return false
        }
        return likes!.contains(userId)
    }
    
    func getLinkStream() -> String {
        let downloadUrl = TotalDataManager.shared.getFileDownloaded(self)
        if downloadUrl != nil && !downloadUrl!.isEmpty {
            return downloadUrl!
        }
        if !linkDownload.isEmpty {
            if linkDownload.contains(".m3u8"){
                return linkDownload
            }
            else if linkDownload.contains(".pls"){
                if linkDownload.contains("listen.pls?") {
                    let rangePls = linkDownload.range(of: "listen.pls?")
                    if rangePls != nil {
                        let s = linkDownload.prefix(upTo:rangePls!.lowerBound)
                        return String(s)
                    }
                }
                else{
                    var data: String?
                    if ApplicationUtils.isOnline() {
                        data = DownloadUtils.downloadString(url: linkDownload)
                    }
                    if data != nil && !(data?.isEmpty)! {
                        let datas = data?.components(separatedBy: CharacterSet.newlines)
                        if datas != nil && (datas?.count)! > 0 {
                            for mStr in datas! {
                                if mStr.contains("File") {
                                    let urls = mStr.components(separatedBy: "=")
                                    if urls.count >= 2 {
                                        return urls[1]
                                    }
                                }
                            }
                        }
                        return data!
                        
                    }
                }
            }
            else if linkDownload.contains(".m3u") {
                var data: String?
                if ApplicationUtils.isOnline() {
                    data = DownloadUtils.downloadString(url: linkDownload)
                }
                if data != nil && !(data?.isEmpty)! {
                    return data!
                }
                else{
                    return linkDownload.replacingOccurrences(of: ".m3u", with: "")
                }
            }
        }
        return linkDownload
    }
    
    override func equalElement(_ otherModel: JsonModel?) -> Bool {
        if let abModel = otherModel as? EpisodeModel {
            return !id.isEmpty  && abModel.id.elementsEqual(id)
        }
        return false
    }
    
    func getUserOwner() -> UserModel? {
        let size = owners?.count ?? 0
        return size > 0 ? owners![0] : nil
    }
    
    func getLikes() -> [String]? {
        let size = likes?.count ?? 0
        if size > 0 {
            return likes?.clone()
        }
        return likes
    }
    
    override func clone() -> EpisodeModel? {
        if !id.isEmpty && !isShowAds {
            let cloneModel = EpisodeModel()
            cloneModel.id = id
            cloneModel.title = title
            cloneModel.linkDownload = linkDownload
            cloneModel.imageUrl = imageUrl
            cloneModel.likes = self.getLikes()
            cloneModel.path = path
            cloneModel.isPremium = isPremium
            cloneModel.urlInfo = urlInfo
            cloneModel.idForDeeplink = idForDeeplink
            cloneModel.isPremium = isPremium
            cloneModel.duration = duration
            cloneModel.slug = slug
            cloneModel.slugId = slugId
            cloneModel.author = author
            cloneModel.audioId = audioId
            cloneModel.audioTitle = audioTitle
            cloneModel.audioSlug = audioSlug
            cloneModel.createDate = createDate
            cloneModel.timeAgo = timeAgo
            cloneModel.summary = summary
            cloneModel.commentCount = commentCount
            cloneModel.owners = owners?.clone()
            cloneModel.credits = credits?.clone()
            cloneModel.description = description
            cloneModel.tags = tags?.clone()
            return cloneModel
        }
        return nil
    }
    
    override func createDictToSave() -> [String : Any]? {
        var dicts = super.createDictToSave()
        dicts?.updateValue(self.id, forKey: "_id")
        dicts?.updateValue(self.audioId, forKey: "audio_id")
        dicts?.updateValue(self.audioType, forKey: "audio_type")
        dicts?.updateValue(self.audioSlug, forKey: "audio_slug")
        dicts?.updateValue(self.audioTitle, forKey: "audio_title")
        dicts?.updateValue(self.format, forKey: "format")
        dicts?.updateValue(self.slug, forKey: "episode_slug")
        dicts?.updateValue(self.commentCount, forKey: "comment_count")
        dicts?.updateValue(self.slugId, forKey: "episode_slug_id")
        dicts?.updateValue(self.title, forKey: "episode_title")
        dicts?.updateValue(self.urlInfo, forKey: "episode_link")
        dicts?.updateValue(self.idForDeeplink, forKey: "episode_id")
        dicts?.updateValue(self.linkDownload, forKey: "download_url")
        dicts?.updateValue(self.summary, forKey: "subtitle")
        dicts?.updateValue(self.description, forKey: "show_notes")
        dicts?.updateValue(self.imageUrl, forKey: "image_url")
        dicts?.updateValue(self.duration, forKey: "duration")
        dicts?.updateValue(self.author, forKey: "publisher")
        
        if self.likes != nil {
            dicts?.updateValue(self.likes!, forKey: "likes")
        }

        let sizeOwner = self.owners?.count ?? 0
        if sizeOwner > 0 {
            let owners = UserModel.getDictFromList(self.owners!)
            dicts?.updateValue(owners, forKey: "owner")
        }
        let sizeCredit = self.owners?.count ?? 0
        if sizeCredit > 0 {
            let credits = UserModel.getDictFromList(self.credits!)
            dicts?.updateValue(credits, forKey: "credits")
        }
        
        if self.tags != nil {
            dicts?.updateValue(self.tags!, forKey: "tags")
        }
        
        dicts?.updateValue(self.isPremium, forKey: "is_premium")
        dicts?.updateValue(self.duration, forKey: "duration")
        dicts?.updateValue(self.urlInfo, forKey: "url_info")
        dicts?.updateValue(self.createDate, forKey: "release_date")
        dicts?.updateValue(self.path, forKey: "path")
        return dicts
    }
    
    public func getShowModel() -> ShowModel {
        if showModel == nil {
            showModel = ShowModel()
            showModel?.id = self.audioId
            showModel?.audioId = self.audioId
            showModel?.audioType = self.audioType
            showModel?.imageUrl = self.imageUrl
            showModel?.slug = self.audioSlug
            showModel?.title = self.audioTitle
            showModel?.author = self.author
        }
        return showModel!
    }
    
    public func getCommentCount() -> Int64 {
        if commentCount.isNumber() {
            return Int64(commentCount) ?? 0
        }
        return 0
    }
    
    func isTypeEvent() -> Bool {
        return audioType.elementsEqual(EventModel.TYPE_EP_EVENT)
    }
    
    override func buildUrlOpenLink() -> String? {
        if !idForDeeplink.isEmpty {
            if self.isTypeEvent() {
                return String(format: IJamitConstants.URL_FORMAT_SHARE_EVENT, idForDeeplink)
            }
            if self.isStory() {
                return String(format: IJamitConstants.URL_FORMAT_SHARE_STORY, idForDeeplink)
            }
            return String(format: IJamitConstants.URL_FORMAT_SHARE_EPISODE, idForDeeplink)
        }
        if !slugId.isEmpty && !audioType.isEmpty {
            return String(format: IJamitConstants.FORMAT_SHARE, audioType, slugId)
        }
        return super.buildUrlOpenLink()
    }
    
    override func buildDynamicTitleLink() -> String? {
        return title
    }
    
    override func buildDynamicDesLink() -> String? {
        return !summary.isEmpty ? summary : description
    }
    
    override func buildDynamicImageLink() -> String {
        return !imageUrl.isEmpty ? imageUrl : super.buildDynamicImageLink()
    }
}
