//
//  RadioFlatListCell.swift
//  Created by YPY Global on 12/21/18.
//  Copyright © 2018 YPY Global. All rights reserved.
//

import UIKit
import MarqueeLabel

class EpisodeStoryFlatListCell: EpisodeFlatListCell {
    
    @IBOutlet weak var btnFolow: UIButton!
    @IBOutlet weak var imgAvatarSize: NSLayoutConstraint!
    
    @IBOutlet weak var durationView: UIStackView!
    @IBOutlet weak var likeView: UIStackView!
    @IBOutlet weak var commentView: UIStackView!
    @IBOutlet weak var lblNumLike: UILabel!
    @IBOutlet weak var lblNumComment: UILabel!
    
    let smallFontSize = UIFont(name: IJamitConstants.FONT_NORMAL, size: DimenRes.tab_font_size) ?? UIFont.systemFont(ofSize: DimenRes.tab_font_size)
    let normalFontSize = UIFont(name: IJamitConstants.FONT_NORMAL, size: DimenRes.text_size_time) ?? UIFont.systemFont(ofSize: DimenRes.text_size_time)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnFolow.setTitle(getString(StringRes.title_follow), for: .normal)
    }
    
    override func updateUI(_ episode: EpisodeModel) {
        if self.isUserStories {
            self.imgAvatarSize.constant = CGFloat(64)
            self.img.cornerRadius = CGFloat(32)
            self.img.layoutIfNeeded()
            self.btnFolow.isHidden = true
        }
        let numberLikes = Int64(episode.likes?.count ?? 0)
        let numberComments = episode.getCommentCount()
        self.lblNumLike.text = StringUtils.formatNumberSocial(StringRes.format_like, StringRes.format_likes, numberLikes)
        self.lblNumComment.text = StringUtils.formatNumberSocial(StringRes.format_comment, StringRes.format_comments, numberComments)
        self.likeView.isHidden = numberLikes <= 0
        self.commentView.isHidden = numberComments <= 0
        self.durationView.isHidden = numberLikes > 0 || numberComments > 0
        self.lblCreatedData.font = self.durationView.isHidden ? smallFontSize : normalFontSize
        super.updateUI(episode)
    }
    
    @IBAction func followTap(_ sender: Any) {
        self.menuDelegate?.onFollowTap(episode)
    }
}

