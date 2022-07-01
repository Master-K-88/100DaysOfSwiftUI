//
//  NewTabHomeController.swift
//  jamit
//
//  Created by Prof K on 3/10/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit
import SwiftUI

//protocol HomeHeaderDelegage {
//    func goToFeaturedShow(_ show: ShowModel)
//    func goToFeatured(_ typeVC: Int)
//}
class TabHomeController: JamitRootViewController {

    var viewModel: HomeViewModel!
//    var episodeCellViewModel: EpisodeViewModel!
    var episodeCellViewModel: EpisodeViewModel!
//    var viewModel: HomeViewModel = HomeViewModel()
    var categoryViewModel: CatergoryViewModel = CatergoryViewModel()
    var trendingUsersViewModel: TrendingUsersViewModel = TrendingUsersViewModel()
    let podcastViewModel: PodcastViewModel = PodcastViewModel()
    
    @IBOutlet weak var lblNodata : UILabel!
    @IBOutlet var progressBar: UIActivityIndicatorView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var lblMore: UILabel!
    @IBOutlet var indicatorMore: UIActivityIndicatorView!
    @IBOutlet weak var homeMainView: UIView!
//    @IBOutlet var bottomHeight: NSLayoutConstraint!
    //MARK: - Private var from the previous code
    
    let refreshControl = UIRefreshControl()
    
    var itemDelegate: AppItemDelegate?
    var menuDelegate: MenuEpisodeDelegate?
    
    var typeVC: Int = 0
    var isAllowRefresh = true
    var isAllowLoadMore = false
    var isOfflineData = false
    var isShowHeader = false
    
    var delegate: HomeHeaderDelegage?
    
    var isTab = false
    var isFirstTab = false
    var isAllowReadCache = false
    var isReadCacheWhenNoData = false
    var isAllowAddObserver = false
    
    var maxPage: Int = IJamitConstants.MAX_PAGE
    var numberItemPerPage: Int = IJamitConstants.NUMBER_ITEM_PER_PAGE
    var isStartLoadData = false
    
    private var isStartAddingPage = false
    private var currentPage: Int = 0
    private var idCell: String = ""
    private var isAllowAddPage = false
    private var isAddObserver = false
    
    var parentVC: MainController?
    private var bannerParentVC : UIViewController!
    
    var uiType : UIType = .FlatList
    
    var totalDataMng = TotalDataManager.shared
    var widthItemGrid : CGFloat = 0.0
    
    //MARK: - End of the private var
    
    let generalRegularLabel = { (text: String) -> UILabel in
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Poppins-Light", size: 12)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    let generalBoldLabel = { (text: String) -> UILabel in
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.textColor = UIColor(named: ColorRes.label_color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    //MARK: - General Button using closure
    let generalButton: (String, UIColor) -> UIButton = { (image: String, color: UIColor) -> UIButton in
        let button = UIButton()
        button.cornerRadius = 10
        button.contentMode = .scaleToFill
        button.setImage(UIImage(named: "\(image)"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = color
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    //MARK: - General Stack view using closure
    
    let generalVerticalStackView = { (space: CGFloat) -> UIStackView in
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        stack.spacing = space
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    let generalVerticalOptionsView = { (space: CGFloat) -> UIStackView in
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.spacing = space
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    let generalHorizontalStackView = { (space: CGFloat) -> UIStackView in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.spacing = space
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    let generalView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    let generalOptionsView = { (color: UIColor) -> UIView in
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    
    //MARK: - The entire scroll view for the screen
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - End of the scroll view
    
    //MARK: - The container for the scroll view
    
    lazy var scrollContainer: UIStackView = generalVerticalStackView(15)
    
    lazy var headsetView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorRes.headset_bgcolor
        view.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headsetBtn = generalButton("ic_subscribe_36dp", ColorRes.headset_bgcolor)
    lazy var optionsContainer: UIStackView = generalVerticalOptionsView(25)
    
    lazy var firstRowStack: UIStackView = generalHorizontalStackView(10)
    lazy var secondRowStack: UIStackView = generalHorizontalStackView(10)
    
    lazy var liveStack: UIView = generalView()
    lazy var shortStack: UIView = generalView()
    lazy var audioStack: UIView = generalView()         
    lazy var podcastStack: UIView = generalView()
//    {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 15
//        view.alignment = .fill
//        view.contentMode = .scaleToFill
////        view.backgroundColor = .blue
//        view.backgroundColor = .clear
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    //MARK: - End of the container for the scroll view
    
    //MARK: - Content for the container view of the scroll view
    
    // First Stack view for the container view (ArrangedSubView)
    
//    let mainView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 10
//        view.backgroundColor = .blue
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    // Second Stack View for the container view (ArrangedSubView)
            // View for various categories such as
                    // -> Live -> Short -> Audiobook -> Podcast
    let categoryStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        view.alignment = .fill
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryView: UIView = {
        let view = UIView()
         view.backgroundColor = .clear
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    // Greeting label (Hi, Username)
    
    let greetingView: UIView = {
        let view = UIView()
         view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    let userAvartar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ic_tab_profile_24dp")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
//    let lblGreeting: UILabel = {
//       let label = UILabel()
//        label.text = "Hi, Anonymous"
//        label.font = UIFont(name: "Poppins-Bold", size: 24)
//        label.textColor = .white
//        label.adjustsFontSizeToFitWidth = true
//        label.sizeToFit()
//        label.backgroundColor = .clear
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    // Banner that displays various view
    let bannerContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bannerView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        view.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Title within the banner
    let lblTrial: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Try premium button
    let btnTry: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Stack
    
    // Short button
    
    lazy var btnLive: UIButton = generalButton("ic_event_live_36dp", ColorRes.live_bgcolor)
    lazy var btnShort: UIButton = generalButton("ic_mic_on_36dp", ColorRes.short_bgcolor)
    lazy var btnAudiobook: UIButton = generalButton("ic_book", ColorRes.audiobook_bgcolor)
    lazy var btnPodcast: UIButton = generalButton("ic_podcast", ColorRes.podcast_bgcolor)
    
    //Page control
    
    var featurePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.borderColor = .white
        pageControl.backgroundColor = .clear
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //MARK: - Trending Now screen setup
    let trendingView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblTrendNow: UILabel = {
        let label = UILabel()
        label.text = "Trending Now"
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        label.textColor = UIColor(named: ColorRes.label_color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trendindNowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var trendingNowCollectionView: UICollectionView?
    private var featuredCollectionView: UICollectionView?
    private var liveRoomsCollectionView: UICollectionView?
    private var trendingUsersCollectionView: UICollectionView?
    
    
    //MARK: - End of Trending Now setup
    
    //MARK: - Featured Podcast screen setup
    let featuredView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblFeaturedPodcast: UILabel = {
        let label = UILabel()
        label.text = "Featured Podcasts"
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        label.textColor = UIColor(named: ColorRes.label_color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let featuredPodcastView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - End of featured Podcast setup
    
    //MARK: - Live Rooms setup
    
    let liveView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblLiveRooms: UILabel = {
        let label = UILabel()
        label.text = "Live Rooms"
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        label.textColor = UIColor(named: ColorRes.label_color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let liveRoomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - End of the Live Rooms setup
    
    //MARK: - Trending Users Setup
    
    let trendingUsersView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblTrendingUsers: UILabel = {
        let label = UILabel()
        label.text = "Trending Users"
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        label.textColor = UIColor(named: ColorRes.label_color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trendingUser: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentIndex = 0
    private var pendingIndex = 0
    private var pageViewController: UIPageViewController!
    fileprivate var viewControllers: [FeaturedShowController] = []
    
    private var listFeaturedShow : [ShowModel]?
    private var autoChangeTimer = Timer()
    private var hideImg: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.fetchData()
        animationLoader.startAnimating()
        homeMainView.backgroundColor = .clear
        initPageController(self)
        
        let width: CGFloat = self.view.layer.frame.size.width
        let height: CGFloat = self.view.layer.frame.size.height
        
        setupViewWithContraints(width: width, height: height)
        setListFeaturedShow(viewModel.listFeaturedPodcast)
        
        
//        let setting = TotalDataManager.shared.getSetting()
//        liveStack.isHidden = !(setting?.isShowLive ?? true)
//        podcastStack.isHidden = !(setting?.isShowPodcast ?? true)
//        shortStack.isHidden = !(setting?.isShowStory ?? true)
//        audioStack.isHidden = !(setting?.isShowAudioBook ?? true)
        
//        trendindNowCollectionView.dataSource = self
//        trendindNowCollectionView.delegate = self
        
        footerView.isHidden = true
        lblNodata.isHidden = true
        progressBar.isHidden = true
        
//        private var paddingInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.parentVC?.refreshContainerBottom()
//        DispatchQueue.main.async {
            self.trendingNowCollectionView?.reloadData()
            self.featuredCollectionView?.reloadData()
            self.trendingUsersCollectionView?.reloadData()
            self.liveRoomsCollectionView?.reloadData()
//        }
        listeners()
        
        
        
        
//        listFeaturedShow =
        //        trendindNowCollectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        episodeCellViewModel.reloadHomeCells = { [weak self] in
            DispatchQueue.main.async {
                self?.trendingNowCollectionView?.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.trendingNowCollectionView?.reloadData()
            self.featuredCollectionView?.reloadData()
            self.trendingUsersCollectionView?.reloadData()
            self.liveRoomsCollectionView?.reloadData()
        }
            
        listeners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let trendingLayout = UICollectionViewFlowLayout()
        trendingLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 5, right: 20)
        trendingLayout.minimumInteritemSpacing = 5.0
        trendingLayout.minimumLineSpacing = 5.0
        trendingLayout.scrollDirection = .horizontal
        
        trendingNowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: trendingLayout)
        
        let featuredLayout = UICollectionViewFlowLayout()
        featuredLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        featuredLayout.minimumInteritemSpacing = 20.0
        featuredLayout.minimumLineSpacing = 20.0
        featuredLayout.scrollDirection = .horizontal
        featuredCollectionView = UICollectionView(frame: .zero, collectionViewLayout: featuredLayout)
        
        
        let eventLayout = UICollectionViewFlowLayout()
        eventLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 10)
        eventLayout.minimumInteritemSpacing = 10.0
        eventLayout.minimumLineSpacing = 10.0
        eventLayout.scrollDirection = .horizontal
        liveRoomsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: eventLayout)
        
        
        let userLayout = UICollectionViewFlowLayout()
        userLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 10)
        userLayout.minimumInteritemSpacing = 0
        userLayout.minimumLineSpacing = 0
        userLayout.scrollDirection = .horizontal
        trendingUsersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: userLayout)
        
        guard let trendingNowCollectionView = trendingNowCollectionView,
                let featuredCollectionView = featuredCollectionView,
                let liveRoomsCollectionView = liveRoomsCollectionView,
                let trendingUsersCollectionView = trendingUsersCollectionView
        else {
                    print("Where are the collection views")
            return
        }
        trendingNowCollectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
        
//        trendingNowCollectionView.isPagingEnabled = true
        trendindNowView.addSubview(trendingNowCollectionView)
        trendingNowCollectionView.frame = trendindNowView.bounds
        trendingNowCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)

        trendingNowCollectionView.dataSource = self
        trendingNowCollectionView.delegate = self
        
        featuredCollectionView.register(NewPodcastCell.self, forCellWithReuseIdentifier: NewPodcastCell.identifier)
        
        featuredPodcastView.addSubview(featuredCollectionView)
        featuredCollectionView.frame = featuredPodcastView.bounds
        featuredCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        
        liveRoomView.addSubview(liveRoomsCollectionView)
        liveRoomsCollectionView.frame = liveRoomView.bounds
        liveRoomsCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        liveRoomsCollectionView.dataSource = self
        liveRoomsCollectionView.delegate = self
        
        liveRoomsCollectionView.register(NewEventCell.self, forCellWithReuseIdentifier: NewEventCell.identifier)
        
        trendingUsersCollectionView.register(NewTrendingUserCell.self, forCellWithReuseIdentifier: NewTrendingUserCell.identifier)
        
        trendingUser.addSubview(trendingUsersCollectionView)
        trendingUsersCollectionView.frame = trendingUser.bounds
        trendingUsersCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        trendingUsersCollectionView.dataSource = self
        trendingUsersCollectionView.delegate = self
        
//        trendingNowCollectionView.reloadData()
    }
    
    private func setupViewWithContraints(width: CGFloat, height: CGFloat) {
        greetingView.isHidden = true
        
        homeMainView.addSubview(scrollView)
        scrollView.pin(to: homeMainView, top: 0, left: 0, bottom: 54, right: 0)
//        scrollView.pin(to: homeMainView, bottom: 54)
        
        scrollView.addSubview(scrollContainer)
//        scrollContainer.backgroundColor = .link
        scrollContainer.pin(to: scrollView)
        
        scrollContainer.addArrangedSubview(greetingView)
        greetingView.addSubview(userAvartar)
        
        scrollContainer.addArrangedSubview(bannerContainerView)
        bannerContainerView.addSubview(bannerView)
        bannerView.addSubview(featurePageControl)
        
        bannerContainerView.addSubview(categoryView)
        categoryView.addSubview(categoryStack)
        categoryStack.pin(to: categoryView)
        
        categoryStack.addArrangedSubview(headsetView)
        headsetView.addSubview(headsetBtn)
        headsetBtn.pin(to: headsetView, top: 20, left: 20, bottom: -20, right: -20)
        categoryStack.addArrangedSubview(optionsContainer)
        optionsContainer.addArrangedSubview(firstRowStack)
        optionsContainer.addArrangedSubview(secondRowStack)
        
        firstRowStack.addArrangedSubview(liveStack)
        firstRowStack.addArrangedSubview(shortStack)
        
        secondRowStack.addArrangedSubview(audioStack)
        secondRowStack.addArrangedSubview(podcastStack)
        
//        categoryStack.addArrangedSubview(liveStack)
//        categoryStack.addArrangedSubview(shortStack)
//        categoryStack.addArrangedSubview(audioStack)
//        categoryStack.addArrangedSubview(podcastStack)
        
        liveStack.addSubview(btnLive)
        btnLive.pin(to: liveStack)
//        liveStack.addArrangedSubview(lblLive)
        
        shortStack.addSubview(btnShort)
        btnShort.pin(to: shortStack)
//        shortStack.addArrangedSubview(lblShort)
        
        audioStack.addSubview(btnAudiobook)
        btnAudiobook.pin(to: audioStack)
//        audioStack.addArrangedSubview(lblAudioBook)
        
        podcastStack.addSubview(btnPodcast)
        btnPodcast.pin(to: podcastStack)
//        podcastStack.addArrangedSubview(lblPodcast)
        
        scrollContainer.addArrangedSubview(trendingView)
        trendingView.addArrangedSubview(lblTrendNow)
        trendingView.addArrangedSubview(trendindNowView)
        
        scrollContainer.addArrangedSubview(featuredView)
        featuredView.addArrangedSubview(lblFeaturedPodcast)
        featuredView.addArrangedSubview(featuredPodcastView)
        
        scrollContainer.addArrangedSubview(liveView)
        liveView.addArrangedSubview(lblLiveRooms)
        liveView.addArrangedSubview(liveRoomView)
        
        scrollContainer.addArrangedSubview(trendingUsersView)
        trendingUsersView.addArrangedSubview(lblTrendingUsers)
        trendingUsersView.addArrangedSubview(trendingUser)
        
        btnShort.addTarget(self, action: #selector(btnShortTapped), for: .touchUpInside)
        btnPodcast.addTarget(self, action: #selector(btnPodcastTapped), for: .touchUpInside)
        btnLive.addTarget(self, action: #selector(btnLiveTapped), for: .touchUpInside)
        btnAudiobook.addTarget(self, action: #selector(btnAudioTapped), for: .touchUpInside)
        let totalHeight = (width * 0.5) + 30 + width * 0.43
        
        NSLayoutConstraint.activate([
            
            lblTrendNow.leadingAnchor.constraint(equalTo: userAvartar.leadingAnchor),
            lblTrendNow.heightAnchor.constraint(equalTo: trendingView.widthAnchor, multiplier: 0.1),
            lblTrendNow.topAnchor.constraint(equalTo: trendingView.topAnchor),
            
            lblFeaturedPodcast.leadingAnchor.constraint(equalTo: userAvartar.leadingAnchor),
            
            lblLiveRooms.leadingAnchor.constraint(equalTo: userAvartar.leadingAnchor),
            
            lblTrendingUsers.leadingAnchor.constraint(equalTo: userAvartar.leadingAnchor),
            
            trendindNowView.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor),
            featuredPodcastView.leadingAnchor.constraint(equalTo: featuredView.leadingAnchor),
            trendingUser.leadingAnchor.constraint(equalTo: trendingUsersView.leadingAnchor),
            liveRoomView.leadingAnchor.constraint(equalTo: liveView.leadingAnchor),
            
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            greetingView.heightAnchor.constraint(equalToConstant: 50),
            greetingView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -20),
            
            userAvartar.leadingAnchor.constraint(equalTo: greetingView.leadingAnchor, constant: 20),
            userAvartar.widthAnchor.constraint(equalToConstant: 36),
            userAvartar.topAnchor.constraint(equalTo: greetingView.topAnchor, constant: 5),
            userAvartar.heightAnchor.constraint(equalToConstant: 36),
            
            bannerContainerView.heightAnchor.constraint(equalToConstant: totalHeight),
            
            bannerView.topAnchor.constraint(equalTo: bannerContainerView.topAnchor, constant: 5),
            bannerView.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor, constant: 20),
            bannerView.trailingAnchor.constraint(equalTo: bannerContainerView.trailingAnchor, constant: -20),
            bannerView.heightAnchor.constraint(equalToConstant: width * 0.43),
            
            featurePageControl.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: -10),
            featurePageControl.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor),
            featurePageControl.widthAnchor.constraint(equalTo: bannerView.widthAnchor, multiplier: 0.4),
            featurePageControl.heightAnchor.constraint(equalToConstant: 20),
            
            categoryView.heightAnchor.constraint(equalToConstant: width * 0.5),
            categoryView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 25),
            categoryView.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            
            trendingView.heightAnchor.constraint(equalToConstant: width * 0.7),
            featuredView.heightAnchor.constraint(equalToConstant: width * 0.6),
            trendingUsersView.heightAnchor.constraint(equalToConstant: width * 0.5),
            liveView.heightAnchor.constraint(equalToConstant: width * 0.6),
        ])
        
    }
    
    @objc func btnAudioTapped(sender: UIButton) {
        viewModel.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_AUDIO_BOOK)
    }
    
    @objc func btnLiveTapped(sender: UIButton) {
        viewModel.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_EVENT)
    }
    
    @objc func btnShortTapped(sender: UIButton) {
        viewModel.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_STORY)
    }
    
    @objc func btnPodcastTapped(sender: UIButton!) {
        viewModel.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_PODCASTS)
    }

    private func goToHomeFeaturedEvent() {
        let eventVC = NewHomeEventController.create(IJamitConstants.STORYBOARD_EVENT) as! NewHomeEventController
        eventVC.dismissDelegate = self.parentVC
        eventVC.parentVC = self.parentVC
        eventVC.eventDelegate = self.parentVC?.eventDelegate
        self.parentVC?.addControllerOnContainer(controller: eventVC)
    }
    
    private func listeners() {
        viewModel.loadCompetion = { [weak self] in
            DispatchQueue.main.async {
                self?.trendingNowCollectionView?.reloadData()
                self?.featuredCollectionView?.reloadData()
                self?.trendingUsersCollectionView?.reloadData()
                self?.liveRoomsCollectionView?.reloadData()
                self?.animationLoader.stopAnimating()
            }
        }
        viewModel.shortTapped = { [weak self] in
            guard let episodeVC = self?.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_FEATURED_STORY) else {
                return
            }
            episodeVC.isShowHeader = true
            self?.parentVC?.addControllerOnContainer(controller: episodeVC)
        }
        
        viewModel.liveEvent = { [weak self] in
            self?.goToHomeFeaturedEvent()
        }
        
        viewModel.audioPodcast = { [weak self] num in
            self?.goToListShow(num)
        }
        
        episodeCellViewModel.reloadCells = { [weak self] in
            DispatchQueue.main.async {
                self?.trendingNowCollectionView?.reloadData()
            }
        }
        
        
//        episodeCellViewModel.itemState = { [weak self] _ in
//
//
//        }
    }

    private func goToListShow(_ typeVC: Int){
        let showVC = ShowController.create(IJamitConstants.STORYBOARD_SHOW) as! ShowController
        showVC.itemDelegate = self.parentVC
        showVC.dismissDelegate = self.parentVC
        showVC.isAllowRefresh = true
        showVC.titleScreen = getString(typeVC == IJamitConstants.TYPE_VC_FEATURED_PODCASTS ? StringRes.title_podcasts : StringRes.title_audio_books)
        showVC.typeVC = typeVC
        self.parentVC?.addControllerOnContainer(controller: showVC)
    }
    
    func initPageController (_ parentVC: UIViewController) {
        self.bannerParentVC = parentVC
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.view.frame = self.bannerContainerView.bounds
        
        
        self.addControllerOnRootView(controller: self.pageViewController)
//        pageViewController.view.clipsToBounds = true
        self.bannerContainerView.bringSubviewToFront(self.featurePageControl)
        self.featurePageControl.numberOfPages = self.viewControllers.count
        self.featurePageControl.currentPage = 0
    }
    
    private func addControllerOnRootView(controller : UIViewController){
        controller.view.frame = CGRect(x: 0, y: 0, width: self.bannerContainerView.bounds.width, height: self.bannerContainerView.bounds.height)
        self.bannerParentVC.addChild(controller)
        self.bannerView.addSubview(controller.view)
        controller.view.clipsToBounds = true
        
        controller.didMove(toParent: self.bannerParentVC)
    }
    
    func setListFeaturedShow(_ listShow: [ShowModel]?) {
        self.resetPageControl()
        if listShow != nil{
            let count = listShow!.count
            for i in 1...count {
                let index = i - 1
                let model = listShow![index]
                self.viewControllers.append(self.createViewControllerAtIndex(index: index,model))
                self.listFeaturedShow?.append(model)
            }
            if let firstVC = self.viewControllers.first {
                self.pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
            self.featurePageControl.numberOfPages = self.viewControllers.count
            self.featurePageControl.currentPage = 0
        }
        
    }
    
    //reset all
    func resetPageControl() {
        self.cancelTask()
        if self.viewControllers.count > 0{
            for vc in self.viewControllers {
                vc.removeFromParent()
            }
            self.viewControllers.removeAll()
        }
        self.listFeaturedShow?.removeAll()
        self.featurePageControl.numberOfPages = 0
        self.featurePageControl.currentPage = 0
    }
}


extension TabHomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case trendingNowCollectionView:
//            let pos: Int = indexPath.row
//            guard let listModels = viewModel.episodes else {
//                return
//            }
//            let item = listModels[pos]
//            self.itemDelegate?.clickItem(list: listModels, model: item, position: pos)
//            DispatchQueue.main.async {
//                self.trendingNowCollectionView?.reloadData()
//            }
            print("Nothing is happening here")
        case featuredCollectionView:
            print("")
//            userInfoController
        case trendingUsersCollectionView:
            let viewModel = ProfileViewModel()
            let userInfo = UserInfoController()
            userInfo.dismissDelegate = parentVC.self
            userInfo.parentVC = parentVC
            guard let user = trendingUsersViewModel.listTrendingUsers?[indexPath.row] else { return }
            userInfo.user = user
            userInfo.viewModel = viewModel
            viewModel.getListModelFromServer(user.username, user.userID)
            self.parentVC?.addProfileControllerOnContainer(controller: userInfo)
        default:
            return
        }
        
    }
}

extension TabHomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case trendingNowCollectionView:
            return viewModel.episodes?.count ?? 0
        case featuredCollectionView:
            return viewModel.episodes?.count ?? 0
        case liveRoomsCollectionView:
            return 5
        case trendingUsersCollectionView:
            return trendingUsersViewModel.listTrendingUsers?.count ?? 0
        default:
            return 0
        }
//        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case trendingNowCollectionView:
            let cell = trendingNowCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEpisodeFlatListCell.identifier, for: indexPath) as! NewEpisodeFlatListCell
                  let episodes = viewModel.episodes
            
            let index = indexPath.row
            cell.episode = episodes?[index]
            cell.updateUI(episodes![index])
            
            cell.listModels = episodes
            cell.menuDelegate = menuDelegate
            cell.typeVC = self.typeVC
            cell.imgEpisode.isHidden = hideImg
            cell.showDelegate = self
            cell.itemDelegate = self.itemDelegate
            
            return cell
        case featuredCollectionView:
            let cell = featuredCollectionView?.dequeueReusableCell(withReuseIdentifier: NewPodcastCell.identifier, for: indexPath) as! NewPodcastCell
                  let showModel = viewModel.listFeaturedPodcast?[indexPath.row]
            cell.podcastViewModel = podcastViewModel
            cell.showModel = showModel
            cell.showDelegate = self
            return cell
        case liveRoomsCollectionView:
            let cell = liveRoomsCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEventCell.identifier, for: indexPath) as! NewEventCell
            return cell
        case trendingUsersCollectionView:
            let cell = trendingUsersCollectionView?.dequeueReusableCell(withReuseIdentifier: NewTrendingUserCell.identifier, for: indexPath) as! NewTrendingUserCell
            let model = trendingUsersViewModel.listTrendingUsers?[indexPath.row]
            cell.viewModel = trendingUsersViewModel
            cell.model = model
            cell.populateUserInfo(with: model!)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

extension TabHomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width
        switch collectionView {
        case trendingNowCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.26)
        case featuredCollectionView:
            return CGSize(width: width * 0.35, height: width * 0.48)
        case liveRoomsCollectionView:
            return CGSize(width: width * 0.9, height: width * 0.45)
        case trendingUsersCollectionView:
            return CGSize(width: width * 0.24, height: width * 0.32)
        default:
            return CGSize(width: width * 0, height: width * 0)
        }
    }
    
}

extension TabHomeController : GoToShowDelegate {
    func goToShowOf(_ model: EpisodeModel) {
        self.itemDelegate?.gotoEpisodeDetail(model)
    }

}

extension TabHomeController : FeaturedDelegate, HomeHeaderDelegage {

    func goToFeaturedShow(_ show: ShowModel) {
        self.itemDelegate?.clickItem(list: [], model: show, position: 0)
    }

    func goToFeatured(_ typeVC: Int) {
        if typeVC == IJamitConstants.TYPE_VC_FEATURED_AUDIO_BOOK || typeVC == IJamitConstants.TYPE_VC_FEATURED_PODCASTS {
            self.goToListShow(typeVC)
        }
        else if typeVC == IJamitConstants.TYPE_VC_FEATURED_STORY {
            if let episodeVC = self.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_FEATURED_STORY) {
                episodeVC.isShowHeader = true
                self.parentVC?.addControllerOnContainer(controller: episodeVC)
            }
        }
        else if typeVC == IJamitConstants.TYPE_VC_FEATURED_EVENT {
            self.goToHomeFeaturedEvent()
        }
    }
}


extension TabHomeController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! FeaturedShowController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        }
        return self.viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! FeaturedShowController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        if nextIndex >= self.viewControllers.count {
            return nil
        }
        return self.viewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = self.viewControllers.firstIndex(of: pendingViewControllers.first as! FeaturedShowController)!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentIndex = pendingIndex
            self.featurePageControl.currentPage = self.currentIndex
            self.schedulePageChange()
        }
    }
    
    func createViewControllerAtIndex(index: Int, _ show: ShowModel) -> FeaturedShowController {
        let featuredShowVC = FeaturedShowController.create(IJamitConstants.STORYBOARD_CHILD_IN_PAGE) as! FeaturedShowController
        featuredShowVC.show = show
        featuredShowVC.index = index
        featuredShowVC.bannerDelegate = self.delegate
        return featuredShowVC
    }
    
    func cancelTask(){
        self.autoChangeTimer.invalidate()
    }
    
    func schedulePageChange() {
        self.cancelTask()
        self.autoChangeTimer = Timer.scheduledTimer(timeInterval: IJamitConstants.TIME_FEATURED_PAGE_CHANGE, target: self, selector: #selector(autoChangePage), userInfo: nil, repeats: false)
    }
    
    @objc func autoChangePage() {
        if self.changePage(true) {
            self.schedulePageChange()
        }
    }
    
    func changePage( _ loop: Bool) -> Bool {
        var currentPage = self.currentIndex + 1
        if currentPage >= self.viewControllers.count {
            if loop {
                currentPage = 0
            }
            else{
                return false
            }
        }
        self.pageViewController.setViewControllers([self.viewControllers[currentPage]], direction: .forward, animated: true, completion: { (completed) in
            self.currentIndex = currentPage
            self.featurePageControl.currentPage = self.currentIndex
            if !loop {
                self.schedulePageChange()
            }
        })
        return true
    }
    
    
}


//extension TabHomeController : HomeHeaderDelegage {
//
////    func goToFeaturedShow(_ show: ShowModel) {
////        self.itemDelegate?.clickItem(list: [], model: show, position: 0)
////    }
//
//    func goToFeatured(_ typeVC: Int) {
//        if typeVC == IJamitConstants.TYPE_VC_FEATURED_AUDIO_BOOK || typeVC == IJamitConstants.TYPE_VC_FEATURED_PODCASTS {
//            self.goToListShow(typeVC)
//        }
//        else if typeVC == IJamitConstants.TYPE_VC_FEATURED_STORY {
//            if let episodeVC = self.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_FEATURED_STORY) {
//                episodeVC.isShowHeader = true
//                self.parentVC?.addControllerOnContainer(controller: episodeVC)
//            }
//        }
//        else if typeVC == IJamitConstants.TYPE_VC_FEATURED_EVENT {
//            self.goToHomeFeaturedEvent()
//        }
//    }
//
////    private func goToHomeFeaturedEvent() {
////        let eventVC = HomeEventController.create(IJamitConstants.STORYBOARD_EVENT) as! HomeEventController
////        eventVC.dismissDelegate = self.parentVC
////        eventVC.parentVC = self.parentVC
////        eventVC.eventDelegate = self.parentVC?.eventDelegate
////        self.parentVC?.addControllerOnContainer(controller: eventVC)
////    }
//
////    private func goToListShow(_ typeVC: Int){
////        let showVC = ShowController.create(IJamitConstants.STORYBOARD_SHOW) as! ShowController
////        showVC.itemDelegate = self.parentVC
////        showVC.dismissDelegate = self.parentVC
////        showVC.isAllowRefresh = true
////        showVC.titleScreen = getString(typeVC == IJamitConstants.TYPE_VC_FEATURED_PODCASTS ? StringRes.title_podcasts : StringRes.title_audio_books)
////        showVC.typeVC = typeVC
////        self.parentVC?.addControllerOnContainer(controller: showVC)
////    }
//
//}
