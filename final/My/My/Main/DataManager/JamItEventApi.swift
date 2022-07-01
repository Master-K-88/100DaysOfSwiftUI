//
//  JamItEventApi.swift
//  jamit
//
//  Created by Do Trung Bao on 16/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import Alamofire

open class JamItEventApi {
    
    static let METHOD_EVENT = "event"
    
    static let METHOD_DETAIL_EVENT_ROOM_ID = "event/%@"
    static let METHOD_DETAIL_EVENT_WITH_ID = "event/id/%@"
    
    static let METHOD_TOPIC_EVENT = "event/topic/%@"
    static let METHOD_LIVE_EVENT = "event/live/now"
    static let METHOD_PAST_EVENT = "event/past"
    static let METHOD_UPCOMMING_EVENT = "event/upcoming"
    static let METHOD_ADD_PARTICIPANT = "event/%@/rsvp/participant"
    static let METHOD_REMOVE_PARTICIPANT = "event/%@/remove/rsvp/participant"
    
    static let METHOD_EVENT_BY_USER = "event/with/user/%@"
    static let METHOD_EVENT_INVITE_USER = "event/invite/user"
    static let METHOD_EVENT_TERMINATED = "event/terminate/%@"
    static let METHOD_ADD_SPEAKER = "event/add/speaker"
    static let METHOD_REMOVE_SPEAKER = "event/remove/speaker"
    static let METHOD_USER_INVITATIONS = "event/user/invitations"
    static let METHOD_USER_NOTIFICATIONS = "user/notifications/events"
    static let METHOD_CREATE_LIVE_EVENT = "create/live/event"
    
    public static func getDetailEvent(eventId: String? = nil, roomId: String? = nil, completion: @escaping (EventModel?)->Void) {
        let myEventId = eventId ?? ""
        let myRoomId = roomId ?? ""
        var url = ""
        if !myEventId.isEmpty {
            url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_DETAIL_EVENT_WITH_ID, myEventId)
        }
        else if !myRoomId.isEmpty {
            url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_DETAIL_EVENT_ROOM_ID, myRoomId)
        }
        JamitLog.logE("=======>getDetailEvent=\(url)")
        if !url.isEmpty {
            JamItPodCastApi.getJson(url: url, completion: completion)
        }
    }
    
    public static func getListTotalEvents(_ completion: @escaping (TotalEventModel?)->Void) {
        let url = JamItPodCastApi.URL_API_ROOT + METHOD_EVENT
        JamitLog.logE("=======>getListTotalEvents=\(url)")
        JamItPodCastApi.getJson(url: url, completion: completion)
    }
    
    public static func getListTopicTotalEvents(_ topicId: String , _ completion: @escaping (TotalEventModel?)->Void) {
        let url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_TOPIC_EVENT, topicId)
        JamitLog.logE("=======>getListTopicTotalEvents=\(url)")
        JamItPodCastApi.getJson(url: url, completion: completion)
    }

    public static func getListTypeEvents(_ type: String , _ completion: @escaping ([EventModel]?)->Void) {
        var url: String?
        if type.elementsEqual(EventModel.STATUS_LIVE){
            url = JamItPodCastApi.URL_API_ROOT + METHOD_LIVE_EVENT
        }
        else if type.elementsEqual(EventModel.STATUS_UPCOMING){
            url = JamItPodCastApi.URL_API_ROOT + METHOD_UPCOMMING_EVENT
        }
        else if type.elementsEqual(EventModel.STATUS_PAST){
            url = JamItPodCastApi.URL_API_ROOT + METHOD_PAST_EVENT
        }
        JamitLog.logE("=======>getListTypeEvents=\(String(describing: url))")
        if url != nil {
            JamItPodCastApi.getArrayJson(url: url!, completion: completion)
        }
        
    }
    
    public static func subscribeEvent(_ eventId: String, _ isSubscribe: Bool, _ completion: @escaping (JamitResponce?)->Void) {
         if isSubscribe {
            return self.notifyMe(eventId, completion)
         }
         else {
            return self.removeMe(eventId, completion)
         }
     }
    
    public static func notifyMe(_ eventId: String , _ completion: @escaping (JamitResponce?)->Void) {
        let url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_ADD_PARTICIPANT, eventId)
        JamitLog.logE("=======>notifyMe=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: JamItPodCastApi.buildUserParams(), completion: completion)
    }
    
    public static func removeMe(_ eventId: String , _ completion: @escaping (JamitResponce?)->Void) {
        let url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_REMOVE_PARTICIPANT, eventId)
        JamitLog.logE("=======>removeMe=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: JamItPodCastApi.buildUserParams(), completion: completion)
    }
    
    public static func getUserEvents(_ userId: String , _ completion: @escaping ([EventModel]?)->Void) {
        let url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_EVENT_BY_USER, userId)
        JamitLog.logE("=======>getUserEvents=\(url)")
        JamItPodCastApi.postArrayJson(url: url, completion: completion)
    }
    
    public static func inviteUser(_ eventId: String ,_ friendId: String , _ completion: @escaping (JamitResponce?)->Void) {
        var params = JamItPodCastApi.buildUserParams()
        params["friendID"] = friendId
        params["eventID"] = eventId
        
        let url = JamItPodCastApi.URL_API_ROOT + METHOD_EVENT_INVITE_USER
        JamitLog.logE("=======>inviteUser=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: params, completion: completion)
    }
    
    public static func terminateEvent(_ eventId: String , _ hostId: String, _ completion: @escaping (JamitResponce?)->Void) {
        var params = JamItPodCastApi.buildUserParams()
        params["eventID"] = eventId
        params["hostID"] = hostId
        
        let url = JamItPodCastApi.URL_API_ROOT + String(format: METHOD_EVENT_TERMINATED, eventId)
        JamitLog.logE("=======>terminateEvent=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: params, completion: completion)
    }
    
    public static func updateSpeaker(_ eventId: String , _ hostId: String, _ speakerId: String, _ isSpeaker: Bool , _ completion: @escaping (JamitResponce?)->Void) {
        
        var params = JamItPodCastApi.buildUserParams()
        params["eventID"] = eventId
        params["hostID"] = hostId
        params["speakerID"] = speakerId
        
        let url = JamItPodCastApi.URL_API_ROOT + (isSpeaker ? METHOD_ADD_SPEAKER : METHOD_REMOVE_SPEAKER)
        JamitLog.logE("=======>updateSpeaker=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: params, completion: completion)
    }
    
    public static func getEventInvitations(_ completion: @escaping ([EventModel]?)->Void) {
        let params = JamItPodCastApi.buildUserParams()
        let url = JamItPodCastApi.URL_API_ROOT + METHOD_USER_INVITATIONS
        JamitLog.logE("=======>getEventInvitations=\(url)")
        JamItPodCastApi.postArrayJson(url: url, parameters: params, completion: completion)
    }
    
    public static func getUserNotification(_ completion: @escaping (NotificationModel?)->Void) {
        let params = JamItPodCastApi.buildUserParams()
        let url = JamItPodCastApi.URL_API_ROOT + METHOD_USER_NOTIFICATIONS
        JamitLog.logE("=======>getUserNotification=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: params, completion: completion)
    }
    
    public static func createEvent(_ params: [String:Any], _ completion: @escaping (EventModel?)->Void) {
        let url = JamItPodCastApi.URL_API_ROOT + METHOD_CREATE_LIVE_EVENT
        JamitLog.logE("=======>createEvent=\(url)")
        JamItPodCastApi.postJson(url: url, parameters: params, completion: completion)
    }
    
}
