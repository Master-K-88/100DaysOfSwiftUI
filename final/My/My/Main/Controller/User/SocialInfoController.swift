//
//  SocialInfoController.swift
//  jamit
//
//  Created by YPY Global on 23/12/2020.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class SocialInfoController: ParentViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tabLayout: Segmentio!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dismissDelegate: DismissDelegate?
    var itemDelegate: AppItemDelegate?
    var mainCont: MainController?
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var user: UserModel?
    var selectIndex: Int = 0
    
    var followerVC: ListUserController?
    var followingVC: ListUserController?
    var isLoaded = false
    
    lazy var viewControllers: [UIViewController] = []
    
    fileprivate func prepareControllers() -> [UIViewController]  {
        var listController = [UIViewController]()
        
        //setup delegate
        let followerVC = ListUserController.create(IJamitConstants.STORYBOARD_USER) as! ListUserController
        followerVC.typeVC = IJamitConstants.TYPE_FOLLOWER
        followerVC.itemDelegate = self.itemDelegate
        followerVC.parentVC = self
        followerVC.isTab = true
        followerVC.isAllowRefresh = true
        listController.append(followerVC)
        self.followerVC = followerVC
        
        let followingVC = ListUserController.create(IJamitConstants.STORYBOARD_USER) as! ListUserController
        followingVC.typeVC = IJamitConstants.TYPE_FOLLOWING
        followingVC.itemDelegate = self.itemDelegate
        followingVC.parentVC = self
        followingVC.isTab = true
        followingVC.isAllowRefresh = true
        listController.append(followingVC)
        self.followingVC = followingVC
        
        let isMyId = user?.isMyUserId(SettingManager.getUserId()) ?? false
        if isMyId {
            let suggestVC = SuggestUserController.create(IJamitConstants.STORYBOARD_USER) as! SuggestUserController
            suggestVC.typeVC = IJamitConstants.TYPE_VC_SUGGEST_USER
            suggestVC.itemDelegate = self.itemDelegate
            suggestVC.isTab = true
            suggestVC.isAllowRefresh = true
            listController.append(suggestVC)
        }
        return listController
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.indicatorView.color = getColor(hex: ColorRes.progress_color)
        self.lblTitle.text = user?.username
    }
    
    override func setUpData() {
        super.setUpData()
        self.viewControllers = prepareControllers()
        (self.viewControllers[self.selectIndex] as! BaseCollectionController).isFirstTab = true
    }
    
    override func onDoWhenNetworkOn() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupScrollView()
        TabBuilder.buildSegmentioView(
            content: segmentioContent(),
            segmentioView: tabLayout,
            segmentioStyle: SegmentioStyle.onlyLabel,
            tabBgColor: .clear,
            indicator: TabBuilder.segmentioIndicatorOptions(getColor(hex: ColorRes.color_accent))
        )
        tabLayout.valueDidChange = { [weak self] _, segmentIndex in
            if segmentIndex >= 0 && segmentIndex < (self?.viewControllers.count)! {
                self?.selectIndex = segmentIndex
                if let scrollViewWidth = self?.scrollView.frame.width {
                    let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                    self?.scrollView.setContentOffset(
                        CGPoint(x: contentOffsetX, y: 0),
                        animated: true
                    )
                }
                if let currentVC = self?.viewControllers[segmentIndex] as? BaseCollectionController {
                    currentVC.startLoadData()
                }
            }
        }
        tabLayout.selectedSegmentioIndex = selectIndex
        startLoadData(false)
    }
    
    func startLoadData(_ isRefresh: Bool){
        if !self.isLoaded || isRefresh {
            self.isLoaded = true
            if !isRefresh {
                self.showLoading(true, isRefresh)
            }
            let userName = self.user?.username ?? ""
            if ApplicationUtils.isOnline() && !userName.isEmpty {
                JamItPodCastApi.getUserInfo( userName) { (result) in
                    self.showLoading(false)
                    self.user = result
                    self.setUpInfoFollow()
                    if !isRefresh {
                        self.setUpInfo()
                    }
                }
                return
            }
            self.setUpInfoFollow()
            self.showLoading(false)
            if !isRefresh {
                setUpInfo()
            }
        }
    }
    private func setUpInfo(){
        if let currentVC = self.viewControllers[self.selectIndex] as? BaseCollectionController {
            self.goToControllerAtIndex(self.selectIndex)
            self.tabLayout.isHidden = false
            currentVC.isStartLoadData = false
            currentVC.startLoadData()
        }
    }
    
    func setUpInfoFollow(){
        self.followerVC?.listModels = self.user?.followers
        self.followingVC?.listModels = self.user?.following
        self.followerVC?.isStartLoadData = false
        self.followingVC?.isStartLoadData = false
        (self.viewControllers[self.selectIndex] as? ListUserController)?.startLoadData()
    }
    
    func showLoading(_ isLoading: Bool, _ isRefresh: Bool = false) {
        if isLoading {
            self.containerView.isHidden = !isRefresh
            self.indicatorView.startAnimating()
        }
        else{
            self.containerView.isHidden = false
            self.indicatorView.stopAnimating()
        }
        self.indicatorView.isHidden = !isLoading
    }
    
    fileprivate func setupScrollView() {
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: containerView.frame.height
        )
        
        for (index, viewController) in viewControllers.enumerated() {
            let x = UIScreen.main.bounds.width * CGFloat(index)
            let rect = CGRect(x:x, y: 0,width: scrollView.frame.width,height: scrollView.frame.height)
            viewController.view.frame = rect
            addChild(viewController)
            scrollView.addSubview(viewController.view, options: .useAutoresize)
            viewController.didMove(toParent: self)
        }
    }
    
    private func segmentioContent() -> [SegmentioItem] {
        var list = [SegmentioItem]()
        list.append(SegmentioItem(title: getString(StringRes.title_tab_followers).uppercased(), image: nil))
        list.append(SegmentioItem(title: getString(StringRes.title_tab_following).uppercased(), image: nil))
        let isMyId = user?.isMyUserId(SettingManager.getUserId()) ?? false
        if isMyId {
            list.append(SegmentioItem(title: getString(StringRes.title_tab_who_to_follow).uppercased(), image: nil))
        }
        return list
    }
    
    
    @IBAction func backTap(_ sender: Any) {
//        mainCont?.bgTab.isHidden = false
//        mainCont?.segment.isHidden = false
        guard let parentVC = mainCont else {
            return
        }
        self.removeFromParent()
        self.view.removeFromSuperview()
        parentVC.settingsBtn.isHidden = false
        parentVC.bgTab.isHidden = false
        parentVC.segment.isHidden = false
        
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
    
}
extension SocialInfoController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        tabLayout.selectedSegmentioIndex = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
    
    fileprivate func goToControllerAtIndex(_ index: Int) {
        tabLayout.selectedSegmentioIndex = index
    }
}
