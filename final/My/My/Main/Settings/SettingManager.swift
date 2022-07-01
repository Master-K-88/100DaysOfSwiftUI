//
//  SettingManager.swift
//  Created by YPY Global on 4/9/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
public class SettingManager {
    
    static let KEY_TIME_SLEEP = "time_sleep"
    static let KEY_PIVOT_TIME = "pivot_time"
    
    static let KEY_SHOW_INTRO = "show_intro"
    static let KEY_USER_NAME = "user_name"
    static let KEY_FIRST_NAME = "first_name"
    static let KEY_LAST_NAME = "last_name"
    static let KEY_ABOUT_USER = "about_user"
    static let KEY_GENDER = "gender"
    static let KEY_USER_AVATAR = "user_avatar"
    static let KEY_USER_ID = "user_id"
    static let KEY_USER_TOKEN = "user_token"
    static let KEY_USER_EMAIL = "email"
    static let KEY_NEED_UPDATE_PURCHASE = "need_update_purchase"
    
    static let KEY_COUNT_REVIEW = "review_count"
    
    public static func saveSetting (_ key: String!, _ value: String!){
        let user = UserDefaults.standard
        user.set(value, forKey: key)
    }
    
    public static func getSetting (_ key: String!, _ defautValue: String = "") -> String{
        let user = UserDefaults.standard
        let value = user.string(forKey: key) ?? defautValue
        return value
    }
    
    public static func getInt (_ key: String!, _ defaultValue: Int = 0) -> Int {
        let value = getSetting(key, String(defaultValue))
        return Int(value)!
    }
    
    
    public static func setInt (_ key: String! , _ value: Int) {
        saveSetting(key, String(value))
    }
    
    public static func getInt64 (_ key: String!, _ defaultValue: Int = 0) -> Int64 {
        let value = getSetting(key, String(defaultValue))
        return Int64(value)!
    }
    
    
    public static func setInt64 (_ key: String! , _ value: Int64) {
        saveSetting(key, String(value))
    }
    
    public static func getDouble (_ key: String! ,_ defaultValue: Double = 0) -> Double {
        let value = getSetting(key, String(defaultValue))
        return Double(value)!
    }
    
    public static func setDouble (_ key: String! , _ value: Double) {
        saveSetting(key, String(value))
    }
    
    public static func getBoolean(_ key: String!, _ defValue: Bool = false) -> Bool {
        let value = getSetting(key!, String(defValue))
        return Bool(value)!
    }
    
    public static func setBoolean (_ key: String!, _ value: Bool) {
        saveSetting(key!, String(value))
    }
    
    public static func getSleepMode () -> Int {
        return getInt(KEY_TIME_SLEEP)
    }
    
    public static func setSleepMode (_ sleepTime: Int) {
        setInt(KEY_TIME_SLEEP, sleepTime)
    }
    
    public static func getPivotTime () -> Double {
        return getDouble(KEY_PIVOT_TIME)
    }
    
    public static func setPivotTime (_ pivotTime: Double) {
        setDouble(KEY_PIVOT_TIME, pivotTime)
    }
  
    public static func isLoginOK() -> Bool {
        let userId = getUserId()
        let userToken = getSetting(KEY_USER_TOKEN)
        let userEmail = getSetting(KEY_USER_EMAIL)
        return !userId.isEmpty && !userToken.isEmpty && !userEmail.isEmpty
    }
    
    public static func getUserId() -> String {
        return getSetting(KEY_USER_ID)
    }
    
    public static func logOut(){
        saveSetting(KEY_USER_ID, "")
        saveSetting(KEY_USER_NAME,"")
        saveSetting(KEY_USER_TOKEN,"")
        saveSetting(KEY_USER_AVATAR,"")
        saveSetting(KEY_USER_EMAIL,"")
    }
    
    public static func isCacheExpired(_ key :String , _ deltaTime: Double) -> Bool{
        let cacheTime = getDouble(key)
        return deltaTime > 0 && (cacheTime==0 || (DateTimeUtils.currentTimeMillis() - cacheTime) >= deltaTime)
    }
    
    public static func cacheHit(_ key: String){
        setDouble(key,DateTimeUtils.currentTimeMillis())
    }

    public static func saveUser(_ user: UserModel) {
        saveSetting(KEY_USER_NAME, user.username)
        if !user.token.isEmpty {
            saveSetting(KEY_USER_TOKEN, user.token)
        }
        saveSetting(KEY_FIRST_NAME, user.firstName)
        saveSetting(KEY_LAST_NAME, user.lastName)
        saveSetting(KEY_ABOUT_USER, user.bio)
        saveSetting(KEY_USER_ID, user.userID)
        saveSetting(KEY_USER_EMAIL, user.email)
        saveSetting(KEY_USER_AVATAR, user.avatar)
        
    }
}
