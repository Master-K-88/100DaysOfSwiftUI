//
//  SearchScreenModel.swift
//  jamit
//
//  Created by Prof K on 12/28/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
public class SearchScreenModel: JamitResponce {
    
    var listPodcasts: [ShowModel]?
    var listAudiobooks: [ShowModel]?
    var listEpisodes: [EpisodeModel]?
    var listShorts: [EpisodeModel]?
    var listEvents: [EventModel]?
    var listUsers: [UserModel]?

    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.listPodcasts = self.parseListFromDict("podcasts")
        self.listAudiobooks = self.parseListFromDict("audiobooks")
        self.listEpisodes = self.parseListFromDict("episodes")
        
        self.listShorts = self.parseListFromDict("shorts")
        self.listEvents = self.parseListFromDict("events")
        self.listUsers = self.parseListFromDict("users")
    }
    
    func isEmpty() -> Bool {
        let isEmptyLive = listPodcasts?.isEmpty ?? true
        let isEmptyAudio = listAudiobooks?.isEmpty ?? true
        let isEmptyEpisode = listEpisodes?.isEmpty ?? true
        
        let isEmptyShort = listShorts?.isEmpty ?? true
        let isEmptyEvent = listEvents?.isEmpty ?? true
        let isEmptyUser = listUsers?.isEmpty ?? true
        return isEmptyLive && isEmptyAudio && isEmptyEpisode && isEmptyShort && isEmptyEvent && isEmptyUser
    }
    
    func onDestroy() {
        self.listPodcasts?.removeAll()
        self.listPodcasts = nil
        
        self.listAudiobooks?.removeAll()
        self.listAudiobooks = nil
        
        self.listEpisodes?.removeAll()
        self.listEpisodes = nil
        
        self.listShorts?.removeAll()
        self.listShorts = nil
        
        self.listEvents?.removeAll()
        self.listEvents = nil
        
        self.listUsers?.removeAll()
        self.listUsers = nil
    }
}
