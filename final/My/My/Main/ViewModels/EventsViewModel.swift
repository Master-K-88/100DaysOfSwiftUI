//
//  EventsViewModel.swift
//  jamit
//
//  Created by Prof K on 4/16/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class EventsViewModel {
    var dataCompletion:(()-> Void)?
    var totalEventData: TotalEventModel?
    var eventTopic: [TopicModel]?
    var myEvents: [EventModel]?
    let eventUserId = SettingManager.getUserId()
    
    init() {
        loadData()
    }
    
    func loadData() {
        JamItEventApi.getListTotalEvents { totalEvent in
            JamItPodCastApi.getTopics { listTopics in
                JamItEventApi.getUserEvents(self.eventUserId) { events in
                    self.myEvents = events
                    self.totalEventData = totalEvent
                    self.eventTopic = listTopics
                    self.dataCompletion?()
                    
                }
            }
        }
        
        //        JamItEventApi.getListTypeEvents("live") { events in
        //            completion(self.convertListModelToResult(events))
        //        }
        //        JamItEventApi.getListTypeEvents("upcomming") { events in
        //            completion(self.convertListModelToResult(events))
        //        }
    }
}
