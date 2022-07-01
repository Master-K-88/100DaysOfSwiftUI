//
//  MenuManager.swift
//  jamit
//
//  Created by Do Trung Bao on 24/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit
import Sheeeeeeeeet

public class MenuDelegate: NSObject {
    
    var currentVC: MainController!
    
    init(currentVC: MainController) {
        super.init()
        self.currentVC = currentVC
    }
    
    func showMenuRecord() {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.currentVC,parentVC: self.currentVC)
        if isLogin { return}
//        let isShowLive = TotalDataManager.shared.getSetting()?.isShowLive ?? false
//        if !isShowLive {
//            //update again index of tab, if selectedIdex >=2 we need increase to 1 because tab record is just button
//            self.currentVC.segment.selectedSegmentioIndex = (self.currentVC.selectIndex < 2) ? self.currentVC.selectIndex : (self.currentVC.selectIndex + 1)
//            NavigationManager.shared.goToRecording(currentVC: self.currentVC)
//            return
//        }
        //update again index of tab, if selectedIdex >=2 we need increase to 1 because tab record is just button
        self.currentVC.segment.selectedSegmentioIndex = (self.currentVC.selectIndex < 2) ? self.currentVC.selectIndex : (self.currentVC.selectIndex + 1)
        
        var items: [MenuItem] = []
        // Rearranging the order of the action sheet for the create button (mic icon button)
        self.addMenuItem(&items,IJamitConstants.ID_RECORDING,StringRes.title_menu_record_voice, UIImage(named: ImageRes.ic_menu_record_36dp)?.resized(toWidth: 40))
        
        self.addMenuItem(&items,IJamitConstants.ID_TALK_TO_ME,StringRes.title_menu_live_voice, UIImage(named: ImageRes.ic_menu_live_36dp)?.resized(toWidth: 40))
        
        self.addMenuItem(&items,IJamitConstants.ID_SUBMIT_PODCAST,StringRes.title_submit_podcast, UIImage(named: ImageRes.ic_podcast)?.resized(toWidth: 40))
       
        let menu = Menu(title: getString(StringRes.title_menu_create), items: items)
        let sheet = menu.toActionSheet { (sheet, menuItem) in
            let id = (menuItem.value as? Int) ?? 0
            switch id {
            case IJamitConstants.ID_TALK_TO_ME:
                NavigationManager.shared.goToCreateLive(currentVC: self.currentVC)
                break
            case IJamitConstants.ID_RECORDING:
                NavigationManager.shared.goToRecording(currentVC: self.currentVC)
                break
            case IJamitConstants.ID_SUBMIT_PODCAST:
                NavigationManager.shared.goToSubmitPodcast(currentVC: self.currentVC)
                break
            default:
                break
            }
        }
        sheet.present(in: self.currentVC, from: self.currentVC.segment)
        
    }
    
    private func addMenuItem(_ items: inout [MenuItem], _ id: Int,_ resId: String, _ image: UIImage? = nil){
        let menuItem = MenuItem(title: getString(resId), value: id)
        menuItem.image = image
        items.append(menuItem)
    }
}
extension MenuDelegate: MenuEpisodeDelegate {
    
    //override
    func onTogglePlay(_ model: EpisodeModel) {
        self.currentVC.startMusicAction(.TogglePlay)
    }
    //override
    func onFollowTap(_ model: EpisodeModel) {
        if let user = model.getUserOwner() {
            self.currentVC.goToUserStories(user)
        }
    }
    //override
    func showEpisodeMenu(_ view: UIView, _ model: EpisodeModel, _ typeVC: Int, _ isFromMyStories: Bool) {
        var items:[MenuItem] = []
        let menuTitle = MenuTitle(title: getString(StringRes.title_options))
        items.append(menuTitle)
        let isOfflineModel = TotalDataManager.shared.isFileDownloaded(model)
        if !isOfflineModel {
            self.addMenuItem(&items,IJamitConstants.ID_MENU_LISTEN_OFFLINE,StringRes.title_download_now)
        }
        else{
             self.addMenuItem(&items,IJamitConstants.ID_MENU_DELETE_MODEL,StringRes.title_remove_downloads)
        }
    
        let isFav = model.isFavorite(SettingManager.getUserId())
        let idFav = isFav ? IJamitConstants.ID_MENU_REMOVE_FAV : IJamitConstants.ID_MENU_ADD_FAV
        let resFav = isFav ? StringRes.title_remove_favorite : StringRes.title_add_favorite
        self.addMenuItem(&items,idFav,resFav)

        if isFromMyStories {
            self.addMenuItem(&items,IJamitConstants.ID_MENU_DELETE_STORY,StringRes.title_delete_story)
        }
        self.addMenuItem(&items,IJamitConstants.ID_MENU_TWITTER,StringRes.title_share_twitter)
        self.addMenuItem(&items,IJamitConstants.ID_MENU_SHARE_MODEL,StringRes.title_share)
    
        let menu = Menu(items: items)
        let isPlayVisible = self.currentVC.playingVC?.isVisible ?? false
        let rootVC = isPlayVisible ? self.currentVC.playingVC : self.currentVC
        let sheet = menu.toActionSheet { (sheet, menuItem) in
            self.processPopUpMenuAction(model, menuItem.value as! Int,typeVC, view)
        }
        sheet.present(in: rootVC!, from: view)
    }

    
    private func processPopUpMenuAction(_ episode: EpisodeModel, _ id: Int, _ typeVC: Int, _ pivotView: UIView){
        if id == IJamitConstants.ID_MENU_SHARE_MODEL{
            self.currentVC.shareWithDeepLink(episode, pivotView)
        }
        else if id == IJamitConstants.ID_MENU_TWITTER{
            self.currentVC.shareWithDeepLink(episode,pivotView, {
                self.currentVC.tweetToTwitter(episode)
            })
        }
        else if id == IJamitConstants.ID_MENU_LISTEN_OFFLINE {
            if episode.isPremium && !MemberShipManager.shared.isPremiumMember() {
                NavigationManager.shared.goToUpgradeMember(currentVC: self.currentVC)
                return
            }
            NavigationManager.shared.goToListenOffline(currentVC: self.currentVC, episode: episode)
        }
        else if id == IJamitConstants.ID_MENU_DELETE_MODEL {
            if let download = currentVC.myDownloadVC {
                download.showDialogDeleteOffline(episode)
            }
        }
        else if id == IJamitConstants.ID_MENU_ADD_FAV {
            self.updateFavorite(episode,typeVC, true)
        }
        else if id == IJamitConstants.ID_MENU_REMOVE_FAV {
            self.updateFavorite(episode,typeVC, false)
        }
        else if id == IJamitConstants.ID_MENU_DELETE_STORY {
            self.currentVC.myStoryVC?.showDialogDeleteStory(episode)
        }
    }
    
    func updateFavorite (_ episode: EpisodeModel, _ typeVC: Int, _ isFav: Bool){
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.currentVC,parentVC: self.currentVC)
        if isLogin { return }
        if !ApplicationUtils.isOnline() {
            self.currentVC.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        let isPlayerVisible = self.currentVC.playingVC.isViewLoaded && self.currentVC.playingVC.isVisible
        let vc = isPlayerVisible ? self.currentVC.playingVC! : self.currentVC
        vc?.showProgress()
        JamItPodCastApi.updateFavorite(isFav, episode.id) { (result) in
            vc?.dismissProgress()
            if let newEpisode = result {
                episode.likes = newEpisode.getLikes()
                if StreamManager.shared.isHavingList() {
                    let isUpdated = StreamManager.shared.updateFavorite(newEpisode, isFav)
                    if isUpdated {
                        self.currentVC.playingVC.updateLikeButton()
                    }
                }
                self.sendFavNoti(newEpisode,typeVC,isFav)
                vc?.showToast(withResId: isFav ? StringRes.info_added_favorite : StringRes.info_removed_favorite)
                return
            }
            vc?.showToast(with: StringRes.info_server_error)
        }

    }
    
    private func sendFavNoti(_ episode: EpisodeModel, _ typeVC: Int, _ isFav: Bool){
        episode.likes = episode.getLikes()
        let userInfo  = [IJamitConstants.KEY_ID:episode.id,
                         IJamitConstants.KEY_IS_FAV:isFav,
                         IJamitConstants.KEY_VC_TYPE:typeVC,
                         IJamitConstants.KEY_LIKE_DATA: episode.likes ?? []] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(IJamitConstants.BROADCAST_DATA_CHANGE), object: nil, userInfo: userInfo)
    }
    
   
    
    
}
