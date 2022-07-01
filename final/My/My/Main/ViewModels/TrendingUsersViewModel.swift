//
//  TrendingUsersViewModel.swift
//  jamit
//
//  Created by Prof K on 3/15/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class TrendingUsersViewModel {
    
    var listTrendingUsers: [UserModel]?
    var userName: ((String) -> Void)?
    var kingFisherCompletion: ((String, String) -> Void)?
    var defaultImage: ((String) -> Void)?
    
    init() {
        fetchTrendingUsers()
    }
    
    func fetchTrendingUsers() {
        JamItPodCastApi.getTrendingUsers { (list) in
            self.listTrendingUsers = list
//            print("The trending user is \(list?[0].followers?.count)")
            if SettingManager.isLoginOK() {
                if list != nil {
                    //remove all trending user who is you
                    let currentUserId = SettingManager.getUserId()
                    self.listTrendingUsers?.removeAll(where: { user in
                        return !currentUserId.isEmpty && user.userID == currentUserId
                    })
//                    let myUser = UserModel()
//                    myUser.userID = IJamitConstants.ID_YOUR_STORY
//                    myUser.username = getString(StringRes.title_your_story)
//                    myUser.avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
//                    self.listTrendingUsers?.insert(myUser, at: 0)
                }
            }
        }
    }
    
}
