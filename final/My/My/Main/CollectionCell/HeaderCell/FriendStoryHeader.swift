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

protocol FriendStoryDelegate {
    func followUser(_ user: UserModel)
    func goToUserEvents(_ user: UserModel)
    func goToSocialPage(_ user: UserModel, _ type: Int)
}

class FriendStoryHeader: UICollectionReusableView {
    
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var btnFollow: UIView!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var imgFollow: UIImageView!
    
    @IBOutlet weak var lblUserName: MarqueeLabel!
    @IBOutlet weak var lblNumStory: UILabel!
    @IBOutlet weak var layoutNumFollow: UIView!
    @IBOutlet weak var btnFollower: UIButton!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnSupport: UIView!
    
    private var user: UserModel?
    
    var delegate: FriendStoryDelegate?
    var parentVC: JamitRootViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpInfo(_ user: UserModel?, _ numStories: Int ) {
        if user != nil {
            self.user = user
            self.lblUserName.text = user!.username
            self.lblNumStory.text =  StringUtils.formatNumberSocial(StringRes.format_story, StringRes.format_stories, Int64(numStories))
            let imgUrl: String = user!.avatar
            if imgUrl.starts(with: "http") {
                self.imgAvatar.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            }
            else {
                self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
            }
            let isFollow = user?.isFollowerUser(SettingManager.getUserId()) ?? false
            self.updateFollow(isFollow)
            
            let setting = TotalDataManager.shared.getSetting()
            let isSupport = setting?.isTipSupport ?? false
            let tipUrlEmpty = user?.tipSupportUrl.isEmpty ?? true
            let showTip = isSupport && !tipUrlEmpty
            self.btnSupport.isHidden = !showTip
            
        }
    }
    
    func updateFollow(_ isFollow : Bool) {
        self.lblFollow.text = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
        self.imgFollow.image = UIImage(named: isFollow ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp)
        self.btnFollow.backgroundColor = isFollow ? UIColor.clear : getColor(hex: ColorRes.subscribe_color)
        self.btnFollow.borderColor = isFollow ? .white : UIColor.clear
        self.btnFollow.borderWidth = CGFloat(isFollow ? 1 : 0)
        
        //update following, follower
        let numberFollower = self.user?.followers?.count ?? 0
        let numberFollowing = self.user?.following?.count ?? 0
        if numberFollower > 0 || numberFollowing > 0 {
            self.layoutNumFollow.isHidden = false
            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
            self.btnFollower.setTitle(strFollower, for: .normal)
            self.btnFollowing.setTitle(strFollowing, for: .normal)
        }
        else{
            self.layoutNumFollow.isHidden = true
        }
    }
    
    @IBAction func followTap(_ sender: Any) {
        if self.user != nil {
            self.delegate?.followUser(self.user!)
        }
    }
    
    @IBAction func listFollowingTap(_ sender: Any) {
        if self.user != nil {
            self.delegate?.goToSocialPage(self.user!,IJamitConstants.TYPE_FOLLOWING)
        }
    }
    
    @IBAction func listFollowerTap(_ sender: Any) {
        if self.user != nil {
            self.delegate?.goToSocialPage(self.user!, IJamitConstants.TYPE_FOLLOWER)
        }
    }
    
    @IBAction func supportTap(_ sender: Any) {
        if let tipSupportUrl = self.user?.tipSupportUrl {
            JamitLog.logE("======>user.tipSupportUrl=\(tipSupportUrl)")
            self.parentVC?.showAlertWithResId(
                titleId: StringRes.title_creator_support,
                messageId: StringRes.info_confirm_support,
                positiveId: StringRes.title_continue,
                negativeId: StringRes.title_cancel,
                completion: {
                    if !tipSupportUrl.isEmpty && tipSupportUrl.starts(with: "http") {
                        ShareActionUtils.goToURL(linkUrl: tipSupportUrl)
                    }
                })
        }
    }
    
    @IBAction func userEventTap(_ sender: Any) {
        if self.user != nil {
            self.delegate?.goToUserEvents(self.user!)
        }
    }
}
