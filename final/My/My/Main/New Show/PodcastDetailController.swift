//
//  PodcastDetailController.swift
//  jamit
//
//  Created by Prof K on 4/22/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class PodcastDetailController: JamitRootViewController {
    
    var dismissDelegate: DismissDelegate?
    var eventDelegate: EventTotalDelegate?
    
    var parentVC: MainController?
    
    var menuDelegate: MenuEpisodeDelegate?
    
    var showModel: ShowModel?
    var episodeModel: [EpisodeModel]?
    
    var itemDelegate: AppItemDelegate?
    
    private var listTopics : [TopicModel]?
    private var totalEvent : TotalEventModel?
    var isDestroy = false
    
    var isAllowRefresh = true
    var isAllowLoadMore = false
    var isAllowAddObserver = false
    
    var typeVC: Int = 0
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backbutton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 25
        view.contentMode = .top
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let upperView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = getColor(hex: "#EB938B")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgShow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageRes.img_default)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let lblTitleShow: UILabel = {
        let label = UILabel()
        label.text = "Podcast Name"
        label.font = UIFont(name: "Poppins-SemiBold", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblAuthor: UILabel = {
        let label = UILabel()
        label.text = "Podcast Name"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let btnContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fillProportionally
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnRatings: UIButton = {
        let button = UIButton()
        button.cornerRadius = 5
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setTitle(" 5.0", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnFollowing: UIButton = {
        let button = UIButton()
        button.cornerRadius = 5
        button.setTitle("Following", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnSubscribe: UIButton = {
        let button = UIButton()
        button.cornerRadius = 5
        button.setTitle("Subscribe", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnMore: UIButton = {
        let button = UIButton()
        button.cornerRadius = 5
        button.setImage(UIImage(named: "ic_more_vert_white_24dp"), for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnCategoryView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnEpisode: UIButton = {
        let button = UIButton()
        button.cornerRadius = 10
        button.setTitle("Episodes(0)", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        button.backgroundColor = getColor(hex: ColorRes.color_accent)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnOverview: UIButton = {
        let button = UIButton()
        button.cornerRadius = 10
        button.backgroundColor = getColor(hex: "#171715")
        button.setTitle("Overview", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        //        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lowerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let episodeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lowerContainerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .fillProportionally
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lowerContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "No information regarding this podcast yet, although this might be an episode."
        label.numberOfLines = 0
        label.backgroundColor = .black
        label.textColor = .white
        label.contentMode = .top
        label.textAlignment = .justified
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        //        label.layoutIfNeeded()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moreLabel: UILabel = {
        let label = UILabel()
        label.layoutIfNeeded()
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.text = "More like this"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.layoutIfNeeded()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    var episodeCollectionView: UICollectionView?
    var categoryCollectionView: UICollectionView?
    var moreCollectionView: UICollectionView?
    
    var viewModel: PodDetailViewModel?
    let refreshControl = UIRefreshControl()
    
    var episodeButtonSelected: Bool = false
    //    var OverviewSelected: Bool = false
    
    private let fakeLabel = UILabel()
    private let fakeInfoLabel = UILabel()
    
    private let tagFont = UIFont.init(name: IJamitConstants.FONT_MEDIUM, size: DimenRes.size_text_tag_view) ?? UIFont.systemFont(ofSize: DimenRes.size_text_tag_view)
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 0)
    
    private var heightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let showModel = showModel {
            viewModel = PodDetailViewModel(showModel: showModel)
        }
        
        infoLabel.text = showModel?.description
        startLoadData(false)
        view.backgroundColor = .black
        let width = view.frame.width
        let height = view.frame.height
        let mainHeight = (height + width ) * 0.88
        
        heightConstraint = NSLayoutConstraint(item: bgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: mainHeight)
        
        //        }
        
        setupView()
        setupConstraints()
        
        bgView.addConstraint(heightConstraint!)
        self.setUpRefresh()
        self.startLoadData(false)
        backbutton.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
        lowerContentView.isHidden = true
        dataListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpInfo(showModel, showModel?.numEpisodes ?? 0)
        lowerContainerView.layoutSubviews()
        lowerContainerView.layoutIfNeeded()
        dataListener()
    }
    
    func dataListener() {
        viewModel?.reloadTopic = { [weak self] in
            print("This is the reload topic")
            self?.setUpCategoryView()
            self?.listTopics = self?.viewModel?.listTopics
            DispatchQueue.main.async {
                self?.categoryCollectionView?.reloadData()
            }
        }
        
        viewModel?.reloadEpisode = { [weak self] in
            print("This is the reload episode")
            //            self?.episodeButtonSelected = true
            self?.episodeModel = self?.viewModel?.episodeModel
            DispatchQueue.main.async {
                self?.episodeCollectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = UICollectionViewFlowLayout()
        
        let collectionLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        
        
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionLayout.scrollDirection = .horizontal
        
        episodeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        
        moreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        
        
        guard let episodeCollectionView = episodeCollectionView,
              let moreCollectionView = moreCollectionView else {
                  return
              }
        
        setUpEpisodeView(episodeCollectionView: episodeCollectionView)
        
        setUpMoreView(moreCollectionView: moreCollectionView)
        
        
        
        
    }
    
    func setUpEpisodeView(episodeCollectionView: UICollectionView) {
        episodeContainerView.addSubview(episodeCollectionView)
        episodeCollectionView.frame = episodeContainerView.bounds
        
        episodeCollectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
        episodeCollectionView.backgroundColor = .black
        episodeCollectionView.dataSource = self
        episodeCollectionView.delegate = self
    }
    
    func setUpCategoryView() {
        let layoutTopic = UICollectionViewFlowLayout()
        layoutTopic.estimatedItemSize = CGSize(width: 4 *  DimenRes.height_tag_view, height: DimenRes.height_tag_view)
        layoutTopic.scrollDirection = .horizontal
        layoutTopic.minimumLineSpacing = DimenRes.medium_padding + 5
        layoutTopic.minimumInteritemSpacing = DimenRes.medium_padding + 5
        layoutTopic.sectionInset = sectionInsets
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutTopic)
        
        guard let categoryCollectionView = categoryCollectionView else {
            return
        }
        
        categoryCollectionView.register(UINib(nibName: "TopicCell", bundle: nil), forCellWithReuseIdentifier: "TopicCell")
        
        categoryView.addSubview(categoryCollectionView)
        categoryCollectionView.frame = categoryView.bounds
        
        
        categoryCollectionView.backgroundColor = .black
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    func setUpMoreView(moreCollectionView: UICollectionView) {
        moreView.addSubview(moreCollectionView)
        moreCollectionView.frame = moreView.bounds
        moreCollectionView.backgroundColor = .black
        moreCollectionView.register(NewPodcastCell.self, forCellWithReuseIdentifier: NewPodcastCell.identifier)
        
        moreCollectionView.dataSource = self
        moreCollectionView.delegate = self
    }
    func setUpRefresh(){
        self.refreshControl.tintColor = getColor(hex: ColorRes.color_pull_to_refresh)
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
    }
    
    private func showLoading(_ isShow: Bool) {
        //        self.progressBar.isHidden = !isShow
        //        if isShow {
        //            self.progressBar.startAnimating()
        //            self.scrollView.isHidden = true
        //        }
        //        else{
        //            self.progressBar.stopAnimating()
        //
        //        }
    }
    
    @objc private func pullToRefresh() {
        self.startLoadData(true)
    }
    
    private func startLoadData(_ isRefresh: Bool) {
        if !ApplicationUtils.isOnline() {
            //            self.refreshControl.endRefreshing()
            self.showToast(with: StringRes.info_lose_internet)
            return
        }
        if !isRefresh {
            self.showLoading(true)
            
        }
    }
    
    
    
    @objc func btnBackTapped(_ sender: UIButton) {
        self.isDestroy = true
        self.view.removeFromSuperview()
        self.dismissDelegate?.dismiss(controller: self)
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    private func setupView() {
        
        view.addSubview(scrollView)
        scrollView.pin(to: view, top: 0, left: 0, bottom: 0, right: 0)
        scrollView.addSubview(containerView)
        containerView.pin(to: scrollView)
//        containerView.addArrangedSubview(bgView)
        containerView.addSubview(bgView)
        bgView.pin(to: containerView)
        bgView.addSubview(upperView)
        bgView.addSubview(btnView)
        upperView.pin(to: bgView, top: 0, left: 0, bottom: nil, right: 0)
        btnView.pin(to: bgView, top: nil, left: 20, bottom: nil, right: -20)
        btnView.addSubview(btnCategoryView)
        btnCategoryView.pin(to: btnView)
        upperView.addSubview(imgShow)
        upperView.addSubview(lblTitleShow)
        upperView.addSubview(lblAuthor)
        upperView.addSubview(btnContainerView)
        
        [btnRatings, btnFollowing, btnSubscribe, btnMore].forEach { newView in
            btnContainerView.addArrangedSubview(newView)
        }
        
        [btnEpisode, btnOverview].forEach { button in
            btnCategoryView.addArrangedSubview(button)
        }
        //        DispatchQueue.main.async {
        btnEpisode.addTarget(self, action: #selector(btnEpisodeClicked), for: .touchUpInside)
        btnOverview.addTarget(self, action: #selector(btnOverviewClicked), for: .touchUpInside)
        //        }
        
        
        view.addSubview(topView)
        topView.pin(to: view, top: 0, left: 0, bottom: nil, right: 0)
        topView.addSubview(backbutton)
        
        
        bgView.addSubview(lowerView)
        lowerView.pin(to: bgView, top: nil, left: 0, bottom: 0, right: 0)
        lowerView.addSubview(lowerContentView)
        lowerView.addSubview(episodeContainerView)
        episodeContainerView.pin(to: lowerView, top: 0, left: 20, bottom: 0, right: -20)
        lowerContentView.pin(to: lowerView, top: 0, left: 20, bottom: 0, right: -20)
        
        lowerContentView.addSubview(categoryView)
        categoryView.pin(to: lowerContentView, top: 0, left: 0, bottom: nil, right: 0)
        
        lowerContentView.addSubview(infoLabel)
        infoLabel.pin(to: lowerContentView, top: nil, left: 0, bottom: nil, right: 0)
        
        lowerContentView.addSubview(moreLabel)
        moreLabel.pin(to: lowerContentView, top: nil, left: 0, bottom: nil, right: 0)
        
        lowerContentView.addSubview(moreView)
        moreView.pin(to: lowerContentView, top: nil, left: 0, bottom: nil, right: 0)
        //        lowerContainerView.addArrangedSubview(categoryView)
        //        lowerContainerView.addArrangedSubview(infoLabel)
        //        lowerContainerView.addArrangedSubview(moreLabel)
        //        lowerContainerView.addArrangedSubview(moreView)
        //        lowerContainerView.addArrangedSubview(emptyView)
        
        emptyView.addSubview(emptyLabel)
        emptyLabel.pin(to: emptyView)
        
        
    }
    
    //    func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
    //        if  self.showModel != nil && ApplicationUtils.isOnline(){
    //            JamItPodCastApi.getDetailShow(showModel!.slug) { (result) in
    //                if let show = result  {
    //                    self.showModel?.reviews = show.reviews
    //                    self.showModel?.subscribers = show.subscribers
    //                    self.showModel?.description = show.description
    //                    self.showModel?.numEpisodes = show.numEpisodes
    //                    self.showModel?.author = show.author
    //                    self.showModel?.summary = show.summary
    //                    self.showModel?.title = show.title
    //                    self.showModel?.tipSupportUrl = show.tipSupportUrl
    //                }
    //                JamItPodCastApi.getEpisodesOfShow(self.showModel!.id) { (list) in
    //                    completion(self.convertListModelToResultModel(list))
    //                }
    //            }
    //
    //            return
    //        }
    //        completion(nil)
    //    }
    
    private func setupConstraints() {
        let width = view.frame.width
        let height = view.frame.height
        let mainHeight = (height + width ) * 0.89
        
        if height < 600 {
            lblTitleShow.numberOfLines = 1
        } else {
            lblTitleShow.numberOfLines = 0
        }
        imgShow.layer.cornerRadius = 12
        imgShow.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            backbutton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            backbutton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            topView.heightAnchor.constraint(equalToConstant: 50),
            //            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            upperView.heightAnchor.constraint(equalToConstant: width * 0.9),
            imgShow.centerXAnchor.constraint(equalTo: upperView.centerXAnchor),
//            imgShow.heightAnchor.constraint(equalToConstant: 135),
//            imgShow.widthAnchor.constraint(equalToConstant: 135),
            imgShow.heightAnchor.constraint(equalTo: upperView.widthAnchor, multiplier: 0.38),
            imgShow.widthAnchor.constraint(equalTo: upperView.widthAnchor, multiplier: 0.38),
            imgShow.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 55),
            lblTitleShow.topAnchor.constraint(equalTo: imgShow.bottomAnchor, constant: width * 0.03),
            lblTitleShow.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            lblTitleShow.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            //            lblTitleShow.heightAnchor.constraint(equalToConstant: 60),
            
            lblAuthor.topAnchor.constraint(equalTo: lblTitleShow.bottomAnchor, constant: width * 0),
            lblAuthor.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            lblAuthor.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            lblAuthor.heightAnchor.constraint(equalToConstant: 30),
            
            btnView.heightAnchor.constraint(equalToConstant: 55),
            btnView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 12),
            btnContainerView.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: -width * 0.04),
            btnContainerView.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            btnContainerView.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            btnContainerView.heightAnchor.constraint(equalToConstant: 35),
            lowerView.topAnchor.constraint(equalTo: btnCategoryView.bottomAnchor, constant: 10),
            lowerView.heightAnchor.constraint(equalToConstant: bgView.bounds.height - (width + 35)),
            categoryView.heightAnchor.constraint(equalToConstant: 40),
            
            episodeContainerView.heightAnchor.constraint(equalToConstant: mainHeight - (35 + width)),
            
            infoLabel.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 12),
            
            moreLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            
            moreView.topAnchor.constraint(equalTo: moreLabel.bottomAnchor, constant: 10),
            moreView.heightAnchor.constraint(equalToConstant: 160),
            
//            bgView.heightAnchor.constraint(equalToConstant: mainHeight)
        ])
        
    }
    
    func setUpInfo(_ show: ShowModel?, _ numEpisodes: Int ) {
        if show != nil {
            self.showModel = show
            self.lblTitleShow.text = show!.title
            let author = !show!.author.isEmpty ? show!.author : getString(StringRes.app_name)
            self.lblAuthor.text = String(format: getString(StringRes.format_with), author)
            if numEpisodes > 1 {
                btnEpisode.setTitle("Episodes(\(numEpisodes))", for: .normal)
            } else {
                btnEpisode.setTitle("Episode(\(numEpisodes))", for: .normal)
            }
            
            //            self.lblNumEpisode.text =  StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(numEpisodes))
            
            self.infoLabel.setHtmlString(show!.description)
            //            infoLabel.text = show?.summary
            
            let imgUrl: String = show!.imageUrl
            if imgUrl.starts(with: "http") {
                self.imgShow.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_default))
            }
            else {
                self.imgShow.image = UIImage(named: ImageRes.img_default)
            }
            let isSubscibre = show?.isSubscribed(SettingManager.getUserId()) ?? false
            self.updateSubscribe(isSubscibre)
            
            //            self.lblSupport.text = getString(StringRes.title_support)
            //            let setting = TotalDataManager.shared.getSetting()
            //            let isSupport = setting?.isTipSupport ?? false
            //            let tipUrlEmpty = show?.tipSupportUrl.isEmpty ?? true
            //            let showTip = isSupport && !tipUrlEmpty
            //            self.btnSupport.isHidden = !showTip
        }
    }
    
    @objc private func btnEpisodeClicked(_ sender: UIButton) {
        changeView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.episodeSelected()
            self.episodeCollectionView?.reloadData()
        }
        
    }
    
    private func changeView() {
        
        let width = view.frame.width
        let height = view.frame.height
        let mainHeight = (height + width ) * 0.93
        DispatchQueue.main.async {
            self.heightConstraint?.constant = mainHeight
        }
        self.episodeCollectionView?.reloadData()
    }
    @objc private func btnOverviewClicked(_ sender: UIButton) {
        let width = view.frame.width
        let height = 40 + infoLabel.bounds.height + moreView.bounds.height + 100
        let mainHeight = height + width
        overviewSelected()
        
        DispatchQueue.main.async {
            self.categoryCollectionView?.reloadData()
        }
        
        lowerContentView.isHidden = false
        episodeContainerView.isHidden = true
        episodeButtonSelected = false
        self.heightConstraint?.constant = mainHeight
    }
    
    func clearSelection() {
        btnEpisode.backgroundColor = getColor(hex: "#171715")
        btnEpisode.setTitleColor(.white, for: .normal)
        btnOverview.backgroundColor = getColor(hex: "#171715")
        btnOverview.setTitleColor(.white, for: .normal)
    }
    
    func episodeSelected() {
        clearSelection()
        btnEpisode.backgroundColor = getColor(hex: ColorRes.color_accent)
        btnEpisode.setTitleColor(.black, for: .normal)
        
        DispatchQueue.main.async {
            self.episodeCollectionView?.reloadData()
            self.lowerContentView.isHidden = true
            self.episodeContainerView.isHidden = false
            
        }
        
    }
    
    func goToTopicEvents(topic: TopicModel) {
        if let eventVC = TopicEventController.create(IJamitConstants.STORYBOARD_EVENT) as? TopicEventController {
            eventVC.dismissDelegate = self.parentVC
            eventVC.eventDelegate = self.eventDelegate
            eventVC.parentVC = self.parentVC
            eventVC.topic = topic
            self.parentVC?.addControllerOnContainer(controller: eventVC)
        }
        
    }
    
    
    func overviewSelected() {
        
        clearSelection()
        btnOverview.backgroundColor = getColor(hex: ColorRes.color_accent)
        btnOverview.setTitleColor(.black, for: .normal)
        DispatchQueue.main.async {
            self.lowerContentView.isHidden = false
            self.episodeContainerView.isHidden = true
        }
        
    }
    
    func updateSubscribe(_ isSubscibre : Bool) {
        //        self.lblSubcribe.text = getString(isSubscibre ? StringRes.title_subscribed : StringRes.title_subscribe)
        //        self.imgSubcribe.image = UIImage(named: isSubscibre ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp)
        //        self.btnSubcribe.backgroundColor = isSubscibre ? UIColor.clear : getColor(hex: ColorRes.subscribe_color)
        //        self.btnSubcribe.borderColor = isSubscibre ? UIColor.white : UIColor.clear
        //        self.btnSubcribe.borderWidth = CGFloat(isSubscibre ? 1 : 0)
    }
    
}

extension PodcastDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case episodeCollectionView:
            return episodeModel?.count ?? 0
        case categoryCollectionView:
            return viewModel?.listTopics?.count ?? 0
        case moreCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case episodeCollectionView:
            guard let cell = episodeCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEpisodeFlatListCell.identifier, for: indexPath) as? NewEpisodeFlatListCell,
                  let episode = episodeModel?[indexPath.row] else {
                      return UICollectionViewCell()
                  }
            cell.updateUI(episode)
            //                cell.updateUI(model, tagFont)
            return cell
        case categoryCollectionView:
            guard let cell = categoryCollectionView?.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell,
                  let model = viewModel?.listTopics?[indexPath.row] else {
                      print("This is the else part")
                      return UICollectionViewCell()
                  }
            
            cell.updateUI(model, tagFont)
            cell.rootLayout.backgroundColor = .clear
            return cell
        case moreCollectionView:
            guard let cell = moreCollectionView?.dequeueReusableCell(withReuseIdentifier: NewPodcastCell.identifier, for: indexPath) as? NewPodcastCell else {
                return UICollectionViewCell()
            }
            //            cell.configure(with: liveEvent)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

extension PodcastDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case episodeCollectionView:
            break
        case categoryCollectionView:
            if let topic = self.viewModel?.listTopics?[indexPath.row] {
                self.goToTopicEvents(topic: topic)
            }
        default:
            break
        }
    }
}

extension PodcastDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width
        let height = width * 0.24
        switch collectionView {
        case episodeCollectionView:
            //            if episodeOverSelected {
            return CGSize(width: width - 40, height: height)
            
            //            } else {
            
            //            }
        case categoryCollectionView:
            let model = self.viewModel?.listTopics?[indexPath.row]
            let realTextWidth = fakeLabel.caculateWidth(DimenRes.height_tag_view, model?.name ?? "")
            let realWidth = realTextWidth + 3 * DimenRes.small_padding + DimenRes.size_tag_image
            return CGSize(width: realWidth, height: DimenRes.height_tag_view)
            //            return CGSize(width: 0, height: 0)
        case moreCollectionView:
            return CGSize(width: width * 0.35, height: width * 0.48)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
}
