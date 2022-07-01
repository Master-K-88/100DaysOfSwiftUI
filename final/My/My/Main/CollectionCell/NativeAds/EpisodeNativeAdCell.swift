//
//  EpisodeNativeAdCell.swift
//  jamit
//
//  Created by YPY Global on 4/9/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit
//import GoogleMobileAds

class EpisodeNativeAdCell: UICollectionViewCell {
    
    let NIB_NATIVE_ADS_CELL = "UnifiedNativeAdView"
    
    @IBOutlet weak var placeHolderContainer: UIView!
    
    var collectionView: UICollectionView?
    
    private var heightConstraint : NSLayoutConstraint?
    
    private var adUnitID: String = TotalDataManager.shared.getNativeId()
//    private var nativeAdView: GADNativeAdView?
    
    private var model: EpisodeModel?
    var parentVC : UIViewController!
    
    func setUpAds(_ model: EpisodeModel?) {
        self.model = model
//        if let nativeAd = self.model?.nativeAd {
//            self.adLoader(self.model!.adLoader!, didReceive: nativeAd)
//        }
//        else{
//            self.loadAds()
//        }
    }

//    private func loadAds() {
//        if ApplicationUtils.isOnline() && self.model != nil && self.model!.adLoader == nil {
//            let adLoader = GADAdLoader(adUnitID: self.adUnitID, rootViewController: self.parentVC, adTypes: [ .native ], options: nil)
//            adLoader.delegate = self
//            self.model?.adLoader = adLoader
//            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [IJamitConstants.ADMOB_TEST_ID]
//            adLoader.load(GADRequest())
//        }
//    }
    
}

//extension EpisodeNativeAdCell : GADVideoControllerDelegate {
//    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
//        JamitLog.logE("=====>Video playback has ended.")
//    }
//}

//extension EpisodeNativeAdCell : GADAdLoaderDelegate {
//
//    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
//        JamitLog.logE("===========>native ads \(adLoader) failed with error: \(error.localizedDescription)")
//        self.model?.isAdError = true
//        self.collectionView?.collectionViewLayout.invalidateLayout()
//
//    }
//    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
//
//    }
//
//}

//extension EpisodeNativeAdCell : GADNativeAdLoaderDelegate {
//
//    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
//        // Create and place ad in view hierarchy.
//        self.model?.nativeAd = nativeAd
//        self.renderAds(nativeAd)
//    }
//
//    func renderAds(_ nativeAd: GADNativeAd){
//        let nibView = Bundle.main.loadNibNamed(NIB_NATIVE_ADS_CELL, owner: nil, options: nil)?.first
//        guard let nativeAdView = nibView as? GADNativeAdView else {
//            return
//        }
//        self.setAdView(nativeAdView)
//        self.nativeAdView?.nativeAd = nativeAd
//        // Deactivate the height constraint that was set when the previous video ad loaded.
//        self.heightConstraint?.isActive = false
//
//        // Populate the native ad view with the native ad assets.
//        // The headline and mediaContent are guaranteed to be present in every native ad.
//        (self.nativeAdView?.headlineView as? UILabel)?.text = nativeAd.headline
//        self.nativeAdView?.mediaView?.mediaContent = nativeAd.mediaContent
//
//        // Some native ads will include a video asset, while others do not. Apps can use the
//        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
//        // UI accordingly.
//        let mediaContent = nativeAd.mediaContent
//        if mediaContent.hasVideoContent {
//            // By acting as the delegate to the GADVideoController, this ViewController receives messages
//            // about events in the video lifecycle.
//            mediaContent.videoController.delegate = self
//            JamitLog.logE("Ad contains a video asset.")
//        }
//
//        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
//        // ratio of the media it displays.
//        if let mediaView = self.nativeAdView?.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
//            heightConstraint = NSLayoutConstraint(item: mediaView,
//                                                  attribute: .height,
//                                                  relatedBy: .equal,
//                                                  toItem: mediaView,
//                                                  attribute: .width,
//                                                  multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
//                                                  constant: 0)
//            heightConstraint?.isActive = true
//        }
//
//        // These assets are not guaranteed to be present. Check that they are before
//        // showing or hiding them.
//        (self.nativeAdView?.bodyView as? UILabel)?.text = nativeAd.body ?? ""
//        self.nativeAdView?.bodyView?.isHidden = nativeAd.body == nil
//
//        (self.nativeAdView?.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
//        self.nativeAdView?.callToActionView?.isHidden = nativeAd.callToAction == nil
//
//        (self.nativeAdView?.iconView as? UIImageView)?.image = nativeAd.icon?.image
//        self.nativeAdView?.iconView?.isHidden = nativeAd.icon == nil
//
//        (self.nativeAdView?.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd.starRating)
//        self.nativeAdView?.starRatingView?.isHidden = nativeAd.starRating == nil
//
//        (self.nativeAdView?.storeView as? UILabel)?.text = nativeAd.store ?? ""
//        self.nativeAdView?.storeView?.isHidden = nativeAd.store == nil
//
//        (self.nativeAdView?.priceView as? UILabel)?.text = nativeAd.price ?? ""
//        self.nativeAdView?.priceView?.isHidden = nativeAd.price == nil
//
//        (self.nativeAdView?.advertiserView as? UILabel)?.text = nativeAd.advertiser ?? ""
//        self.nativeAdView?.advertiserView?.isHidden = nativeAd.advertiser == nil
//
//        // In order for the SDK to process touch events properly, user interaction should be disabled.
//        self.nativeAdView?.callToActionView?.isUserInteractionEnabled = false
//    }
//
//    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
//        guard let rating = starRating?.doubleValue else {
//            return nil
//        }
//        if rating >= 5 {
//            return UIImage(named: "stars_5")
//        }
//        else if rating >= 4.5 {
//            return UIImage(named: "stars_4_5")
//        }
//        else if rating >= 4 {
//            return UIImage(named: "stars_4")
//        }
//        else if rating >= 3.5 {
//            return UIImage(named: "stars_3_5")
//        }
//        return nil
//    }
//
//    private func setAdView(_ view: GADNativeAdView) {
//        // Remove the previous ad view.
//        if self.nativeAdView != nil {
//            self.nativeAdView?.removeFromSuperview()
//        }
//        self.nativeAdView = view
//        self.placeHolderContainer.addSubview(self.nativeAdView!)
//        self.nativeAdView!.translatesAutoresizingMaskIntoConstraints = false
//
//        // Layout constraints for positioning the native ad view to stretch the entire width and height
//        // of the nativeAdPlaceholder.
//        let viewDictionary = ["_nativeAdView": nativeAdView!]
//        self.placeHolderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
//                                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
//        self.placeHolderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
//                                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
//    }
//
//
//}
