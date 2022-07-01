//
//  UserModel.swift
//  jamit
//
//  Created by jamit on 5/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//
import Foundation

public class UserModel: JamitResponce {
    
    var userID = ""
    var token = ""
    var username = ""
    var firstName = ""
    var lastName = ""
    var bio = ""
    var gender = ""
    var avatar = ""
    var email = ""
    var subscriptionType = ""
    var premiumId = ""
    var isActive = false
    var isPremium = false
    var startDate: Double = 0
    var endDate: Double = 0
    var tipSupportUrl = ""
    var selected: String?
    
    var followers: [UserModel]?
    var following: [UserModel]?
    
    var isInvited = false
    
    override func initFromDict(_ dict: [String : Any]?) {
        super.initFromDict(dict)
        self.userID = self.parseValueFromDict("_id") ?? ""
        self.firstName = self.parseValueFromDict("first_name") ?? ""
        self.lastName = self.parseValueFromDict("last_name") ?? ""
        self.gender = self.parseValueFromDict("gender") ?? ""
        self.bio = self.parseValueFromDict("about") ?? ""
        self.token = self.parseValueFromDict("token") ?? ""
        self.username = self.parseValueFromDict("username") ?? ""
        self.email = self.parseValueFromDict("email") ?? ""
        self.avatar = self.parseValueFromDict("avatar") ?? ""
        self.subscriptionType = self.parseValueFromDict("subscription_type") ?? ""
        self.premiumId = self.parseValueFromDict("premium_id") ?? ""
        self.isActive = self.parseValueFromDict("is_activated") ?? false
        self.isPremium = self.parseValueFromDict("is_premium_member") ?? false
        if let startDate = dict?["premium_start_date"] as? String {
            self.startDate = startDate.isNumber() ? Double(startDate)! : 0
        }
        if let endDate = dict?["premium_end_date"] as? String {
            self.endDate = endDate.isNumber() ? Double(endDate)! : 0
        }
        self.tipSupportUrl = self.parseValueFromDict("creator_support_url") ?? ""
        self.followers = self.parseListFromDict("followers")
        self.following = self.parseListFromDict("following")
    }
    
    override func clone() -> UserModel? {
        let userModel = UserModel()
        userModel.userID = userID
        userModel.avatar = avatar
        userModel.username = username
        return userModel
    }
    
    func update() -> UserModel? {
        let userModel = UserModel()
        userModel.firstName = firstName
        userModel.lastName = lastName
        userModel.bio = bio
        userModel.gender = gender
        return userModel
    }
    
    func isFollowerUser(_ userId: String) -> Bool {
        if !userId.isEmpty && self.followers != nil {
            for user in self.followers! {
                let compareId = user.userID
                if !compareId.isEmpty && compareId.elementsEqual(userId) {
                    return true
                }
            }
        }
        return false
    }
    
    func isMyUserId(_ userId: String) -> Bool {
        if !userId.isEmpty {
            return userId.elementsEqual(self.userID)
        }
        return false
    }
    
    func isYourStory() -> Bool {
        return userID.elementsEqual(IJamitConstants.ID_YOUR_STORY)
    }
    
    override func equalElement(_ otherModel: JsonModel?) -> Bool {
        if otherModel is UserModel {
            let cpUser = otherModel as! UserModel
            return cpUser.userID.elementsEqual(userID)
        }
        return false
    }
    
    func updateFollower(_ updateUser: UserModel, _ isFollower: Bool) {
        if self.followers == nil {
            self.followers =  []
        }
        if isFollower {
            self.followers?.append(updateUser)
            return
        }
        self.followers?.removeAll(where: { user in
            return user.equalElement(updateUser)
        })
    }
}
