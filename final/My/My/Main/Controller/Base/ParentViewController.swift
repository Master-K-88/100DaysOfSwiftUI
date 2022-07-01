//
//  ParentViewController.swift
//  Created by YPY Global on 4/10/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit
//import GoogleMobileAds
import MediaPlayer
//import FirebaseDynamicLinks

class ParentViewController: JamitRootViewController {
        
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
        
//    var admobInterstitial: GADInterstitialAd?
    var counting :Int = 0
    
    var totalDataMng = TotalDataManager.shared
    var appConfigure: ConfigModel?
    
    var widgetInfoMetadata = [String : Any]()
    
    let audioSession = AVAudioSession.sharedInstance()
    
    private var isAddedDeepLinkObserver = false
    var msgId: String?
    
    override func setUpUI() {
        super.setUpUI()
        self.processLeftRight()
    }
    
    override func setUpData() {
        super.setUpData()
        self.appConfigure = totalDataMng.appConfigure
        if ApplicationUtils.isOnline() {
            self.onDoWhenNetworkOn()
        }
        self.registerObserverNetworkChange(networkDelegate: self)
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //show message
        if self.msgId != nil {
            self.showToast(withResId: self.msgId!)
            self.msgId = nil
        }

        // register event when remoting music in the lock screen
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
  
    
    func onDoWhenNetworkOn() {
        setUpIntertestialAds()
    }
    
    func onDoWhenNetworkOff() {
        print("Network is off")
        DispatchQueue.main.async {
            self.showAlertWith(title: "Network Issue", message: "Check your network connection", positive: nil, negative: nil, completion: nil, cancel: .none)
        }
        
    }
    
    func startMusicAction (_ action: PlayerAction){
        StreamManager.shared.startMusicAction(action: action)
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event != nil{
            switch event!.subtype {
            case .remoteControlPlay:
                startMusicAction(PlayerAction.TogglePlay)
                break
            case .remoteControlPause:
                startMusicAction(PlayerAction.Pause)
                break
            case .remoteControlStop:
                startMusicAction(PlayerAction.Stop)
                break
            case .remoteControlPreviousTrack:
                startMusicAction(PlayerAction.Previous)
                break
            case .remoteControlNextTrack:
                startMusicAction(PlayerAction.Next)
                break
            default:
                break
            }
        }
    }
    
    func setUpIntertestialAds(){
        if !ApplicationUtils.isOnline() || self.appConfigure == nil || self.appConfigure!.interstitialId.isEmpty{
            return
        }
//        if IJamitConstants.SHOW_ADS {
//            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [IJamitConstants.ADMOB_TEST_ID]
//            let request = GADRequest()
//            GADInterstitialAd.load(withAdUnitID: self.appConfigure!.interstitialId, request: request) { ads, error in
//                if let error = error {
//                    JamitLog.logE("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                    return
//                }
//                self.admobInterstitial = ads
//                self.admobInterstitial?.fullScreenContentDelegate = self
//            }
//        }
        
    }
    
    func checkShowPopup() -> Bool{
        if IJamitConstants.SHOW_ADS {
//            if admobInterstitial != nil  {
//                self.admobInterstitial?.present(fromRootViewController: self)
//                return true
//            }
        }
        return false
    }
    
    func updateInfoForIOSMusicWidget(){
        let currentRadio = StreamManager.shared.currentModel
        if currentRadio != nil {
            let artwork = UIImage(named: ImageRes.img_default)
            widgetInfoMetadata[MPMediaItemPropertyTitle] = currentRadio!.title
            widgetInfoMetadata[MPMediaItemPropertyArtist] = !currentRadio!.getAuthor().isEmpty ?  currentRadio!.getAuthor() : getString(StringRes.app_name)
            widgetInfoMetadata[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: CGSize(width: DimenRes.size_image_music_widget, height: DimenRes.size_image_music_widget)) { size in
                    return artwork!
            }
            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = widgetInfoMetadata
        }
        
    }
    func onInterstitialAdClose() {
//        self.admobInterstitial = nil
    }
    
    func registerDeeplinkObserver() {
        if !self.isAddedDeepLinkObserver {
            self.isAddedDeepLinkObserver = true
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(receiveDeepLink), name: NSNotification.Name(rawValue: IJamitConstants.BROADCAST_DEEP_LINK), object: nil)
        }
    }
    
    func unregisterDeeplinkObserver() {
        if self.isAddedDeepLinkObserver {
            self.isAddedDeepLinkObserver = false
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: NSNotification.Name(rawValue: IJamitConstants.BROADCAST_DEEP_LINK), object: nil)
        }
    }
    
    @objc private func receiveDeepLink() {
        JamitLog.logD("======>onReceiveDeepLink")
        self.onReceiveDeepLink()
    }
    
    func onReceiveDeepLink() {
        
    }
    
    func shareWithDeepLink(_ model: JamitResponce, _ pivotView: UIView? = nil, _ callback: (() -> Void)? = nil) {
        let oldLink = model.urlDynamicLink
        JamitLog.logD("========>oldLink=\(oldLink)")
        if !oldLink.isEmpty {
            self.shareModel(model,pivotView)
            return
        }
//        if let linkBuilder = self.createBuilder(model) {
//            self.showProgress()
////            linkBuilder.options = DynamicLinkComponentsOptions()
////            linkBuilder.options?.pathLength = .short
//            linkBuilder.shorten() { url, warnings, error in
//                self.dismissProgress()
//                if url == nil || error != nil {
//                    JamitLog.logE("========>error deeplink: \(String(describing: error))")
//                    self.showToast(withResId: StringRes.info_error_deep_link)
//                    return
//                }
//                JamitLog.logE("========>The deep link short URL is: \(String(describing: url))")
//                model.urlDynamicLink = url?.absoluteString ?? ""
//                if !model.urlDynamicLink.isEmpty {
//                    self.shareModel(model,pivotView)
//                }
//            }
//            return
//        }
        self.showToast(withResId: StringRes.info_error_deep_link)
    }

    private func shareModel(_ model: JamitResponce, _ pivotView: UIView? = nil){
        let msg = model.getShareStr()
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        self.shareContent(msg, nil, isPad ? pivotView : nil)
    }
    
    func tweetToTwitter(_ model: EpisodeModel){
        var tweetMsg: String!
        if !model.isTypeEvent() {
            let msg = model.title
            var author = model.getAuthor()
            if author.isEmpty {
                author = getString(StringRes.app_name)
            }
            let formatShare = getString(StringRes.info_tweet_share)
            let appName = getString(StringRes.app_name)
            tweetMsg = StringUtils.urlEncodeString(String(format: formatShare,msg, author,appName)) ?? ""
        }
        else{
            tweetMsg = model.title
        }
        var urlApp = model.urlDynamicLink
        if urlApp.isEmpty {
            urlApp = String.init(format: ShareActionUtils.FORMAT_SHARE_APP_URL, IJamitConstants.APP_ID)
        }
        let tweetUrl = "https://twitter.com/intent/tweet?text=" + tweetMsg + "&url=" + urlApp
        JamitLog.logE("====>shareTwitterUrl=\(tweetUrl)")
        ShareActionUtils.goToURL(linkUrl: tweetUrl)
        
    }
    
//    func createBuilder(_ model: JamitResponce) -> DynamicLinkComponents? {
//        let openLink = model.buildUrlOpenLink() ?? ""
//        JamitLog.logE("========>openLink: \(openLink)")
//        if openLink.isEmpty { return nil}
//        var title = model.buildDynamicTitleLink() ?? ""
//        if title.isEmpty {
//            title = getString(StringRes.title_social_tag_deep_link)
//        }
//        var des = model.buildDynamicDesLink() ?? ""
//        if des.isEmpty {
//            des = getString(StringRes.info_social_tag_deep_link)
//        }
//        let img = model.buildDynamicImageLink()
//        guard let link = URL(string: openLink) else { return nil }
//        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: IJamitConstants.URL_DYNAMIC_LINK)
//        let iOSPkg = Bundle.main.bundleIdentifier!
//        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: iOSPkg)
//        linkBuilder?.iOSParameters?.appStoreID = IJamitConstants.APP_ID
//        linkBuilder?.iOSParameters?.minimumAppVersion = IJamitConstants.IOS_MININUM_APP_VERSION
//        linkBuilder?.iOSParameters?.fallbackURL = URL(string: openLink)
//
//        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: IJamitConstants.ANDROID_PACKAGE_NAME)
//        linkBuilder?.androidParameters?.minimumVersion = IJamitConstants.ANDROID_MININUM_VERSION_CODE
//        linkBuilder?.androidParameters?.fallbackURL = URL(string: openLink)
//
//        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        linkBuilder?.socialMetaTagParameters?.title = title
//        linkBuilder?.socialMetaTagParameters?.descriptionText = des
//        linkBuilder?.socialMetaTagParameters?.imageURL = URL(string: img)
//        return linkBuilder
//    }
    
    func showDialogConfirm(_ resource: ConfirmResource, _ delegate: ConfirmDelegate) {
        let dialogVC = DialogConfirmController.create(IJamitConstants.STORYBOARD_DIALOG) as! DialogConfirmController
        dialogVC.resource = resource
        dialogVC.delegate = delegate
        self.present(dialogVC, animated: false, completion: nil)
    }
    
}

extension ParentViewController: NetworkDelegate{
    func onNetworkState(_ isConnect: Bool) {
        if isConnect {
            onDoWhenNetworkOn()
        }
        else {
            onDoWhenNetworkOff()
        }
    }
}

//Delegate for admob ads
//extension ParentViewController : GADFullScreenContentDelegate{
//        
//    // Tells the delegate that the ad failed to present full screen content.
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("ADBMOB interstitial ERROR:didFailToPresentFullScreenContentWithError: \(error.localizedDescription)")
//        onInterstitialAdClose()
//    }
//    
//    /// Tells the delegate that the ad presented full screen content.
//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        JamitLog.logE("Ad did present full screen content.")
//    }
//    
//    /// Tells the delegate that the ad dismissed full screen content.
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        JamitLog.logE("===>Ad did dismiss full screen content.")
//        onInterstitialAdClose()
//        setUpIntertestialAds()
//    }
//}

