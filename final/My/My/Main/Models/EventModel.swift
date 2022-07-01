//
//  EventModel.swift
//  jamit
//
//  Created by Do Trung Bao on 16/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class EventModel: JamitResponce {
    
    static let STATUS_PAST = "past"
    static let STATUS_LIVE = "now"
    static let STATUS_UPCOMING = "future"
    static let STATUS_UPCOMING1 = "upcoming"
    static let TYPE_EP_EVENT = "event"
    
    var id = ""
    var alias = ""
    var title = ""
    var roomId = ""
    var linkReplay = ""
    var time = ""
    var startTime = ""
    var timestamp: Double = 0
    var numListeners: Int64 = 0
    var timezone = ""
    var status = ""
    var eventId = ""
    var topics: [TopicModel]?
    var tags: [String]?
    var participants: [String]?
    var speakers: [String]?
    var invitedParticipants : [String]?
    var host: UserModel?
    
    var strTopics: String?
    var episode: EpisodeModel?
    
    override func initFromDict(_ dict: [String : Any]?) {
        super.initFromDict(dict)
        self.id = self.parseValueFromDict("_id") ?? ""
        self.alias = self.parseValueFromDict("event_alias") ?? ""
        self.title = self.parseValueFromDict("event_title") ?? ""
        self.roomId = self.parseValueFromDict("event_room_id") ?? ""
        self.linkReplay = self.parseValueFromDict("download_url") ?? ""
        self.time = self.parseValueFromDict("event_time") ?? ""
        self.startTime = self.parseValueFromDict("start_time") ?? ""
        self.timestamp = self.parseValueFromDict("timestamp") ?? 0
        self.numListeners = self.parseValueFromDict("num_listeners") ?? 0
        self.timezone = self.parseValueFromDict("event_timezone") ?? ""
        self.status = self.parseValueFromDict("status") ?? ""
        self.eventId = self.parseValueFromDict("event_id") ?? ""
        self.topics = self.parseListFromDict("topic")
        self.tags = self.parseListValueFromDict("tags")
        self.speakers = self.parseListValueFromDict("speakers")
        self.participants = self.parseListValueFromDict("participants")
        self.invitedParticipants = self.parseListValueFromDict("invited_participants")
        self.host = self.parseModelFromDict("host")
    }
    
    
    func getAuthor() -> String? {
        return host?.username
    }
    
    func getArtwork() -> String? {
        return host?.avatar
    }
    
    func getTopic() -> String? {
        let size = topics?.count ?? 0
        if size > 0 && (strTopics == nil || strTopics!.isEmpty) {
            var strBuilder = ""
            var count = 0
            self.topics?.forEach({ topic in
                strBuilder += topic.name
                if count != size - 1 {
                    strBuilder += ", "
                }
                count += 1
            })
            self.strTopics = strBuilder
        }
        return strTopics
    }
    
    func isHostEvent(_ userId: String) -> Bool {
        let hostId = self.host?.userID ?? ""
        return !userId.isEmpty && !hostId.isEmpty && userId.elementsEqual(hostId)
    }
    
    func isEventSpeaker(_ userId: String) -> Bool {
        return self.speakers?.contains(userId) ?? false
    }
    
    func isInvitedUser(_ userId: String) -> Bool {
        return self.invitedParticipants?.contains(userId) ?? false
    }
    
    func isSubscribed(_ userId: String) -> Bool {
        return self.participants?.contains(userId) ?? false
    }
    
    func isLiveEvent() -> Bool {
        return self.status.elementsEqual(EventModel.STATUS_LIVE)
    }
    
    func updateSpeaker(_ userId: String, _ isAdd: Bool) {
        if self.speakers == nil {
            self.speakers = []
        }
        let isContain = self.speakers?.contains(userId) ?? false
        if !isContain && isAdd {
            self.speakers?.append(userId)
            return
        }
        self.speakers?.removeAll(where: { spk in
            return spk.elementsEqual(userId)
        })
    }
    
    func addInvite(_ userId: String) {
        if self.invitedParticipants == nil {
            self.invitedParticipants = []
        }
        let isContain = self.invitedParticipants?.contains(userId) ?? false
        if !isContain {
            self.invitedParticipants?.append(userId)
        }
    }
    
    func addParticipant(_ userId: String) {
        if self.participants == nil {
            self.participants = []
        }
        let isContain = self.participants?.contains(userId) ?? false
        if !isContain {
            self.participants?.append(userId)
        }
    }
    
    func removeParticipant(_ userId: String) {
        let isContain = self.participants?.contains(userId) ?? false
        if isContain {
            self.participants?.removeAll(where: { spk in
                return spk.elementsEqual(userId)
            })
        }
    }
    
    override func equalElement(_ otherModel: JsonModel?) -> Bool {
        if let abModel = otherModel as? EventModel {
            return !id.isEmpty && abModel.id.elementsEqual(id)
        }
        return false
    }
    
    func convertToEpisode() -> EpisodeModel? {
        if episode == nil && !linkReplay.isEmpty && linkReplay.starts(with: "http") {
            episode = EpisodeModel()
            episode?.id = id
            episode?.title = title
            episode?.imageUrl = self.host?.avatar ?? ""
            episode?.audioType = EventModel.TYPE_EP_EVENT
            episode?.slugId = roomId
            episode?.idForDeeplink = roomId
            episode?.summary = getTopic() ?? ""
            episode?.linkDownload = linkReplay
            episode?.createDate = startTime
            episode?.author = getTopic() ?? ""
            episode?.description = tags?.joined(separator: ",") ?? ""
        }
        return episode
    }
   
    override func buildUrlOpenLink() -> String? {
        if !roomId.isEmpty {
            return String(format: IJamitConstants.URL_FORMAT_SHARE_EVENT, roomId)
        }
        return super.buildUrlOpenLink()
    }
    
    override func buildDynamicTitleLink() -> String? {
        return title
    }
    
    override func buildDynamicDesLink() -> String? {
        return ""
    }
    
    override func buildDynamicImageLink() -> String {
        return host?.avatar ?? super.buildDynamicImageLink()
    }
}
