//
//  TopicEventController.swift
//  jamit
//
//  Created by Do Trung Bao on 23/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

class TopicEventController: JamitRootViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var layoutTitleLive: UIView!
    @IBOutlet weak var collectionLive: UICollectionView!
    
    @IBOutlet weak var layoutTitleUpcomming: UIView!
    @IBOutlet weak var collectionUpComming: UICollectionView!
    
    @IBOutlet weak var layoutTitlePastEvent: UIView!
    @IBOutlet weak var collectionPast: UICollectionView!
    
    var dismissDelegate: DismissDelegate?
    var eventDelegate: EventTotalDelegate?
    
    var parentVC: MainController?
    
    private var totalEvent : TotalEventModel?
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: DimenRes.medium_padding, bottom: 0.0, right: DimenRes.medium_padding)
    
    let refreshControl = UIRefreshControl()
    private var cellWidth: CGFloat = 0.0
    private var avatarWidth: CGFloat = 0.0
    private var currentUserId: String = ""
    var isDestroy = false
    
    var topic: TopicModel?
    
    override func setUpUI() {
        super.setUpUI()
 
        self.collectionLive.register(UINib(nibName: String(describing: LiveEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: LiveEventCell.self))
        
        self.collectionUpComming.register(UINib(nibName: String(describing: UpCommingEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: UpCommingEventCell.self))
        
        self.collectionPast.register(UINib(nibName: String(describing: PastEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PastEventCell.self))
        
        self.lblTitle.text = "#" + (topic?.name ?? "")
        
        self.currentUserId = SettingManager.getUserId()
        self.setUpRefresh()
        self.startLoadData(false)
        
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
        let topicId = topic?.topicID ?? ""
        if topicId.isEmpty {
            setUpInfo(nil)
            return
        }
        if !ApplicationUtils.isOnline() {
            self.refreshControl.endRefreshing()
            self.showToast(with: StringRes.info_lose_internet)
            return
        }
        if !isRefresh {
            self.showLoading(true)
        }
        JamItEventApi.getListTopicTotalEvents(topicId) { totalEvent in
            self.refreshControl.endRefreshing()
            self.showLoading(false)
            self.setUpInfo(totalEvent)
        }
    }
    
    private func setUpInfo(_ totalEvent: TotalEventModel?) {
        if isDestroy { return }
        self.totalEvent?.onDestroy()
        self.totalEvent = totalEvent
                
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
        self.goToMyEvents()
    }
    
    private func goToMyEvents(){
        let totalEventVC = ListTotalEventController.create(IJamitConstants.STORYBOARD_EVENT) as? ListTotalEventController
        totalEventVC?.dismissDelegate = self.parentVC
        totalEventVC?.eventUserId = self.currentUserId
        totalEventVC?.eventDelegate = self.eventDelegate
        totalEventVC?.screenTitle = getString(StringRes.title_my_events)
        totalEventVC?.isAllowRefresh = true
        totalEventVC?.parentVC = self.parentVC
        totalEventVC?.isAllowLoadMore = false
        self.parentVC?.addControllerOnContainer(controller: totalEventVC!)
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

extension TopicEventController : UICollectionViewDataSource {
    
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
    
    func reloadUpCommingUI() {
        self.collectionUpComming?.reloadData()
    }
    
    private func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        (cell as! BaseEventCell).updateUI(model as! EventModel, self.currentUserId,self.avatarWidth)
        (cell as! BaseEventCell).baseDelegate = self.eventDelegate
        (cell as? PastEventCell)?.pastDelegate = self.eventDelegate
        
        (cell as? UpCommingEventCell)?.upcommingDelegate = self.eventDelegate
        (cell as? UpCommingEventCell)?.controller = self
        
        (cell as? LiveEventCell)?.liveDelegate = self.eventDelegate
    }
    
    private func getNumItems(_ collectionView: UICollectionView) -> Int{
        if collectionView == self.collectionLive {
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
        if collectionView == self.collectionLive {
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
        if collectionView == self.collectionLive {
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

extension TopicEventController: UICollectionViewDelegateFlowLayout{
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

