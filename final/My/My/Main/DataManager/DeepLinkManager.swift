//
//  DeepLinkManager.swift
//  jamit
//
//  Created by Do Trung Bao on 21/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation

public class DeepLinkManager: NSObject {
    
    private static let TYPE_CONFIRM_UPCOMMING = 1
    private static let TYPE_CONFIRM_LIVE = 2
    
    private var typeConfirm = 0
    var event: EventModel?
    var isSubscribed = false
    
    var currentVC: MainController!
    
    init(currentVC: MainController) {
        super.init()
        self.currentVC = currentVC
    }
 
    func processDeepLink(_ deepLink: DeepLinkModel? = nil) {
        let type = deepLink?.type ?? ""
        let targetId = deepLink?.targetId ?? ""
        JamitLog.logE("=====>processDeepLink type=\(type)==>targetId=\(targetId)")
        if (type.isEmpty || targetId.isEmpty) { return }
        if !ApplicationUtils.isOnline() {
            currentVC.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        if type.elementsEqual(IJamitConstants.TYPE_DL_EPISODE) || type.elementsEqual(IJamitConstants.TYPE_DL_STORY) {
            self.processDeeplinkEpisode(type, targetId)
        }
        else if type.elementsEqual(IJamitConstants.TYPE_DL_PODCAST)
                    || type.elementsEqual(IJamitConstants.TYPE_DL_AUDIO_BOOK) {
            self.processDeeplinkShow(type, targetId)
        }
        else if type.elementsEqual(IJamitConstants.TYPE_DL_EVENT) {
            self.processDeeplinkEvent(targetId);
        }
    }
    
    private func processDeeplinkEvent(_ idForDeeplink: String) {
        self.currentVC.showProgress()
        JamItEventApi.getDetailEvent(roomId: idForDeeplink) { result in
            self.currentVC.dismissProgress()
            if let event = result {
                self.goToEventModel(event)
            }
            
        }
    }
    
    private func processDeeplinkShow(_ type: String, _ idForDeeplink:String) {
        self.currentVC.showProgress()
        JamItPodCastApi.getDetailDeeplinkShow(type, idForDeeplink) { result in
            self.currentVC.dismissProgress()
            if let show = result {
                self.currentVC.goToDetailShow(show)
            }
        }
    }
    
    private func processDeeplinkEpisode(_ type: String, _ idForDeeplink:String) {
        self.currentVC.showProgress()
        JamItPodCastApi.getDetailDeeplinkEpisode(type, idForDeeplink) { result in
            self.currentVC.dismissProgress()
            if let episode = result {
                var list: [EpisodeModel] = []
                list.append(episode)
                self.currentVC.playListEpisodeWithCheckAds(list: list, episode: episode, isDeepLink: true)
            }
        }
    }
    
    func processDeeplinkUpComingEvent(_ event: EventModel) {
        let userId = SettingManager.getUserId()
        let isCurrentSubscribed = event.isSubscribed(userId)
        if !isCurrentSubscribed {
            // save current param
            self.isSubscribed = true
            self.event = event
            self.typeConfirm = DeepLinkManager.TYPE_CONFIRM_UPCOMMING
            
            var resource = ConfirmResource()
            resource.title = event.title
            resource.msg = getString(StringRes.info_notify_me)
            resource.artwork = event.getArtwork()
            resource.posBgColorId = ColorRes.color_notify_me
            resource.posTextColor = .black
            resource.posStrId = StringRes.title_notify_me
            self.currentVC.showDialogConfirm(resource, self)
            return
        }
        self.currentVC.showToast(withResId: StringRes.info_added_listener)
    }
    
    func processDeeplinkUpLiveEvent(_ event: EventModel) {
        let userId = SettingManager.getUserId()
        let isCurrentSubscribed = event.isSubscribed(userId) || event.isHostEvent(userId)
        if !isCurrentSubscribed {
            // save current param
            self.isSubscribed = true
            self.event = event
            self.typeConfirm = DeepLinkManager.TYPE_CONFIRM_LIVE
            
            var resource = ConfirmResource()
            resource.title = event.title
            resource.msg = getString(StringRes.info_join_now)
            resource.artwork = event.getArtwork()
            resource.posBgColorId = ColorRes.color_join
            resource.posTextColor = .white
            resource.posStrId = StringRes.title_join_now
            self.currentVC.showDialogConfirm(resource, self)
            return
        }
        self.currentVC?.goToLive(event)
    }
    
    func processDeeplinkUpComingEventWithApi(_ event: EventModel, _ isSubscribed: Bool, _ callback: (() -> Void)? = nil) {
        if !ApplicationUtils.isOnline() {
            self.currentVC.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        let userId = SettingManager.getUserId()
        self.currentVC.showProgress()
        JamItEventApi.subscribeEvent(event.id, isSubscribed) { result in
            self.currentVC.dismissProgress()
            let isResultOk = result?.isResultOk() ?? false
            if isResultOk {
                self.currentVC.showToast(withResId: isSubscribed ? StringRes.info_added_listener : StringRes.info_removed_listener)
                if isSubscribed {
                    event.addParticipant(userId)
                }
                else {
                    event.removeParticipant(userId)
                }
                callback?()
            }
        }
    }
    
    func goToEventModel(_ event: EventModel) {
        let status = event.status
        if status.isEmpty { return }
        if status.elementsEqual(EventModel.STATUS_LIVE) {
            self.processDeeplinkUpLiveEvent(event)
        }
        else if status.elementsEqual(EventModel.STATUS_UPCOMING) {
            self.processDeeplinkUpComingEvent(event)
        }
        else if status.elementsEqual(EventModel.STATUS_PAST) {
            self.currentVC?.eventDelegate?.playPastEvent(event)
        }
    }
    
}

extension DeepLinkManager : ConfirmDelegate {
    
    func onConfirm() {
        if event == nil { return }
        if self.typeConfirm == DeepLinkManager.TYPE_CONFIRM_UPCOMMING {
            self.processDeeplinkUpComingEventWithApi(self.event!, self.isSubscribed)
        }
        else if self.typeConfirm == DeepLinkManager.TYPE_CONFIRM_LIVE {
            self.processDeeplinkUpComingEventWithApi(self.event!, self.isSubscribed, {
                self.currentVC?.goToLive(self.event)
            })
        }
        self.typeConfirm = 0
        self.isSubscribed = false
    }

    func onCancel() {}
    func onTopAction() {}
    
}
