//
//  NavigationManager.swift
//  jamit
//
//  Created by Do Trung Bao on 21/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

public class NavigationManager {
    
    static let shared = NavigationManager()
    
    func checkLogin(currentVC: JamitRootViewController?, parentVC: JamitRootViewController? = nil) -> Bool {
        if(!NewSettingManager.isLoginOK()){
            self.goToLogin(currentVC: currentVC,parentVC: parentVC)
            return true
        }
        return false
    }
    
    func goToLogin(currentVC: JamitRootViewController?, parentVC: JamitRootViewController? = nil, msg: String? = nil) {
        
        if currentVC ==  nil { return }
        (currentVC as? MainController)?.unregisterDeeplinkObserver()
        SettingManager.logOut()
        let loginVC = LoginController.create(IJamitConstants.STORYBOARD_USER) as! LoginController
        loginVC.parentVC = parentVC
        loginVC.msgFirstTime = msg
        currentVC?.navigationController?.popToRootViewController(animated: true)
//        currentVC?.presentDetail(loginVC)
    }

    func goToInfo(currentVC: JamitRootViewController, show: ShowModel) {
        (currentVC as? MainController)?.unregisterDeeplinkObserver()
        let showInfoVC = ShowInfoController.create(IJamitConstants.STORYBOARD_SHOW) as! ShowInfoController
        showInfoVC.show = show
        currentVC.presentDetail(showInfoVC)
    }

    func goToReview(currentVC: MainController,show: ShowModel) {
        currentVC.unregisterDeeplinkObserver()
        let reviewVC = ReviewController.create(IJamitConstants.STORYBOARD_COMMENT)  as! ReviewController
        reviewVC.show = show
        reviewVC.parentVC = currentVC
        reviewVC.modalPresentationStyle = .overFullScreen
        currentVC.present(reviewVC, animated: true, completion: nil)
    }

    func goToRecording(currentVC: MainController){
        JamitLog.logD("========>goToRecording")
        if self.checkLogin(currentVC: currentVC,parentVC: currentVC) { return }
        if StreamManager.shared.isHavingList() {
            currentVC.startMusicAction(.Stop)
        }
        currentVC.unregisterDeeplinkObserver()
        let recordingVC = NewTabRecordingController.create(IJamitConstants.STORYBOARD_TAB) as! NewTabRecordingController
        recordingVC.parentVC = currentVC
        recordingVC.modalPresentationStyle = .overFullScreen
        currentVC.present(recordingVC, animated: true, completion: nil)
    }

    func goToSubmitPodcast(currentVC: MainController){
        JamitLog.logD("========>goToSubmitPodcast")
        if self.checkLogin(currentVC: currentVC,parentVC: currentVC) { return }
        if StreamManager.shared.isHavingList() {
            currentVC.startMusicAction(.Stop)
        }
        currentVC.unregisterDeeplinkObserver()
        let submitPodcastVC = TabSubmitPodcast.create(IJamitConstants.STORYBOARD_TAB) as! TabSubmitPodcast
//        submitPodcastVC.parentVC = currentVC
        submitPodcastVC.modalPresentationStyle = .overFullScreen
        currentVC.present(submitPodcastVC, animated: true, completion: nil)
    }

    func goToCreateLive(currentVC: MainController) {
        if self.checkLogin(currentVC: currentVC,parentVC: currentVC) { return }
        if StreamManager.shared.isHavingList() {
            currentVC.startMusicAction(.Stop)
        }
        currentVC.unregisterDeeplinkObserver()
        let createEventVC = CreateLoungeController.create(IJamitConstants.STORYBOARD_EVENT) as! CreateLoungeController
        createEventVC.parentVC = currentVC
        createEventVC.modalPresentationStyle = .fullScreen
        currentVC.present(createEventVC, animated: true, completion: nil)
    }

    func goToListenOffline(currentVC: JamitRootViewController, episode: EpisodeModel) {
        currentVC.showAlertWith(title: "Download", message: "Downloading in the background", positive: nil, negative: nil, completion: nil, cancel: .none)
        BackgroundDownload().startListenOffline(episode: episode)
    }


    func goToUpgradeMember(currentVC: JamitRootViewController?) {
        if self.checkLogin(currentVC: currentVC,parentVC: currentVC) { return }
        (currentVC as? MainController)?.unregisterDeeplinkObserver()
        let control = UpradeMemberViewController.create(IJamitConstants.STORYBOARD_IAP) as! UpradeMemberViewController
        currentVC?.presentDetail(control)
    }


    func goToLive(currentVC: ParentViewController?, event: EventModel?) {
        if self.checkLogin(currentVC: currentVC,parentVC: currentVC) { return }
        (currentVC as? MainController)?.unregisterDeeplinkObserver()
        let control = LiveEventController.create(IJamitConstants.STORYBOARD_EVENT) as! LiveEventController
        control.event = event
        control.parentVC = currentVC
        currentVC?.presentDetail(control)
    }

    func goToEditProfile(currentVC: JamitRootViewController, parentVC: MainController) {
//            (currentVC as? MainController)?.unregisterDeeplinkObserver()
//            let editProfileVC = EditProfileController.create("Tab") as! EditProfileController
//            currentVC.presentDetail(editProfileVC)
        let storyBoard = UIStoryboard(name: "Tab", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
        controller.parentVC = parentVC
        parentVC.addControllerOnContainer(controller: controller)

        }

    func goToSocialPage(_ type: Int, currentVC: JamitRootViewController) {

        if let currentVC = currentVC as? NewTabProfileController,
               let user = currentVC.userModel {
                   currentVC.parentVC?.goToSocialPage(user, type)
        }

        if let currentVC = currentVC as? UserInfoController,
               let user = currentVC.user {
                   currentVC.parentVC?.goToSocialPage(user, type)
        }

        if let currentVC = currentVC as? NewUserProfileController,
               let user = currentVC.userModel {
                   currentVC.parentVC?.goToSocialPage(user, type)
        }
//        }
    }

    func goToLikes(_ currentVC: TabLibraryController) {
        let favoriteVC = FavoriteController.create(IJamitConstants.STORYBOARD_LIBRARY) as! FavoriteController
        favoriteVC.typeVC = IJamitConstants.TYPE_VC_FAVORITE
        favoriteVC.itemDelegate = currentVC.parentVC
        favoriteVC.isAllowAddObserver = true
        favoriteVC.menuDelegate = currentVC.parentVC?.menuDelegate
        favoriteVC.isAllowRefresh = true
        favoriteVC.dismissDelegate = currentVC.parentVC
        currentVC.parentVC?.addControllerOnContainer(controller: favoriteVC)
    }

    func gotoWalletSystem(_ currentVC: JamitRootViewController) {
        if let currentVC = currentVC as? UserInfoController {
            print("The wallet system is tapped in Navigation controllrer manager")
            let walletVC = HomeWalletController()
            walletVC.parentVC = currentVC.parentVC
            currentVC.parentVC?.addControllerOnContainer(controller: walletVC)
        }

        if let currentVC = currentVC as? NewUserProfileController {
            print("The wallet system is tapped in Navigation controllrer manager")
            let walletVC = HomeWalletController()
            walletVC.parentVC = currentVC.parentVC
            currentVC.parentVC?.addControllerOnContainer(controller: walletVC)
        }

    }
    
}
