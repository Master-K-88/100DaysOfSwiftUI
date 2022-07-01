//
//  TotalEventModel.swift
//  jamit
//
//  Created by Do Trung Bao on 16/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
public class TotalEventModel: JamitResponce {
    
    var listLiveEvents: [EventModel]?
    var listUpcomingEvents: [EventModel]?
    var listPassEvents: [EventModel]?
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.listLiveEvents = self.parseListFromDict("liveEvents")
        self.listUpcomingEvents = self.parseListFromDict("upcomingEvents")
        self.listPassEvents = self.parseListFromDict("pastEvents")
    }
    
    func isEmpty() -> Bool {
        let isEmptyLive = listLiveEvents?.isEmpty ?? true
        let isEmptyUp = listUpcomingEvents?.isEmpty ?? true
        let isEmptyPass = listPassEvents?.isEmpty ?? true
        return isEmptyLive && isEmptyPass && isEmptyUp
    }
    
    func onDestroy() {
        self.listLiveEvents?.removeAll()
        self.listLiveEvents = nil
        
        self.listUpcomingEvents?.removeAll()
        self.listUpcomingEvents = nil
        
        self.listPassEvents?.removeAll()
        self.listPassEvents = nil
    }
}
