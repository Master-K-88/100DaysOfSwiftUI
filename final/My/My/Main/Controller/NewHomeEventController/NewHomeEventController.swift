//
//  NewHomeEventController.swift
//  jamit
//
//  Created by Prof K on 4/13/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit
//import SwiftUI

class NewHomeEventController: JamitRootViewController {
    
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    var dismissDelegate: DismissDelegate?
    var eventDelegate: EventTotalDelegate?
    var liveDelegate: LiveEventDelegate?
    
    var parentVC: MainController?
    
    private var listTopics : [TopicModel]?
    private var totalEvent : TotalEventModel?
    var isDestroy = false
    
    private let btnStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fillEqually
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnLive: UIButton = {
        let button = UIButton()
        button.cornerRadius = 8
        button.setTitle("Live", for: .normal)
        button.backgroundColor = getColor(hex: "#1B1C1F")
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnUpcomming: UIButton = {
        let button = UIButton()
        button.cornerRadius = 8
        button.setTitle("Upcomming", for: .normal)
        button.backgroundColor = getColor(hex: "#1B1C1F")
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let btnMine: UIButton = {
        let button = UIButton()
        button.cornerRadius = 8
        button.setTitle("Mine", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12)
        button.backgroundColor = getColor(hex: "#1B1C1F")
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
    
    private let topicView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var noDataLbl: UILabel = {
        let label = UILabel()
        label.text = "No data found"
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var collectionLive: UICollectionView?
    var collectionUpComming: UICollectionView?
    var collectionTopic: UICollectionView?
    var collectionMine: UICollectionView?
    
    var liveSelected: Bool = true
    var upcommingSelected: Bool = false
    var minesSlected: Bool = false
    var topicSelected: Bool = true
    
    private let fakeLabel = UILabel()
    
    private let tagFont = UIFont.init(name: IJamitConstants.FONT_MEDIUM, size: DimenRes.size_text_tag_view) ?? UIFont.systemFont(ofSize: DimenRes.size_text_tag_view)
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 0)
    
    let refreshControl = UIRefreshControl()
    private var cellWidth: CGFloat = 0.0
    private var avatarWidth: CGFloat = 0.0
    private var currentUserId: String = ""
    
    private let viewModel = EventsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoadData(false)
        view.backgroundColor = .black
        btnLive.backgroundColor = getColor(hex: "#FFAE29")
        btnLive.setTitleColor(.black, for: .normal)
        
        setupView()
        setupConstraints()
        
        self.fakeLabel.font = tagFont
        
        self.currentUserId = SettingManager.getUserId()
        self.setUpRefresh()
        self.startLoadData(false)
        
        dataListener()
        self.collectionTopic?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataListener()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let childrenView = mainView.subviews
        if !childrenView.isEmpty {
            childrenView.forEach { child in
                if child == noDataLbl {
                    
                } else {
                    child.removeFromSuperview()
                }
                
            }
        }
        noDataLbl.isHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 4 *  DimenRes.height_tag_view, height: DimenRes.height_tag_view)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = DimenRes.medium_padding
        layout.minimumInteritemSpacing = DimenRes.medium_padding
        layout.sectionInset = sectionInsets
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionLayout.scrollDirection = .vertical
        
        if topicSelected {
            collectionTopic = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            guard let collectionTopic = collectionTopic else {
                return
            }
            
            collectionTopic.register(UINib(nibName: "TopicCell", bundle: nil), forCellWithReuseIdentifier: "TopicCell")
            
            topicView.addSubview(collectionTopic)
            collectionTopic.frame = topicView.bounds
            collectionTopic.backgroundColor = .black
            collectionTopic.showsVerticalScrollIndicator = false
            collectionTopic.showsHorizontalScrollIndicator = false
            
            collectionTopic.dataSource = self
            collectionTopic.delegate = self
        }
        
        if liveSelected {
            
            collectionLive = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            
            guard let collectionLive = collectionLive,
                  let liveEvents = viewModel.totalEventData?.listLiveEvents else {
                     
                      
//
                return
            }
            if liveEvents.count < 1 {
                noDataLbl.isHidden = false
                return
            }
            
            collectionLive.register(NewEventCell.self, forCellWithReuseIdentifier: NewEventCell.identifier)
            
            mainView.addSubview(collectionLive)
            collectionLive.frame = mainView.bounds
            collectionLive.backgroundColor = .black
            
            collectionLive.dataSource = self
            collectionLive.delegate = self
        } else if upcommingSelected {
            collectionUpComming = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            
            guard let collectionUpComming = collectionUpComming,
                  let upcommingEvents = viewModel.totalEventData?.listUpcomingEvents else {
                return
            }
            
            if upcommingEvents.count < 1 {
                noDataLbl.isHidden = false
                return
            }
            
            collectionUpComming.register(NewEventCell.self, forCellWithReuseIdentifier: NewEventCell.identifier)
            
            mainView.addSubview(collectionUpComming)
            collectionUpComming.frame = mainView.bounds
            collectionUpComming.backgroundColor = .black
            
            collectionUpComming.dataSource = self
            collectionUpComming.delegate = self
        } else if minesSlected {
            collectionMine = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            
            guard let collectionMine = collectionMine,
                  let myEvent = viewModel.myEvents else {
                return
            }
            
            if myEvent.count < 1 {
                noDataLbl.isHidden = false
                return
            }
            
            collectionMine.register(NewEventCell.self, forCellWithReuseIdentifier: NewEventCell.identifier)
            
            mainView.addSubview(collectionMine)
            collectionMine.frame = mainView.bounds
            collectionMine.backgroundColor = .black
            
            collectionMine.dataSource = self
            collectionMine.delegate = self
        }
    }
    
    func setUpRefresh(){
        self.refreshControl.tintColor = getColor(hex: ColorRes.color_pull_to_refresh)
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
    }
    
    private func showLoading(_ isShow: Bool){
        self.progressBar.isHidden = !isShow
        if isShow {
            self.progressBar.startAnimating()
            self.scrollView.isHidden = true
        }
        else{
            self.progressBar.stopAnimating()
            
        }
    }
    
    @objc private func pullToRefresh() {
        self.startLoadData(true)
    }
    
    private func startLoadData(_ isRefresh: Bool) {
        if !ApplicationUtils.isOnline() {
            self.refreshControl.endRefreshing()
            self.showToast(with: StringRes.info_lose_internet)
            return
        }
        if !isRefresh {
            self.showLoading(true)
        }
        viewModel.loadData()
    }
    
    private func dataListener() {
        viewModel.dataCompletion = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.showLoading(false)
            
            
            if let totalEvent = self?.viewModel.totalEventData,
               let topicData = self?.viewModel.eventTopic {
                DispatchQueue.main.async {
                    self?.listTopics = topicData
                    self?.totalEvent = totalEvent
                    self?.progressBar.stopAnimating()
                    self?.scrollView.isHidden = false
                    self?.topicSelected = false
                    self?.collectionTopic?.reloadData()
                    self?.collectionMine?.reloadData()
                }
            }
            
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.isDestroy = true
        self.view.removeFromSuperview()
        self.dismissDelegate?.dismiss(controller: self)
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    private func setupView() {
        view.addSubview(btnStackView)
        btnStackView.pin(to: view, top: 54, left: 20, bottom: nil, right: -20)
        btnStackView.addArrangedSubview(btnLive)
        btnStackView.addArrangedSubview(btnUpcomming)
        btnStackView.addArrangedSubview(btnMine)
        view.addSubview(scrollView)
        scrollView.pin(to: view, top: nil, left: 20, bottom: 0, right: -20)
        scrollView.addSubview(containerView)
        containerView.pin(to: scrollView)
        containerView.addArrangedSubview(topicView)
        containerView.addArrangedSubview(mainView)
        mainView.addSubview(noDataLbl)
        
        btnLive.addTarget(self, action: #selector(liveTapped(_:)), for: .touchUpInside)
        btnUpcomming.addTarget(self, action: #selector(upcommingTapped(_:)), for: .touchUpInside)
        btnMine.addTarget(self, action: #selector(mineTapped(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        let width = view.frame.width
        let height = view.frame.height
        let mainHeight = height - (300 + width * 0.125)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: btnStackView.bottomAnchor, constant: 30),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            btnStackView.heightAnchor.constraint(equalToConstant: width * 0.125),
            topicView.heightAnchor.constraint(equalToConstant: 90),
            mainView.heightAnchor.constraint(equalToConstant: mainHeight),
            noDataLbl.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            noDataLbl.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        ])
        
    }
    
    private func clearSelection() {
        liveSelected = false
        upcommingSelected = false
        minesSlected = false
        topicSelected = false
        clearButton()
    }
    
    @objc private func liveTapped(_ sender: UIButton) {
        clearSelection()
        liveSelected = true
        btnLive.backgroundColor = getColor(hex: "#FFAE29")
        btnLive.setTitleColor(.black, for: .normal)
        DispatchQueue.main.async {
            self.collectionLive?.reloadData()
        }
    }
    
    @objc private func upcommingTapped(_ sender: UIButton) {
        clearSelection()
        upcommingSelected = true
        btnUpcomming.backgroundColor = getColor(hex: "#FFAE29")
        btnUpcomming.setTitleColor(.black, for: .normal)
        DispatchQueue.main.async {
            self.collectionUpComming?.reloadData()
        }
        
    }
    
    @objc private func mineTapped(_ sender: UIButton) {
        clearSelection()
        minesSlected = true
        btnMine.backgroundColor = getColor(hex: "#FFAE29")
        btnMine.setTitleColor(.black, for: .normal)
        DispatchQueue.main.async {
            self.collectionMine?.reloadData()
        }
    }
    
    fileprivate func clearButton() {
        btnLive.backgroundColor = getColor(hex: "#171715")
        btnUpcomming.backgroundColor = getColor(hex: "#171715")
        btnMine.backgroundColor = getColor(hex: "#171715")
        btnLive.setTitleColor(.white, for: .normal)
        btnUpcomming.setTitleColor(.white, for: .normal)
        btnMine.setTitleColor(.white, for: .normal)
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
    
    func onJoin(_ event: EventModel, _ isAcceptInvite: Bool) {
        if isAcceptInvite && self.parentVC?.dolbySdkManager != nil{
            self.parentVC?.dolbySdkManager?.confirmInviteOnServer(event: event, confId: event.eventId, isAccepted: true)
            return
        }
        self.parentVC?.goToLive(event)
    }
    
}

extension NewHomeEventController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionTopic:
            return listTopics?.count ?? 0
        case collectionLive:
            return viewModel.totalEventData?.listLiveEvents?.count ?? 0
        case collectionUpComming:
            return viewModel.totalEventData?.listUpcomingEvents?.count ?? 0
        case collectionMine:
            return viewModel.myEvents?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionTopic:
            guard let cell = collectionTopic?.dequeueReusableCell(withReuseIdentifier: String(describing: TopicCell.self), for: indexPath) as? TopicCell,
                  let model = listTopics?[indexPath.row] else {
                      return UICollectionViewCell()
                  }
            cell.updateUI(model, tagFont)
            return cell
        case collectionLive:
            guard let cell = collectionLive?.dequeueReusableCell(withReuseIdentifier: String(describing: NewEventCell.self), for: indexPath) as? NewEventCell,
                  let liveEvent = viewModel.totalEventData?.listLiveEvents?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(with: liveEvent)
            return cell
        case collectionUpComming:
            guard let cell = collectionUpComming?.dequeueReusableCell(withReuseIdentifier: String(describing: NewEventCell.self), for: indexPath) as? NewEventCell,
                let upcommingEvents = viewModel.totalEventData?.listUpcomingEvents?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(with: upcommingEvents)
            return cell
        case collectionMine:
            guard let cell = collectionMine?.dequeueReusableCell(withReuseIdentifier: String(describing: NewEventCell.self), for: indexPath) as? NewEventCell,
                  let myEvents = viewModel.myEvents?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.configure(with: myEvents)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

extension NewHomeEventController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionLive:
            guard let event = viewModel.totalEventData?.listLiveEvents?[indexPath.row] else { return }
            if self.currentUserId == nil { return }
            let isSubscribed = event.isSubscribed(self.currentUserId)
            let isInvited = event.isInvitedUser(self.currentUserId)
            let isHostEvent = event.isHostEvent(self.currentUserId)
            self.onJoin(event, !isSubscribed && isInvited && !isHostEvent)
        case collectionTopic:
            if let topic = self.listTopics?[indexPath.row] {
                self.goToTopicEvents(topic: topic)
            }
        case collectionUpComming:
            break
        default:
            break
            
        }
//        if collectionView == self.collectionTopic {
//            if let topic = self.listTopics?[indexPath.row] {
//                self.goToTopicEvents(topic: topic)
//            }
//        }
    }
}

extension NewHomeEventController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width
        let height = width * 0.48
        switch collectionView {
        case collectionTopic:
            let model = self.listTopics![indexPath.row]
            let realTextWidth = fakeLabel.caculateWidth(DimenRes.height_tag_view, model.name)
            let realWidth = realTextWidth + 3 * DimenRes.small_padding + DimenRes.size_tag_image
            return CGSize(width: realWidth, height: DimenRes.height_tag_view)
        case collectionLive:
            return CGSize(width: width - 40, height: height)
        case collectionUpComming:
            return CGSize(width: width - 40, height: height)
        case collectionMine:
            return CGSize(width: width - 40, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
}

