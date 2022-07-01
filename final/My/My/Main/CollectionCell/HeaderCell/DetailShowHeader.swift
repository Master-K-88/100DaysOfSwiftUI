//
//  DetailShowHeader.swift
//  jamit
//
//  Created by Do Trung Bao on 4/9/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel

protocol DetailShowHeaderDelegate {
    func onSubscribe(_ show: ShowModel)
    func shareShow(_ show: ShowModel, _ view: UIView)
    func goToInfo(_ show: ShowModel)
    func goToReview(_ show: ShowModel)
    func goToSupport(_ show: ShowModel)
}
class DetailShowHeader: UICollectionReusableView {
    
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgShow: UIImageView!

    @IBOutlet weak var lblSubcribe: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgSubcribe: UIImageView!
    @IBOutlet weak var lblTitleShow: MarqueeLabel!
    @IBOutlet weak var lblAuthor: MarqueeLabel!
    @IBOutlet weak var lblNumEpisode: UILabel!
    
    @IBOutlet weak var btnSupport: UIView!
    @IBOutlet weak var btnSubcribe: UIView!
    private var show: ShowModel?
    
    var headerDelegate: DetailShowHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpInfo(_ show: ShowModel?, _ numEpisodes: Int ) {
        if show != nil {
            self.show = show
            self.lblTitleShow.text = show!.title
            let author = !show!.author.isEmpty ? show!.author : getString(StringRes.app_name)
            self.lblAuthor.text = String(format: getString(StringRes.format_with), author)
            self.lblNumEpisode.text =  StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(numEpisodes))
            
            self.lblDescription.setHtmlString(show!.summary.shorted(to: 140))
            let imgUrl: String = show!.imageUrl
            if imgUrl.starts(with: "http") {
                self.imgShow.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_default))
            }
            else {
                self.imgShow.image = UIImage(named: ImageRes.img_default)
            }
            let isSubscibre = show?.isSubscribed(SettingManager.getUserId()) ?? false
            self.updateSubscribe(isSubscibre)
            
            self.lblSupport.text = getString(StringRes.title_support)
            let setting = TotalDataManager.shared.getSetting()
            let isSupport = setting?.isTipSupport ?? false
            let tipUrlEmpty = show?.tipSupportUrl.isEmpty ?? true
            let showTip = isSupport && !tipUrlEmpty
            self.btnSupport.isHidden = !showTip
        }
    }
    
    func updateSubscribe(_ isSubscibre : Bool) {
        self.lblSubcribe.text = getString(isSubscibre ? StringRes.title_subscribed : StringRes.title_subscribe)
        self.imgSubcribe.image = UIImage(named: isSubscibre ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp)
        self.btnSubcribe.backgroundColor = isSubscibre ? UIColor.clear : getColor(hex: ColorRes.subscribe_color)
        self.btnSubcribe.borderColor = isSubscibre ? UIColor.white : UIColor.clear
        self.btnSubcribe.borderWidth = CGFloat(isSubscibre ? 1 : 0)
    }
    
    @IBAction func shareTap(_ sender: Any) {
        if self.show != nil {
            self.headerDelegate?.shareShow(self.show!,self.btnShare)
        }
    }
    
    @IBAction func subscribeTap(_ sender: Any) {
        if self.show != nil {
            self.headerDelegate?.onSubscribe(self.show!)
        }
        
    }
    
    @IBAction func infoTap(_ sender: Any) {
        if self.show != nil {
            self.headerDelegate?.goToInfo(self.show!)
        }
    }
    
    @IBAction func supportTap(_ sender: Any) {
        if self.show != nil {
            self.headerDelegate?.goToSupport(self.show!)
        }
    }
    
    @IBAction func chatTap(_ sender: Any) {
        if self.show != nil {
            self.headerDelegate?.goToReview(self.show!)
        }
    }
}
