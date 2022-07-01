//
//  NewTabProfileCollectionView.swift
//  jamit
//
//  Created by Prof K on 3/19/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit
import Kingfisher

protocol AvatarDelegate {
    func changeAvatar()
}

class NewTabProfileController: JamitRootViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var profileDelegate: ProfileViewDelegate?
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private let loginView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
//    private let loginLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "You're not Logged In"
//        label.textColor = .white
//        label.font = UIFont(name: "Poppins-Bold", size: 18)
//        return label
//    }()
    
//    private let loginInfoLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "You have to login to access your profile"
//        label.textColor = .white
//        label.font = UIFont(name: "Poppins-Regular", size: 16)
//        return label
//    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 10
        button.setImage(UIImage(named: ImageRes.ic_back_white_24dp), for: .normal)
        button.tintColor = UIColor(named: ColorRes.textfield_bgcolor)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    @objc private func loginTapped() {
//        print("The l;ogin button tapped")
//        profileDelegate?.goToLogin()
//    }
    
    private let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
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
    
    private let backButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
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
        label.text = "Username".shorted(to: 140)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblUserBio: UILabel = {
        let label = UILabel()
        label.text = "User bio to be displayed with max. word of 140".shorted(to: 140)
        label.numberOfLines = 0
        label.textColor = .label
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
    
    private let lblNumFollowing: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblFollowing: UILabel = {
        let label = UILabel()
        label.text = "Following".shorted(to: 140)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var btnFollowing: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let followerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.text = "Follower".shorted(to: 140)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var btnFollower: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let likeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblNumLikes: UILabel = {
        let label = UILabel()
        let listFav = TotalDataManager.shared.getListData(IJamitConstants.TYPE_VC_FAVORITE)
        let size = listFav?.count ?? 0
        label.text = StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(size))
        label.textColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblLikes: UILabel = {
        let label = UILabel()
        label.text = "Likes"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var btnLikes: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.backgroundColor = .clear
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
    
    private let btnEditProfile: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
        button.backgroundColor = getColor(hex: "#EC0B65")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        imageView.tintColor = .label
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
        label.textColor = .label
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
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private var loginMsg: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    private let loginBtn: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    var dismissDelegate: DismissDelegate?
    var parentVC: MainController?
    var userModel: UserModel?
    var userStories: [EpisodeModel]?
    var userFav: [EpisodeModel]?
    
    
    var avatarDelegate: AvatarDelegate?
    var typeVC: Int = 0
    private var avatarWidth: CGFloat = 0.0
    
//    var typeVC: Int = 0
    var isAllowRefresh = true
    var isAllowLoadMore = false
    var isOfflineData = false
    var isShowHeader = false
    
    var menuDelegate: MenuEpisodeDelegate?
    var itemDelegate: AppItemDelegate?
    var episodeCellViewModel: EpisodeViewModel!
    
    var isTab = false
    var isFirstTab = false
    var isAllowReadCache = false
    var isReadCacheWhenNoData = false
    var isAllowAddObserver = false
    
    private var shortSelected: Bool = true
    private var likesSelected: Bool = false
    private var roomsSelected: Bool = false
    
    private var numLike: Int = 0
    private var shortsCollectionView: UICollectionView?
    private var likesCollectionView: UICollectionView?
    private var roomsCollectionView: UICollectionView?
   
    
    private let myPickerController = UIImagePickerController()
    private var pickedImage: UIImage?
    
    private var viewModel = ProfileViewModel()
    private var episodeModel = EpisodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileDelegate = ProfileViewDelegate(currentVC: self)
        view.backgroundColor = .black
        setupView()
        getListModelFromServer()
        shortTapped()
        
        DispatchQueue.main.async {
            self.shortsCollectionView?.reloadData()
        }
        
        btnShort.addTarget(self, action: #selector(btnShortTapped(_:)), for: .touchUpInside)
        btnFav.addTarget(self, action: #selector(btnFavTapped(_:)), for: .touchUpInside)
        btnRooms.addTarget(self, action: #selector(btnRoomsTapped(_:)), for: .touchUpInside)
        btnEditProfile.addTarget(self, action: #selector(goToEditProfile), for: .touchUpInside)
        btnFollower.addTarget(self, action: #selector(goToFollower), for: .touchUpInside)
        btnFollowing.addTarget(self, action: #selector(goToFollowing), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        clearButton()
        updateUIHeader(userModel)
        shortTapped()
        
//        headerView.isHidden = true
        btnShort.backgroundColor = getColor(hex: "#FFAE29")
        btnShort.setTitleColor(.black, for: .normal)
        
        episodeCellViewModel.reloadCells = { [weak self] in
            DispatchQueue.main.async {
                self?.likesCollectionView?.reloadData()
                self?.shortsCollectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUIHeader(userModel)
        
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
            shortsCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)

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
            likesCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
            
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
            roomsCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
            
            roomsCollectionView.delegate = self
            roomsCollectionView.dataSource = self
        }
        
    }
    
//    private func listeners() {
//        viewModel.userModelCompletion = {
//            self.userModel = self.viewModel.userModel
//        }
//    }
    
    func shortTapped() {
        clearButton()
        clearSelection()
        shortSelected = true
        shortsCollectionView?.reloadData()
        btnShort.backgroundColor = getColor(hex: "#FFAE29")
        btnShort.setTitleColor(.black, for: .normal)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
    
    @objc private func goToEditProfile() {
        NavigationManager.shared.goToEditProfile(currentVC: self, parentVC: self.parentVC!)
    }
    
    @objc private func goToFollower() {
        NavigationManager.shared.goToSocialPage(IJamitConstants.TYPE_FOLLOWER, currentVC: self)
    }
    
    @objc private func goToFollowing() {
        NavigationManager.shared.goToSocialPage(IJamitConstants.TYPE_FOLLOWING, currentVC: self)
    }
    
    private func updateInfo(user: UserModel?){
        let numberFollower = user?.followers?.count ?? 0
        let numberFollowing = user?.following?.count ?? 0
        if (numberFollower > 0 || numberFollowing > 0) {
            let strFollower = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers, Int64(numberFollower))
            let strFollowing = StringUtils.formatNumberSocial(StringRes.format_following, StringRes.format_following, Int64(numberFollowing))
            DispatchQueue.main.async {
                self.lblNumFollower.text = String(strFollower.prefix(strFollower.count - 9))
                self.lblNumFollowing.text = String(strFollowing.prefix(strFollowing.count - 9))
            }
            
        }
    }
    
    func updateUIHeader(_ user: UserModel?) {
        let isLogin = NewSettingManager.isLoginOK()
//        self.user = user
        
        if isLogin {
//            self.loginView.isHidden = true
            self.scrollView.isHidden = false
            print("This is the avar: \(NewSettingManager.getSetting(NewSettingManager.KEY_USER_AVATAR))")
            
            let avatar = NewSettingManager.getSetting(NewSettingManager.KEY_USER_AVATAR)
            if avatar.starts(with: "https") {
                self.userImageView.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            }
            else {
                self.userImageView.image = UIImage(named: ImageRes.ic_avatar_48dp)
            }
            var displayName = NewSettingManager.getSetting(NewSettingManager.KEY_USER_NAME)
            if displayName.isEmpty || displayName.elementsEqual(getString(StringRes.null_value)) {
                displayName = NewSettingManager.getSetting(NewSettingManager.KEY_USER_EMAIL)
            }
            let userType = NewSettingManager.getSetting(NewSettingManager.KEY_USER_TYPE)
            
            
//            let firstName = SettingManager.getSetting(SettingManager.KEY_FIRST_NAME)
//            let lastName = SettingManager.getSetting(SettingManager.KEY_LAST_NAME)
            let bio = NewSettingManager.getSetting(NewSettingManager.KEY_ABOUT_USER)
            
//            self.fullNameLbl.text = "\(firstName) \(lastName)"
            DispatchQueue.main.async {
                self.lblUsername.text = " @\(displayName)"
                self.lblUserBio.text = bio.shorted(to: 140)
                self.lblNumLikes.text = "\(self.numLike)"
                self.lblUserType.text = userType
            }
            
//            let index = MemberShipManager.shared.getMemberIndex()
//            self.lblTvMemberInfo.isHidden = index < 0
//            if index >= 0 {
//                self.imgMember.image = UIImage(named: ImageRes.img_members[index])
//                self.lblTvMemberInfo.text = getString(StringRes.info_premium_member)
//            }
//            layoutAction.isHidden = false
        }
//        else {
//            self.scrollView.isHidden = true
//            self.loginView.isHidden = false
//        }
        self.updateInfo(user: user)
    }
    
    private func setupView() {
        view.addSubview(mainView)
//        mainView.addSubview(loginView)
//        loginView.addSubview(loginLabel)
//        loginView.addSubview(loginInfoLabel)
//        loginView.addSubview(loginButton)
        mainView.pin(to: view, top: 0, left: 0, bottom: 0, right: 0)
        mainView.addSubview(scrollView)
        scrollView.pin(to: mainView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.pin(to: scrollView)
        
        // Adding the four subView
        scrollViewContainer.addArrangedSubview(backButtonView)
        
        scrollViewContainer.addArrangedSubview(infoView)
        scrollViewContainer.addArrangedSubview(contactView)
        scrollViewContainer.addArrangedSubview(userContentView)
        scrollViewContainer.addArrangedSubview(collectionView)
        
        // sub content of the first view
        backButtonView.pin(to: scrollViewContainer, top: 0, left: 0, bottom: nil, right: 0)
        backButtonView.addSubview(backButton)
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
        likeView.addSubview(btnLikes)
        btnLikes.pin(to: likeView)
        
        // end of the content first view
        
        // sub content for the second view
        contactView.addSubview(userContactView)
        userContactView.pin(to: contactView, top: 0, left: 20, bottom: 0, right: -20)
        userContactView.addArrangedSubview(btnFollowView)
        btnFollowView.addSubview(btnEditProfile)
        btnEditProfile.pin(to: btnFollowView)
        
//        btnFollowView.addSubview(btnImage)
//        btnFollowView.addSubview(btnLabel)
        
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
        btnEditProfile.cornerRadius = 10
//        btnFollowUser.contentMode = .center
//        btnFollowUser.contente
        btnWalletView.cornerRadius = width * 0.14 * 0.5
        btnMessageView.cornerRadius = width * 0.14 * 0.5
        NSLayoutConstraint.activate([
//            loginView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
//            loginView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
//            loginView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
//            loginView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.3),
//
//            loginLabel.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 20),
//            loginLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
//
//            loginInfoLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
//            loginInfoLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
//
//            loginButton.topAnchor.constraint(equalTo: loginInfoLabel.bottomAnchor, constant: 20),
//            loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
//            loginButton.widthAnchor.constraint(equalToConstant: width - 48),
//            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContainer.heightAnchor.constraint(equalToConstant: totalHeight),
            
            backButtonView.heightAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: backButtonView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: backButtonView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            infoView.heightAnchor.constraint(equalToConstant: width * 0.5),
            contactView.heightAnchor.constraint(equalToConstant: width * 0.14),
            userContentView.heightAnchor.constraint(equalToConstant: width * 0.125),
            collectionView.heightAnchor.constraint(equalToConstant: height),
            
            //MARK: constraint of the first view content
            userInfoContainer.leadingAnchor.constraint(equalTo: scrollViewContainer.leadingAnchor, constant: 20),
            userInfoContainer.heightAnchor.constraint(equalToConstant: width * 0.26),
            userInfoContainer.topAnchor.constraint(equalTo: infoView.topAnchor, constant: width * 0.05),
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
            
            //MARK: End of the constaints for the second content
            //MARK: -
            
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
    
    
    func getListModelFromServer() {
        let setting = TotalDataManager.shared.getSetting()
//        let isShow = setting != nil //&& setting!.showAudioTypes
        if SettingManager.isLoginOK() && ApplicationUtils.isOnline() {
            let userName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            JamItPodCastApi.getUserInfo(userName) { (result) in
                self.userModel = result
                
//                self.startCreateProfileItem(completion)
            }
//            if let short = self.headerView?.shortSelected {
//                if short {
                    JamItPodCastApi.getUserStories(SettingManager.getUserId()) { (list) in
                        if list?.count == 0 {
//                            self.profileDelegate?.updateLikeSelection()
                        } else {
                            self.userStories = list
                        }
                        
//                        completion(self.convertListModelToResult(list))
//                    }
//                }

            }
//            if let like = self.headerView?.likesSelected {
//                if like {
                    JamItPodCastApi.getUserFavEpisode { (list) in
                        let size = list?.count ?? 0
                        if size > 0 {
                            self.numLike = size
                            for model in list! {
                                model.likes = [SettingManager.getUserId()]
                            }
                        } else {
//                            self.profileDelegate?.updateShortSelection()
                        }
                        self.userFav = list
//                        completion(self.convertListModelToResult(list))
//                    }
//                }

            }
//            if let event = self.headerView?.eventSelected {
//                if event {
//                    self.eventUserId = user?.userID
//                    if self.eventUserId != nil && !self.eventUserId!.isEmpty {
//                        JamItEventApi.getUserEvents(self.eventUserId!) { events in
//                            completion(self.convertListModelToResult(events))
//                        }
//                        return
//                    }
//                    if self.eventType != nil && !self.eventType!.isEmpty {
//                        JamItEventApi.getListTypeEvents(self.eventType!) { events in
//                            completion(self.convertListModelToResult(events))
//                        }
//                        return
//                    }
//                }
//
//            }

            return
        }
        self.userModel = nil
//        startCreateProfileItem(completion)
    }
}

extension NewTabProfileController: UICollectionViewDelegate, UICollectionViewDataSource {
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
//            cell.updateUI(episodes[index])
            cell.updateUI(episodes[index])
            cell.listModels = episodes
            cell.menuDelegate = menuDelegate
            cell.typeVC = self.typeVC
//            cell.btnPlay.tag = index
            cell.showDelegate = self
            cell.itemDelegate = itemDelegate
            
//            cell.episode = episode
//            episodeModel.updateUI(with: episode)
//            cell.menuDelegate = menuDelegate
//            cell.itemDelegate = itemDelegate
//            cell.listModels = userFav
//            cell.episodeCellViewModel = episodeModel
            
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
            return 10
        default:
            return 0
        }
    }
    
}

extension NewTabProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width
        switch collectionView {
        case shortsCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.27)
        case likesCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.27)
        case roomsCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.45)
//        case trendingUsersCollectionView:
//            return CGSize(width: width * 0.24, height: width * 0.32)
        default:
            return CGSize(width: width * 0.24, height: width * 0.32)
        }
    }
    
}

extension NewTabProfileController : GoToShowDelegate {

    func goToShowOf(_ model: EpisodeModel) {
        self.itemDelegate?.clickItem(list: [], model: model.getShowModel(), position: 0)
    }

}

