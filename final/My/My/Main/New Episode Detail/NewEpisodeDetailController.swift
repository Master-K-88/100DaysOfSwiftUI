//
//  NewEpisodeDetailController.swift
//  jamit
//
//  Created by Prof K on 5/6/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewEpisodeDetailController: JamitRootViewController {
    
    var dismissDelegate: DismissDelegate?
    var eventDelegate: EventTotalDelegate?
    
    var parentVC: MainController?
    
    var menuDelegate: MenuEpisodeDelegate?
    
    var episodeModel: EpisodeModel?
    
    var itemDelegate: AppItemDelegate?
    
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
        view.layer.cornerRadius = 20
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
//        label.font = UIFont(name: "Poppins-SemiBold", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblAuthor: UILabel = {
        let label = UILabel()
        label.text = "Podcast Name"
        label.font = UIFont(name: "Poppins-SemiBold", size: 16)
//        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let queueView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let queueImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let queueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Queue"
        label.textColor = .systemGray
        return label
    }()
    
    private let queueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let downloadImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_download_white_36dp")
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let downloadLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Load"
        label.textColor = .systemGray
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: ColorRes.color_accent)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_play_white_36dp")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        return imageView
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let shareView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shareImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "paperplane")
        return imageView
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Share"
        label.textColor = .systemGray
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let favImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_heart_outline_grey_36dp")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let favLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "25"
        label.textColor = .systemGray
        return label
    }()
    
    private let favButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let subscribeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 3
        button.clipsToBounds = true
        button.setTitle("  SUBSCRIBE  ", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 14)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private let lowerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemYellow
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private let episodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cheap talk"
        label.numberOfLines = 1
        label.font = UIFont(name: "Poppins-Bold", size: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let numberOfSubscriber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4 Subscribers"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let episodeInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textColor = .white
        return label
    }()
    
    let refreshControl = UIRefreshControl()
    
    private var heightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoadData(false)
        view.backgroundColor = .black
        let width = view.frame.width
        let height = view.frame.height
        let mainHeight = (height + width ) * 0.88
        
        print("The view height is: \(height)")
        
        
        heightConstraint = NSLayoutConstraint(item: bgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: mainHeight)
        
        setupView()
        setupConstraints()
        setUpInfo(self.episodeModel)
        
        bgView.addConstraint(heightConstraint!)
        self.setUpRefresh()
        self.startLoadData(false)
        backbutton.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setUpInfo(showModel, showModel?.numEpisodes ?? 0)
//        lowerContainerView.layoutSubviews()
//        lowerContainerView.layoutIfNeeded()
//        dataListener()
//    }
    
//    func dataListener() {
//        viewModel?.reloadTopic = { [weak self] in
//            print("This is the reload topic")
//            self?.setUpCategoryView()
//            self?.listTopics = self?.viewModel?.listTopics
//            DispatchQueue.main.async {
//                self?.categoryCollectionView?.reloadData()
//            }
//        }
//
//        viewModel?.reloadEpisode = { [weak self] in
//            print("This is the reload episode")
//            //            self?.episodeButtonSelected = true
//            self?.episodeModel = self?.viewModel?.episodeModel
//            DispatchQueue.main.async {
//                self?.episodeCollectionView?.reloadData()
//            }
//        }
//    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let layout = UICollectionViewFlowLayout()
//
//        let collectionLayout = UICollectionViewFlowLayout()
//
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.scrollDirection = .vertical
//
//
//        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionLayout.scrollDirection = .horizontal
//
//        episodeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//
//
//        moreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
//
//
//        guard let episodeCollectionView = episodeCollectionView,
//              let moreCollectionView = moreCollectionView else {
//                  return
//              }
//
//        setUpEpisodeView(episodeCollectionView: episodeCollectionView)
//
//        setUpMoreView(moreCollectionView: moreCollectionView)
//
//
//
//
//    }
    
//    func setUpEpisodeView(episodeCollectionView: UICollectionView) {
//        episodeContainerView.addSubview(episodeCollectionView)
//        episodeCollectionView.frame = episodeContainerView.bounds
//
//        episodeCollectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
//        episodeCollectionView.backgroundColor = .black
//        episodeCollectionView.dataSource = self
//        episodeCollectionView.delegate = self
//    }
    
//    func setUpCategoryView() {
//        let layoutTopic = UICollectionViewFlowLayout()
//        layoutTopic.estimatedItemSize = CGSize(width: 4 *  DimenRes.height_tag_view, height: DimenRes.height_tag_view)
//        layoutTopic.scrollDirection = .horizontal
//        layoutTopic.minimumLineSpacing = DimenRes.medium_padding + 5
//        layoutTopic.minimumInteritemSpacing = DimenRes.medium_padding + 5
//        layoutTopic.sectionInset = sectionInsets
//
//        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutTopic)
//
//        guard let categoryCollectionView = categoryCollectionView else {
//            return
//        }
//
//        categoryCollectionView.register(UINib(nibName: "TopicCell", bundle: nil), forCellWithReuseIdentifier: "TopicCell")
//
//        categoryView.addSubview(categoryCollectionView)
//        categoryCollectionView.frame = categoryView.bounds
//
//
//        categoryCollectionView.backgroundColor = .black
//
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.delegate = self
//    }
//    func setUpMoreView(moreCollectionView: UICollectionView) {
//        moreView.addSubview(moreCollectionView)
//        moreCollectionView.frame = moreView.bounds
//        moreCollectionView.backgroundColor = .black
//        moreCollectionView.register(NewPodcastCell.self, forCellWithReuseIdentifier: NewPodcastCell.identifier)
//
//        moreCollectionView.dataSource = self
//        moreCollectionView.delegate = self
//    }
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
        bgView.addSubview(buttonsView)
        upperView.pin(to: bgView, top: 0, left: 0, bottom: nil, right: 0)
        buttonsView.pin(to: bgView, top: nil, left: 20, bottom: nil, right: -20)
//        buttonsView.addSubview(btnCategoryView)
//        btnCategoryView.pin(to: buttonsView)
        upperView.addSubview(imgShow)
        upperView.addSubview(lblTitleShow)
        upperView.addSubview(lblAuthor)
//        upperView.addSubview(btnContainerView)
        [queueView, downloadView, playView, shareView, favView].forEach { view in
            buttonsView.addSubview(view)
            if view === queueView {
                print("This is queue view")
                view.pin(to: buttonsView, top: 0, left: 0, bottom: 0, right: nil)
            } else if view === favView {
                print("This is fav view")
                view.pin(to: buttonsView, top: 0, left: nil, bottom: 0, right: 0)
            } else if view === playView {
                print("This is other view")
                view.pin(to: buttonsView, top: nil, left: nil, bottom: nil, right: nil)
            } else {
                print("This is other view")
                view.pin(to: buttonsView, top: 0, left: nil, bottom: 0, right: nil)
            }
            
        }
        bgView.addSubview(subscribeView)
        subscribeView.pin(to: bgView, top: nil, left: 20, bottom: nil, right: -20)
        
        [episodeImage, episodeTitleLabel, numberOfSubscriber, subscribeButton].forEach { new in
            subscribeView.addSubview(new)
        }
        
        bgView.addSubview(episodeInfoLabel)
        episodeInfoLabel.pin(to: bgView, top: nil, left: 20, bottom: nil, right: -20)
        
        view.addSubview(topView)
        topView.pin(to: view, top: 0, left: 0, bottom: nil, right: 0)
        topView.addSubview(backbutton)
        
        queueView.addSubview(queueImg)
        queueView.addSubview(queueLabel)
        queueView.addSubview(queueButton)
        queueButton.pin(to: queueView)
        
        downloadView.addSubview(downloadImage)
        downloadView.addSubview(downloadLabel)
        downloadView.addSubview(downloadButton)
        downloadButton.pin(to: downloadView)
        
        playView.addSubview(playContainerView)
//        playContainerView.pin(to: playView)
        playView.addSubview(playImage)
        playView.addSubview(playButton)
        playButton.pin(to: playView)
        
        shareView.addSubview(shareImage)
        shareView.addSubview(shareLabel)
        shareView.addSubview(shareButton)
        shareButton.pin(to: shareView)
        
        favView.addSubview(favImage)
        favView.addSubview(favLabel)
        favView.addSubview(favButton)
        favButton.pin(to: favView)
        
        
        
    }
    
//        func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
//            if  self.showModel != nil && ApplicationUtils.isOnline(){
//                JamItPodCastApi.getDetailShow(showModel!.slug) { (result) in
//                    if let show = result  {
//                        self.showModel?.reviews = show.reviews
//                        self.showModel?.subscribers = show.subscribers
//                        self.showModel?.description = show.description
//                        self.showModel?.numEpisodes = show.numEpisodes
//                        self.showModel?.author = show.author
//                        self.showModel?.summary = show.summary
//                        self.showModel?.title = show.title
//                        self.showModel?.tipSupportUrl = show.tipSupportUrl
//                    }
//                    JamItPodCastApi.getEpisodesOfShow(self.showModel!.id) { (list) in
//                        completion(self.convertListModelToResultModel(list))
//                    }
//                }
//
//                return
//            }
//            completion(nil)
//        }
    
    private func setupConstraints() {
        let width = view.frame.width
        let height = view.frame.height
        let buttonWidth = ((width - 40) * 0.2) - 2
        let mainHeight = (height + width ) * 0.89
        imgShow.layer.cornerRadius = 12
        imgShow.clipsToBounds = true
        playContainerView.cornerRadius = (buttonWidth * 0.9) * 0.5
        NSLayoutConstraint.activate([
            backbutton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            backbutton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            topView.heightAnchor.constraint(equalToConstant: 50),
            //            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            upperView.heightAnchor.constraint(equalToConstant: width * 0.9),
            imgShow.centerXAnchor.constraint(equalTo: upperView.centerXAnchor),
//            imgShow.heightAnchor.constraint(equalToConstant: 135),
            imgShow.heightAnchor.constraint(equalTo: upperView.widthAnchor, multiplier: 0.45),
            imgShow.widthAnchor.constraint(equalTo: upperView.widthAnchor, multiplier: 0.45),
            imgShow.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 55),
            lblTitleShow.topAnchor.constraint(equalTo: imgShow.bottomAnchor, constant: width * 0.03),
            lblTitleShow.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            lblTitleShow.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            //         width * 0.03   lblTitleShow.heightAnchor.constraint(equalToConstant: 60),
            
            lblAuthor.topAnchor.constraint(equalTo: lblTitleShow.bottomAnchor, constant: width * 0.03),
            lblAuthor.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 20),
            lblAuthor.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -20),
            lblAuthor.heightAnchor.constraint(equalToConstant: 30),
            
            
            buttonsView.heightAnchor.constraint(equalToConstant: buttonWidth + 8),
            buttonsView.topAnchor.constraint(equalTo: upperView.bottomAnchor),
            queueView.widthAnchor.constraint(equalToConstant: buttonWidth),
            downloadView.leadingAnchor.constraint(equalTo: queueView.trailingAnchor, constant: 0),
            downloadView.widthAnchor.constraint(equalToConstant: buttonWidth),
            playView.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -buttonWidth * 0.3),
            playView.leadingAnchor.constraint(equalTo: downloadView.trailingAnchor, constant: 0),
            playView.widthAnchor.constraint(equalToConstant: buttonWidth + 8),
            playView.heightAnchor.constraint(equalToConstant: buttonWidth + 8),
            
            playContainerView.topAnchor.constraint(equalTo: playView.topAnchor, constant: buttonWidth * 0.1),
            playContainerView.leadingAnchor.constraint(equalTo: playView.leadingAnchor, constant: buttonWidth * 0.1),
            playContainerView.widthAnchor.constraint(equalToConstant: buttonWidth * 0.9),
            playContainerView.heightAnchor.constraint(equalToConstant: buttonWidth * 0.9),
            
            shareView.trailingAnchor.constraint(equalTo: favView.leadingAnchor),
            shareView.widthAnchor.constraint(equalToConstant: buttonWidth),
            favView.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            queueImg.topAnchor.constraint(equalTo: queueView.topAnchor, constant: width * 0.05),
            queueImg.centerXAnchor.constraint(equalTo: queueView.centerXAnchor),
            queueImg.heightAnchor.constraint(equalTo: queueView.heightAnchor, multiplier: 0.35),
            queueImg.widthAnchor.constraint(equalTo: queueView.heightAnchor, multiplier: 0.35),
            
            queueLabel.topAnchor.constraint(equalTo: queueImg.bottomAnchor, constant: 0),
            queueLabel.centerXAnchor.constraint(equalTo: queueView.centerXAnchor),
            
            
            downloadImage.topAnchor.constraint(equalTo: downloadView.topAnchor, constant: width * 0.05),
            downloadImage.centerXAnchor.constraint(equalTo: downloadView.centerXAnchor),
            downloadImage.heightAnchor.constraint(equalTo: downloadView.heightAnchor, multiplier: 0.35),
            downloadImage.widthAnchor.constraint(equalTo: downloadView.heightAnchor, multiplier: 0.35),
            
            downloadLabel.topAnchor.constraint(equalTo: downloadImage.bottomAnchor, constant: 0),
            downloadLabel.centerXAnchor.constraint(equalTo: downloadView.centerXAnchor),
            
//            playImage.topAnchor.constraint(equalTo: playView.topAnchor, constant: width * 0.02),
            playImage.centerXAnchor.constraint(equalTo: playView.centerXAnchor),
            playImage.centerYAnchor.constraint(equalTo: playView.centerYAnchor),
            playImage.heightAnchor.constraint(equalTo: playView.heightAnchor, multiplier: 0.55),
            playImage.widthAnchor.constraint(equalTo: playView.heightAnchor, multiplier: 0.55),
            
            shareImage.topAnchor.constraint(equalTo: shareView.topAnchor, constant: width * 0.05),
            shareImage.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            shareImage.heightAnchor.constraint(equalTo: shareView.heightAnchor, multiplier: 0.35),
            shareImage.widthAnchor.constraint(equalTo: shareView.heightAnchor, multiplier: 0.35),
            
            shareLabel.topAnchor.constraint(equalTo: shareImage.bottomAnchor, constant: 0),
            shareLabel.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            
            favImage.topAnchor.constraint(equalTo: favView.topAnchor, constant: width * 0.05),
            favImage.centerXAnchor.constraint(equalTo: favView.centerXAnchor),
            favImage.heightAnchor.constraint(equalTo: favView.heightAnchor, multiplier: 0.35),
            favImage.widthAnchor.constraint(equalTo: favView.heightAnchor, multiplier: 0.35),
            
            favLabel.topAnchor.constraint(equalTo: favImage.bottomAnchor, constant: 0),
            favLabel.centerXAnchor.constraint(equalTo: favView.centerXAnchor),
            
            subscribeView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            subscribeView.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            episodeImage.heightAnchor.constraint(equalTo: subscribeView.heightAnchor, multiplier: 0.8),
            episodeImage.widthAnchor.constraint(equalTo: subscribeView.heightAnchor, multiplier: 0.8),
            episodeImage.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
            episodeImage.leadingAnchor.constraint(equalTo: subscribeView.leadingAnchor),
            
            numberOfSubscriber.leadingAnchor.constraint(equalTo: episodeImage.trailingAnchor, constant: 5),
            numberOfSubscriber.bottomAnchor.constraint(equalTo: subscribeView.bottomAnchor, constant: -buttonWidth * 0.2),
            
            episodeTitleLabel.leadingAnchor.constraint(equalTo: numberOfSubscriber.leadingAnchor),
//            episodeTitleLabel.trailingAnchor.constraint(equalTo: subscribeButton.leadingAnchor, constant: -5),
            episodeTitleLabel.widthAnchor.constraint(equalTo: subscribeView.widthAnchor, multiplier: 0.55),
            episodeTitleLabel.bottomAnchor.constraint(equalTo: numberOfSubscriber.topAnchor, constant: -5),
            
            subscribeButton.trailingAnchor.constraint(equalTo: subscribeView.trailingAnchor, constant: 0),
            subscribeButton.centerYAnchor.constraint(equalTo: subscribeView.centerYAnchor),
            
            episodeInfoLabel.topAnchor.constraint(equalTo: subscribeView.bottomAnchor),
            
        ])
        
    }
    
    func setUpInfo(_ episode: EpisodeModel?) {
        if let episode = episode {
            //            self.showModel = show
            self.lblTitleShow.text = episode.createDate
//            let author =
            self.lblAuthor.text = episode.audioTitle
//            String(format: getString(StringRes.format_with), author)
            episodeTitleLabel.text = episode.title
            if let numberOfSubscribers = episode.showModel?.subscribers?.count {
                if numberOfSubscribers > 1 {
                    numberOfSubscriber.text =  "\(numberOfSubscribers) Subscribers"
                } else {
                    numberOfSubscriber.text =  "\(numberOfSubscribers) Subscriber"
                }
                
            }
            numberOfSubscriber.text =  "0 Subscriber"
            
            
//            episodeInfoLabel.text = episode.summary
//            if numEpisodes > 1 {
//                btnEpisode.setTitle("Episodes(\(numEpisodes))", for: .normal)
//            } else {
//                btnEpisode.setTitle("Episode(\(numEpisodes))", for: .normal)
//            }
            
            //            self.lblNumEpisode.text =  StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(numEpisodes))
            
            self.episodeInfoLabel.setHtmlString(episode.description.shorted(to: 100))
            //            infoLabel.text = show?.summary
            
            let imgUrl: String = episode.imageUrl
            if imgUrl.starts(with: "http") {
                self.imgShow.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_default))
                self.episodeImage.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_default))
            }
            else {
                self.imgShow.image = UIImage(named: ImageRes.img_default)
                self.episodeImage.image = UIImage(named: ImageRes.img_default)
            }
//            let isSubscibre = show?.isSubscribed(SettingManager.getUserId()) ?? false
//            self.updateSubscribe(isSubscibre)
            
            //            self.lblSupport.text = getString(StringRes.title_support)
            //            let setting = TotalDataManager.shared.getSetting()
            //            let isSupport = setting?.isTipSupport ?? false
            //            let tipUrlEmpty = show?.tipSupportUrl.isEmpty ?? true
            //            let showTip = isSupport && !tipUrlEmpty
            //            self.btnSupport.isHidden = !showTip
        }
    }
    
//    @objc private func btnEpisodeClicked(_ sender: UIButton) {
//        changeView()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.episodeSelected()
////            self.episodeCollectionView?.reloadData()
//        }
//        
//    }
    
    private func changeView() {
        
        let width = view.frame.width
        let height = view.frame.height
        let mainHeight = (height + width ) * 0.93
        DispatchQueue.main.async {
            self.heightConstraint?.constant = mainHeight
        }
//        self.episodeCollectionView?.reloadData()
    }
//    @objc private func btnOverviewClicked(_ sender: UIButton) {
//        let width = view.frame.width
//        let height = 40 + infoLabel.bounds.height + moreView.bounds.height + 100
//        let mainHeight = height + width
//        overviewSelected()
//
//        DispatchQueue.main.async {
////            self.categoryCollectionView?.reloadData()
//        }
//
//        lowerContentView.isHidden = false
//        episodeContainerView.isHidden = true
//        episodeButtonSelected = false
//        self.heightConstraint?.constant = mainHeight
//    }
    
//    func clearSelection() {
//        btnEpisode.backgroundColor = getColor(hex: "#171715")
//        btnEpisode.setTitleColor(.white, for: .normal)
//        btnOverview.backgroundColor = getColor(hex: "#171715")
//        btnOverview.setTitleColor(.white, for: .normal)
//    }
    
//    func episodeSelected() {
//        clearSelection()
//        btnEpisode.backgroundColor = getColor(hex: ColorRes.color_accent)
//        btnEpisode.setTitleColor(.black, for: .normal)
//        
//        DispatchQueue.main.async {
////            self.episodeCollectionView?.reloadData()
//            self.lowerContentView.isHidden = true
//            self.episodeContainerView.isHidden = false
//            
//        }
//        
//    }
    
//    func goToTopicEvents(topic: TopicModel) {
//        if let eventVC = TopicEventController.create(IJamitConstants.STORYBOARD_EVENT) as? TopicEventController {
//            eventVC.dismissDelegate = self.parentVC
//            eventVC.eventDelegate = self.eventDelegate
//            eventVC.parentVC = self.parentVC
//            eventVC.topic = topic
//            self.parentVC?.addControllerOnContainer(controller: eventVC)
//        }
//
//    }
    
    
//    func overviewSelected() {
//
//        clearSelection()
//        btnOverview.backgroundColor = getColor(hex: ColorRes.color_accent)
//        btnOverview.setTitleColor(.black, for: .normal)
//        DispatchQueue.main.async {
//            self.lowerContentView.isHidden = false
//            self.episodeContainerView.isHidden = true
//        }
//
//    }
    
    func updateSubscribe(_ isSubscibre : Bool) {
        //        self.lblSubcribe.text = getString(isSubscibre ? StringRes.title_subscribed : StringRes.title_subscribe)
        //        self.imgSubcribe.image = UIImage(named: isSubscibre ? ImageRes.ic_check_white_36dp : ImageRes.ic_subscribe_36dp)
        //        self.btnSubcribe.backgroundColor = isSubscibre ? UIColor.clear : getColor(hex: ColorRes.subscribe_color)
        //        self.btnSubcribe.borderColor = isSubscibre ? UIColor.white : UIColor.clear
        //        self.btnSubcribe.borderWidth = CGFloat(isSubscibre ? 1 : 0)
    }
    
}

//extension PodcastDetailController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch collectionView {
//        case episodeCollectionView:
//            return episodeModel?.count ?? 0
//        case categoryCollectionView:
//            return viewModel?.listTopics?.count ?? 0
//        case moreCollectionView:
//            return 5
//        default:
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch collectionView {
//        case episodeCollectionView:
//            guard let cell = episodeCollectionView?.dequeueReusableCell(withReuseIdentifier: NewEpisodeFlatListCell.identifier, for: indexPath) as? NewEpisodeFlatListCell,
//                  let episode = episodeModel?[indexPath.row] else {
//                      return UICollectionViewCell()
//                  }
//            cell.updateUI(episode)
//            //                cell.updateUI(model, tagFont)
//            return cell
//        case categoryCollectionView:
//            guard let cell = categoryCollectionView?.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell,
//                  let model = viewModel?.listTopics?[indexPath.row] else {
//                      print("This is the else part")
//                      return UICollectionViewCell()
//                  }
//
//            cell.updateUI(model, tagFont)
//            cell.rootLayout.backgroundColor = .clear
//            return cell
//        case moreCollectionView:
//            guard let cell = moreCollectionView?.dequeueReusableCell(withReuseIdentifier: NewPodcastCell.identifier, for: indexPath) as? NewPodcastCell else {
//                return UICollectionViewCell()
//            }
//            //            cell.configure(with: liveEvent)
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
//    }
//
//
//}

//extension PodcastDetailController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch collectionView {
//        case episodeCollectionView:
//            break
//        case categoryCollectionView:
//            if let topic = self.viewModel?.listTopics?[indexPath.row] {
//                self.goToTopicEvents(topic: topic)
//            }
//        default:
//            break
//        }
//    }
//}

//extension PodcastDetailController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = self.view.layer.frame.size.width
//        let height = width * 0.24
//        switch collectionView {
//        case episodeCollectionView:
//            //            if episodeOverSelected {
//            return CGSize(width: width - 40, height: height)
//
//            //            } else {
//
//            //            }
//        case categoryCollectionView:
//            let model = self.viewModel?.listTopics?[indexPath.row]
//            let realTextWidth = fakeLabel.caculateWidth(DimenRes.height_tag_view, model?.name ?? "")
//            let realWidth = realTextWidth + 3 * DimenRes.small_padding + DimenRes.size_tag_image
//            return CGSize(width: realWidth, height: DimenRes.height_tag_view)
//            //            return CGSize(width: 0, height: 0)
//        case moreCollectionView:
//            return CGSize(width: width * 0.35, height: width * 0.48)
//        default:
//            return CGSize(width: 0, height: 0)
//        }
//
//    }
//
//}
