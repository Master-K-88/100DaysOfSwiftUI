//
//  HomeEventController.swift
//  jamit
//
//  Created by Do Trung Bao on 19/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

class HomeEventController: JamitRootViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var layoutTitleLive: UIView!
    @IBOutlet weak var collectionLive: UICollectionView!
    
    @IBOutlet weak var layoutTitleUpcomming: UIView!
    @IBOutlet weak var collectionUpComming: UICollectionView!
    
    @IBOutlet weak var layoutTitlePastEvent: UIView!
    @IBOutlet weak var collectionPast: UICollectionView!
    
    @IBOutlet weak var layoutTitleTopic: UIView!
    @IBOutlet weak var collectionTopic: UICollectionView!
    
    var dismissDelegate: DismissDelegate?
    var eventDelegate: EventTotalDelegate?
    
    var parentVC: MainController?
    
    private var listTopics : [TopicModel]?
    private var totalEvent : TotalEventModel?
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    @IBOutlet weak var lblViewAllLive: AutoFillLabel!
    @IBOutlet weak var lblViewAllUpComming: AutoFillLabel!
    @IBOutlet weak var lblViewAllPast: AutoFillLabel!
    
    //fake font to calculate width of tag in the header
    private let fakeLabel = UILabel()
    
    private let tagFont = UIFont.init(name: IJamitConstants.FONT_MEDIUM, size: DimenRes.size_text_tag_view) ?? UIFont.systemFont(ofSize: DimenRes.size_text_tag_view)
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: DimenRes.medium_padding, bottom: 0.0, right: DimenRes.medium_padding)
    
    let refreshControl = UIRefreshControl()
    private var cellWidth: CGFloat = 0.0
    private var avatarWidth: CGFloat = 0.0
    private var currentUserId: String = ""
    var isDestroy = false
    
    override func setUpUI() {
        super.setUpUI()
        
        self.fakeLabel.font = tagFont
        
        self.collectionTopic.register(UINib(nibName: String(describing: TopicCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TopicCell.self))
        
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 4 *  DimenRes.height_tag_view, height: DimenRes.height_tag_view)
        self.collectionTopic.collectionViewLayout = layout
        
        self.collectionLive.register(UINib(nibName: String(describing: LiveEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: LiveEventCell.self))
        
        self.collectionUpComming.register(UINib(nibName: String(describing: UpCommingEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: UpCommingEventCell.self))
        
        self.collectionPast.register(UINib(nibName: String(describing: PastEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PastEventCell.self))
        
        self.lblViewAllLive.isUserInteractionEnabled = true
        self.lblViewAllLive.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewAllLive)))
        
        self.lblViewAllUpComming.isUserInteractionEnabled = true
        self.lblViewAllUpComming.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewAllUpComing)))

        self.lblViewAllPast.isUserInteractionEnabled = true
        self.lblViewAllPast.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewAllUpPast)))
        
        self.currentUserId = SettingManager.getUserId()
        self.setUpRefresh()
        self.startLoadData(false)
        
    }
    
    @objc func onViewAllLive() {
        self.goToListTotalEvent(title: getString(StringRes.title_live_events), type: EventModel.STATUS_LIVE)
    }
    
    @objc func onViewAllUpComing() {
        self.goToListTotalEvent(title: getString(StringRes.title_upcoming_events), type: EventModel.STATUS_UPCOMING)
    }
    
    @objc func onViewAllUpPast() {
        self.goToListTotalEvent(title: getString(StringRes.title_past_events), type: EventModel.STATUS_PAST)
    }
    
    func setUpRefresh(){
        self.refreshControl.tintColor = getColor(hex: ColorRes.color_pull_to_refresh)
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.scrollView.refreshControl = refreshControl
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
        JamItEventApi.getListTotalEvents { totalEvent in
            JamItPodCastApi.getTopics { listTopics in
                self.refreshControl.endRefreshing()
                self.showLoading(false)
                
                self.setUpInfo(totalEvent, listTopics)
            }
        }
    }
    
    private func setUpInfo(_ totalEvent: TotalEventModel?, _ topics: [TopicModel]?) {
        if isDestroy { return }
        self.totalEvent?.onDestroy()
        self.totalEvent = totalEvent
        
        self.listTopics?.removeAll()
        self.listTopics = topics
        
        let sizeTopic = listTopics?.count ?? 0
        self.layoutTitleTopic.isHidden = sizeTopic <= 0
        self.collectionTopic.isHidden = sizeTopic <= 0
        self.collectionTopic.reloadData()
        
        let sizeLive = totalEvent?.listLiveEvents?.count ?? 0
        self.layoutTitleLive.isHidden = sizeLive <= 0
        self.collectionLive.isHidden = sizeLive <= 0
        self.collectionLive.reloadData()
        
        let sizeUp = totalEvent?.listUpcomingEvents?.count ?? 0
        self.layoutTitleUpcomming.isHidden = sizeUp <= 0
        self.collectionUpComming.isHidden = sizeUp <= 0
        self.collectionUpComming.reloadData()
        
        let sizePast = totalEvent?.listPassEvents?.count ?? 0
        self.layoutTitlePastEvent.isHidden = sizePast <= 0
        self.collectionPast.isHidden = sizePast <= 0
        self.collectionPast.reloadData()
        
        self.scrollView.isHidden = false
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.isDestroy = true
        self.view.removeFromSuperview()
        self.dismissDelegate?.dismiss(controller: self)
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    @IBAction func myEventTap(_ sender: Any) {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.parentVC,parentVC: self.parentVC)
        if isLogin { return }
        self.goToListTotalEvent(title: getString(StringRes.title_my_events), userId: currentUserId)
    }
    
    private func goToListTotalEvent( title: String,type: String? = nil, userId: String? = nil){
        if let totalEventVC = ListTotalEventController.create(IJamitConstants.STORYBOARD_EVENT) as? ListTotalEventController {
            totalEventVC.dismissDelegate = self.parentVC
            totalEventVC.eventType = type
            totalEventVC.eventUserId = userId
            totalEventVC.screenTitle = title
            totalEventVC.eventDelegate = self.eventDelegate
            totalEventVC.isAllowRefresh = true
            totalEventVC.parentVC = self.parentVC
            totalEventVC.isAllowLoadMore = false
            self.parentVC?.addControllerOnContainer(controller: totalEventVC)
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
    
    func reloadUpCommingUI() {
        self.collectionUpComming?.reloadData()
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
    
}

extension HomeEventController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getNumItems(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let idCell = self.getCellId(collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath)
            if let listModels = self.getListModels(collectionView) {
                let model = listModels[indexPath.row]
                self.renderCell(cell: cell, model: model)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionTopic {
            if let topic = self.listTopics?[indexPath.row] {
                self.goToTopicEvents(topic: topic)
            }
        }
    }
    
    private func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        if cell is TopicCell {
            (cell as! TopicCell).updateUI(model as! TopicModel, tagFont)
        }
        else if cell is BaseEventCell {
            (cell as! BaseEventCell).updateUI(model as! EventModel, self.currentUserId,self.avatarWidth)
            (cell as! BaseEventCell).baseDelegate = self.eventDelegate
            
            (cell as? PastEventCell)?.pastDelegate = self.eventDelegate
            
            (cell as? UpCommingEventCell)?.upcommingDelegate = self.eventDelegate
            (cell as? UpCommingEventCell)?.controller = self
            
            (cell as? LiveEventCell)?.liveDelegate = self.eventDelegate
        }
    }
    
    private func getNumItems(_ collectionView: UICollectionView) -> Int{
        if collectionView == self.collectionTopic {
            return self.listTopics?.count ?? 0
        }
        else if collectionView == self.collectionLive {
            return totalEvent?.listLiveEvents?.count ?? 0
        }
        else if collectionView == self.collectionUpComming {
            return totalEvent?.listUpcomingEvents?.count ?? 0
        }
        else if collectionView == self.collectionPast {
            return totalEvent?.listPassEvents?.count ?? 0
        }
        return 0
    }
    
    private func getCellId(_ collectionView: UICollectionView) -> String? {
        if collectionView == self.collectionTopic {
            return String(describing: TopicCell.self)
        }
        else if collectionView == self.collectionLive {
            return String(describing: LiveEventCell.self)
        }
        else if collectionView == self.collectionUpComming {
            return String(describing: UpCommingEventCell.self)
        }
        else if collectionView == self.collectionPast {
            return String(describing: PastEventCell.self)
        }
        return nil
    }
    
    private func getListModels(_ collectionView: UICollectionView) -> [JsonModel]? {
        if collectionView == self.collectionTopic {
            return self.listTopics
        }
        else if collectionView == self.collectionLive {
            return self.totalEvent?.listLiveEvents
        }
        else if collectionView == self.collectionUpComming {
            return self.totalEvent?.listUpcomingEvents
        }
        else if collectionView == self.collectionPast {
            return self.totalEvent?.listPassEvents
        }
        return nil
    }
    
}

extension HomeEventController: UICollectionViewDelegateFlowLayout{
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionTopic {
            let model = self.listTopics![indexPath.row]
            let realTextWidth = fakeLabel.caculateWidth(DimenRes.height_tag_view, "#" + model.name)
            let realWidth = realTextWidth + 3 * DimenRes.small_padding + DimenRes.size_tag_image
            return CGSize(width: realWidth, height: DimenRes.height_tag_view)
        }
        if self.cellWidth == 0 {
            self.cellWidth = (self.view.frame.width - DimenRes.medium_padding) / 1.5
            self.avatarWidth = collectionView.frame.height  * IJamitConstants.RATE_AVATAR_EVENT_CELL
        }
        return CGSize(width: self.cellWidth, height: collectionView.frame.height)
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
  
   
    
}

