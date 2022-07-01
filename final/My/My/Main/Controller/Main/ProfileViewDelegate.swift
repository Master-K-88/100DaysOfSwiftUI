//
//  ProfileViewDelegate.swift
//  jamit
//
//  Created by Prof K on 10/28/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import Sheeeeeeeeet

public class ProfileViewDelegate: NSObject {
    
    var currentVC: NewTabProfileController!
    var shortListener:(() -> Void)?
    var likeListener:(() -> Void)?
    
    init(currentVC: NewTabProfileController) {
        super.init()
        self.currentVC = currentVC
    }
    
}
extension ProfileViewDelegate: ProfileDelegate {
    
    func updateLikeSelection() {
//        if let likes = self.currentVC.headerView?.likesSelected {
//            if likes == true {
////                currentVC.onRefreshData(false)
//            }
//            likeListener?()
//        }
    }
    
    func updateShortSelection() {
//        if let shorts = self.currentVC.headerView?.shortSelected {
//            if shorts == true {
//                currentVC.onRefreshData(false)
//            }
//            shortListener?()
//        }
    }
    
    func updateEventSelected() {
        
    }
    
    func followUser(_ user: UserModel) {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.currentVC.parentVC,parentVC: self.currentVC.parentVC)
        if isLogin { return }
        if !ApplicationUtils.isOnline() {
            self.currentVC.parentVC?.showToast(with: StringRes.info_lose_internet)
            return
        }
        self.currentVC.parentVC?.showProgress()
        let userId = SettingManager.getUserId()
        let isNewFollow = !user.isFollowerUser(userId)
        JamItPodCastApi.updateFollow(isNewFollow, user.userID) { (result) in
            self.currentVC.parentVC?.dismissProgress()
            if let newUser = result {
                if newUser.isResultOk() {
                    user.followers = newUser.followers
                    user.following = newUser.following
                    self.currentVC.parentVC?.showToast(withResId: isNewFollow ? StringRes.info_follow_successfully: StringRes.info_unfollow_successfully)
//                    self.currentVC.parentVC?.friendVC?.updateFollow(isNewFollow)
//                    self.currentVC.parentVC?.profileVC?.isStartLoadData = false
//                    self.currentVC.parentVC?.profileVC?.startLoadData()
                }
                else{
                    let msg = !newUser.message.isEmpty ?  newUser.message : getString(StringRes.info_server_error)
                    self.currentVC.parentVC?.showToast(with: msg)
                }
             }
        }
    }
    
    func goToSocialPage(_ user: UserModel, _ type: Int) {
        self.currentVC.parentVC?.goToSocialPage(user, type)
    }
    
    func goToUserEvents(_ user: UserModel) {
        let totalEventVC = ListTotalEventController.create(IJamitConstants.STORYBOARD_EVENT) as? ListTotalEventController
        totalEventVC?.dismissDelegate = self.currentVC.parentVC
        totalEventVC?.eventUserId = user.userID
        totalEventVC?.screenTitle = String(format: getString(StringRes.format_title_event), user.username)
        totalEventVC?.eventDelegate = self.currentVC.parentVC?.eventDelegate
        totalEventVC?.isAllowRefresh = true
        totalEventVC?.parentVC = self.currentVC.parentVC
        self.currentVC.parentVC?.addControllerOnContainer(controller: totalEventVC!)
    }
    
    
    func goToMyHighLight() {
        
    }
    
    
    func goToRecording() {
        NavigationManager.shared.goToRecording(currentVC: self.currentVC.parentVC!)
    }
    
    func goToLogin() {
        NavigationManager.shared.goToLogin(currentVC: self.currentVC.parentVC!)
    }
    
    func goToMyStories() {
        if let myStoryVC = self.currentVC.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_MY_STORIES) {
            self.currentVC.parentVC?.myStoryVC = myStoryVC
            self.currentVC.parentVC?.addControllerOnContainer(controller: myStoryVC)
        }
    }
    
    func goToSocialPage(_ type: Int) {
//        if self.currentVC.user != nil {
//            self.currentVC.parentVC?.goToSocialPage(self.currentVC.user!, type)
//        }
    }
    
    func goToEditProfile() {
        NavigationManager.shared.goToEditProfile(currentVC: self.currentVC, parentVC: self.currentVC.parentVC!)
//        let storyBoard = UIStoryboard(name: "Tab", bundle: nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
//        controller.parentVC = self.currentVC.parentVC
//        self.currentVC.parentVC?.addControllerOnContainer(controller: controller)
    }
}
