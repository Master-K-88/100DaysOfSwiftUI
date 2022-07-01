//
//  NewSettingManager.swift
//  My
//
//  Created by Prof K on 6/29/22.
//

import Foundation
public class NewSettingManager {
    
    static let CSRF_HEADER_KEY = "X-CSRF-Token"
    static let KEY_CSRF_TOKEN = "csrf_token"
    static let KEY_USER_EMAIL = "user_email"
    static let KEY_USER_TOKEN = "user_token"
    static let KEY_USER_ID = "user_id"
    static let KEY_USER_NAME = "user_name"
    static let KEY_USER_AVATAR = "user_avatar"
    static let KEY_REGISTER_USER = "register_user"
    static let KEY_ABOUT_USER = "about_user"
    static let KEY_USER_TYPE = "user_type"
    
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
    
    public static func isCacheExpired(_ key :String , _ deltaTime: Double) -> Bool{
        let cacheTime = getDouble(key)
        return deltaTime > 0 && (cacheTime==0 || (DateTimeUtils.currentTimeMillis() - cacheTime) >= deltaTime)
    }
    
    public static func cacheHit(_ key: String){
        setDouble(key,DateTimeUtils.currentTimeMillis())
    }
}
