//
//  NewTabLibraryController.swift
//  jamit
//
//  Created by Prof K on 3/17/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class TabLibraryController: JamitRootViewController {

//    @IBOutlet weak var lblNodata : UILabel!
//    @IBOutlet var progressBar: UIActivityIndicatorView!
//    @IBOutlet weak var libraryView: UIView!
    
//    var viewModel: CatergoryViewModel!
    
    let fontDL = UIFont(name: IJamitConstants.FONT_SEMI_BOLD, size: DimenRes.btn_downloads_likes) ?? UIFont.systemFont(ofSize: DimenRes.btn_downloads_likes)
    let fontHeader = UIFont(name: IJamitConstants.FONT_BOLD, size: DimenRes.btn_downloads_likes) ?? UIFont.systemFont(ofSize: DimenRes.btn_downloads_likes)
    
    let scrollContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.alignment = .fill
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var typeVC: Int = 0
    var isAllowRefresh = true
    var itemDelegate: AppItemDelegate?
    var parentVC: MainController?
    var isTab = false
    var isAllowReadCache = false
    var isReadCacheWhenNoData = false
    var isCatShow: Bool = true
    var isShowHeader: Bool = false
    
    let scrollView: UIScrollView = {
       let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIStackView = {
       let view = UIStackView()
        view.spacing = 20
        view.axis = .vertical
        view.distribution = .fillProportionally
//        view.contentMode = .scaleToFill
        view.alignment = .fill
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnFavAudio: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnDownloads: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favBGView: UIView = {
       let view = UIView()
        view.cornerRadius = 12
        view.backgroundColor = getColor(hex: "#171715")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblFavAudio: UILabel = {
        let label = UILabel()
        label.text = "Liked Audio"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgFavAudio: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(named: "ic_arrow_right_white_24dp")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let downloadBGView: UIView = {
       let view = UIView()
        view.cornerRadius = 12
        view.backgroundColor = getColor(hex: "#171715")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblDownload: UILabel = {
        let label = UILabel()
        label.text = "Downloads"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgDownload: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(named: "ic_arrow_right_white_24dp")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let followedBGView: UIView = {
       let view = UIView()
        view.cornerRadius = 12
        view.backgroundColor = getColor(hex: "#171715")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgFollow: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 12
        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: ImageRes.img_default)
//        imageView.backgroundColor = .purple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let btnPlayFollow: UIButton = {
        let button = UIButton()
        button.backgroundColor = getColor(hex: ColorRes.play_color_text) //getColor(hex: "ffae29")
        button.tintColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let followContent: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblFollowedRecent: UILabel = {
        let label = UILabel()
        label.text = "Followed Recently"
        label.textColor = getColor(hex: "#8991A1")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblFollowedTitle: UILabel = {
        let label = UILabel()
        label.text = "Late Night Thought"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblFollowedAuthor: UILabel = {
        let label = UILabel()
        label.text = "by Author Name"
        label.textColor = getColor(hex: "#8991A1")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblFollowing: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followedButtonsBGView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let followButtonStackView: UIStackView = {
        let view = UIStackView()
         view.spacing = 8
         view.axis = .horizontal
         view.distribution = .fillProportionally
 //        view.contentMode = .scaleToFill
         view.alignment = .center
         view.backgroundColor = .black
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    let btnFollowedPodcast: UIButton = {
       let button = UIButton()
        button.setTitle("Podcasts", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnFollowedAudiobook: UIButton = {
       let button = UIButton()
        button.setTitle("Audiobooks", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnFollowedCreators: UIButton = {
       let button = UIButton()
        button.setTitle("Creators", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionBGView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var audiobookCollectionView: UICollectionView?
    private var featuredCollectionView: UICollectionView?
    private var liveRoomsCollectionView: UICollectionView?
    private var trendingUsersCollectionView: UICollectionView?
    
    private let viewModel = LibraryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = getColor(hex: "#201D21")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
        btnDownloads.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        btnFavAudio.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        btnFollowedPodcast.addTarget(self, action: #selector(podcastTapped), for: .touchUpInside)
        btnFollowedAudiobook.addTarget(self, action: #selector(audiobookTapped), for: .touchUpInside)
        btnFollowedCreators.addTarget(self, action: #selector(btnCreatorsTapped), for: .touchUpInside)
        
        lblFavAudio.font = fontDL
        lblDownload.font = fontDL
        lblFollowing.font = fontHeader
        listeners()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listeners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let audiobookLayout = UICollectionViewFlowLayout()
        audiobookLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right:0)
        audiobookLayout.minimumInteritemSpacing = 10.0
        audiobookLayout.minimumLineSpacing = 10.0
        audiobookLayout.scrollDirection = .vertical
        
        audiobookCollectionView = UICollectionView(frame: .zero, collectionViewLayout: audiobookLayout)
        
//        let featuredLayout = UICollectionViewFlowLayout()
//        featuredLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
//        featuredLayout.minimumInteritemSpacing = 20.0
//        featuredLayout.minimumLineSpacing = 20.0
//        featuredLayout.scrollDirection = .horizontal
//        featuredCollectionView = UICollectionView(frame: .zero, collectionViewLayout: featuredLayout)
        
        
//        let eventLayout = UICollectionViewFlowLayout()
//        eventLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 10)
//        eventLayout.minimumInteritemSpacing = 10.0
//        eventLayout.minimumLineSpacing = 10.0
//        eventLayout.scrollDirection = .horizontal
//        liveRoomsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: eventLayout)
        
        
//        let userLayout = UICollectionViewFlowLayout()
//        userLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 10)
//        userLayout.minimumInteritemSpacing = 0
//        userLayout.minimumLineSpacing = 0
//        userLayout.scrollDirection = .horizontal
//        trendingUsersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: userLayout)
        
        guard let audiobookCollectionView = audiobookCollectionView
//                let featuredCollectionView = featuredCollectionView,
//                let liveRoomsCollectionView = liveRoomsCollectionView,
//                let trendingUsersCollectionView = trendingUsersCollectionView
        else {
                    print("Where are the collection views")
            return
        }
        audiobookCollectionView.register(NewAudiobookCell.self, forCellWithReuseIdentifier: NewAudiobookCell.identifier)
        
//        trendingNowCollectionView.isPagingEnabled = true
        collectionBGView.addSubview(audiobookCollectionView)
        audiobookCollectionView.frame = collectionBGView.bounds
        audiobookCollectionView.backgroundColor = .black
        

        audiobookCollectionView.dataSource = self
        audiobookCollectionView.delegate = self
        
//        featuredCollectionView.register(NewPodcastCell.self, forCellWithReuseIdentifier: NewPodcastCell.identifier)
//
//        featuredPodcastView.addSubview(featuredCollectionView)
//        featuredCollectionView.frame = featuredPodcastView.bounds
//        featuredCollectionView.backgroundColor = .black
//        featuredCollectionView.dataSource = self
//        featuredCollectionView.delegate = self
//
//        liveRoomView.addSubview(liveRoomsCollectionView)
//        liveRoomsCollectionView.frame = liveRoomView.bounds
//        liveRoomsCollectionView.backgroundColor = .black
//        liveRoomsCollectionView.dataSource = self
//        liveRoomsCollectionView.delegate = self
//
//        liveRoomsCollectionView.register(NewEventCell.self, forCellWithReuseIdentifier: NewEventCell.identifier)
//
//        trendingUsersCollectionView.register(NewTrendingUserCell.self, forCellWithReuseIdentifier: NewTrendingUserCell.identifier)
//
//        trendingUser.addSubview(trendingUsersCollectionView)
//        trendingUsersCollectionView.frame = trendingUser.bounds
//        trendingUsersCollectionView.backgroundColor = .black
//        trendingUsersCollectionView.dataSource = self
//        trendingUsersCollectionView.delegate = self
        
    }
    
    @objc private func downloadTapped() {
        goToMyDownload()
    }
    
    @objc private func favoriteTapped() {
        goToMyFavorite()
    }
    
    @objc private func podcastTapped() {
        viewModel.btnPodcast()
    }
    
    @objc private func audiobookTapped() {
        viewModel.btnAudio()
    }
    
    @objc private func btnCreatorsTapped() {
        viewModel.btnSeries()
    }
    
    fileprivate func clearButton() {
        btnFollowedPodcast.backgroundColor = getColor(hex: "#171715")
        btnFollowedCreators.backgroundColor = getColor(hex: "#171715")
        btnFollowedAudiobook.backgroundColor = getColor(hex: "#171715")
        btnFollowedPodcast.setTitleColor(.white, for: .normal)
        btnFollowedAudiobook.setTitleColor(.white, for: .normal)
        btnFollowedCreators.setTitleColor(.white, for: .normal)
    }
    
    fileprivate func listeners() {
        viewModel.seriesSelectect = { [weak self] in
            self?.clearButton()
            self?.btnFollowedCreators.backgroundColor = getColor(hex: "#FFAE29")
            self?.btnFollowedCreators.setTitleColor(.black, for: .normal)
        }
        
        viewModel.audioSelectect = { [weak self] in
            self?.clearButton()
            self?.btnFollowedAudiobook.backgroundColor = getColor(hex: "#FFAE29")
            self?.btnFollowedAudiobook.setTitleColor(.black, for: .normal)
        }
        
        viewModel.podcastSelectect = { [weak self] in
            self?.clearButton()
            self?.btnFollowedPodcast.setTitleColor(.black, for: .normal)
            self?.btnFollowedPodcast.backgroundColor = getColor(hex: "#FFAE29")
        }
    }
    
    private func setupView() {
        
        // Scroll view added as a subbview
        view.addSubview(scrollView)
        scrollView.pin(to: view)
        
        // Scroll view container added as a subview
        scrollView.addSubview(scrollContainer)
        scrollContainer.pin(to: scrollView)
        
        // Bacground views added to the scrollview container
        scrollContainer.addArrangedSubview(containerBGView)
        containerBGView.pin(to: scrollContainer)
//
//        // background view of the scroll view container
        containerBGView.addSubview(containerView)
        containerView.pin(to: containerBGView, top: 10, left: 24, bottom: 0, right: -24)
        
        containerView.addArrangedSubview(favBGView)
        favBGView.addSubview(lblFavAudio)
        favBGView.addSubview(imgFavAudio)
        favBGView.addSubview(btnFavAudio)
        btnFavAudio.pin(to: favBGView)
        
        containerView.addArrangedSubview(downloadBGView)
        downloadBGView.addSubview(lblDownload)
        downloadBGView.addSubview(imgDownload)
        downloadBGView.addSubview(btnDownloads)
        btnDownloads.pin(to: downloadBGView)
        
        containerView.addArrangedSubview(followedBGView)
        
        followedBGView.addSubview(imgFollow)
        imgFollow.pin(to: followedBGView, top: nil, left: 10, bottom: nil, right: nil)
        followedBGView.addSubview(btnPlayFollow)
        btnPlayFollow.pin(to: followedBGView, top: nil, left: 43, bottom: nil, right: nil)
        followedBGView.addSubview(followContent)
        followContent.pin(to: followedBGView, top: 20, left: nil, bottom: -20, right: -20)
        followContent.addArrangedSubview(lblFollowedRecent)
        followContent.addArrangedSubview(lblFollowedTitle)
        followContent.addArrangedSubview(lblFollowedAuthor)
        
        followedButtonsBGView.addSubview(followButtonStackView)
        followButtonStackView.pin(to: followedButtonsBGView)
        followButtonStackView.addArrangedSubview(btnFollowedPodcast)
        followButtonStackView.addArrangedSubview(btnFollowedAudiobook)
        followButtonStackView.addArrangedSubview(btnFollowedCreators)
        
//        followButtonStackView.backgroundColor = .brown
        btnFollowedPodcast.cornerRadius = 5
        btnFollowedAudiobook.cornerRadius = 5
        btnFollowedCreators.cornerRadius = 5
        btnPlayFollow.cornerRadius = 15
        
        
        btnFollowedPodcast.backgroundColor = getColor(hex: "#FFAE29")
        btnFollowedCreators.backgroundColor = getColor(hex: "#171715")
        btnFollowedAudiobook.backgroundColor = getColor(hex: "#171715")
        btnFollowedPodcast.setTitleColor(.black, for: .normal)
//        btnFollowedAudiobook.tintColor = .black
        
        containerView.addArrangedSubview(lblFollowing)
        
        containerView.addArrangedSubview(followedButtonsBGView)
        
        containerView.addArrangedSubview(collectionBGView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        let totalHeight = height + 166
        
        NSLayoutConstraint.activate([
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            containerView.widthAnchor.constraint(equalToConstant: width - 40),
            containerBGView.heightAnchor.constraint(equalToConstant: totalHeight),
            
            imgFollow.heightAnchor.constraint(equalTo: followedBGView.heightAnchor, multiplier: 0.8),
            imgFollow.widthAnchor.constraint(equalTo: followedBGView.heightAnchor, multiplier: 0.8),
            
            favBGView.heightAnchor.constraint(equalToConstant: 63),
            lblFavAudio.leadingAnchor.constraint(equalTo: favBGView.leadingAnchor, constant: 28),
            lblFavAudio.widthAnchor.constraint(equalToConstant: 188),
            lblFavAudio.centerYAnchor.constraint(equalTo: favBGView.centerYAnchor),
            imgFavAudio.trailingAnchor.constraint(equalTo: favBGView.trailingAnchor, constant: -20),
            imgFavAudio.centerYAnchor.constraint(equalTo: favBGView.centerYAnchor),
            
            downloadBGView.heightAnchor.constraint(equalToConstant: 63),
            lblDownload.leadingAnchor.constraint(equalTo: downloadBGView.leadingAnchor, constant: 28),
            lblDownload.widthAnchor.constraint(equalToConstant: 188),
            lblDownload.centerYAnchor.constraint(equalTo: downloadBGView.centerYAnchor),
            imgDownload.centerYAnchor.constraint(equalTo: downloadBGView.centerYAnchor),
            imgDownload.trailingAnchor.constraint(equalTo: downloadBGView.trailingAnchor, constant: -20),
            
            followedBGView.heightAnchor.constraint(equalToConstant: 116),
            lblFollowing.heightAnchor.constraint(equalToConstant: 42),
            followedButtonsBGView.heightAnchor.constraint(equalToConstant: width * 0.2),
            btnFollowedPodcast.heightAnchor.constraint(equalToConstant: width * 0.12),
            btnFollowedAudiobook.heightAnchor.constraint(equalToConstant: width * 0.12),
            btnFollowedCreators.heightAnchor.constraint(equalToConstant: width * 0.12),
            followContent.leadingAnchor.constraint(equalTo: imgFollow.trailingAnchor, constant: 20),
            
            collectionBGView.heightAnchor.constraint(equalToConstant: height),
            
            btnPlayFollow.heightAnchor.constraint(equalToConstant: 30),
            btnPlayFollow.widthAnchor.constraint(equalToConstant: 30),
            btnPlayFollow.centerYAnchor.constraint(equalTo: followedBGView.centerYAnchor),
            imgFollow.centerYAnchor.constraint(equalTo: followedBGView.centerYAnchor),
            
        ])
    }
    
    private func goToMyFavorite() {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self,parentVC: self.parentVC)
        if isLogin { return }
        NavigationManager.shared.goToLikes(self)
        
    }
    
    private func goToMyDownload() {
        let myDownloadVC = MyDownloadController.create(IJamitConstants.STORYBOARD_LIBRARY) as? MyDownloadController
        myDownloadVC?.typeVC = IJamitConstants.TYPE_VC_DOWNLOAD
        myDownloadVC?.isAllowAddObserver = true
        myDownloadVC?.itemDelegate = self.parentVC
        myDownloadVC?.menuDelegate = self.parentVC?.menuDelegate
        myDownloadVC?.isAllowRefresh = false
        myDownloadVC?.parentVC = self.parentVC
        myDownloadVC?.dismissDelegate = self.parentVC
        myDownloadVC?.isOfflineData = true
        self.parentVC?.myDownloadVC = myDownloadVC
        self.parentVC?.addControllerOnContainer(controller: myDownloadVC!)
    }
    
//    func updateInfoDownload(){
//        let listFav = TotalDataManager.shared.getListData(IJamitConstants.TYPE_VC_DOWNLOAD)
//        let size = listFav?.count ?? 0
//        self.lblNumEpisode.text = StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(size))
//    }
    
    private func subscribeShow(_ show: ShowModel, _ isSubcribe: Bool){
//        let size = self.listModels?.count ?? -1
//        if size >= 0 {
            if isSubcribe {
//                self.listModels?.insert(show.clone()!, at: 0)
//                self.notifyWhenDataChanged()
            }
            else{
//                self.deleteModel(show)
            }
//            return
//        }
//        self.isStartLoadData = false
    }
    
}

extension TabLibraryController: UICollectionViewDelegate {
    
}

extension TabLibraryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = audiobookCollectionView?.dequeueReusableCell(withReuseIdentifier: NewAudiobookCell.identifier, for: indexPath) as? NewAudiobookCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension TabLibraryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width
        switch collectionView {
        case audiobookCollectionView:
            return CGSize(width: width * 0.42, height: width * 0.58)
//        case featuredCollectionView:
//            return CGSize(width: width * 0.35, height: width * 0.48)
//        case liveRoomsCollectionView:
//            return CGSize(width: width * 0.9, height: width * 0.45)
//        case trendingUsersCollectionView:
//            return CGSize(width: width * 0.24, height: width * 0.32)
        default:
            return CGSize(width: width * 0.4, height: width * 0.25)
        }
    }
}
