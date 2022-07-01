//
//  JamItUserApi.swift
//  jamit
//  Created by Jamit on 5/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

open class JamItPodCastApi {
    
//    static let URL_API_ROOT  = "https://jamit.app/api/" // Production
////        static let URL_API_ROOT  = "http://ec2-54-157-228-67.compute-1.amazonaws.com/api/" // Staging
    static let URL_API_ROOT  = "https://staging-env.jamit.app/api/" // Staging

    // Testing
//    static let URL_API_ROOT  = "http://localhost:8000/api/" // Local
    
    static let TIMEOUT_INTERVAL = TimeInterval(60) // 60 seconds
    
    static let METHOD_REGISTER  = "register"
    static let METHOD_LOGIN  = "login"
    static let METHOD_PREMIUM  = "user/premium"
    static let METHOD_GET_USER  = "user/"
    static let METHOD_GET_FAVORITES  = "user/likes/"
    static let METHOD_GET_AUDIO_SUBSCRIPTIONS = "user/audio/subscriptions"
    static let METHOD_GET_SHOW_OF_CAT = "category/%@/audios/%@/%@"
    static let METHOD_DETAIL_SHOW = "audio/%@"
    static let METHOD_CHECK_USER = "check/user"
    static let METHOD_TRENDING_USER = "users/trending"
    
    static let METHOD_JAMIT_LOCALES = "jamit/locales"
    static let METHOD_LOCALE_LANS = "locale/languages"
    static let METHOD_LOCALE_COUNTRY = "locale/countries"
    static let METHOD_TOPIC = "topics"
    static let METHOD_SERIES_NAME = "series/by/%@/names"
    static let METHOD_PLAY_COUNT = "play/count/%@"
    
    static let METHOD_FEATURED_EPISODE = "featured/episodes/%@"
    static let METHOD_FEATURED_STORY = "featured/audio/stories/%@"
    
    static let METHOD_STORIES_FOR_USER = "stories/for/user"
    static let METHOD_SUGGESTED_USER = "users/suggested/%@"
    
    static let METHOD_FEATURED_PODCAST = "featured/audio/podcasts"
    static let METHOD_FEATURED_AUDIOBOOKS = "featured/audio/audiobooks"
    
    static let METHOD_TRENDING_PODCAST = "trending/audio/podcasts"
    
    static let METHOD_FEATURED_BANNER = "featured/audio"
    static let METHOD_SEARCH_EPISODES = "search/episodes"
    static let METHOD_SEARCH_EPISODES_BY_TAG = "search/episodes/by/tag"
    
    static let METHOD_EPISODE_OF_SHOW = "episodes/by/%@/%@"
    static let METHOD_USER_STORIES = "episodes/credits/%@"
    static let METHOD_TOPIC_EPISODES = "episodes/topic/%@"
    static let METHOD_EPISODE = "episode/%@"
    static let METHOD_SETTING = "site/config/settings/main-settings"
    
    static let METHOD_GET_COMMENTS = "comments/for/%@"
    
    static let METHOD_FOLLOW  = "user/follow"
    static let METHOD_UNFOLLOW  = "user/unfollow"
    
    static let METHOD_LIKE  = "episode/like"
    static let METHOD_UNLIKE  = "episode/unlike"
    
    static let METHOD_SUBSCRIBE = "audio/subscribe"
    static let METHOD_UNSUBSCRIBE  = "audio/unsubscribe"
    
    static let METHOD_ADD_REVIEW = "audio/add/review"
    static let METHOD_DELETE_REVIEW = "audio/delete/review"
    
    static let METHOD_ADD_COMMENT = "comment/add"
    static let METHOD_DELETE_COMMENT = "comment/delete"
    
    static let METHOD_UPLOAD_AVATAR = "avatar/upload"
    static let METHOD_UPLOAD_STORY = "audio/upload"

    static let METHOD_CATEGORIES  = "categories"
    static let METHOD_FORGET_PASS = "forgot/password"
    static let HEADER_AUTHORIZATION = "Authorization"
    
    static let METHOD_DETAIL_PODCAST = "podcast/catalog/id/%@"
    static let METHOD_DETAIL_AUDIOBOOK = "audiobook/catalog/id/%@"
    static let METHOD_DETAIL_EPISODE = "item/episode/catalog/id/%@"
    static let METHOD_DETAIL_STORY = "item/story/catalog/id/%@"
    static let METHOD_EDIT_PROFILE = "user"
    static let METHOD_SUBMIT_PODCAST = "audio/create"
    static let METHOD_LEADER_BOARD = "track/leaderboard"
    static let METHOD_SEARCH_SOCIAL = "search/social"
    
    static let METHOD_SEARCH_USERS = "search/user"
    
    public static func getUser(_ token: String, _ completion: @escaping (JamitResultModel?)->Void){
        let urlUserInfo = URL_API_ROOT + METHOD_GET_USER
        let httpHeaders: HTTPHeaders  = [HEADER_AUTHORIZATION: "Bearer "+token]
        JamitLog.logE("=======>getUser=\(urlUserInfo)")
        AF.request(urlUserInfo, method: .get,encoding: URLEncoding.default,headers: httpHeaders).responseData(completionHandler: { responce in
           if let data = responce.data {
                completion(parseJamResult(data, keyModel: "user", UserModel.self))
            }
            else{
                let resultModel = JamitResultModel(message: "Error", error: "Error Timeout")
                completion(resultModel)
            }
        })
    }
    
    public static func login(_ email: String, _ password: String, _ completion: @escaping (JamitResultModel?)->Void){
        let urlLogin = URL_API_ROOT + METHOD_LOGIN
        JamitLog.logE("=======>urlLogin=\(urlLogin)")
        let parameters = ["email":email,"password":password]
        postJson(url: urlLogin, parameters: parameters, keyModel: "user", classType: UserModel.self, completion: completion)
    }
    
    public static func editProfile(_ params: [String:Any], _ completion: @escaping (JamitResultModel?)->Void) {
        let url = URL_API_ROOT + METHOD_EDIT_PROFILE
        JamitLog.logE("=======>editProfile=\(url)")
        putJson(url: url, parameters: params, keyModel: "user", classType: UserModel.self, completion: completion)
    }
    
    public static func submitPodcast(_ params: [String:Any], _ completion: @escaping (JamitResponce?)->Void){
        let urlLogin = URL_API_ROOT + METHOD_SUBMIT_PODCAST
        JamitLog.logE("=======>urlLogin=\(urlLogin)")
        postJson(url: urlLogin, parameters: params, completion: completion)
    }
    
    public static func checkUser( _ completion: @escaping (CheckTokenModel?)->Void){
        let url = URL_API_ROOT + METHOD_CHECK_USER
        JamitLog.logE("=======>checkUser=\(url)")
        let parameters = buildUserParams()
        postJson(url: url, parameters: parameters, completion: completion)
    }
    
    public static func leaderBoard( _ completion: @escaping ([LeaderboardModel]?)->Void){
        let url = URL_API_ROOT + METHOD_LEADER_BOARD
        JamitLog.logE("=======>leaderboard=\(url)")
        postArrayJson(url: url, completion: completion)
    }
    
    public static func searchScreen(_ searchItem: String, _ completion: @escaping (SearchScreenModel?)->Void){
        let url = URL_API_ROOT + METHOD_SEARCH_SOCIAL
        JamitLog.logE("=======>searchScreen=\(url)")
        let params = ["query": searchItem, "token": SettingManager.getSetting(SettingManager.KEY_USER_TOKEN), "userID": SettingManager.getUserId()]
        postJson(url: url, parameters: params, completion: completion)
    }
    
    public static func signIn(_ username: String, _ email: String, _ password: String, _ completion: @escaping (JamitResultModel?)->Void){
        let urlLogin = URL_API_ROOT + METHOD_REGISTER
        JamitLog.logE("=======>signIn=\(urlLogin)")
        let parameters = ["email":email,"password":password,"username":username]
        postJson(url: urlLogin, parameters: parameters, keyModel: "user", classType: UserModel.self, completion: completion)
    }
    
    public static func playCount(_ episodeId: String, _ completion: @escaping (CountModel?)->Void){
        let url = URL_API_ROOT + String(format: METHOD_PLAY_COUNT, episodeId)
        JamitLog.logE("=======>playCount=\(url)")
        let parameters = ["userID":SettingManager.getUserId()]
        postJson(url: url, parameters: parameters, completion: completion)
    }
    
    public static func getRemoteSettings(_ completion: @escaping (SettingModel?)->Void) {
        let url = URL_API_ROOT + METHOD_SETTING
        JamitLog.logE("=======>getRemoteSettings=\(url)")
        getJson(url: url, completion: completion)
    }
    
    public static func getUserInfo(_ username: String,_ completion: @escaping (UserModel?)->Void) {
        let urlEncodeUserName = username.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? username
        let urlGetInfo = URL_API_ROOT + METHOD_GET_USER + urlEncodeUserName
        JamitLog.logE("=======>getUserInfo=\(urlGetInfo)")
        getJson(url: urlGetInfo, completion: completion)
    }
    
    public static func getUserFavEpisode(_ completion: @escaping ([EpisodeModel]?)->Void) {
        let urlFav = URL_API_ROOT + METHOD_GET_FAVORITES + SettingManager.getUserId()
        JamitLog.logE("=======>getUserFavEpisode=\(urlFav)")
        getArrayJson(url: urlFav, completion: completion)
    }
    
    public static func getFrndFavEpisode(_ frndId: String, _ completion: @escaping ([EpisodeModel]?)->Void) {
        let urlFav = URL_API_ROOT + METHOD_GET_FAVORITES + frndId
        JamitLog.logE("=======>getFrndFavEpisode=\(urlFav)")
        getArrayJson(url: urlFav, completion: completion)
    }
    
    public static func getTopicEpisode(_ topicId: String, _ completion: @escaping ([EpisodeModel]?)->Void) {
        let urlTopicEp = URL_API_ROOT + String(format: METHOD_TOPIC_EPISODES, topicId)
        JamitLog.logE("=======>getTopicEpisode=\(urlTopicEp)")
        getArrayJson(url: urlTopicEp, completion: completion)
    }
    
    public static func getTrendingUsers(_ completion: @escaping ([UserModel]?)->Void) {
        let urlFav = URL_API_ROOT + METHOD_TRENDING_USER
        JamitLog.logE("=======>getTrendingUsers=\(urlFav)")
        getArrayJson(url: urlFav, completion: completion)
    }
    
    public static func getFeaturedEpisodes(_ completion: @escaping ([EpisodeModel]?)->Void) {
        let urlFeaturedEp = URL_API_ROOT + String(format: METHOD_FEATURED_EPISODE, SettingManager.getUserId())
        JamitLog.logE("=======>getFeaturedEpisodes=\(urlFeaturedEp)")
        getArrayJson(url: urlFeaturedEp, completion: completion)
    }
    
    public static func getTopics(_ completion: @escaping ([TopicModel]?)->Void) {
        let urlTopic = URL_API_ROOT + METHOD_TOPIC
        JamitLog.logE("=======>getTopics=\(urlTopic)")
        getArrayJson(url: urlTopic, completion: completion)
    }
    
    public static func getAllLocales(_ completion: @escaping ([LocaleModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_LOCALE_LANS
        JamitLog.logE("=======>getAllLocales=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getJamItLocales(_ completion: @escaping (JamItLocaleModel?)->Void) {
        let url = URL_API_ROOT + METHOD_JAMIT_LOCALES
        JamitLog.logE("=======>getJamItLocales=\(url)")
        getJson(url: url, completion: completion)
    }
    
    public static func getJamItCountryLocales(_ completion: @escaping ([LocaleModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_LOCALE_COUNTRY
        JamitLog.logE("=======>getJamItLocales=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getFeaturedPodcast(_ completion: @escaping ([ShowModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_FEATURED_PODCAST
        JamitLog.logE("=======>getFeaturedPodcast=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getSeriesName(_ completion: @escaping ([SeriesModel]?)->Void) {
        let url = URL_API_ROOT + String(format: METHOD_SERIES_NAME, SettingManager.getUserId())
        JamitLog.logE("=======>getSeriesName=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getTrendingPodcast(_ completion: @escaping ([ShowModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_TRENDING_PODCAST
        JamitLog.logE("=======>getTrendingPodcast=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getFeaturedBanner(_ completion: @escaping ([ShowModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_FEATURED_BANNER
        JamitLog.logE("=======>getFeaturedBanner=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getSuggestStories(_ completion: @escaping ([EpisodeModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_STORIES_FOR_USER
        JamitLog.logE("=======>getSuggestStories=\(url)")
        let parameters = buildUserParams()
        postArrayJson(url: url,parameters: parameters, completion: completion)
    }
    
    public static func searchUsers(_ keyword: String, _ completion: @escaping ([UserModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_SEARCH_USERS
        JamitLog.logE("=======>searchUsers=\(url)")
        var parameters = buildUserParams()
        parameters["query"] = keyword
        postArrayJson(url: url,parameters: parameters, completion: completion)
    }
    
    public static func getFeaturedStories(_ completion: @escaping ([EpisodeModel]?)->Void) {
        let url = URL_API_ROOT + String(format: METHOD_FEATURED_STORY, SettingManager.getUserId())
        JamitLog.logE("=======>getFeaturedStories=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getUserStories(_ userId: String, _ completion: @escaping ([EpisodeModel]?)->Void) {
        let url = URL_API_ROOT + String(format: METHOD_USER_STORIES, userId)
        JamitLog.logE("=======>getUserStories=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func searchEpisode(_ query: String, _ isTag: Bool = false, _ completion: @escaping ([EpisodeModel]?)->Void) {
        let method = isTag ? METHOD_SEARCH_EPISODES_BY_TAG : METHOD_SEARCH_EPISODES
        let url = URL_API_ROOT + method
        JamitLog.logE("=======>searchEpisode=\(url)")
        var parameters = buildUserParams()
        parameters["query"] = query
        postArrayJson(url: url,parameters: parameters, completion: completion)
    }
    
    public static func getEpisodesOfShow(_ audioId: String, _ completion: @escaping ([EpisodeModel]?)->Void) {
        let url = URL_API_ROOT + String(format: METHOD_EPISODE_OF_SHOW, audioId, SettingManager.getUserId())
        JamitLog.logE("=======>getEpisodesOfShow=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getFeaturedAudioBooks(_ completion: @escaping ([ShowModel]?)->Void) {
        let url = URL_API_ROOT + METHOD_FEATURED_AUDIOBOOKS
        JamitLog.logE("=======>getFeaturedAudioBooks=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func getUserSubscriptions(_ completion: @escaping ([ShowModel]?)->Void) {
        let urlSub = URL_API_ROOT + METHOD_GET_AUDIO_SUBSCRIPTIONS
        let parameters = buildUserParams()
        JamitLog.logE("=======>getUserSubscriptions=\(urlSub)")
        postArrayJson(url: urlSub, parameters: parameters, completion: completion)
    }
    
    public static func getCategories(_ completion: @escaping ([CategoryModel]?)->Void) {
        let urlCat = URL_API_ROOT + METHOD_CATEGORIES
        JamitLog.logE("=======>getCategories=\(urlCat)")
        getArrayJson(url: urlCat, completion: completion)
    }
    
    public static func getShowOfCategory(_ slug: String, _ country: String, _ lan: String, _ completion: @escaping ([ShowModel]?)->Void) {
        let urlShowOfCat = URL_API_ROOT + String(format: METHOD_GET_SHOW_OF_CAT, slug,country,lan)
        JamitLog.logE("=======>getShowOfCategory=\(urlShowOfCat)")
        getArrayJson(url: urlShowOfCat, completion: completion)
    }
    
    public static func getSuggestUsers(_ userId: String, _ completion: @escaping ([UserModel]?)->Void) {
        let urlSuggest = URL_API_ROOT + String(format: METHOD_SUGGESTED_USER, userId)
        JamitLog.logE("=======>getSuggestUsers=\(urlSuggest)")
        getArrayJson(url: urlSuggest, completion: completion)
    }
    
    public static func getDetailShow(_ slug: String, _ completion: @escaping (ShowModel?)->Void) {
        let urlDetail = URL_API_ROOT + String(format: METHOD_DETAIL_SHOW, slug)
        JamitLog.logE("=======>getDetailShow=\(urlDetail)")
        getJson(url: urlDetail, completion:completion)
    }
    
    public static func getDetailDeeplinkShow(_ type: String, _ idForDeepLink: String, _ completion: @escaping (ShowModel?)->Void) {
        let method = type.elementsEqual(IJamitConstants.TYPE_DL_PODCAST) ? METHOD_DETAIL_PODCAST : METHOD_DETAIL_SHOW
        let urlDetail = URL_API_ROOT + String(format: method, idForDeepLink)
        JamitLog.logE("=======>getDetailDeeplinkShow=\(urlDetail)")
        getJson(url: urlDetail, completion: completion)
    }
    
    public static func getDetailDeeplinkEpisode(_ type: String, _ idForDeepLink: String, _ completion: @escaping (EpisodeModel?)->Void) {
        let method = type.elementsEqual(IJamitConstants.TYPE_DL_STORY) ? METHOD_DETAIL_STORY : METHOD_DETAIL_EPISODE
        let urlDetail = URL_API_ROOT + String(format: method, idForDeepLink)
        JamitLog.logE("=======>getDetailDeeplinkEpisode=\(urlDetail)")
        getJson(url: urlDetail, completion: completion)
    }

    
    public static func updateSubscribe(_ isSubscribe : Bool, _ audioId: String,_ completion: @escaping (ShowModel?)->Void){
        let urlSub = URL_API_ROOT + (isSubscribe ? METHOD_SUBSCRIBE : METHOD_UNSUBSCRIBE)
        JamitLog.logE("=======>updateSubscribe=\(urlSub)")
        var parameters = buildUserParams()
        parameters["audioID"] = audioId
        putJson(url: urlSub, parameters: parameters, completion: completion)
    }
    
    public static func updateFollow(_ isFollow : Bool, _ userId: String,_ completion: @escaping (UserModel?)->Void){
        let urlFollow = URL_API_ROOT + (isFollow ? METHOD_FOLLOW : METHOD_UNFOLLOW)
        JamitLog.logE("=======>updateFollow=\(urlFollow)")
        var parameters = buildUserParams()
        parameters[isFollow ? "followID" : "unfollowID"] = userId
        putJson(url: urlFollow, parameters: parameters, completion: completion)
    }
    
    public static func updateFavorite(_ isFav : Bool, _ episodeID: String,_ completion: @escaping (EpisodeModel?)->Void){
        let urlFavorite = URL_API_ROOT + (isFav ? METHOD_LIKE : METHOD_UNLIKE)
        JamitLog.logE("=======>urlFavorite=\(urlFavorite)")
        var parameters = buildUserParams()
        parameters["episodeID"] = episodeID
        putJson(url: urlFavorite, parameters: parameters, completion: completion)
    }
    
    public static func addReview(_ review: String, _ audioID: String ,_ completion: @escaping (ShowModel?)->Void){
        let url = URL_API_ROOT + METHOD_ADD_REVIEW
        JamitLog.logE("=======>addReview=\(url)")
        var parameters = buildUserParams()
        parameters["review"] = review
        parameters["audioID"] = audioID
        putJson(url: url, parameters: parameters, completion: completion)
    }
    
    public static func deleteReview(_ reviewID: String, _ audioID: String ,_ completion: @escaping (ReviewModel?)->Void){
        let url = URL_API_ROOT + METHOD_DELETE_REVIEW
        JamitLog.logE("=======>deleteReview=\(url)==>reviewID=\(reviewID)==>audioID=\(audioID)")
        var parameters = buildUserParams()
        parameters["reviewID"] = reviewID
        parameters["audioID"] = audioID
        deleteJson(url: url, parameters: parameters, completion: completion)
    }
    
    public static func getListComments(_ episodeID: String, _ completion: @escaping ([ReviewModel]?)->Void) {
        let url = URL_API_ROOT + String(format: METHOD_GET_COMMENTS, episodeID)
        JamitLog.logE("=======>getListComments=\(url)")
        getArrayJson(url: url, completion: completion)
    }
    
    public static func addComment(_ comment: String, _ audioID: String, _ episodeID: String ,_ completion: @escaping (JamitResponce?)->Void){
        let url = URL_API_ROOT + METHOD_ADD_COMMENT
        JamitLog.logE("=======>addComment=\(url)")
        var parameters = buildUserParams()
        parameters["comment"] = comment
        parameters["audioID"] = audioID
        parameters["episodeID"] = episodeID
        postJson(url: url, parameters: parameters, completion: completion)
    }
    
    public static func deleteComment(_ commentID: String, _ completion: @escaping (ReviewModel?)->Void){
        let url = URL_API_ROOT + METHOD_DELETE_COMMENT
        JamitLog.logE("=======>deleteComment=\(url)==>commentID=\(commentID)")
        var parameters = buildUserParams()
        parameters["id"] = commentID
        deleteJson(url: url, parameters: parameters, completion: completion)
    }
 
    public static func deleteStory(_ episodeId : String,_ completion: @escaping (JamitResponce?)->Void){
        let url = URL_API_ROOT + String(format: METHOD_EPISODE, episodeId)
        JamitLog.logE("=======>deleteStory=\(url)")
        let parameters = buildUserParams()
        deleteJson(url: url, parameters: parameters, completion: completion)
    }
    
    public static func buildUserParams() -> [String:Any] {
        let userId = SettingManager.getUserId()
        let token = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
        let parameters = ["userID":userId,"token":token]
        return parameters
    }
    
    public static func updatePremium(_ parameters: [String:Any],_ completion: @escaping (JamitResultModel?)->Void) {
        let urlPremium = URL_API_ROOT + METHOD_PREMIUM
        JamitLog.logE("=======>urlPremium=\(urlPremium)==>parameters=\(parameters)")
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(urlPremium, method: .put, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(parseJamResult(data, keyModel: "userData", UserModel.self))
            }
            else{
                let resultModel = JamitResultModel(message: "Error", error: "Error Timeout")
                completion(resultModel)
            }
        })
    }
    
    public static func resetPassword( _ email: String, _ completion: @escaping (JamitResultModel?)->Void){
        let urlResetPass = URL_API_ROOT + METHOD_FORGET_PASS
        JamitLog.logE("=======>resetPassword=\(urlResetPass)")
        let parameters = ["email":email]
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(urlResetPass, method: .put, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(parseJamResult(data, keyModel: "user", UserModel.self))
            }
            else{
                let resultModel = JamitResultModel(message: "Error", error: "Error Timeout")
                completion(resultModel)
            }
        })
    }
    
    public static func uploadImage(_ image: UIImage,_ fileName: String?, _ completion: @escaping (AvatarModel?)->Void) {
        guard let data = image.jpegData(compressionQuality: IJamitConstants.IMG_QUALITY) else {
            return completion(nil)
        }
        let url = URL_API_ROOT + METHOD_UPLOAD_AVATAR
        let params = buildUserParams()
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(data, withName: "file", fileName: fileName!,mimeType: "image/jpg")
        },to: url,usingThreshold: UInt64.init(), method: .put,fileManager: .default).response { response in
            if let data = response.data {
                completion(JsonParsingUtils.getModel(data))
            }
            else{
                completion(nil)
            }
                
        }
    }
    
    public static func uploadStory(_ file: URL, params: [String:Any],_ fileName: String, _ completion: @escaping (EpisodeModel?)->Void) {
        let url = URL_API_ROOT + METHOD_UPLOAD_STORY
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(file, withName: "file", fileName: fileName,mimeType: "audio/aac")
        },to: url,usingThreshold: UInt64.init(), method: .post,fileManager: .default).response { response in
            if let data = response.data {
                completion(JsonParsingUtils.getModel(data))
            }
            else{
                completion(nil)
            }
                
        }
    }
    
    public static func postArrayJson<T:JsonModel>(url: String,parameters: [String:Any]? = nil, completion: @escaping ([T]?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(JsonParsingUtils.getListModel(data))
            }
            else{
                completion(nil)
            }
        })
    }
    
    public static func postJson<T:JsonModel>(url: String,parameters: [String:Any], completion: @escaping (T?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(JsonParsingUtils.getModel(data))
            }
            else{
                completion(nil)
            }
        })
    }

    public static func deleteJson<T:JsonModel>(url: String,parameters: [String:Any],completion: @escaping (T?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .delete, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(JsonParsingUtils.getModel(data))
            }
            else{
                completion(nil)
            }
        })
    }
    
    public static func postJson(url: String,parameters: [String:Any],keyModel: String,classType: JsonModel.Type, completion: @escaping (JamitResultModel?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(parseJamResult(data, keyModel: keyModel, classType))
            }
            else{
                let resultModel = JamitResultModel(message: "Error", error: "Error Timeout")
                completion(resultModel)
            }
        })
    }
    
    public static func putJson<T:JamitResponce>(url: String,parameters: [String:Any], completion: @escaping (T?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .put, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(JsonParsingUtils.getModel(data))
            }
            else{
                completion(self.generateJamError())
            }
        })
    }
    
    public static func putJson(url: String,parameters: [String:Any], keyModel: String,classType: JsonModel.Type, completion: @escaping (JamitResultModel?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .put, parameters: parameters,encoding: JSONEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(parseJamResult(data, keyModel: keyModel, classType))
            }
            else{
                let resultModel = JamitResultModel(message: "Error", error: "Error Timeout")
                completion(resultModel)
            }
        })
    }

    
    public static func getJson<T:JamitResponce>(url: String, completion: @escaping (T?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .get, encoding:URLEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(JsonParsingUtils.getModel(data))
            }
            else{
                completion(self.generateJamError())
            }
        })
    }
   
    public static func getArrayJson<T:JsonModel>(url: String, completion: @escaping ([T]?)->Void ){
        AF.sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL
        AF.request(url, method: .get, encoding:URLEncoding.default).responseData(completionHandler: { responce in
            if let data = responce.data {
                completion(JsonParsingUtils.getListModel(data))
            }
            else{
                completion(nil)
            }
        })
    }
    
    private static func parseJamResult(_ dataJSON: Data, keyModel: String, _ classType: JsonModel.Type) -> JamitResultModel? {
        do {
            let json = try JSONSerialization.jsonObject(with: dataJSON, options: [])
            guard let dict = json as? [String: Any] else {
                return nil
            }
            let resultModel = JamitResultModel()
            resultModel.initFromDict(dict, keyModel, classType)
            return resultModel
        }
        catch  {
            JamitLog.logE("======>error when parsing json of resultmodel \(error)")
        }
        return nil
    }
    
    private static func generateJamError<T:JamitResponce>() -> T{
        let result = T.init()
        result.errorCode = -1
        result.message = "Error empty data"
        return result
    }
    
}
