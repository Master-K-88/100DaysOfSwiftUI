//
//  userInfoController.swift
//  jamit
//
//  Created by Prof K on 3/17/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit
import SwiftUI

class UserInfoController: JamitRootViewController {

    // Overall container view
    private let userInfoStack: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Topmost view
    private let userInfoBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Following and follower bg view
    private let userFollowBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // User Description BF=G view
    private let userDescrBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Final view for sharing and tiping creators
    private let userShareBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Unseen view
    private let otherBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Topmost stack view for arranging the collection
    private let userDetailStack: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.spacing = 17
        view.axis = .horizontal
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Image bg view
    private let userImageBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Middle view of the topmost view for the username and usertype
    private let userNameBGView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Follow button BG view
    private let btnUserFollowBGView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // User image view
    private let imgUser: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: ImageRes.ic_circle_avatar_default)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // User detail view for user name and type
    private let userDetailBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userDetailView: UIStackView = {
        let view = UIStackView()
        view.spacing = 7
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .leading
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblUserName: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont(name: "Poppins-SemiBold", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblUserType: PaddingUILabel = {
        let label = PaddingUILabel()
        label.text = "Creator"
        label.font = UIFont(name: "Poppins-Regular", size: 9)
        label.paddingLeft = 10
        label.paddingRight = 10
        label.paddingTop = 5
        label.paddingBottom = 5
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textColor = .white
        label.backgroundColor = .link
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let btnBGView: UIView = {
        let view = UIView()
        view.cornerRadius = 10
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollow: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
//        button.setTitleColor(getColor(hex: "#"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Follower and Following stack view
    
    private let followStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let followersView: UIView = {
        let view = UIView()
        view.cornerRadius = 12
        view.backgroundColor = getColor(hex: ColorRes.color_accent)
//        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollower: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let followerContentStack: UIStackView = {
        let view = UIStackView()
        view.spacing = -10
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillProportionally
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblNumFollower: UILabel = {
       let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblFollower: UILabel = {
       let label = UILabel()
        label.text = "Followers"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingView: UIView = {
        let view = UIView()
        view.cornerRadius = 12
        view.backgroundColor = getColor(hex: ColorRes.color_accent)
//        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollowing: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let followingContentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblNumFollowing: UILabel = {
       let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblFollowing: UILabel = {
       let label = UILabel()
        label.text = "Following"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // User description view
    
    private let descrText: UILabel = {
        let textView = UILabel()
        textView.text = "Short description of the user"
        textView.textAlignment = .justified
        textView.contentMode = .top
        textView.textColor = .white
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let lblWebsiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Website: https://"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblWebsite: UILabel = {
        let label = UILabel()
        label.text = "jamitfm.com"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStacks: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 11
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shareBGView: UIView = {
        let view = UIView()
        view.cornerRadius = 10
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnShare: UIButton = {
        let button = UIButton()
        button.tintColor = .white
//        button.backgroundColor = .black
//        button.setImage(, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imgShare: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_send")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tipCreatorView: UIView = {
        let view = UIView()
        view.cornerRadius = 10
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnTipCreator: UIButton = {
        let button = UIButton()
        button.tintColor = .white
//        button.backgroundColor = .black
//        button.setImage(UIImage(named: "ic_tip"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imgTipCreator: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_tip")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let moreInfoBGView: UIView = {
        let view = UIView()
        view.cornerRadius = 10
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnMoreInfo: UIButton = {
        let button = UIButton()
        button.tintColor = .white
//        button.backgroundColor = .black
//        button.setImage(UIImage(named: "ic_more_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imgMoreInfo: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.image = UIImage(named: "ic_more_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var dismissDelegate: DismissDelegate?
    var parentVC: MainController?
    var friendVC: NewUserProfileController?
    var user: UserModel?
    var viewModel: ProfileViewModel?
    var isLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listeners()
        view.backgroundColor = getColor(hex: "#201D21")
        view.layer.cornerRadius = 35
        
        setupView()
        isLogin = NavigationManager.shared.checkLogin(currentVC: self.parentVC,parentVC: self.parentVC)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        setupView()
        
        imgUser.cornerRadius = userImageBGView.frame.width * 0.5
        imgUser.clipsToBounds = true
        userImageBGView.cornerRadius = userImageBGView.frame.width * 0.5
        btnFollow.cornerRadius = 10
        
        btnFollow.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
        btnShare.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        btnTipCreator.addTarget(self, action: #selector(tipCreatorTapped), for: .touchUpInside)
        btnMoreInfo.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        btnFollowing.addTarget(self, action: #selector(goToFollowing), for: .touchUpInside)
        btnFollower.addTarget(self, action: #selector(goToFollower), for: .touchUpInside)
        
    }
    
    private func listeners() {
        viewModel?.userModelCompletion = {
            DispatchQueue.main.async {
                self.user = self.viewModel?.userModel
                self.configureView()
            }
        }
        
    }
    
    @objc private func followTapped() {
        guard let user = user else {
            return
        }
        followUser(user)
    }
    
    @objc private func shareTapped() {
        print("Share button tapped")
    }
    
    @objc private func tipCreatorTapped() {
        print("Tip creator tapped")
        dismissDelegate?.dismiss(controller: self)
        if let parentVC = parentVC {
            print("The wallet system is tapped")
            NavigationManager.shared.gotoWalletSystem(self)
        }
    }
    
    @objc private func moreTapped() {
        print("More tapped")
        gotoFullProfile()
    }
    
    func updateFollow(_ isFollow : Bool) {
        let followBtnText = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
        DispatchQueue.main.async {
            self.btnFollow.setTitle(followBtnText, for: .normal)
//            self.btnLabel.text = "\(followBtnText)"
//            self.btnImage.image = UIImage(named: isFollow ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp)
            self.btnFollow.backgroundColor = isFollow ? .black/*UIColor.clear*/ : getColor(hex: ColorRes.subscribe_color)
            self.btnFollow.borderColor = isFollow ? .white : UIColor.clear
            self.btnFollow.borderWidth = CGFloat(isFollow ? 1 : 0)
        }
        
//
//        //update following, follower
        let numberFollower = self.user?.followers?.count ?? 0
        let numberFollowing = self.user?.following?.count ?? 0
        if numberFollower > 0 || numberFollowing > 0 {
            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
            DispatchQueue.main.async {
                self.lblNumFollower.text = String(strFollower.prefix(strFollower.count - 9))
                self.lblNumFollowing.text = String(strFollowing.prefix(strFollowing.count - 9))
//                self.followerTap.isUserInteractionEnabled = false
//                self.followingTap.isUserInteractionEnabled = false
            }
            
        }
    }
    
    
    func followUser(_ user: UserModel) {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.parentVC,parentVC: self.parentVC)
        if isLogin { return }
        if !ApplicationUtils.isOnline() {
            self.parentVC?.showToast(with: StringRes.info_lose_internet)
            return
        }
        self.parentVC?.showProgress()
        let userId = SettingManager.getUserId()
        let isNewFollow = !user.isFollowerUser(userId)
        JamItPodCastApi.updateFollow(isNewFollow, user.userID) { (result) in
            self.parentVC?.dismissProgress()
            if let newUser = result {
                if newUser.isResultOk() {
                    user.followers = newUser.followers
                    user.following = newUser.following
                    self.parentVC?.showToast(withResId: isNewFollow ? StringRes.info_follow_successfully: StringRes.info_unfollow_successfully)
                    self.updateFollow(isNewFollow)
//                    self.currentVC.parentVC?.profileVC?.isStartLoadData = false
//                    self.currentVC.parentVC?.profileVC?.startLoadData()
                }
                else{
                    let msg = !newUser.message.isEmpty ?  newUser.message : getString(StringRes.info_server_error)
                    self.parentVC?.showToast(with: msg)
                }
             }
        }
    }
    
    private func setupView() {
        view.addSubview(userInfoStack)
        userInfoStack.pin(to: view, top: 24, left: 20, bottom: 0, right: -24)
        
        userInfoStack.addArrangedSubview(userInfoBGView)
        userInfoStack.addArrangedSubview(userFollowBGView)
        userInfoStack.addArrangedSubview(userDescrBGView)
        userInfoStack.addArrangedSubview(userShareBGView)
        userInfoStack.addArrangedSubview(otherBGView)
        
        userInfoBGView.addSubview(userDetailStack)
        userDetailStack.addArrangedSubview(userImageBGView)
        
        userImageBGView.addSubview(imgUser)
        imgUser.pin(to: userImageBGView)
        
        userDetailStack.addArrangedSubview(userDetailBGView)
        userDetailBGView.addSubview(userDetailView)
        userDetailView.pin(to: userDetailBGView)
        userDetailView.addArrangedSubview(lblUserName)
        userDetailView.addArrangedSubview(lblUserType)
        
        userDetailStack.addArrangedSubview(btnBGView)
        btnBGView.addSubview(btnFollow)
        btnFollow.pin(to: btnBGView)
        
        userFollowBGView.addSubview(followStack)
        followStack.pin(to: userFollowBGView)
        
        followStack.addArrangedSubview(followersView)
        followersView.addSubview(followerContentStack)
        followersView.addSubview(btnFollower)
        btnFollower.pin(to: followersView)
//        followerContentStack.pin(to: followersView)
        followerContentStack.pin(to: followersView, top: 10, left: 0, bottom: -10, right: 0)
        
        followerContentStack.addArrangedSubview(lblNumFollower)
        followerContentStack.addArrangedSubview(lblFollower)
        
        followStack.addArrangedSubview(followingView)
        followingView.addSubview(followingContentStack)
        followingContentStack.pin(to: followingView, top: 10, left: 0, bottom: -10, right: 0)
        followingView.addSubview(btnFollowing)
        btnFollowing.pin(to: followingView)
        followingContentStack.addArrangedSubview(lblNumFollowing)
        followingContentStack.addArrangedSubview(lblFollowing)
        
        userDescrBGView.addSubview(descrText)
        descrText.pin(to: userDescrBGView, top: 0, left: 0, bottom: nil, right: 0)
        userDescrBGView.addSubview(lblWebsiteLabel)
        userDescrBGView.addSubview(lblWebsite)
//        userDescrBGView.addSubview(descrText)
        
        userShareBGView.addSubview(buttonStacks)
        buttonStacks.pin(to: userShareBGView)
        
        buttonStacks.addArrangedSubview(shareBGView)
        buttonStacks.addArrangedSubview(tipCreatorView)
        buttonStacks.addArrangedSubview(moreInfoBGView)
        
        shareBGView.addSubview(imgShare)
        imgShare.pin(to: shareBGView, top: 10, left: 10, bottom: -10, right: -10)
//        imgShare.pin(to: shareBGView)
        shareBGView.addSubview(btnShare)
        btnShare.pin(to: shareBGView)
        
        tipCreatorView.addSubview(imgTipCreator)
        imgTipCreator.pin(to: tipCreatorView, top: 10, left: 10, bottom: -10, right: -10)
        tipCreatorView.addSubview(btnTipCreator)
        btnTipCreator.pin(to: tipCreatorView)
        
        moreInfoBGView.addSubview(imgMoreInfo)
        imgMoreInfo.pin(to: moreInfoBGView, top: 10, left: 10, bottom: -10, right: -10)
        moreInfoBGView.addSubview(btnMoreInfo)
        btnMoreInfo.pin(to: moreInfoBGView)
//
        
//        buttonStacks.addArrangedSubview(btnShare)
//        buttonStacks.addArrangedSubview(btnTipCreator)
//        buttonStacks.addArrangedSubview(btnMoreInfo)
//        buttonStacks
        
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            userInfoBGView.heightAnchor.constraint(equalToConstant: 72),
            userFollowBGView.heightAnchor.constraint(equalToConstant: 73),
            userDescrBGView.heightAnchor.constraint(equalToConstant: 95),
            userShareBGView.heightAnchor.constraint(equalToConstant: 54),
            otherBGView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            userDetailStack.heightAnchor.constraint(equalToConstant: 72),
            userDetailBGView.widthAnchor.constraint(equalToConstant: 180),
            userDetailBGView.heightAnchor.constraint(equalTo: userDetailStack.heightAnchor, multiplier: 0.8),
            
            userImageBGView.heightAnchor.constraint(equalTo: userDetailStack.heightAnchor, multiplier: 1.0),
            userImageBGView.widthAnchor.constraint(equalToConstant: 72),
            
            btnBGView.widthAnchor.constraint(equalToConstant: 96),
            btnBGView.heightAnchor.constraint(equalToConstant: 48),
            
            lblWebsiteLabel.leadingAnchor.constraint(equalTo: userDescrBGView.leadingAnchor),
            lblWebsiteLabel.bottomAnchor.constraint(equalTo: userDescrBGView.bottomAnchor, constant: -5),
            
            lblWebsite.leadingAnchor.constraint(equalTo: lblWebsiteLabel.trailingAnchor, constant: 10),
            lblWebsite.bottomAnchor.constraint(equalTo: lblWebsiteLabel.bottomAnchor),
            
//            descrText.topAnchor.constraint(equalTo: userDescrBGView.topAnchor, constant: 5),
//            descrText.leadingAnchor.constraint(equalTo: userDetailView.leadingAnchor, constant: 0),
//            descrText.trailingAnchor.constraint(equalTo: userDescrBGView.trailingAnchor, constant: 0),
            
//            lblFollower.heightAnchor.constraint(equalToConstant: 25),
//            lblNumFollower.heightAnchor.constraint(equalToConstant: 25),
            
            
        ])
    }
    
    @objc func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            goBackHome()
        }
        else if gesture.direction == .up {
//            self.headerView?.myLikes()
            gotoFullProfile()
        }
    }
    
    @objc private func goToFollower() {
        NavigationManager.shared.goToSocialPage(IJamitConstants.TYPE_FOLLOWER, currentVC: self)
    }
    
    @objc private func goToFollowing() {
        NavigationManager.shared.goToSocialPage(IJamitConstants.TYPE_FOLLOWING, currentVC: self)
    }
    
    private func goBackHome() {
        self.view.removeFromSuperview()
        if #available(iOS 13.0, *) {
            self.dismissDelegate?.dismiss(controller: self)
        }
        else{
            self.dismissDelegate?.dismiss(controller: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func gotoFullProfile() {
        self.friendVC = NewUserProfileController.create(IJamitConstants.STORYBOARD_STORY) as? NewUserProfileController
        self.friendVC?.typeVC = IJamitConstants.TYPE_VC_USER_STORIES
        self.friendVC?.itemDelegate = self.parentVC
//                            self.friendVC?.menuDelegate = self.parentVC?.menuDelegate
        self.friendVC?.parentVC = self.parentVC
        self.friendVC?.userModel = user
//                            self.friendVC?.isAllowRefresh = true
//                            self.friendVC?.isShowHeader = true
        self.friendVC?.dismissDelegate = self.parentVC
//                            self.friendVC?.isAllowAddObserver = true
        self.parentVC?.addControllerOnContainer(controller: self.friendVC!)

    }
    private func configureView() {
        guard let user = user else {
            return
        }
        let userId = SettingManager.getUserId()
        let isNewFollow = user.isFollowerUser(userId)
        print("The expected answer is true but it is \(isNewFollow)")
        
        DispatchQueue.main.async {
            self.updateFollow(isNewFollow)
            self.lblUserName.text = user.username.capitalized
            self.lblUserType.text = user.subscriptionType == "free" ? "User" : "Creator"
            self.lblNumFollower.text = "\(user.followers?.count ?? 0)"
            self.lblNumFollowing.text = "\(user.following?.count ?? 0)"
         self.descrText.text = user.bio.shorted(to: 140)
            self.imgUser.kf.setImage(with: URL(string: user.avatar), placeholder: UIImage(named: ImageRes.img_default))
        }
        
    }
    
//    @objc func removeUserProfile() {
//        self.view.removeFromSuperview()
//    }

}
