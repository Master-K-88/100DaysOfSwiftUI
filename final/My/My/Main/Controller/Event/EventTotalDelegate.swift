//
//  EventTotalDelegate.swift
//  jamit
//
//  Created by Do Trung Bao on 24/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

public class EventTotalDelegate: NSObject {
    
    var currentVC: MainController?
    private var userId: String!
    var deepLinkMng: DeepLinkManager?
    
    init(currentVC: MainController) {
        super.init()
        self.currentVC = currentVC
        self.userId = SettingManager.getUserId()
    }
    
}

extension EventTotalDelegate: BaseEventDelegate {
    
    func onShare(_ event: EventModel, _ pivotView: UIView?) {
        self.currentVC?.shareWithDeepLink(event,pivotView)
    }
    
    func onGoToProfile(_ event: EventModel) {
        if let user = event.host {
            self.currentVC?.goToUserStories(user)
        }
    }
}

extension EventTotalDelegate: PastEventDelegate, UpcommingEventDelegate, LiveEventDelegate {
    
    func onSubscribe(_ event: EventModel, _ controller: JamitRootViewController?) {
        let isHostEvent = event.isHostEvent(userId)
       
        if isHostEvent {
            let linkEvent = String(format: IJamitConstants.FORMAT_WEB_EVENT_MANAGE, event.eventId)
            JamitLog.logE("===>manageEvent=\(linkEvent)")
//            ShareActionUtils.goToURL(linkUrl: linkEvent)
            checkForEvent(event: event, isHostEvent: isHostEvent)
            self.currentVC?.goToLive(event)
            return
        }
        let isSubscribed = event.isSubscribed(userId)
        if isSubscribed {
            self.currentVC?.showAlertWithResId(titleId: StringRes.title_confirm, messageId: StringRes.info_remove_me, positiveId: StringRes.title_remove_me, negativeId: StringRes.title_cancel, completion: {
//                self.deepLinkMng?.processDeeplinkUpComingEventWithApi(event, false, {
//                    self.reloadController(controller)
//                })

            })
            checkForEvent(event: event, isHostEvent: isHostEvent)
            return
        } else {
            checkForEvent(event: event, isHostEvent: isHostEvent)
        }
//        self.deepLinkMng?.processDeeplinkUpComingEventWithApi(event, isSubscribed, {
//            self.reloadController(controller)
//        })
    }
    
    private func reloadController(_ controller: JamitRootViewController?){
        if controller is BaseCollectionController {
            (controller as? BaseCollectionController)?.notifyWhenDataChanged()
        }
        else if controller is HomeEventController {
            (controller as? HomeEventController)?.reloadUpCommingUI()
        }
        else if controller is TopicEventController {
            (controller as? HomeEventController)?.reloadUpCommingUI()
        }
    }
    
    func onLiveJoinFromInvitation(_ event: EventModel, _ isAcceptInvite: Bool) {
        if self.currentVC?.dolbySdkManager != nil{
            self.currentVC?.dolbySdkManager?.confirmInviteOnServer(event: event, confId: event.eventId, isAccepted: isAcceptInvite)
            return
        }
    }
    
    func onJoin(_ event: EventModel, _ isAcceptInvite: Bool) {
        if isAcceptInvite && self.currentVC?.dolbySdkManager != nil{
            self.currentVC?.dolbySdkManager?.confirmInviteOnServer(event: event, confId: event.eventId, isAccepted: true)
            return
        }
        self.currentVC?.goToLive(event)
    }
    
    func onReplay(_ event: EventModel) {
        self.playPastEvent(event)
    }
    
    func playPastEvent(_ event: EventModel) {
        let episode = event.convertToEpisode()
        if episode == nil {
            self.currentVC?.showToast(withResId: StringRes.info_play_error)
            return
        }
        var list: [EpisodeModel] = []
        list.append(episode!)
        self.currentVC?.playListEpisodeWithCheckAds(list: list, episode: episode!)
    }
    
    private func checkForEvent(event: EventModel, isHostEvent: Bool) {
        
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm"
        let currentFullDate:String = dateFormatter.string(from: todaysDate as Date)
        let currentDate: String = String(currentFullDate.prefix(10))
        let currentTime: String = String(currentFullDate.suffix(5))
        let eventDate: String = String(event.startTime.prefix(10))
        let eventTime: String = String(event.startTime.suffix(14).prefix(5))
        
        if eventDate.compare(currentDate) == .orderedAscending {
            self.currentVC?.showAlertWith(title: String(format: getString(StringRes.title_upcoming_events)), message: String(format: getString(StringRes.event_info_past)), positive: nil, negative: .none, completion: .none, cancel: .none)
        } else if eventDate.compare(currentDate) == .orderedSame {
            if eventTime.compare(currentTime) == .orderedSame {
                self.currentVC?.showAlertWith(title: String(format: getString(StringRes.title_upcoming_events)), message: String(format: getString(StringRes.event_info_present)), positive: "yes", negative: StringRes.title_cancel, completion: {
                    self.onLiveJoinFromInvitation(event, true)
                })
            } else if eventTime.compare(currentTime) == .orderedAscending {
                self.currentVC?.showAlertWith(title: String(format: getString(StringRes.title_upcoming_events)), message: String(format: getString(StringRes.event_info_now)), positive: "yes", negative: "no", completion: {
                    if isHostEvent {
                        self.currentVC?.goToLive(event, false)
                    } else {
                        self.onLiveJoinFromInvitation(event, true)
                    }
                        
                })
            } else if eventTime.compare(currentTime) == .orderedDescending {
                self.currentVC?.showAlertWith(title: String(format: getString(StringRes.title_upcoming_events)), message: String(format: getString(StringRes.event_info_future), eventDate, eventTime)/*"This live event is starting on \(eventDate) at \(eventTime)"*/, positive: nil, negative: .none, completion: .none, cancel: .none)
                return
            }
        } else if eventDate.compare(currentDate) == .orderedDescending {
            self.currentVC?.showAlertWith(title: String(format: getString(StringRes.title_upcoming_events)), message: String(format: getString(StringRes.event_info_future), eventDate, eventTime), positive: nil, negative: .none, completion: .none, cancel: .none)
        }
        
    }
    
    
}
