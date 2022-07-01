//
//  IRadioConstants.swift
//  Created by YPY Global on 1/22/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//
//

import Foundation
import UIKit

class IJamitConstants {
    
    // debug
    static let DEBUG = true
    
    //Your App ID on App Store, need it for rate me link
    static let APP_ID = "1448115371"
    static let SERVER_NEW_DATE_PATTERN = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    static let IAP_SHARE_SECRET = "cc2680e5b6304264861049c94e5598f6"
    
    static let FORMAT_SHARE = "https://jamit.app/%@/%@"
    static let FORMAT_WEB_EVENT_MANAGE = "https://jamit.app/live/manage/room/%@" //  /live/manage/room/event_id
    
    // Staging Enviroment Keys
    static let DOLBY_CONSUMER_KEY = "9HopokZV6CflfRHrEBpddw==" // Staging Only
    static let DOLBY_SECRET_KEY = "QoltcjxcUOX_Agpk0siZiCQYjm8OOUSq3pX1_vVPcMg=" // Staging Only
    
    // Production Enviroment Keys
//    static let DOLBY_CONSUMER_KEY = "59HuTMiQ8I_t19nf4Qt0aQ=="
//    static let DOLBY_SECRET_KEY = "S50Hgtuq-hLLdp29GwIYAhhL8psyGXqTGN9cEMdD03o="
    
    static let FREQ_AUDIO_ADS = 2 //click each item episode to show this one
    static let FREQ_EVENT_ADS = 1 //click each item event to show this one
 
    //storyboard name
    static let STORYBOARD_EVENT = "Event"
    static let STORYBOARD_USER = "User"
    static let STORYBOARD_TAB = "Tab"
    static let STORYBOARD_CHILD_IN_PAGE = "ChildInPage"
    static let STORYBOARD_STORY = "Story"
    static let STORYBOARD_DIALOG = "Dialog"
    static let STORYBOARD_COMMENT = "Comment"
    static let STORYBOARD_PLAYING = "Playing"
    static let STORYBOARD_SHOW = "Show"
    static let STORYBOARD_LIBRARY = "Library"
    static let STORYBOARD_IAP = "IAP"
    
    static let DATE_FORMAT_EVENT = "yyyy-MM-dd'T'HH:mm"
    
    static let MIN_SCHEDULE_IN_DAY = 1 // 1 day
    static let MAX_SCHEDULE_IN_DAY = 30 // 30 days
    static let ONE_DAY_IN_SECONDS = 86400 // 1 day
    
    //deep link
    static let URL_FORMAT_SHARE_SHOW = "https://jamit.app/link/%@/%@"
    static let URL_FORMAT_SHARE_STORY = "https://jamit.app/link/short/%@"
    static let URL_FORMAT_SHARE_EPISODE = "https://jamit.app/link/episode/%@"
    static let URL_FORMAT_SHARE_EVENT = "https://jamit.app/link/event/%@" //  jamit.app/live/event_room_id
    static let IOS_MININUM_APP_VERSION = "4.0.5" // this is long the version name which starting have deep link
    static let ANDROID_MININUM_VERSION_CODE = 2021032301 // this is the version code which starting have deep link
    static let ANDROID_PACKAGE_NAME = "com.jamit.music"
    static let URL_DYNAMIC_LINK = "https://jamit.link"
    static let DEFAULT_URL_IMAGE = "https://uploads.jamitfm.com/assets/jamit-podcasters-banner.png"
    
    //type deep link
    static let BROADCAST_DEEP_LINK = "BROADCAST_DEEP_LINK"
    static let KEY_DL_MODEL = "dl_model"
    static let TYPE_DL_PODCAST = "/podcast/"
    static let TYPE_DL_EPISODE = "/episode/"
    static let TYPE_DL_STORY = "/short/"
    static let TYPE_DL_AUDIO_BOOK = "/audiobook/"
    static let TYPE_DL_EVENT = "/event/"

    static let TAG_ALL = "all" // this one for filter in show of categories
    
    static let PLAY_COUNT_TIME = 30 // checking play count 30 seconds
    
    static let MAX_TIME_RECORD = 5 // 5 minutes
    
    static let ID_YOUR_STORY = "-1" // id for your story in feature story
    
    // frequency for review app must be higher than 10
    static let FREQ_REVIEW_APP = 10 // frequency for review app
    
    //Link social
    static let URL_FACEBOOK: String = "https://www.facebook.com/jamitfm" // if you want to hide it, just put it to be empty ""
    static let URL_TWITTER: String = "https://twitter.com/jamitfm" // if you want to hide it, just put it to be empty ""
    static let URL_INSTAGRAM: String = "https://www.instagram.com/jamitfm" // if you want to hide it, just put it to be empty ""
    static let URL_WEBSITE: String = "https://jamit.app" // if you want to hide it, just put it to be empty ""
    static let YOUR_CONTACT_EMAIL: String = "team@jamit.app"
    
    //url privacy policy in offline mode when you dont have url enpoint
    static let URL_PRIVACY_POLICY = "https://jamit.app/legal/privacy"
    
    //url term of use in offline mode when you dont have url enpoint
    static let URL_TERM_OF_USE = "https://jamit.app/legal/terms"
    
    static let ADMOB_TEST_ID = "fce2c0ef05df9b18cef751ec32d81fa4"
  
    static let TYPE_VC_TAB_HOME = 2
    static let TYPE_VC_TAB_CATEGORIES = 14
    static let TYPE_VC_FAVORITE = 16
    static let TYPE_VC_DOWNLOAD = 10
    static let TYPE_VC_TAB_LIBRARY = 11
    static let TYPE_VC_DETAIL_SHOW = 7
    static let TYPE_VC_SHOWS_OF_CATEGORY = 22
    static let TYPE_VC_FEATURED_PODCASTS = 24
    static let TYPE_VC_USER_STORIES = 25
    static let TYPE_VC_FEATURED_STORY = 26
    static let TYPE_VC_FEATURED_AUDIO_BOOK = 23
    static let TYPE_VC_SEARCH = 8
    static let TYPE_PLAYING = 27
    static let TYPE_VC_TAB_PROFILE = 29
    static let TYPE_VC_MY_STORIES = 30
    static let TYPE_VC_DETAIL_TOPIC = 31
    static let TYPE_VC_FEATURED_EVENT = 33
    static let TYPE_VC_TOP_TEN_PODCASTS = 34
    
    static let TYPE_FOLLOWER = 0
    static let TYPE_FOLLOWING = 1
    static let TYPE_WHO_FOLLOW = 2
    
    static let TYPE_VC_SOCIAL_INFO = 31
    static let TYPE_VC_SUGGEST_USER = 32
    
    static let TYPE_SETTING = 31
    
    //reset timer when exit app
    static let RESET_TIMER = true
        
    static let SHOW_ADS = false
    
    static let NUMBER_ITEM_PER_PAGE = 10
    static let MAX_PAGE = 10
    
    static let MAX_SLEEP_MODE = 120
    static let MIN_SLEEP_MODE = 0

    //broadcast action name
    static let BROADCAST_DATA_CHANGE = "BROADCAST_DATA_CHANGED"
    static let KEY_VC_TYPE = "vcType"
    static let KEY_ID = "id"
    static let KEY_IS_FAV = "is_fav"
    static let KEY_LIKE_DATA = "likes"

    
    //file name in Config
    static let FILE_RADIO_JSON = "radios"
    static let FILE_GENRE_JSON = "genres"
    static let FILE_THEME_JSON = "themes"
    static let FILE_UI_JSON = "ui"
    static let FILE_CONFIG_JSON = "config"
    static let FORMAT_JSON = "json"
    
    // use blur background effect
    static let USE_BLUR_EFFECT: Bool = true
                
    static let FONT_NORMAL = "Poppins-Regular"
    static let FONT_SEMI_BOLD = "Poppins-SemiBold"
    static let FONT_BOLD = "Poppins-Bold"
    static let FONT_LIGHT = "Poppins-Light"
    
    static let ONE_HOUR: Double = Double(3600000) // 1 hour
    static let ONE_MINUTE: Double = Double(60000) //1 minute
    
    static let DIR_DOWNLOADED = "downloaded"
    static let FORMAT_CACHE = "jamit_"
    
    static let MINIMUM_FREE_STORAGE = 200
    
    static let ID_MENU_LISTEN_OFFLINE = -14
    static let ID_MENU_DELETE_MODEL = -9
    static let ID_MENU_SHARE_MODEL = -10
    static let ID_MENU_ADD_FAV = -11
    static let ID_MENU_REMOVE_FAV = -12
    static let ID_MENU_DELETE_STORY = -13
    static let ID_MENU_TWITTER = -15
    
    static let MAX_FEATURED_BANNER = 5
    
    static let RATE_2_1: CGFloat = 1.0/2.0
    static let RATE_16_9: CGFloat = 9.0/16.0
    static let RATE_AUDIO_TYPE: CGFloat = 0.4
    static let RATE_TRENDING_PODCAST: CGFloat = 1.2/3.0
    static let RATE_PROFILE_BANNER: CGFloat = 9.0/16.0
    static let RATE_TRENDING_USER: CGFloat = 0.8/3.0
    static let RATE_AVATAR_EVENT_CELL: CGFloat = 0.171429
    static let RATE_EVENT_LIVE_USER: CGFloat = 0.233918
    
    static let TIME_FEATURED_PAGE_CHANGE = 10.0
    
    static let ID_UPDATE_PREMIUM = -1
    static let ID_RATE_US = -2
    static let ID_TELL_A_FRIEND = -3
    static let ID_CONTACT_US = -4
    static let ID_VISIT_WEBSITE = -6
    static let ID_VISIT_FACEBOOK = -7
    static let ID_VISIT_TWITTER = -8
    static let ID_VISIT_INSTA = -9
    static let ID_PRIVACY_POLICY = -10
    static let ID_TERM_OF_USE = -11
    static let ID_SIGN_OUT = -12
    
    static let ID_SIGN_IN = -13
    static let ID_RECORDING = -14
    static let ID_TALK_TO_ME = -15
    static let ID_SUBMIT_PODCAST = -16
    static let ID_CREATE = -17

    static let ARRAY_IDS_PROFILE:[Int] = [ID_UPDATE_PREMIUM, ID_RATE_US, ID_TELL_A_FRIEND, ID_CONTACT_US,ID_VISIT_WEBSITE,ID_VISIT_FACEBOOK, ID_VISIT_INSTA, ID_VISIT_TWITTER, ID_PRIVACY_POLICY, ID_TERM_OF_USE]
    
    static let FORWARD_SEEK_SECONDS = 30 // 30 seconds
    static let REWIND_SEEK_SECONDS = 10 // 10 seconds
    static let MIN_PASSWORD_LENGHT = 8
    
    static let DELTA_CHECK_IAP_EXPIRED = 1 //1 day
    
    static let RECORD_FOLDER = "record"
    static let BITRATE = 96000
    static let NUMBER_CHANNELS = 2
    static let SAMPLING_RATE = 44100
    static let FORMAT_FILE_NAME = "story_%@_%@.m4a"
    
    static let IMG_AVATAR = "img_avatar.jpg"
    static let IMG_QUALITY: CGFloat = 80.0 // percentage image
    static let IMG_SIZE: CGFloat = 320 // size avatar
    
    static let FONT_MEDIUM = "Poppins-Medium"
    
}
enum UIType: Int{
    case FlatGrid = 1, FlatList, CardGrid, CardList
}

