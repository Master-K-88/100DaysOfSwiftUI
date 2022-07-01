//
//  RecordingController.swift
//  jamit
//
//  Created by Prof K on 3/26/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewUserProfileController: JamitRootViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.backgroundColor = .black
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Four main views
    
    //MARK: First main view is user info view
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // stackView for the first view
    
    private let userInfoContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.backgroundColor = .clear
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 20
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: ImageRes.img_default)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let lblUserType: UILabel = {
        let label = UILabel()
        label.text = "Creator"
        label.textColor = .white
        label.backgroundColor = .link
        label.textAlignment = .center
        label.sizeToFit()
        label.cornerRadius = 2.5
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblUsername: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblUserBio: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .gray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userInfoContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 30
        view.distribution = .fillEqually
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let followingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollowing: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lblNumFollowing: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblFollowing: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollower: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lblNumFollower: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblFollower: UILabel = {
        let label = UILabel()
        label.text = "Follower"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblNumLikes: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblLikes: UILabel = {
        let label = UILabel()
        label.text = "Likes"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: Second main view is contactView
    private let contactView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userContactView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fillProportionally
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnFollowUser: UIButton = {
        let button = UIButton()
        button.backgroundColor = getColor(hex: "#EC0B65")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "plus.square")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let btnLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let btnWalletView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgWallet: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_card")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let btnWallet: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgMessage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_mail")
//        imageView.tintColor = getColor(hex: "#FFAE29")
        imageView.tintColor = .white
//        imageView.image?.withTintColor(getColor(hex: "#FFAE29"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let btnMessage: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    private let btnFollowLabel: UILabel = {
        let label = UILabel()
        label.text = "Follow"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: Third main view is userContentView
    private let userContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnUserContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fillEqually
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnShort: UIButton = {
        let button = UIButton()
        button.cornerRadius = 8
        button.setTitle("Shorts", for: .normal)
        button.backgroundColor = getColor(hex: "#1B1C1F")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnFav: UIButton = {
        let button = UIButton()
        button.cornerRadius = 8
        button.setTitle("Likes", for: .normal)
        button.backgroundColor = getColor(hex: "#1B1C1F")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnRooms: UIButton = {
        let button = UIButton()
        button.cornerRadius = 8
        button.setTitle("Rooms", for: .normal)
        button.backgroundColor = getColor(hex: "#1B1C1F")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: Fourth main view is collectionView
    private let collectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var loginMsg: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lblNoData: UILabel = {
        let label = UILabel()
        label.text = "No Data Found"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dismissDelegate: DismissDelegate?
    var parentVC: MainController?
    var userModel: UserModel?
    var itemDelegate: AppItemDelegate?
    var avatarDelegate: AvatarDelegate?
    var typeVC: Int = 0
    private var avatarWidth: CGFloat = 0.0
    
//    var typeVC: Int = 0
    var isAllowRefresh = true
    var isAllowLoadMore = false
    var isOfflineData = false
    var isShowHeader = false
    
    var menuDelegate: MenuEpisodeDelegate?
    
    var isTab = false
    var isFirstTab = false
    var isAllowReadCache = false
    var isReadCacheWhenNoData = false
    var isAllowAddObserver = false
    
    private var shortSelected: Bool = true
    private var likesSelected: Bool = false
    private var roomsSelected: Bool = false
    
    private var shortsCollectionView: UICollectionView?
    private var likesCollectionView: UICollectionView?
    private var roomsCollectionView: UICollectionView?
    
    var userStories: [EpisodeModel]?
    var userFav: [EpisodeModel]?
    
    
    private let myPickerController = UIImagePickerController()
    private var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        getUserInfo()
        view.backgroundColor = .black
//        setupView()
        
        lblTitle.isHidden = true
        btnShort.addTarget(self, action: #selector(btnShortTapped(_:)), for: .touchUpInside)
        btnFav.addTarget(self, action: #selector(btnFavTapped(_:)), for: .touchUpInside)
        btnRooms.addTarget(self, action: #selector(btnRoomsTapped(_:)), for: .touchUpInside)
        btnFollowUser.addTarget(self, action: #selector(updateTapped(_:)), for: .touchUpInside)
        btnFollower.addTarget(self, action: #selector(goToFollower), for: .touchUpInside)
        btnFollowing.addTarget(self, action: #selector(goToFollowing), for: .touchUpInside)
        btnWallet.addTarget(self, action: #selector(goToWallet), for: .touchUpInside)
        
        
    }
    
    @objc private func goToWallet() {
        print("The wallet system is tapped")
        if let parentVC = parentVC {
            NavigationManager.shared.gotoWalletSystem(self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
//        configureView()
//        clearButton()
        shortTapped()
        parentVC?.episodeCellViewModel.reloadHomeCells = {
            DispatchQueue.main.async {
                self.likesCollectionView?.reloadData()
                self.shortsCollectionView?.reloadData()
            }
        }
//        headerView.isHidden = true
        btnShort.backgroundColor = getColor(hex: "#FFAE29")
        btnShort.setTitleColor(.black, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 5, right: 20)
        collectionLayout.minimumInteritemSpacing = 10.0
        collectionLayout.minimumLineSpacing = 10.0
        collectionLayout.scrollDirection = .vertical
        
        if shortSelected {
            shortsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            guard let shortsCollectionView = shortsCollectionView else {
                return
            }

            shortsCollectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
            collectionView.addSubview(shortsCollectionView)
            shortsCollectionView.frame = collectionView.bounds
            shortsCollectionView.backgroundColor = .black

            shortsCollectionView.dataSource = self
            shortsCollectionView.delegate = self
        }
        
        if likesSelected {
            likesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            guard let likesCollectionView = likesCollectionView else {
                return
            }

            likesCollectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
            collectionView.addSubview(likesCollectionView)
            likesCollectionView.frame = collectionView.bounds
            likesCollectionView.backgroundColor = .black
            
            likesCollectionView.dataSource = self
            likesCollectionView.delegate = self
        }
        
        if roomsSelected {
            roomsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            
            guard let roomsCollectionView = roomsCollectionView else {
                return
            }

            roomsCollectionView.register(NewEventCell.self, forCellWithReuseIdentifier: NewEventCell.identifier)
            collectionView.addSubview(roomsCollectionView)
            roomsCollectionView.frame = collectionView.bounds
            roomsCollectionView.backgroundColor = .black
            
            roomsCollectionView.delegate = self
            roomsCollectionView.dataSource = self
        }
        
    }
    
    private func getUserInfo() {
        guard let userName = userModel?.username,
        let userID = userModel?.userID else {
            return
        }
        
        let isFollow = userModel?.isFollowerUser(SettingManager.getUserId()) ?? false
        self.updateFollow(isFollow)
        
        if SettingManager.isLoginOK() && ApplicationUtils.isOnline() {
            JamItPodCastApi.getUserInfo(userName) { (result) in
                self.userModel = result
                DispatchQueue.main.async {
                    self.lblUserBio.text = "\(result?.bio.shorted(to: 140) ?? "")"
                    self.lblUsername.text = "\(result?.username ?? "")"
                    if let numFollower = result?.followers?.count,
                       let numFollowing = result?.following?.count {
                        if numFollower >  1 {
                            self.lblFollower.text = "Followers"
                        }
                        self.lblNumFollower.text = "\(numFollower)"
                        self.lblNumFollowing.text = "\(numFollowing)"
                    }
                    guard let result = result else {
                        return
                    }
                    
                    self.userImageView.kf.setImage(with: URL(string: result.avatar), placeholder: UIImage(named: ImageRes.img_default))
                }
            }
            
            JamItPodCastApi.getUserStories(userID) { (list) in
                self.userStories = list
            }
            
            
            JamItPodCastApi.getFrndFavEpisode(userID) { (list) in
                self.userFav = list
                let size = list?.count ?? 0
                if size > 0 {
                    for model in list! {
                        model.likes = [userID]
                    }
                    DispatchQueue.main.async {
                        self.lblNumLikes.text = "\(size)"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.likesCollectionView?.isHidden = true
                        self.lblNoData.isHidden = false
                        let msgIdFormat = StringRes.friend_no_like
                        let uname = self.userModel?.username ?? ""
                        let msg = String(format: getString(msgIdFormat), uname, uname)
                        self.lblNoData.text = msg
                        
                    }
                }
                return
            }
        }
        
    }
    
    func updateFollow(_ isFollow : Bool) {
        let followBtnText = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
        DispatchQueue.main.async {
            self.btnLabel.text = "\(followBtnText)"
            self.btnImage.image = UIImage(named: isFollow ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp)
            self.btnFollowUser.backgroundColor = isFollow ? .black/*UIColor.clear*/ : getColor(hex: ColorRes.subscribe_color)
            self.btnFollowUser.borderColor = isFollow ? .white : UIColor.clear
            self.btnFollowUser.borderWidth = CGFloat(isFollow ? 1 : 0)
        }
        
//
//        //update following, follower
        let numberFollower = self.userModel?.followers?.count ?? 0
        let numberFollowing = self.userModel?.following?.count ?? 0
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
    
    fileprivate func shortTapped() {
        clearButton()
        clearSelection()
        shortSelected = true
        shortsCollectionView?.reloadData()
        btnShort.backgroundColor = getColor(hex: "#FFAE29")
        btnShort.setTitleColor(.black, for: .normal)
    }
    
    @objc private func btnShortTapped(_ sender: UIButton) {
        shortTapped()
    }
    
    @objc private func btnFavTapped(_ sender: UIButton) {
        clearButton()
        clearSelection()
        likesSelected = true
        likesCollectionView?.reloadData()
        btnFav.backgroundColor = getColor(hex: "#FFAE29")
        btnFav.setTitleColor(.black, for: .normal)
    }
    
    @objc private func btnRoomsTapped(_ sender: UIButton) {
        clearButton()
        clearSelection()
        roomsSelected = true
        roomsCollectionView?.reloadData()
        btnRooms.backgroundColor = getColor(hex: "#FFAE29")
        btnRooms.setTitleColor(.black, for: .normal)
    }
    
    @objc private func updateTapped(_ sender: UIButton) {
        guard let userModel = userModel else {
            return
        }
        followUser(userModel)
        
    }
    
    private func setupView() {
        view.addSubview(mainView)
        mainView.pin(to: view, top: 54, left: 0, bottom: 0, right: 0)
        mainView.addSubview(scrollView)
        scrollView.pin(to: mainView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.pin(to: scrollView)
        
        // Adding the four subView
        scrollViewContainer.addArrangedSubview(infoView)
        scrollViewContainer.addArrangedSubview(contactView)
        scrollViewContainer.addArrangedSubview(userContentView)
        scrollViewContainer.addArrangedSubview(collectionView)
        
        collectionView.addSubview(lblNoData)
        
        // sub content of the first view
        
        infoView.addSubview(userInfoContainer)
        userInfoContainer.addArrangedSubview(userImageView)
        userInfoContainer.addArrangedSubview(lblUserType)
        
        infoView.addSubview(lblUsername)
        infoView.addSubview(lblUserBio)
        
        infoView.addSubview(userInfoContentView)
        userInfoContentView.addArrangedSubview(followingView)
        userInfoContentView.addArrangedSubview(followerView)
        userInfoContentView.addArrangedSubview(likeView)
        
        followingView.addSubview(lblNumFollowing)
        followingView.addSubview(lblFollowing)
        followingView.addSubview(btnFollowing)
        btnFollowing.pin(to: followingView)
        
        followerView.addSubview(lblNumFollower)
        followerView.addSubview(lblFollower)
        followerView.addSubview(btnFollower)
        btnFollower.pin(to: followerView)
        
        likeView.addSubview(lblNumLikes)
        likeView.addSubview(lblLikes)
        
        // end of the content first view
        
        // sub content for the second view
        contactView.addSubview(userContactView)
        userContactView.pin(to: contactView, top: 0, left: 20, bottom: 0, right: -20)
        userContactView.addArrangedSubview(btnFollowView)
        btnFollowView.addSubview(btnFollowUser)
        btnFollowUser.pin(to: btnFollowView)
        
        btnFollowView.addSubview(btnImage)
        btnFollowView.addSubview(btnLabel)
        
//        btnFollowUser.frame = btnFollowView.bounds
        userContactView.addArrangedSubview(btnWalletView)
        btnWalletView.addSubview(imgWallet)
        imgWallet.pin(to: btnWalletView, top: 15, left: 15, bottom: -15, right: -15)
        btnWalletView.addSubview(btnWallet)
        btnWallet.pin(to: btnWalletView)
        
        btnMessageView.addSubview(imgMessage)
        imgMessage.pin(to: btnMessageView, top: 15, left: 15, bottom: -15, right: -15)
        btnMessageView.addSubview(btnMessage)
        btnMessage.pin(to: btnMessageView)
//        imgWallet.clipsToBounds = true
        userContactView.addArrangedSubview(btnMessageView)
//        btnWalletView
        // end of sub content for the second view
        
        
        // sub content of the third view
        userContentView.addSubview(btnUserContentView)
        btnUserContentView.pin(to: userContentView, top: 0, left: 20, bottom: 0, right: -20)
        
        btnUserContentView.addArrangedSubview(btnShort)
        btnUserContentView.addArrangedSubview(btnFav)
        btnUserContentView.addArrangedSubview(btnRooms)
        
//        btnUserBontentView
        setupConstraints()
        lblUserType.cornerRadius = 10
//        userImageView.cornerRadius = 10
    }
    
    private func clearSelection() {
        shortSelected = false
        likesSelected = false
        roomsSelected = false
    }
    
    private func setupConstraints() {
        let width = view.frame.width
        let height = view.frame.height
        let totalHeight = width * 0.5 + width * 0.14 + width * 0.125 + height
        print("The width: \(width) and height: \(height)")
        btnFollowUser.cornerRadius = 10
        btnWalletView.cornerRadius = width * 0.14 * 0.5
        btnMessageView.cornerRadius = width * 0.14 * 0.5
        NSLayoutConstraint.activate([
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContainer.heightAnchor.constraint(equalToConstant: totalHeight),
            
            infoView.heightAnchor.constraint(equalToConstant: width * 0.5),
            contactView.heightAnchor.constraint(equalToConstant: width * 0.14),
            userContentView.heightAnchor.constraint(equalToConstant: width * 0.125),
            collectionView.heightAnchor.constraint(equalToConstant: height),
            
            //MARK: constraint of the first view content
            userInfoContainer.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 20),
            userInfoContainer.heightAnchor.constraint(equalToConstant: width * 0.26),
            userInfoContainer.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor, constant: width * 0.05),
            userInfoContainer.widthAnchor.constraint(equalToConstant: width * 0.2),
            
            userImageView.heightAnchor.constraint(equalTo: userInfoContainer.widthAnchor, multiplier: 1.0),
            
            lblUsername.leadingAnchor.constraint(equalTo: userInfoContainer.trailingAnchor, constant: width * 0.05),
            lblUsername.topAnchor.constraint(equalTo: userInfoContainer.topAnchor),
            
            lblUserBio.leadingAnchor.constraint(equalTo: lblUsername.leadingAnchor),
            lblUserBio.topAnchor.constraint(equalTo: lblUsername.bottomAnchor, constant: 5),
            lblUserBio.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            
            userInfoContentView.topAnchor.constraint(equalTo: lblUserType.bottomAnchor, constant: width * 0.02),
            userInfoContentView.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor),
            userInfoContentView.trailingAnchor.constraint(equalTo: lblUserBio.trailingAnchor),
            userInfoContentView.heightAnchor.constraint(equalToConstant: width * 0.2),
            
            lblFollower.centerXAnchor.constraint(equalTo: followerView.centerXAnchor),
            lblNumFollower.centerXAnchor.constraint(equalTo: followerView.centerXAnchor),
            lblNumFollower.topAnchor.constraint(equalTo: followerView.topAnchor, constant: width * 0.05),
            lblFollower.topAnchor.constraint(equalTo: lblNumFollower.bottomAnchor, constant: width * 0.01),
            
            lblFollowing.centerXAnchor.constraint(equalTo: followingView.centerXAnchor),
            lblNumFollowing.centerXAnchor.constraint(equalTo: followingView.centerXAnchor),
            lblNumFollowing.topAnchor.constraint(equalTo: followingView.topAnchor, constant: width * 0.05),
            lblFollowing.topAnchor.constraint(equalTo: lblNumFollowing.bottomAnchor, constant: width * 0.01),
            
            lblLikes.centerXAnchor.constraint(equalTo: likeView.centerXAnchor),
            lblNumLikes.centerXAnchor.constraint(equalTo: likeView.centerXAnchor),
            lblNumLikes.topAnchor.constraint(equalTo: likeView.topAnchor, constant: width * 0.05),
            lblLikes.topAnchor.constraint(equalTo: lblNumLikes.bottomAnchor, constant: width * 0.01),
            
            //MARK: End of the constaints for the first content
            //MARK: -
            
            //MARK: - Constraints for the second content
            
            btnFollowView.widthAnchor.constraint(equalToConstant: width * 0.62),
            btnWalletView.widthAnchor.constraint(equalToConstant: width * 0.14),
            btnMessageView.widthAnchor.constraint(equalToConstant: width * 0.14),
            btnImage.leadingAnchor.constraint(equalTo: btnFollowView.leadingAnchor, constant: width * 0.08),
//            btnImage.leadingAnchor.constraint(equalTo: btnFollowView.leadingAnchor, constant: 20),
            btnImage.centerYAnchor.constraint(equalTo: btnFollowView.centerYAnchor),
//            btnImage.widthAnchor.constraint(equalToConstant: width * 0.08),
            
            btnLabel.leadingAnchor.constraint(equalTo: btnImage.trailingAnchor, constant: width * 0.07),
            btnLabel.centerYAnchor.constraint(equalTo: btnFollowView.centerYAnchor),
            
            lblNoData.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            lblNoData.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            lblNoData.heightAnchor.constraint(equalToConstant: 56)
            //MARK: End of the constaints for the second content
            
        ])
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.view.removeFromSuperview()
//        self.removeObserverForData()
        if #available(iOS 13.0, *) {
            self.dismiss(animated: true, completion: {
                self.dismissDelegate?.dismiss(controller: self)
            })
        }
        else{
            self.dismissDelegate?.dismiss(controller: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func clearButton() {
        btnShort.backgroundColor = getColor(hex: "#171715")
        btnFav.backgroundColor = getColor(hex: "#171715")
        btnRooms.backgroundColor = getColor(hex: "#171715")
        btnShort.setTitleColor(.white, for: .normal)
        btnFav.setTitleColor(.white, for: .normal)
        btnRooms.setTitleColor(.white, for: .normal)
    }
    
    @objc private func goToFollower() {
        NavigationManager.shared.goToSocialPage(IJamitConstants.TYPE_FOLLOWER, currentVC: self)
    }
    
    @objc private func goToFollowing() {
        NavigationManager.shared.goToSocialPage(IJamitConstants.TYPE_FOLLOWING, currentVC: self)
    }
}


extension NewUserProfileController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case shortsCollectionView:
            guard let cell = shortsCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEpisodeFlatListCell.identifier, for: indexPath) as? NewEpisodeFlatListCell,
                  let episode = userStories?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.episode = episode
            cell.updateUI(episode)
            cell.listModels = userStories
            cell.menuDelegate = menuDelegate
            cell.typeVC = typeVC
            cell.itemDelegate = itemDelegate
            cell.imgEpisode.isHidden = true
            return cell
        case likesCollectionView:
            guard let cell = likesCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEpisodeFlatListCell.identifier, for: indexPath) as? NewEpisodeFlatListCell,
                  let episodes = userFav else {
                return UICollectionViewCell()
            }
            let index = indexPath.row
            cell.episode = episodes[index]
            cell.listModels = episodes
            cell.menuDelegate = parentVC?.menuDelegate
            cell.typeVC = self.typeVC
//            cell.btnPlay.tag = index
            cell.showDelegate = self
            cell.itemDelegate = self.itemDelegate
            cell.updateUI(episodes[index])
//            cell.episodeCellViewModel = self.parentVC?.episodeCellViewModel
//            cell.episodeCellViewModel?.listModels = episodes
            return cell
        case roomsCollectionView:
            guard let cell = roomsCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEventCell.identifier, for: indexPath) as? NewEventCell else {
                return UICollectionViewCell()
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case shortsCollectionView:
            return userStories?.count ?? 0
        case likesCollectionView:
            return userFav?.count ?? 0
        case roomsCollectionView:
            return 4
        default:
            return 0
        }
    }
    
}

extension NewUserProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width
        switch collectionView {
        case shortsCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.27)
        case likesCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.27)
        case roomsCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.45)
        default:
            return CGSize(width: width * 0.24, height: width * 0.32)
        }
    }
    
}

extension NewUserProfileController : GoToShowDelegate {

    func goToShowOf(_ model: EpisodeModel) {
        self.itemDelegate?.clickItem(list: [], model: model.getShowModel(), position: 0)
    }

}
