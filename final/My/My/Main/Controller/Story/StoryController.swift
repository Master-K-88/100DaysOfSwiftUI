//
//  SearchController.swift
//  jamit
//
//  Created by YPY Global on 8/6/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class StoryController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnStartSearch: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchView: UIView!
    var menuDelegate: MenuEpisodeDelegate?
    var dismissDelegate: DismissDelegate?
    var parentVC: MainController?
    var eventDelegate: EventTotalDelegate?
    
    var topic: TopicModel?
    
    var listPodcast: [ShowModel]?
    var listEpisode: [EpisodeModel]?
    var listShort: [EpisodeModel]?
    var listLiveEvent: [JsonModel]?
    var listPeople: [UserModel]?
    
    var keyword = ""
    var isTagSearch = false
    var nativeCell: String?
    var storyCell : String?
    var peopleCell: String?
    var podcastCell: String?
    var eventCell: String?
    var idHeader: String!
    var listTrendingUsers: [UserModel]?
    var listPopularTopics: [TopicModel]?
    var heightItemGrid: CGFloat = 0.0
    var eventType: String?
    var currentUserId: String?
    
    var colorMain: UIColor = getColor(hex: ColorRes.tab_text_focus_color)
    
    
    @IBOutlet weak var optionView: UIView!
    
    @IBOutlet weak var podcastView: UIView!
    @IBOutlet weak var btnPodcast: UIButton!
    var podcastSelected: Bool = false
    var podcastIndicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 1)
        indicatorView.backgroundColor = .clear
        return indicatorView
    }()
    
    var episodeIndicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 1)
        indicatorView.backgroundColor = .clear
        return indicatorView
    }()
    
    var shortIndicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 1)
        indicatorView.backgroundColor = .clear
        return indicatorView
    }()
    
    var liveIndicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 1)
        indicatorView.backgroundColor = .clear
        return indicatorView
    }()
    
    var peopleIndicatorView: UIView = {
        let indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 1)
        indicatorView.backgroundColor = .clear
        return indicatorView
    }()
    
    @IBOutlet weak var episodeView: UIView!
    @IBOutlet weak var btnEpisode: UIButton!
    var episodeSelected: Bool = false
    
    @IBOutlet weak var audiobookView: UIView!
    var audiobookSelected: Bool = false
    
    
    @IBOutlet weak var shortView: UIView!
    @IBOutlet weak var btnShort: UIButton!
    var shortSelected: Bool = false
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var btnLive: UIButton!
    var liveSelected: Bool = false
    
    
    @IBOutlet weak var peopleView: UIView!
    @IBOutlet weak var btnPeople: UIButton!
    var peopleSelected: Bool = false
    
    
    override func setUpUI() {
        super.setUpUI()
        podcastView.addSubview(podcastIndicatorView)
        episodeView.addSubview(episodeIndicatorView)
        shortView.addSubview(shortIndicatorView)
        eventView.addSubview(liveIndicatorView)
        peopleView.addSubview(peopleIndicatorView)
        gestureRecogSetup()
        self.nativeCell = String(describing: EpisodeNativeAdCell.self)
        self.collectionView.register(UINib(nibName: self.nativeCell!, bundle: nil), forCellWithReuseIdentifier: self.nativeCell!)
        
        self.storyCell = String(describing: EpisodeStoryFlatListCell.self)
//        self.collectionView.register(UINib(nibName: self.storyCell!, bundle: nil), forCellWithReuseIdentifier: self.storyCell!)
        self.collectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
        
        self.peopleCell = String(describing: UserFlatListCell.self)
        self.collectionView.register(UINib(nibName: self.peopleCell!, bundle: nil), forCellWithReuseIdentifier: self.peopleCell!)
        
        self.podcastCell = String(describing: ShowCardGridCell.self)
        self.collectionView.register(UINib(nibName: self.podcastCell!, bundle: nil), forCellWithReuseIdentifier: self.podcastCell!)
        
        self.eventCell = String(describing: PastEventCell.self)
        self.collectionView.register(UINib(nibName: self.eventCell!, bundle: nil), forCellWithReuseIdentifier: self.eventCell!)
        
        if self.typeVC == IJamitConstants.TYPE_VC_FEATURED_STORY {
            self.idHeader = String(describing: FeaturedStoryHeader.self)
            self.collectionView?.register(UINib(nibName: self.idHeader!,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.idHeader!)
        }
        
        NSLayoutConstraint.activate([
            podcastIndicatorView.bottomAnchor.constraint(equalTo: podcastView.bottomAnchor, constant: 0),
            podcastIndicatorView.leadingAnchor.constraint(equalTo: podcastView.leadingAnchor, constant: 0),
            podcastIndicatorView.trailingAnchor.constraint(equalTo: podcastView.trailingAnchor, constant: 0),
            podcastIndicatorView.heightAnchor.constraint(equalToConstant: 1),
            
            episodeIndicatorView.bottomAnchor.constraint(equalTo: episodeView.bottomAnchor, constant: 0),
            episodeIndicatorView.leadingAnchor.constraint(equalTo: episodeView.leadingAnchor, constant: 0),
            episodeIndicatorView.trailingAnchor.constraint(equalTo: episodeView.trailingAnchor, constant: 0),
            episodeIndicatorView.heightAnchor.constraint(equalToConstant: 1),
            
            shortIndicatorView.bottomAnchor.constraint(equalTo: shortView.bottomAnchor, constant: 0),
            shortIndicatorView.leadingAnchor.constraint(equalTo: shortView.leadingAnchor, constant: 0),
            shortIndicatorView.trailingAnchor.constraint(equalTo: shortView.trailingAnchor, constant: 0),
            shortIndicatorView.heightAnchor.constraint(equalToConstant: 1),
            
            liveIndicatorView.bottomAnchor.constraint(equalTo: eventView.bottomAnchor, constant: 0),
            liveIndicatorView.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 0),
            liveIndicatorView.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: 0),
            liveIndicatorView.heightAnchor.constraint(equalToConstant: 1),
            
            peopleIndicatorView.bottomAnchor.constraint(equalTo: peopleView.bottomAnchor, constant: 0),
            peopleIndicatorView.leadingAnchor.constraint(equalTo: peopleView.leadingAnchor, constant: 0),
            peopleIndicatorView.trailingAnchor.constraint(equalTo: peopleView.trailingAnchor, constant: 0),
            peopleIndicatorView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
    }
    
    fileprivate func gestureRecogSetup() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            
            if peopleSelected {
                liveBtnSelected()
            } else if liveSelected {
                shortBtnSelected()
            } else if shortSelected {
                episodeBtnSelected()
            } else {
                podcastBtnSelected()
            }
        }
        else if gesture.direction == .left {
            if podcastSelected {
                episodeBtnSelected()
            } else if episodeSelected {
                shortBtnSelected()
            } else if shortSelected {
                liveBtnSelected()
            } else {
                peopleBtnSelected()
            }
        }
    }
    
    func showSearchTabs() {
        NSLayoutConstraint.activate([
            optionView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func hideSearchTabs() {
        NSLayoutConstraint.activate([
            optionView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    func podcastBtnSelected() {
        clearSelection()
        podcastSelected = true
        btnPodcast.setTitleColor(colorMain, for: .normal)
        podcastIndicatorView.backgroundColor = colorMain
        if let listModels = listPodcast {
            self.listModels = listModels
            if listModels.isEmpty {
                DispatchQueue.main.async {
                    self.lblNodata.isHidden = false
                    self.lblNodata.text = "No Podcast found with the title \(self.keyword)"
                }
            }
            self.lblNodata.isHidden = true
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No Podcast found with the title \(self.keyword)"
            }
        }
        
    }
    
    func episodeBtnSelected() {
        clearSelection()
        episodeSelected = true
        btnEpisode.setTitleColor(colorMain, for: .normal)
        episodeIndicatorView.backgroundColor = colorMain
        if let listModels = listEpisode {
            self.listModels = listModels
            if listModels.isEmpty {
                DispatchQueue.main.async {
                    self.lblNodata.isHidden = false
                    self.lblNodata.text = "No Episode found with the title \(self.keyword)"
                }
            }
            self.lblNodata.isHidden = true
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No Episode found with the title \(self.keyword)"
            }
        }
    }
    
    func shortBtnSelected() {
        clearSelection()
        shortSelected = true
        btnShort.setTitleColor(colorMain, for: .normal)
        shortIndicatorView.backgroundColor = colorMain
        if let listModels = listShort {
            self.listModels = listModels
            if listModels.isEmpty {
                DispatchQueue.main.async {
                    self.lblNodata.isHidden = false
                    self.lblNodata.text = "No Short found with the title \(self.keyword)"
                }
            }
            self.lblNodata.isHidden = true
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No Short found with the title \(self.keyword)"
            }
        }
        
    }
    
    func liveBtnSelected() {
        clearSelection()
        liveSelected = true
        btnLive.setTitleColor(colorMain, for: .normal)
        liveIndicatorView.backgroundColor = colorMain
        listModels = listLiveEvent
        
        if let listModels = listLiveEvent {
            self.listModels = listModels
            if listModels.isEmpty {
                
                DispatchQueue.main.async {
                    self.lblNodata.isHidden = false
                    self.lblNodata.text = "No Live found with the title \(self.keyword)"
                }
               
            }
            self.lblNodata.isHidden = true
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No Live found with the title \(self.keyword)"
            }
        }
    }
    
    func peopleBtnSelected() {
        clearSelection()
        peopleSelected = true
        btnPeople.setTitleColor(colorMain, for: .normal)
        peopleIndicatorView.backgroundColor = colorMain
        listModels = listPeople
        
        if let listModels = listPeople {
            if listModels.isEmpty {
                DispatchQueue.main.async {
                    self.lblNodata.isHidden = false
                    self.lblNodata.text = "No Person found with the name \(self.keyword)"
                }
            }
            self.listModels = listModels
            self.lblNodata.isHidden = true
            collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.lblNodata.isHidden = false
                self.lblNodata.text = "No Person found with the name \(self.keyword)"
            }
            
        }
    }
    
    func clearSelection() {
        podcastSelected = false
        episodeSelected = false
        shortSelected = false
        audiobookSelected = false
        liveSelected = false
        peopleSelected = false
        
        podcastIndicatorView.backgroundColor = .clear
        shortIndicatorView.backgroundColor = .clear
        peopleIndicatorView.backgroundColor = .clear
        liveIndicatorView.backgroundColor = .clear
        episodeIndicatorView.backgroundColor = .clear
        
        btnLive.setTitleColor(.white, for: .normal)
        btnShort.setTitleColor(.white, for: .normal)
        btnPeople.setTitleColor(.white, for: .normal)
        btnEpisode.setTitleColor(.white, for: .normal)
        btnPodcast.setTitleColor(.white, for: .normal)
        
    }
    
    override func getUIType() -> UIType {
        if podcastSelected {
            return .CardGrid
        } else if liveSelected {
            return .CardList
        } else {
            return .FlatList
        }
    }
    
    override func setUpCustomizeUI() {
        self.setUpUISearch()
        if self.typeVC == IJamitConstants.TYPE_VC_SEARCH {
            showSearchTabs()
            podcastBtnSelected()
            DispatchQueue.main.async {
                self.lblNodata.isHidden = true
            }
            self.lblTitle.text = !self.keyword.isEmpty ? "Searched for \(self.keyword)" : getString(StringRes.title_search)
        }
        else if self.typeVC == IJamitConstants.TYPE_VC_FEATURED_STORY {
            hideSearchTabs()
            self.lblTitle.text = getString(StringRes.title_stories)
        }
        else if self.typeVC == IJamitConstants.TYPE_VC_MY_STORIES {
            hideSearchTabs()
            self.lblTitle.text = getString(StringRes.title_my_stories)
        }
        else if self.typeVC == IJamitConstants.TYPE_VC_DETAIL_TOPIC {
            hideSearchTabs()
//            self.lblTitle.text = "#" + (self.topic?.name ?? "")
            self.lblTitle.text = self.topic?.name ?? ""
        }
        else if self.typeVC == IJamitConstants.TYPE_VC_TOP_TEN_PODCASTS {
//            self.optionView.isHidden = true
            hideSearchTabs()
            self.lblTitle.text = "Top 10 Podcasts"
        }
    }
    
    @IBAction func podcastBtnTapped(_ sender: UIButton) {
        podcastBtnSelected()
    }
    
    @IBAction func episodeBtnTapped(_ sender: UIButton) {
        episodeBtnSelected()
    }
    
    @IBAction func shortBtnTapped(_ sender: UIButton) {
        shortBtnSelected()
    }
    
    @IBAction func liveBtnTapped(_ sender: UIButton) {
        liveBtnSelected()
    }
    
    @IBAction func peopleBtnTapped(_ sender: UIButton) {
        peopleBtnSelected()
    }
    
    private func setUpUISearch(){
        self.searchView.isHidden = true
        self.btnSearch.isHidden = self.typeVC != IJamitConstants.TYPE_VC_SEARCH
        
        self.tfSearch.delegate = self
        self.tfSearch.placeholderColor(color: getColor(hex: ColorRes.text_search_hint_color))
        
    }
    
    override func getIDCellOfCollectionView() -> String {
        if podcastSelected {
            return String(describing: ShowCardGridCell.self)
        } else if liveSelected {
            return String(describing: PastEventCell.self)
        } else if peopleSelected {
            return String(describing: UserFlatListCell.self)
        } else {
            return String(describing: NewEpisodeFlatListCell.self)
        }
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if ApplicationUtils.isOnline() {
            if self.typeVC == IJamitConstants.TYPE_VC_FEATURED_STORY {
                self.getFeaturedStory(completion)
            }
            else if self.typeVC == IJamitConstants.TYPE_VC_DETAIL_TOPIC {
                let topicId = self.topic?.rootId ?? ""
                JamItPodCastApi.getTopicEpisode(topicId) { (list) in
                    completion(self.convertListModelToResult(list))
                }
            }
            else if self.typeVC == IJamitConstants.TYPE_VC_MY_STORIES {
                JamItPodCastApi.getUserStories(SettingManager.getUserId()) { (list) in
                    completion(self.convertListModelToResult(list))
                }
            }
            else if self.typeVC == IJamitConstants.TYPE_VC_SEARCH &&  !self.keyword.isEmpty {
//                let urlEncodeKeyword = self.keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? keyword
                JamItPodCastApi.searchScreen(keyword) { (list) in
                    
                    self.listPodcast = list?.listPodcasts
                    self.listLiveEvent = list?.listEvents
                    self.listPeople = list?.listUsers
                    self.listEpisode = list?.listEpisodes
                    self.listShort = list?.listShorts
                    
                    if self.podcastSelected {
                        if list?.listPodcasts != nil {
                            completion(self.convertListModelToResult(list?.listPodcasts))
                        } else {
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = false
                                self.lblNodata.text = "No Podcast found with the title \(self.keyword)"
                            }
                        }
                    } else if self.liveSelected {
                        if list?.listEvents != nil {
                            completion(self.convertListModelToResult(list?.listEvents))
                        } else {
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = false
                                self.lblNodata.text = "No Live found with the title \(self.keyword)"
                            }
                        }
                    } else if self.peopleSelected {
                        if list?.listUsers != nil {
                            self.lblNodata.isHidden = true
                            completion(self.convertListModelToResult(list?.listUsers))
                        } else {
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = false
                                self.lblNodata.text = "No Person found with the name \(self.keyword)"
                            }
                        }
                    } else if self.episodeSelected{
                        if list?.listEpisodes != nil {
                            self.lblNodata.isHidden = true
                            completion(self.convertListModelToResult(list?.listEpisodes))
                        } else {
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = false
                                self.lblNodata.text = "No Episode found with the title \(self.keyword)"
                            }
                        }
                        
                    } else if self.shortSelected {
                        if list?.listShorts != nil {
                            self.lblNodata.isHidden = true
                            completion(self.convertListModelToResult(list?.listShorts))
                        } else {
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = false
                                self.lblNodata.text = "No Short found with the title \(self.keyword)"
                            }
                        }
                    }
                }
                
            } else if self.typeVC == IJamitConstants.TYPE_VC_TOP_TEN_PODCASTS {
                JamItPodCastApi.getUserStories(SettingManager.getUserId()) { (list) in
                    completion(self.convertListModelToResult(list))
                }
            }

            return
            
        }
        completion(nil)
    }
    
    private func getFeaturedStory(_ completion: @escaping (ResultModel?) -> Void) {
        //get trending user
        JamItPodCastApi.getTrendingUsers { (list) in
            self.listTrendingUsers = list
            if SettingManager.isLoginOK() {
                if list != nil {
                    //remove all trending user who is you
                    let currentUserId = SettingManager.getUserId()
                    self.listTrendingUsers?.removeAll(where: { user in
                        return !currentUserId.isEmpty && user.userID == currentUserId
                    })
                    let myUser = UserModel()
                    myUser.userID = IJamitConstants.ID_YOUR_STORY
                    myUser.username = getString(StringRes.title_your_story)
                    myUser.avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
                    self.listTrendingUsers?.insert(myUser, at: 0)
                }
                //get popular topics
                JamItPodCastApi.getTopics { (topics) in
                    self.listPopularTopics = topics
                    JamItPodCastApi.getSuggestStories { (list) in
                        let result = self.convertListModelToResult(list)
                        result.msg = getString(StringRes.info_no_suggest_story)
                        completion(result)
                    }
                }
                
            }
            else{
                //get popular topics
                JamItPodCastApi.getTopics { (topics) in
                    self.listPopularTopics = topics
                    JamItPodCastApi.getFeaturedStories { (list) in
                        completion(self.convertListModelToResult(list))
                    }
                }
            }
            
        }
    }
    
//    override func doOnNextWithListModel(_ listModels: inout [JsonModel]?, _ offset: Int, _ isGetNew: Bool) {
//        if podcastSelected || liveSelected || peopleSelected {
//            
//        } else {
//            let isMyStory = self.typeVC == IJamitConstants.TYPE_VC_MY_STORIES
//            if listModels != nil && listModels!.count > 0 && !MemberShipManager.shared.isPremiumMember() && !isMyStory {
//                let episodeModel = EpisodeModel(true)
//                listModels!.append(episodeModel)
//            }
//        }
//        
//    }
    
    //override function to calculate height of native ads
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !self.listModels!.isEmpty {
            if peopleSelected {
                return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
            }
            else if liveSelected {
                self.widthItemGrid = self.view.frame.width - 2 * DimenRes.medium_padding
                self.heightItemGrid = self.widthItemGrid * IJamitConstants.RATE_2_1
                return CGSize(width: self.widthItemGrid, height: self.heightItemGrid)
            }
            else if podcastSelected {
                sectionInsets.left = 10
                let paddingSpace = (sectionInsets.left * CGFloat(itemsPerRow + 1)) + 10
                let availableWidth = view.frame.size.width - paddingSpace
                self.widthItemGrid = availableWidth / CGFloat(itemsPerRow)
                return CGSize(width: self.widthItemGrid, height: self.widthItemGrid)
            }
                let item = self.listModels![indexPath.row] as! EpisodeModel
                let availableWidth = self.view.frame.width - 2 * DimenRes.medium_padding
                if item.isShowAds {
                    let height = item.isAdError ? CGFloat(0) : DimenRes.native_ads_place_holder
                    return CGSize(width: availableWidth, height: height)
                }
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    //override render cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if podcastSelected {
            if let model = self.listModels?[indexPath.row] as? ShowModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCardGridCell.self), for: indexPath)
                renderCell(cell: cell, model: model)
                return cell
            }
        }
        else if shortSelected || episodeSelected {
            if let model = self.listModels![indexPath.row] as? EpisodeModel {
                if model.isShowAds || model.isStory() {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.isShowAds ? self.nativeCell! : self.storyCell!, for: indexPath)
                    renderCell(cell: cell, model: model)
                    return cell
                }
            }
        }
        else if liveSelected {
            if let model = self.listModels?[indexPath.row] as? EventModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.eventCell!, for: indexPath)
                renderCell(cell: cell, model: model)
                return cell
            }
        }
        else if peopleSelected {
            
            if let model = self.listModels?[indexPath.row] as? UserModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.peopleCell!, for: indexPath)
                renderCell(cell: cell, model: model)
                return cell
            }
            else {
                if let model = self.listModels![indexPath.row] as? EpisodeModel {
                    if model.isShowAds || model.isStory() {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.isShowAds ? self.nativeCell! : self.storyCell!, for: indexPath)
                        renderCell(cell: cell, model: model)
                        return cell
                    }
                }
            }
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        if podcastSelected {
            if let item = model as? ShowModel {
                if let cell = cell as? ShowCardGridCell {
                    cell.updateUI(item)
                    return
                }
            }
            return
        }
        if shortSelected || episodeSelected {
            if let episode = model as? EpisodeModel {
                if episode.isShowAds {
                    let cell = cell as! EpisodeNativeAdCell
                    cell.collectionView = self.collectionView
                    cell.setUpAds(episode)
                }
                else{
                    let cell = cell as! NewEpisodeFlatListCell
                    let isMystory = self.typeVC == IJamitConstants.TYPE_VC_MY_STORIES
                    cell.isMyStories = isMystory
                    cell.menuDelegate = self.menuDelegate
                    cell.listModels = self.listModels as? [EpisodeModel]
                    cell.typeVC = self.typeVC
                    cell.itemDelegate = self.itemDelegate
                    cell.updateUI(episode)
                }
            }
        }
        if liveSelected {
            currentUserId = SettingManager.getUserId()
            (cell as! BaseEventCell).updateUI(model as! EventModel, self.currentUserId!, 40)
            (cell as! BaseEventCell).baseDelegate = self.eventDelegate
            (cell as? PastEventCell)?.pastDelegate = self.eventDelegate
            return
        }
        if peopleSelected {
            if let user = model as? UserModel {
                let cell = cell as! UserFlatListCell
                cell.updateUI(user)
            }
            return
        }
            if let episode = model as? EpisodeModel {
                if episode.isShowAds {
                    guard let cell = cell as? EpisodeNativeAdCell else {
                        return
                    }
                    cell.collectionView = self.collectionView
                    cell.setUpAds(episode)
                }
                else {
                    let cell = cell as! NewEpisodeFlatListCell
                    let isMystory = self.typeVC == IJamitConstants.TYPE_VC_MY_STORIES
                    cell.isMyStories = isMystory
                    cell.isUserStories = isMystory
                    cell.menuDelegate = self.menuDelegate
                    cell.listModels = self.listModels as? [EpisodeModel]
                    cell.typeVC = self.typeVC
                    cell.itemDelegate = self.itemDelegate
                    cell.updateUI(episode)
                }
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
    
    @IBAction func backTapped(_ sender: Any) {
        if !self.searchView.isHidden {
            hideVirtualKeyboard()
            return
        }
        if !self.footerView.isHidden || !self.progressBar.isHidden {
            return
        }
        self.view.removeFromSuperview()
        self.removeObserverForData()
        self.parentVC?.segment.isHidden = false
        self.parentVC?.bgTab.isHidden = false
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    @IBAction func startSearchTapped(_ sender: Any) {
        if !(tfSearch.text?.isEmpty)!{
            startSearch(tfSearch.text!)
            hideVirtualKeyboard()
        }
    }
    
    @IBAction func clearTextTapped(_ sender: Any) {
        if !(tfSearch.text?.isEmpty)!{
            tfSearch.text = ""
        }
        else{
            hideVirtualKeyboard()
        }
    }
    
    override func hideVirtualKeyboard(){
        super.hideVirtualKeyboard()
        self.tfSearch.text = ""
        self.searchView.isHidden = true
        self.lblTitle.isHidden = false
        self.btnSearch.isHidden = false
        self.unregisterTapOutSideRecognizer()
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        self.searchView.isHidden = false
        self.lblTitle.isHidden = true
        self.btnSearch.isHidden = true
        self.tfSearch.becomeFirstResponder()
        self.registerTapOutSideRecognizer()
    }
    
    func startSearch (_ keyword: String!) {
        if !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.keyword = keyword
        self.lblTitle.text = !self.keyword.isEmpty ? "Searched for \(self.keyword)" : getString(StringRes.title_search)
        self.isStartLoadData = false
        self.startLoadData()
    }
    
    //process for header view
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.idHeader != nil {
            let availableWidth = self.view.frame.width
            let trendingUserHeight = IJamitConstants.RATE_TRENDING_USER * availableWidth
            let popularTopicHeight = CGFloat(0.75) * trendingUserHeight
            let headerTitle = DimenRes.header_text_height + DimenRes.divider_height
            
            var totalHeight = 3 * headerTitle + trendingUserHeight + popularTopicHeight
            totalHeight += 1.5 * DimenRes.large_padding
            return CGSize(width: availableWidth, height: totalHeight)
        }
        return CGSize(width: 0.0, height: 0.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if (kind == UICollectionView.elementKindSectionHeader){
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing:self.idHeader!), for: indexPath) as? FeaturedStoryHeader else {
                fatalError("Invalid view type")
            }
            headerView.appItemDelegate = self.itemDelegate
            headerView.setListTrendingUsers(self.listTrendingUsers, self.view.frame.width)
            headerView.setListPopularTopics(self.listPopularTopics)
            return headerView
        }
        fatalError()
    }
    
    func showDialogDeleteStory(_ episode: EpisodeModel) {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.parentVC,parentVC: self.parentVC)
        if isLogin { return }
        if !ApplicationUtils.isOnline() {
            self.parentVC?.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        let msg = getString(StringRes.info_delete_story)
        let titleCancel = getString(StringRes.title_cancel)
        let titleDelete = getString(StringRes.title_delete)
        self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleDelete, negative: titleCancel, completion: {
            self.showProgress()
            JamItPodCastApi.deleteStory(episode.id) { (result) in
                self.dismissProgress()
                if let responce = result {
                    if responce.isResultOk() {
                        self.parentVC?.showToast(withResId: StringRes.info_delete_story_success)
                        self.deleteModel(episode)
                    }
                    else{
                        let msg = !responce.message.isEmpty ? responce.message : getString(StringRes.info_server_error)
                        self.parentVC?.showToast(with: msg)
                    }
                    return
                }
                self.parentVC?.showToast(withResId: StringRes.info_server_error)
            }
        })
    }
    
}

extension StoryController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !tfSearch.text!.isEmpty {
            let temp = tfSearch.text
            self.tfSearch.text = ""
            hideVirtualKeyboard()
            startSearch(temp)
        }
        else {
            hideVirtualKeyboard()
        }
        return true
    }
}


