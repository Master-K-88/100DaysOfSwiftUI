//
//  ShowInfoController.swift
//  jamit
//
//  Created by Do Trung Bao on 8/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel

class ShowInfoController: ParentViewController {
    
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var lblTitleShow: MarqueeLabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblNumEpisode: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    
    var show: ShowModel?
    
    let colorText  = getColor(hex: ColorRes.play_color_text)
    let font = UIFont(name: IJamitConstants.FONT_NORMAL, size: DimenRes.text_size_body) ?? UIFont.systemFont(ofSize: DimenRes.text_size_body)
    let style = NSMutableParagraphStyle()
    
    override func setUpUI() {
        super.setUpUI()
      
        self.lblAuthor.text = self.show != nil && !self.show!.author.isEmpty ? self.show!.author : getString(StringRes.app_name)
        self.lblTitleShow.text = self.show?.title ?? ""
        self.lblNumEpisode.text =  StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(show?.numEpisodes ?? 0))
        
        let des = self.show?.description ?? ""
        
        self.tvDescription.setHtmlText(text: des, textColor: self.colorText, font: self.font, style: self.style, linkColor: .white)
        
        let imgUrl: String = show!.imageUrl
        if imgUrl.starts(with: "http") {
            self.imgShow.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_default))
        }
        else {
            self.imgShow.image = UIImage(named: ImageRes.img_default)
        }
        
    }
    
    @IBAction func shareTap(_ sender: Any) {
        if let show = self.show {
            self.shareWithDeepLink(show,self.btnShare)
        }
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.dismissDetail()
    }
}
