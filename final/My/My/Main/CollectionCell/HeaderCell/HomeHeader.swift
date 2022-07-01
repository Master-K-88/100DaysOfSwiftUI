//
//  DiscoverHeader.swift
//  jamit
//
//  Created by Do Trung Bao on 4/9/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

//protocol HomeHeaderDelegage {
//    func goToFeaturedShow(_ show: ShowModel)
//    func goToFeatured(_ typeVC: Int)
//}

//class HomeHeader: UICollectionReusableView {
//
//    @IBOutlet weak var featureContainer: UIView!
//    @IBOutlet weak var featurePageControl: UIPageControl!
//    @IBOutlet weak var lblFeaturedStories: UILabel!
//    @IBOutlet weak var layoutTopAudioType: UIView!
//    @IBOutlet weak var collectionTrendingPodcast: UICollectionView!
//    @IBOutlet weak var layoutTrending: UIStackView!
//    @IBOutlet weak var lblTrending: PaddingUILabel!
//
//    private var listFeaturedShow : [ShowModel]?
//    private var listTrendingShow : [ShowModel]?
//    private var currentIndex = 0
//    private var pendingIndex = 0
//    private var pageViewController: UIPageViewController!
//    fileprivate var viewControllers: [FeaturedShowController] = []
//    private var paddingInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//
//    var delegate: HomeHeaderDelegage?
//
//    private var parentVC : UIViewController!
//    private var autoChangeTimer = Timer()
//    private var cellWidth: CGFloat = 0.0
//
//    @IBOutlet weak var layoutLive: UIView!
//    @IBOutlet weak var layoutPodcast: UIView!
//    @IBOutlet weak var layoutStories: UIView!
//    @IBOutlet weak var layoutAudioBooks: UIView!
//
//
//    override func awakeFromNib() {
//        let setting = TotalDataManager.shared.getSetting()
//        self.layoutLive.isHidden = !(setting?.isShowLive ?? true)
//        self.layoutPodcast.isHidden = !(setting?.isShowPodcast ?? true)
//        self.layoutStories.isHidden = !(setting?.isShowStory ?? true)
//        self.layoutAudioBooks.isHidden = !(setting?.isShowAudioBook ?? true)
//
//        self.layoutTopAudioType.isHidden = !(setting?.hasAudioType ?? true)
//
//        let idCell: String = String(describing: ShowCardGridCell.self)
//        self.collectionTrendingPodcast.register(UINib(nibName: idCell, bundle: nil), forCellWithReuseIdentifier: idCell)
//    }
//
//    func initPageController (_ parentVC: UIViewController) {
//        self.parentVC = parentVC
//        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        self.pageViewController.dataSource = self
//        self.pageViewController.delegate = self
//        self.pageViewController.view.frame = self.featureContainer.bounds
//
//        self.addControllerOnRootView(controller: self.pageViewController)
//        self.featureContainer.bringSubviewToFront(self.featurePageControl)
//        self.featurePageControl.numberOfPages = self.viewControllers.count
//        self.featurePageControl.currentPage = 0
//    }
//
//    private func addControllerOnRootView(controller : UIViewController){
//        controller.view.frame = CGRect(x: 0, y: 0, width: self.featureContainer.bounds.width, height: self.featureContainer.bounds.height)
//        self.parentVC.addChild(controller)
//        self.featureContainer.addSubview(controller.view)
//        controller.didMove(toParent: self.parentVC)
//    }
//
//    func setListTrendingShow(_ listShow: [ShowModel]?, _ screenWidth: CGFloat) {
//        self.listTrendingShow?.removeAll()
//        self.cellWidth = (screenWidth - DimenRes.medium_padding) / 2.5
//        self.listTrendingShow = listShow
//        self.collectionTrendingPodcast.reloadData()
//    }
//
//    func setListFeaturedShow(_ listShow: [ShowModel]?) {
//        self.resetPageControl()
//        if listShow != nil{
//            let count = listShow!.count
//            for i in 1...count {
//                let index = i - 1
//                let model = listShow![index]
//                self.viewControllers.append(self.createViewControllerAtIndex(index: index,model))
//                self.listFeaturedShow?.append(model)
//            }
//            if let firstVC = self.viewControllers.first {
//                self.pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//            }
//            self.featurePageControl.numberOfPages = self.viewControllers.count
//            self.featurePageControl.currentPage = 0
//        }
//
//    }
//    //reset all
//    func resetPageControl() {
//        self.cancelTask()
//        if self.viewControllers.count > 0{
//            for vc in self.viewControllers {
//                vc.removeFromParent()
//            }
//            self.viewControllers.removeAll()
//        }
//        self.listFeaturedShow?.removeAll()
//        self.featurePageControl.numberOfPages = 0
//        self.featurePageControl.currentPage = 0
//    }
//
//    @IBAction func podcastTap(_ sender: Any) {
//        self.delegate?.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_PODCASTS)
//    }
//
//    @IBAction func audioBookTap(_ sender: Any) {
//        self.delegate?.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_AUDIO_BOOK)
//    }
//
//    @IBAction func storyTap(_ sender: Any) {
//        self.delegate?.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_STORY)
//    }
//
//    @IBAction func liveTap(_ sender: Any) {
//        self.delegate?.goToFeatured(IJamitConstants.TYPE_VC_FEATURED_EVENT)
//    }
//}

//extension HomeHeader: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! FeaturedShowController) else {
//            return nil
//        }
//        let previousIndex = viewControllerIndex - 1
//        if previousIndex < 0 {
//            return nil
//        }
//        return self.viewControllers[previousIndex]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! FeaturedShowController) else {
//            return nil
//        }
//        let nextIndex = viewControllerIndex + 1
//        if nextIndex >= self.viewControllers.count {
//            return nil
//        }
//        return self.viewControllers[nextIndex]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        self.pendingIndex = self.viewControllers.firstIndex(of: pendingViewControllers.first as! FeaturedShowController)!
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed {
//            self.currentIndex = pendingIndex
//            self.featurePageControl.currentPage = self.currentIndex
//            self.schedulePageChange()
//        }
//    }
//
//    func createViewControllerAtIndex(index: Int, _ show: ShowModel) -> FeaturedShowController {
//        let featuredShowVC = FeaturedShowController.create(IJamitConstants.STORYBOARD_CHILD_IN_PAGE) as! FeaturedShowController
//        featuredShowVC.show = show
//        featuredShowVC.index = index
////        featuredShowVC.bannerDelegate = self.delegate
//        return featuredShowVC
//    }
//
//    func cancelTask(){
//        self.autoChangeTimer.invalidate()
//    }
//
//    func schedulePageChange() {
//        self.cancelTask()
//        self.autoChangeTimer = Timer.scheduledTimer(timeInterval: IJamitConstants.TIME_FEATURED_PAGE_CHANGE, target: self, selector: #selector(autoChangePage), userInfo: nil, repeats: false)
//    }
//
//    @objc func autoChangePage() {
//        if self.changePage(true) {
//            self.schedulePageChange()
//        }
//    }
//
//    func changePage( _ loop: Bool) -> Bool {
//        var currentPage = self.currentIndex + 1
//        if currentPage >= self.viewControllers.count {
//            if loop {
//                currentPage = 0
//            }
//            else{
//                return false
//            }
//        }
//        self.pageViewController.setViewControllers([self.viewControllers[currentPage]], direction: .forward, animated: true, completion: { (completed) in
//            self.currentIndex = currentPage
//            self.featurePageControl.currentPage = self.currentIndex
//            if !loop {
//                self.schedulePageChange()
//            }
//        })
//        return true
//    }
//
//
//}
//extension HomeHeader : UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.listTrendingShow?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let model = self.listTrendingShow?[indexPath.row] {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCardGridCell.self), for: indexPath) as! ShowCardGridCell
//            cell.updateUI(model)
//            return cell
//        }
//        else{
//            return UICollectionViewCell()
//        }
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let model = self.listTrendingShow?[indexPath.row] {
//            self.delegate?.goToFeaturedShow(model)
//        }
//    }
//
//}

//extension HomeHeader: UICollectionViewDelegateFlowLayout{
//    
//    @objc(collectionView:layout:sizeForItemAtIndexPath:)
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.cellWidth, height: self.cellWidth)
//    }
//
//    @objc(collectionView:layout:insetForSectionAtIndex:)
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return self.paddingInset
//    }
// 
//    
//    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return DimenRes.medium_padding
//    }
//}
