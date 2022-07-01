//
//  MemberShipManager.swift
//  jamit
//
//  Created by Do Trung Bao on 4/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

public class MemberShipManager {
    
    static let ONE_DAY: Double = Double(86400000) //1 day in million seconds
    static let BROADCAST_PURCHASE_SUCCESS = "PURCHASE_SUCCESS"
    static let KEY_MESSAGE = "message"
    static let BROADCAST_PURCHASE_FAIL = "PURCHASE_FAILED"
    
    static let TYPE_BEGINNER_MEMBER = 0;
    static let TYPE_PLUS_MEMBER = 1
    static let TYPE_PREMIUM_MEMBER = 2
    static let TYPE_VIP_MEMBER = 3
    static let TYPE_MEMBERS: [Int] = [TYPE_PLUS_MEMBER, TYPE_PREMIUM_MEMBER, TYPE_VIP_MEMBER]
    static let DELTA_TIMES: [Int] = [31, 186, 365]
    static let STR_MEMBERS: [String] = ["subscriber_plus", "subscriber_premium", "subscriber_vip"]
    
    static let KEY_SV_TRANSACTION_ID = "transaction_id"
    static let KEY_MEMBER_ID = "member_id"
    static let KEY_USER_ROLE = "user_role"
    static let KEY_PRODUCT_ID = "product_id"
    static let KEY_PURCHASE_TIME = "purchase_time"
    static let KEY_EXPIRED_TIME = "expired_time"
    static let KEY_PIVOT_CHECK_IAP = "pivot_check_iap"
    static let KEY_YOUR_DEVICE_TRANS_ID = "trans_id_on_device"
    
    static let shared = MemberShipManager()
    
    init() {
        
    }
    
    func checkIAP( _ completion: @escaping ()->Void){
        //check to submit error current purchase before
        let isNeedUpdate = SettingManager.getBoolean(SettingManager.KEY_NEED_UPDATE_PURCHASE)
        if isNeedUpdate {
            JamitLog.logE("======>submit old purchase because it is error")
            self.submitOldPurchase(completion)
        }
        else{
            let isPurchaseOnDevice = self.isPurchasedOnThisDevice()
            let isPremium = self.isPremiumId()
            JamitLog.logE("==========>checkIAP isPurchaseOnDevice=\(isPurchaseOnDevice)==>isPremium=\(isPremium)")
            if isPurchaseOnDevice && isPremium {
                let isExpired = self.isMemberExpired()
                JamitLog.logE("==========>your purchase isExpired=\(isExpired)")
                if isExpired {
                    self.checkExpiredOnDevice(completion)
                }
                else{
                    completion()
                }
            }
            else{
                self.checkMemberExpired(completion)
            }
        }
        
    }
    
    private func checkExpiredOnDevice( _ completion: @escaping ()->Void){
        //check receipt info before doing another
        StoreKitManager.shared.checkReceiptInfo(sharedSecret: IJamitConstants.IAP_SHARE_SECRET
            , completion: { (receiptInfo) in
                let productId = SettingManager.getSetting(MemberShipManager.KEY_PRODUCT_ID)
                let purchaseItem = StoreKitManager.shared.verifySubscription(productId: productId, receipt: receiptInfo)
                if purchaseItem != nil {
                    JamitLog.logE("======>save new purchase")
                    let receiptDict = self.getDictReceiptItem(receipt: purchaseItem!)
                    self.saveInfoMember(receipt: receiptDict)
                    
                    //save need update to be true
                    JamitLog.logE("======>submit new purchase from restore model")
                    SettingManager.setBoolean(SettingManager.KEY_NEED_UPDATE_PURCHASE, true)
                    self.submitOldPurchase(completion)
                    
                }
                else{
                    JamitLog.logE("======>user cancel reset purchase")
                    self.checkMemberExpired(completion)
                }
                
        }, error: {(msg) in
            JamitLog.logE("======>checkExpiredOnDevice purchase error =\(msg)")
             self.checkMemberExpired(completion)
        })
    }
    
    func submitOldPurchase( _ completion: @escaping ()->Void){
        let currentInfo = self.getCurrentMemberInfo()
        JamItPodCastApi.updatePremium(currentInfo) { (result) in
            if (result?.model as? UserModel) != nil {
                //reset neet update
                SettingManager.setBoolean(SettingManager.KEY_NEED_UPDATE_PURCHASE, false)
            }
            completion()
        }
    }
    
    private func checkMemberExpired(_ completion: @escaping ()->Void){
        let isPremium = self.isPremiumId()
        let isExpired = self.isMemberExpired()
        if isPremium && isExpired {
            self.resetIAP()
            let freeInfo = self.getFreeMemberInfo()
            JamItPodCastApi.updatePremium(freeInfo) { (result) in
                completion()
            }
        }
        else{
            JamitLog.logE("========>start check user info from web to know if user subscribe from web")
            let token = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
            JamItPodCastApi.getUser(token) { (result) in
                if let userModel = result?.model as? UserModel {
                    //reset neet update
                    if userModel.isActive {
                        SettingManager.saveUser(userModel)
                        MemberShipManager.shared.saveInfoMemberFromUserModel(userModel)
                        completion()
                        return
                    }
                    else{
                        JamitLog.logE("========>user not active, we need to signout")
                        self.resetIAP()
                        SettingManager.logOut()
                    }
                }
                completion()
            }
        }
    }
    
    func isMemberExpired() -> Bool{
        let expiredTime = SettingManager.getDouble(MemberShipManager.KEY_EXPIRED_TIME)
        if expiredTime == 0 || (expiredTime > 0 && expiredTime < DateTimeUtils.currentTimeMillis()) {
            return true
        }
        return false
    }
    
    func isPremiumMember() -> Bool {
        if self.isMemberExpired() {
            return false
        }
        return isPremiumId()
    }
    
    func isPremiumId() -> Bool {
        let id = self.getIdMember()
        let len = MemberShipManager.TYPE_MEMBERS.count
        if id >= MemberShipManager.TYPE_MEMBERS[0] && id <= MemberShipManager.TYPE_MEMBERS[len - 1] {
            for typeMember in MemberShipManager.TYPE_MEMBERS {
                if id == typeMember {
                    return true
                }
            }
        }
        return false
    }
    
    func resetIAP(){
        self.setIdMember(MemberShipManager.TYPE_BEGINNER_MEMBER)
        SettingManager.setDouble(MemberShipManager.KEY_PURCHASE_TIME, 0)
        SettingManager.setDouble(MemberShipManager.KEY_EXPIRED_TIME,0)
        //SettingManager.saveSetting(MemberShipManager.KEY_TRANSACTION_ID, "")
        SettingManager.saveSetting(MemberShipManager.KEY_USER_ROLE, "")
    }

    
    func getMemberIndexFromProductId(_ sku: String) -> Int {
        let mListItems = StringRes.array_product_ids
        var index = 0
        for itemId in mListItems {
            let realSku = getString(itemId)
            if (realSku.elementsEqual(sku)) {
                return index
            }
            index += 1
        }
        return 0
    }
    
    func getMemberIdexFromType(_ type: String) -> Int {
        let mListItems = MemberShipManager.STR_MEMBERS
        var index = 0
        for item in mListItems {
            if (item.elementsEqual(type)) {
                return index
            }
            index += 1
        }
        return 0
    }
    
    private func getDurationInDaysOfSKU(_ sku: String) -> Int {
        let mListItems = StringRes.array_product_ids
        var index = 0
        for itemId in mListItems {
            let realSku = getString(itemId)
            if (realSku.elementsEqual(sku)) {
                return MemberShipManager.DELTA_TIMES[index]
            }
            index += 1
        }
        return 0
    }
    
    func getMemberIndex() -> Int {
        let memberId = getIdMember()
        var index = 0
        for item in MemberShipManager.TYPE_MEMBERS {
            if (item == memberId) {
                return index
            }
            index += 1
        }
        return -1
    }
        
    func setIdMember(_ memberId :Int){
        SettingManager.setInt(MemberShipManager.KEY_MEMBER_ID, memberId)
    }
    
    func getIdMember() -> Int{
        return SettingManager.getInt(MemberShipManager.KEY_MEMBER_ID)
    }
    
    func saveInfoMemberFromUserModel(_ user: UserModel){
        let index = user.isPremium ? self.getMemberIdexFromType(user.subscriptionType) : -1
        let mListItems = StringRes.array_product_ids
        JamitLog.logE("==========>saveInfoMemberFromUserModel index member =\(index)===>user.endDate=\(user.endDate)===>user.startDate=\(user.startDate)")
        if index >= 0 {
            setIdMember(MemberShipManager.TYPE_MEMBERS[index])
            SettingManager.saveSetting(MemberShipManager.KEY_USER_ROLE, user.subscriptionType)
            SettingManager.saveSetting(MemberShipManager.KEY_PRODUCT_ID, getString(mListItems[index]))
            SettingManager.setDouble(MemberShipManager.KEY_PURCHASE_TIME,user.startDate)
            SettingManager.setDouble(MemberShipManager.KEY_EXPIRED_TIME,user.endDate)
            
        }
        SettingManager.saveSetting(MemberShipManager.KEY_SV_TRANSACTION_ID,user.premiumId)
        if !self.isPremiumMember() || index < 0 {
            self.resetIAP()
        }
    }
    
    func saveInfoMember(receipt: [String: Any]){
        let productId = receipt[MemberShipManager.KEY_PRODUCT_ID] as! String
        let index = self.getMemberIndexFromProductId(productId)
        JamitLog.logE("==========>saveInfoMember indexMember =\(index)")
        if index >= 0 {
            setIdMember(MemberShipManager.TYPE_MEMBERS[index])
            SettingManager.saveSetting(MemberShipManager.KEY_USER_ROLE,MemberShipManager.STR_MEMBERS[index])
            SettingManager.saveSetting(MemberShipManager.KEY_PRODUCT_ID,receipt[MemberShipManager.KEY_PRODUCT_ID] as? String)
            SettingManager.saveSetting(MemberShipManager.KEY_SV_TRANSACTION_ID,receipt[MemberShipManager.KEY_SV_TRANSACTION_ID] as? String)
            SettingManager.setDouble(MemberShipManager.KEY_PURCHASE_TIME,receipt[MemberShipManager.KEY_PURCHASE_TIME] as! Double)
            SettingManager.setDouble(MemberShipManager.KEY_EXPIRED_TIME,receipt[MemberShipManager.KEY_EXPIRED_TIME] as! Double)
            SettingManager.saveSetting(MemberShipManager.KEY_YOUR_DEVICE_TRANS_ID, receipt[MemberShipManager.KEY_SV_TRANSACTION_ID] as? String)
        }
     
    }
    
    func isPurchasedOnThisDevice() -> Bool{
        let svTransId = SettingManager.getSetting(MemberShipManager.KEY_SV_TRANSACTION_ID)
        let yourTransId = "ios_" + SettingManager.getSetting(MemberShipManager.KEY_YOUR_DEVICE_TRANS_ID)
        JamitLog.logE("========>svTransId=\(svTransId)===>yourTransId=\(yourTransId)")
        return !svTransId.isEmpty && svTransId.elementsEqual(yourTransId)
    }
    
    func getDictReceiptItem(receipt: ReceiptItem) -> [String: Any] {
        var dict = [String: Any]()
        dict[MemberShipManager.KEY_PRODUCT_ID] = receipt.productId
        dict[MemberShipManager.KEY_SV_TRANSACTION_ID] = receipt.transactionId
        dict[MemberShipManager.KEY_PURCHASE_TIME] = DateTimeUtils.getTimeMillisOfDate(date: receipt.purchaseDate)
        var expiredTime = DateTimeUtils.getTimeMillisOfDate(date: receipt.subscriptionExpirationDate)
        if expiredTime == 0 {
            let duration = self.getDurationInDaysOfSKU(receipt.productId)
            expiredTime = Double(duration) * MemberShipManager.ONE_DAY
        }
        dict[MemberShipManager.KEY_EXPIRED_TIME] = expiredTime
        return dict
    }
    
    func getExamplePurchaseInfo() -> [String: Any] {
        var dict = [String: Any]()
        dict[MemberShipManager.KEY_PRODUCT_ID] = getString(StringRes.array_product_ids[0])
        dict[MemberShipManager.KEY_SV_TRANSACTION_ID] = "RYAFGHSFUY278383"
        dict[MemberShipManager.KEY_PURCHASE_TIME] = Double(1588577954000)
        dict[MemberShipManager.KEY_EXPIRED_TIME] = Double(1591228800000)
        return dict
    }
    
    func getFreeMemberInfo() -> [String: Any] {
        var dict = [String: Any]()
        dict["token"] = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
        dict["subscription_type"] = "free"
        dict["premium_id"] = ""
        dict["premium_start_date"] = "0"
        dict["premium_end_date"] = "0"
        dict["is_premium_member"] = false
        dict["is_activated"] = true
        dict["premium_referral_platform"] = "ios"
        return dict
    }
    
    func getCurrentMemberInfo() -> [String: Any] {
        var dict = [String: Any]()
        dict["token"] = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
        let userRole = SettingManager.getSetting(MemberShipManager.KEY_USER_ROLE)
        dict["subscription_type"] = !userRole.isEmpty ? userRole: "free"
        dict["premium_id"] = "ios_" + SettingManager.getSetting(MemberShipManager.KEY_SV_TRANSACTION_ID)
        dict["premium_start_date"] = String(SettingManager.getDouble(MemberShipManager.KEY_PURCHASE_TIME))
        dict["premium_end_date"] = String(SettingManager.getDouble(MemberShipManager.KEY_EXPIRED_TIME))
        dict["is_premium_member"] = true
        dict["is_activated"] = true
        dict["premium_referral_platform"] = "ios"
        return dict
    }
    
}
