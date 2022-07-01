//
//  PlayingLyricController.swift
//  iLandMusic
//
//  Created by jamit on 10/22/19.
//  Copyright © 2019 jamit. All rights reserved.
//

import Foundation
import UIKit
import TagListView

class PlayingInfoController: JamitRootViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var layoutStackContent: UIStackView!
    @IBOutlet weak var heightInfo: NSLayoutConstraint!
    
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var divider: UIView!
    
    let colorAccent = getColor(hex: ColorRes.color_accent)
    var fontDescription: UIFont!
    
    var parentVC: PlayingControler?
    
    override func setUpUI() {
        super.setUpUI()
        self.tvInfo.text  = ""
        self.lblNoData.text = getString(StringRes.title_no_description)
        
        self.fontDescription = UIFont.init(name: IJamitConstants.FONT_MEDIUM, size: DimenRes.text_size_play_info) ?? UIFont.systemFont(ofSize: DimenRes.text_size_play_info)
        
        self.updateInfo()
    }
 
    func updateInfo() {
        if self.tvInfo != nil {
            if let episodeModel = StreamManager.shared.currentModel{
                let lyric = episodeModel.description.trimmingCharacters(in: .whitespaces)
                if !lyric.isEmpty {
                    self.tvInfo.textContainer.lineFragmentPadding = 0
                    self.tvInfo.textContainerInset = .zero
                    self.tvInfo.isHidden = false
                    self.lblNoData.isHidden = true
                    self.tvInfo.setHtmlText(text: lyric, textColor: .white, font: fontDescription, linkColor: colorAccent)
                }
                else{
                    self.tvInfo.isHidden = true
                    self.lblNoData.isHidden = false
                }
                self.tagView.removeAllTags()
                let sizeTag = episodeModel.tags?.count ?? 0
                self.divider.isHidden = sizeTag <= 0
                self.tagView.isHidden = sizeTag <= 0
                if sizeTag > 0 {
                    for tag in episodeModel.tags! {
                        let tagView = self.tagView.addTag(tag)
                        tagView.textFont = self.fontDescription
                        tagView.onTap = { tagView in
                            self.searchTag(tag)
                        }
                    }
                }
            }
        }

    }
    func searchTag(_ tag: String){
        JamitLog.logE("====>onClick tag=\(tag)")
        self.parentVC?.goToSearchTag(tag)
    }
}
