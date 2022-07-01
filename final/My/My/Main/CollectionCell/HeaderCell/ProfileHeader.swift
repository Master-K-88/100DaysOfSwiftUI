//
//  ProfileHeader.swift
//  jamit
//
//  Created by Do Trung Bao on 4/13/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileDelegate {
    func goToMyStories()
    func goToSocialPage(_ type: Int)
    func goToMyHighLight()
    func goToEditProfile()
    func updateLikeSelection()
    func updateShortSelection()
    func updateEventSelected()
    func followUser(_ user: UserModel)
    func goToUserEvents(_ user: UserModel)
}
//protocol AvatarDelegate {
//    func changeAvatar()
//}

class ProfileHeader: UICollectionReusableView {
    
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var layoutAvatar: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblTvMemberInfo: UILabel!
    @IBOutlet weak var imgMember: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var layoutAction: UIView!
    var shortSelected: Bool!
    var likesSelected: Bool!
    var eventSelected: Bool!
    @IBOutlet weak var shortsBtn: UIButton!
    @IBOutlet weak var likesBtn: UIButton!
    @IBOutlet weak var likeIndicator: UIView!
    @IBOutlet weak var shortIndicator: UIView!
    @IBOutlet weak var eventIndicator: UIView!
    @IBOutlet weak var eventBtn: UIButton!
    @IBOutlet weak var btnFollowing: UILabel!
    @IBOutlet weak var btnFollower: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var followerTap: UIButton!
    @IBOutlet weak var followingTap: UIButton!
    
    var delegate: ProfileDelegate?
    var parentVC: JamitRootViewController?
    var avatarDelegate: AvatarDelegate?
    var user: UserModel?
    var colorMain: UIColor!
    var numStory: Int?
    
    override func awakeFromNib() {
        self.shortSelected = true
        self.likesSelected = false
        self.eventSelected = false
        eventBtn.isHidden = true
        eventIndicator.isHidden = true
        if let user = user {
            updateUIHeader(user)
        }
        colorMain = getColor(hex: ColorRes.tab_text_focus_color)
        shortIndicator.backgroundColor = colorMain
        shortsBtn.tintColor = colorMain
        
    }
    
    func updateAvatar(_ image: UIImage?){
        self.imgAvatar.image = image
    }
    
    func updateUIHeader(_ user: UserModel?) {
        let isLogin = SettingManager.isLoginOK()
//        self.user = user
        
        self.layoutAvatar.cornerRadius = self.layoutAvatar.frame.size.width / CGFloat(2)
        self.imgAvatar.cornerRadius = self.imgAvatar.frame.size.width / CGFloat(2)
        
        if isLogin {
            let avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
            if avatar.starts(with: "https") {
                self.imgAvatar.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            }
            else {
                self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
            }
            var displayName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            if displayName.isEmpty || displayName.elementsEqual(getString(StringRes.null_value)) {
                displayName = SettingManager.getSetting(SettingManager.KEY_USER_EMAIL)
            }
            
            let firstName = SettingManager.getSetting(SettingManager.KEY_FIRST_NAME)
            let lastName = SettingManager.getSetting(SettingManager.KEY_LAST_NAME)
            let bio = SettingManager.getSetting(SettingManager.KEY_ABOUT_USER)
            
            self.fullNameLbl.text = "\(firstName) \(lastName)"
            self.lblUserName.text = " @\(displayName)"
            self.bioLbl.text = bio
            let index = MemberShipManager.shared.getMemberIndex()
            self.lblTvMemberInfo.isHidden = index < 0
            if index >= 0 {
                self.imgMember.image = UIImage(named: ImageRes.img_members[index])
                self.lblTvMemberInfo.text = getString(StringRes.info_premium_member)
            }
            layoutAction.isHidden = false
        }
        else {
            self.isHidden = true
        }
        self.updateInfo(user: user)
    }
    
    // Setting it up for friends controller
    func setUpInfo(_ user: UserModel?, _ numStories: Int ) {
        self.numStory = numStories
        
        self.layoutAvatar.cornerRadius = self.layoutAvatar.frame.size.width / CGFloat(2)
        self.imgAvatar.cornerRadius = self.imgAvatar.frame.size.width / CGFloat(2)
        
        if user != nil {
            self.user = user
            self.lblUserName.text = "@\(user!.username)"
//            let numStory =  StringUtils.formatNumberSocial(StringRes.format_story, StringRes.format_stories, Int64(numStories))
//            let shortText = numStory.suffix(1) == "s" ? "Shorts \(numStory.prefix(numStory.count - 6))" : "Short \(numStory.prefix(numStory.count - 5))"
            if let fName = user?.firstName, let lName = user?.lastName {
                    self.fullNameLbl.text = "\(fName) \(lName)"
            } else {
                self.fullNameLbl.isHidden = true
            }
            if let frnBio = user?.bio {
                self.bioLbl.text = "\(frnBio)"
            }
            if shortSelected {
                shortsBtn.setTitle("Shorts", for: .normal)
            } else {
                shortsBtn.setTitle("Shorts", for: .normal)
            }
            
            let imgUrl: String = user!.avatar
            if imgUrl.starts(with: "http") {
                self.imgAvatar.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            }
            else {
                self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
            }
            let isFollow = user?.isFollowerUser(SettingManager.getUserId()) ?? false
            self.updateFollow(isFollow)
            
//            let setting = TotalDataManager.shared.getSetting()
//            let isSupport = setting?.isTipSupport ?? false
//            let tipUrlEmpty = user?.tipSupportUrl.isEmpty ?? true
//            let showTip = isSupport && !tipUrlEmpty
//            self.btnSupport.isHidden = !showTip
            
        }
    }
    
    // Update user follow for the friends controller
    func updateFollow(_ isFollow : Bool) {
        let followBtnText = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
        DispatchQueue.main.async {
            self.editProfileBtn.setTitle("    \(followBtnText)", for: .normal)
            self.editProfileBtn.setImage(UIImage(named: isFollow ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp), for: .normal)
            self.editProfileBtn.backgroundColor = isFollow ? .black/*UIColor.clear*/ : getColor(hex: ColorRes.subscribe_color)
            self.editProfileBtn.borderColor = isFollow ? .white : UIColor.clear
            self.editProfileBtn.borderWidth = CGFloat(isFollow ? 1 : 0)
        }
        
//
//        //update following, follower
        let numberFollower = self.user?.followers?.count ?? 0
        let numberFollowing = self.user?.following?.count ?? 0
        if numberFollower > 0 || numberFollowing > 0 {
            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
            DispatchQueue.main.async {
                self.btnFollower.text = String(strFollower.prefix(strFollower.count - 9))
                self.btnFollowing.text = String(strFollowing.prefix(strFollowing.count - 9))
                self.followerTap.isUserInteractionEnabled = false
                self.followingTap.isUserInteractionEnabled = false
            }
            
        }
    }
    
    @IBAction func followingTap(_ sender: Any) {
        self.delegate?.goToSocialPage(IJamitConstants.TYPE_FOLLOWING)
    }
    
    
    @IBAction func followerTap(_ sender: Any) {
        self.delegate?.goToSocialPage(IJamitConstants.TYPE_FOLLOWER)
    }
    
    fileprivate func shortSelection() {
        shortSelected = true
        shortIndicator.backgroundColor = colorMain
        shortsBtn.tintColor = colorMain
        self.delegate?.updateShortSelection()
    }
    
    fileprivate func likeSelection() {
        likesSelected = true
        likeIndicator.backgroundColor = colorMain
        likesBtn.tintColor = colorMain
        self.delegate?.updateLikeSelection()
    }
    
    fileprivate func eventSelection() {
        eventSelected = true
        eventIndicator.backgroundColor = colorMain
        eventBtn.tintColor = colorMain
        if self.user != nil {
            self.delegate?.updateEventSelected()
        }
    }
    
    func myLikes() {
        if shortSelected == true || eventSelected == true {
            shortSelected = false
            eventSelected = false
            shortIndicator.backgroundColor = .clear
            shortsBtn.tintColor = .white
            eventIndicator.backgroundColor = .clear
            eventBtn.tintColor = .white
            likeSelection()
        } else {
            likeSelection()
        }
    }
    
    func myEvent() {
        if shortSelected == true || likesSelected == true {
            shortSelected = false
            likesSelected = false
            shortIndicator.backgroundColor = .clear
            shortsBtn.tintColor = .white
            likeIndicator.backgroundColor = .clear
            likesBtn.tintColor = .white
            eventSelection()
        } else {
            eventSelection()
        }
    }
    func myShorts() {
        if likesSelected == true || eventSelected == true {
            likesSelected = false
            likeIndicator.backgroundColor = .clear
            likesBtn.tintColor = .white
            eventSelected = false
            eventIndicator.backgroundColor = .clear
            eventBtn.tintColor = .white
            shortSelection()
        } else {
            shortSelection()
        }
    }
    
    @IBAction func myLikes(_ sender: Any) {
        myLikes()
    }
    
    @IBAction func eventBtnTapped(_ sender: Any) {
        myEvent()
    }
    
    @IBAction func myShorts(_ sender: Any) {
        myShorts()
    }
    
    @IBAction func instagramBtnTapped(_ sender: Any) {
    }
    @IBAction func twitterBtnTapped(_ sender: Any) {
    }
    
    // Update follow for user profile
    private func updateInfo(user: UserModel?){
        let numberFollower = user?.followers?.count ?? 0
        let numberFollowing = user?.following?.count ?? 0
        if (numberFollower > 0 || numberFollowing > 0) {
            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
            btnFollower.text = String(strFollower.prefix(strFollower.count - 9))
            btnFollowing.text = String(strFollowing.prefix(strFollowing.count - 9))
        }
    }
    
    @IBAction func changePicsTap(_ sender: Any) {
            self.avatarDelegate?.changeAvatar()
    }
    
    @IBAction func editUserProfile() {
        if editProfileBtn.title(for: .normal) == "Edit Profile" {
            self.delegate?.goToEditProfile()
        } else {
            if self.user != nil {
                self.delegate?.followUser(user!)
            }
        }
        
    }
}
