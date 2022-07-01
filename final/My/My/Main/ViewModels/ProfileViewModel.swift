//
//  ProfileViewModel.swift
//  jamit
//
//  Created by Prof K on 4/4/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class ProfileViewModel {
    var userModel: UserModel?
    var userShort: [EpisodeModel]?
    var userLikes: [EpisodeModel]?
    var userModelCompletion: (() -> Void)?
    var userShortCompletion: (() -> Void)?
    var mainUserLike: (([EpisodeModel]) -> Void)?
    var noLikeData: ((String) -> Void)?
    var noUserDataMsg: ((String) -> Void)?
    var offlineUser: (() -> Void)?
    
    
    func followUser(_ user: UserModel,_ isLogin: Bool) {
                
        if isLogin {
            offlineUser?()
            return
        }
        if !ApplicationUtils.isOnline() {
            //            self.currentVC.parentVC?.showToast(with: StringRes.info_lose_internet)
            return
        }
        //        self.currentVC.parentVC?.showProgress()
        let userId = SettingManager.getUserId()
        let isNewFollow = !user.isFollowerUser(userId)
        JamItPodCastApi.updateFollow(isNewFollow, user.userID) { (result) in
            //            self.currentVC.parentVC?.dismissProgress()
            if let newUser = result {
                if newUser.isResultOk() {
                    user.followers = newUser.followers
                    user.following = newUser.following
                    //                    self.currentVC.parentVC?.showToast(withResId: isNewFollow ? StringRes.info_follow_successfully: StringRes.info_unfollow_successfully)
                    let msg = isNewFollow ? StringRes.info_follow_successfully: StringRes.info_unfollow_successfully
                    print("The message is \(msg)")
                    
                    //                    self.currentVC.parentVC?.friendVC?.updateFollow(isNewFollow)
                    //                    self.currentVC.parentVC?.profileVC?.isStartLoadData = false
                    //                    self.currentVC.parentVC?.profileVC?.startLoadData()
                }
                else{
                    let msg = !newUser.message.isEmpty ?  newUser.message : getString(StringRes.info_server_error)
                    self.noUserDataMsg?(msg)
                    //                    self.currentVC.parentVC?.showToast(with: msg)
                }
            }
        }
    }
    
    func updateFollow(_ isFollow : Bool) {
        let followBtnText = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
//        DispatchQueue.main.async {
//            self.editProfileBtn.setTitle("    \(followBtnText)", for: .normal)
//            self.editProfileBtn.setImage(UIImage(named: isFollow ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp), for: .normal)
//            self.editProfileBtn.backgroundColor = isFollow ? .black/*UIColor.clear*/ : getColor(hex: ColorRes.subscribe_color)
//            self.editProfileBtn.borderColor = isFollow ? .white : UIColor.clear
//            self.editProfileBtn.borderWidth = CGFloat(isFollow ? 1 : 0)
//        }
        
//
//        //update following, follower
        let numberFollower = self.userModel?.followers?.count ?? 0
        let numberFollowing = self.userModel?.following?.count ?? 0
        if numberFollower > 0 || numberFollowing > 0 {
            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
//            DispatchQueue.main.async {
////                self.btnFollower.text = String(strFollower.prefix(strFollower.count - 9))
////                self.btnFollowing.text = String(strFollowing.prefix(strFollowing.count - 9))
////                self.followerTap.isUserInteractionEnabled = false
////                self.followingTap.isUserInteractionEnabled = false
//            }
            
        }
    }
    
    func getListModelFromServer(_ userName: String,_ userID: String) {
//        let setting = TotalDataManager.shared.getSetting()
//        let isShow = setting != nil //&& setting!.showAudioTypes
        if SettingManager.isLoginOK() && ApplicationUtils.isOnline() {
//            let userName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            JamItPodCastApi.getUserInfo(userName) { (result) in
                self.userModel = result
//                guard let result = result else { return }
                self.userModelCompletion?()
//                self.startCreateProfileItem(completion)
            }
//            if let short = self.headerView?.shortSelected {
//                if short {
                    JamItPodCastApi.getUserStories(userID) { (list) in
                        self.userShort = list
//                        guard let list = list else {
//                            return
//                        }

                        self.userShortCompletion?()
//                        completion(self.convertListModelToResult(list))
//                    }
//                }

            }
//            if let like = self.headerView?.likesSelected {
//                if like {
                    JamItPodCastApi.getUserFavEpisode { (list) in
//                        let size = list?.count ?? 0
//                        if size > 0 {
                        guard let list = list else { return }
//                            self.numLike = size
                            for model in list {
                                model.likes = [userID]
                            }
//                        } else {
//                            self.profileDelegate?.updateShortSelection()
//                        }
                        self.mainUserLike?(list)
//                        self.userFav = list
//                        completion(self.convertListModelToResult(list))
//                    }
//                }

            }

            JamItPodCastApi.getFrndFavEpisode(userID) { (list) in
                self.userLikes = list
                //                if let like = self.friendHeader?.likesSelected {
                //                    if like {
                let size = list?.count ?? 0
                //                        self.lblNodata.isHidden = size > 0
                if size > 0 {
                    for model in list! {
                        model.likes = [userID]
                    }
                } else {
//                    DispatchQueue.main.async {
                        let msgIdFormat = StringRes.friend_no_like
                        let uname = self.userModel?.username ?? ""
                        let msg = String(format: getString(msgIdFormat), uname, uname)
                    self.noLikeData?(msg)
                        //                                self.lblNodata.text = msg
//                    }
                }
    //
    //            //                        completion(self.convertListModelToResult(list))
    //
//            if let event = self.headerView?.eventSelected {
//                if event {
//                    self.eventUserId = user?.userID
//                    if self.eventUserId != nil && !self.eventUserId!.isEmpty {
//                        JamItEventApi.getUserEvents(self.eventUserId!) { events in
//                            completion(self.convertListModelToResult(events))
//                        }
//                        return
//                    }
//                    if self.eventType != nil && !self.eventType!.isEmpty {
//                        JamItEventApi.getListTypeEvents(self.eventType!) { events in
//                            completion(self.convertListModelToResult(events))
//                        }
//                        return
//                    }
//                }
//
//            }

            return
        }
        self.userModel = nil
//        startCreateProfileItem(completion)
    }
////    func getListModelFromServer(_ parsedUserModel: UserModel,_ completion: @escaping (ResultModel?) -> Void) {
////        let userName = parsedUserModel.username ?? ""
////        //        guard let userId = userModel.userID else {return}
////        let userID = parsedUserModel.userID
////        if  !userName.isEmpty && ApplicationUtils.isOnline(){
////            JamItPodCastApi.getUserInfo(userName) { (result) in
////                if let userInfo = result {
////                    self.userModel = userInfo
////                    guard let userModel = self.userModel else {
////                        return
////                    }
////
////                    userModel.followers = userInfo.followers
////                    userModel.following = userInfo.following
////                    userModel.tipSupportUrl = userInfo.tipSupportUrl
////                    //                    self.startCreateProfileItem(completion)
////                }
////            }
////
////        }
////
////        JamItPodCastApi.getUserStories(userID) { (list) in
////            self.userShort = list
////            //                        self.lblNodata.isHidden = (list?.count ?? 0) > 0
////            //                        completion(self.convertListModelToResult(list))
////            //                    }
////        }
////
////        JamItPodCastApi.getFrndFavEpisode(userID) { (list) in
////            self.userLikes = list
////            //                if let like = self.friendHeader?.likesSelected {
////            //                    if like {
////            let size = list?.count ?? 0
////            //                        self.lblNodata.isHidden = size > 0
////            if size > 0 {
////                for model in list! {
////                    model.likes = [userID]
////                }
////            } else {
////                DispatchQueue.main.async {
////                    let msgIdFormat = StringRes.friend_no_like
////                    let uname = self.userModel?.username ?? ""
////                    let msg = String(format: getString(msgIdFormat), uname, uname)
////                    //                                self.lblNodata.text = msg
////                }
////            }
//////
//////            //                        completion(self.convertListModelToResult(list))
//////            //                    }
////            //                }
//        }
//
//        return
    }
    
    func setUpInfo(_ user: UserModel?, _ numStories: Int ) {
//        self.numStory = numStories
//
//        self.layoutAvatar.cornerRadius = self.layoutAvatar.frame.size.width / CGFloat(2)
//        self.imgAvatar.cornerRadius = self.imgAvatar.frame.size.width / CGFloat(2)
        
        if user != nil {
//            self.user = user
//            self.lblUserName.text = "@\(user!.username)"
//            let numStory =  StringUtils.formatNumberSocial(StringRes.format_story, StringRes.format_stories, Int64(numStories))
//            let shortText = numStory.suffix(1) == "s" ? "Shorts \(numStory.prefix(numStory.count - 6))" : "Short \(numStory.prefix(numStory.count - 5))"
//            if let fName = user?.firstName, let lName = user?.lastName {
//                    self.fullNameLbl.text = "\(fName) \(lName)"
//            } else {
//                self.fullNameLbl.isHidden = true
//            }
//            if let frnBio = user?.bio {
//                self.bioLbl.text = "\(frnBio)"
//            }
//            if shortSelected {
//                shortsBtn.setTitle("Shorts", for: .normal)
//            } else {
//                shortsBtn.setTitle("Shorts", for: .normal)
//            }
//
//            let imgUrl: String = user!.avatar
//            if imgUrl.starts(with: "http") {
//                self.imgAvatar.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
//            }
//            else {
//                self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
//            }
            let isFollow = user?.isFollowerUser(SettingManager.getUserId()) ?? false
            self.updateFollow(isFollow)
            
//            let setting = TotalDataManager.shared.getSetting()
//            let isSupport = setting?.isTipSupport ?? false
//            let tipUrlEmpty = user?.tipSupportUrl.isEmpty ?? true
//            let showTip = isSupport && !tipUrlEmpty
//            self.btnSupport.isHidden = !showTip
            
        }
    }
    
    // Update user follow for the friends controller
//    func updateFollow(_ isFollow : Bool) {
//        let followBtnText = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
//        DispatchQueue.main.async {
//            self.editProfileBtn.setTitle("    \(followBtnText)", for: .normal)
//            self.editProfileBtn.setImage(UIImage(named: isFollow ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp), for: .normal)
//            self.editProfileBtn.backgroundColor = isFollow ? .black/*UIColor.clear*/ : getColor(hex: ColorRes.subscribe_color)
//            self.editProfileBtn.borderColor = isFollow ? .white : UIColor.clear
//            self.editProfileBtn.borderWidth = CGFloat(isFollow ? 1 : 0)
//        }
        
//
//        //update following, follower
//        let numberFollower = self.user?.followers?.count ?? 0
//        let numberFollowing = self.user?.following?.count ?? 0
//        if numberFollower > 0 || numberFollowing > 0 {
//            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
//            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
//            DispatchQueue.main.async {
//                self.btnFollower.text = String(strFollower.prefix(strFollower.count - 9))
//                self.btnFollowing.text = String(strFollowing.prefix(strFollowing.count - 9))
//                self.followerTap.isUserInteractionEnabled = false
//                self.followingTap.isUserInteractionEnabled = false
//            }
            
//        }
    }
    
    //        completion(nil)
    //    }

