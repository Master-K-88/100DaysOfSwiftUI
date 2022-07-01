//
//  DetailRadioController.swift
//  Created by YPY Global on 4/11/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class DetailShowController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet var rootLayout: UIView!
    
    var menuDelegate: MenuEpisodeDelegate?
    var dismissDelegate: DismissDelegate?

    var showModel: ShowModel?
    var parentVC: MainController?
    
    var idHeader: String?
    var nativeCell: String?
    var storyCell : String?
    
    //fake font to calculate height of description in the header
    let fakeLabel = UILabel()
    
    var numberEpisode = 0
    
    override func setUpUI() {
        super.setUpUI()
        self.fakeLabel.font = UIFont.init(name: IJamitConstants.FONT_NORMAL, size: DimenRes.text_size_body) ?? UIFont.systemFont(ofSize: DimenRes.text_size_body)
        
        self.idHeader = String(describing: DetailShowHeader.self)
        self.collectionView?.register(UINib(nibName: self.idHeader!,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.idHeader!)
        
        self.nativeCell = String(describing: EpisodeNativeAdCell.self)
        self.collectionView.register(UINib(nibName: self.nativeCell!, bundle: nil), forCellWithReuseIdentifier: self.nativeCell!)
        
        self.storyCell = String(describing: EpisodeStoryFlatListCell.self)
        self.collectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
//        self.collectionView.register(UINib(nibName: self.storyCell!, bundle: nil), forCellWithReuseIdentifier: self.storyCell!)
    }

    override func setUpCustomizeUI() {
        self.lblTitle.text = self.showModel?.title
    }
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: NewEpisodeFlatListCell.self)
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if  self.showModel != nil && ApplicationUtils.isOnline(){
            JamItPodCastApi.getDetailShow(showModel!.slug) { (result) in
                if let show = result  {
                    self.showModel?.reviews = show.reviews
                    self.showModel?.subscribers = show.subscribers
                    self.showModel?.description = show.description
                    self.showModel?.numEpisodes = show.numEpisodes
                    self.showModel?.author = show.author
                    self.showModel?.summary = show.summary
                    self.showModel?.title = show.title
                    self.showModel?.tipSupportUrl = show.tipSupportUrl
                }
                JamItPodCastApi.getEpisodesOfShow(self.showModel!.id) { (list) in
                    completion(self.convertListModelToResult(list))
                }
            }
     
            return
        }
        completion(nil)
    }
    
    override func notifyWhenDataChanged() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
  
//    override func doOnNextWithListModel(_ listModels: inout [JsonModel]?, _ offset: Int, _ isGetNew: Bool) {
//        self.numberEpisode = listModels?.count ?? 0
//        self.showModel?.numEpisodes = self.numberEpisode
//        if listModels != nil && listModels!.count > 0 && !MemberShipManager.shared.isPremiumMember() {
//            let episodeModel = EpisodeModel(true)
//            listModels!.append(episodeModel)
//        }
//    }

    
    //override function to calculate height of native ads
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.listModels != nil {
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
        if self.listModels != nil {
            let model = self.listModels![indexPath.row] as! EpisodeModel
            if model.isShowAds || model.isStory() {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.isShowAds ? self.nativeCell! : self.storyCell!, for: indexPath)
                renderCell(cell: cell, model: model)
                return cell
            }
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let episode = model as! EpisodeModel
        if episode.isShowAds {
            let cell = cell as! EpisodeNativeAdCell
            cell.collectionView = self.collectionView
            cell.setUpAds(episode)
        }
        else{
            let cell = cell as! NewEpisodeFlatListCell
            cell.updateUI(episode)
            cell.typeVC = self.typeVC
            cell.menuDelegate = self.menuDelegate
            cell.listModels = self.listModels as? [EpisodeModel]
            cell.itemDelegate = self.itemDelegate
        }
    }
 
    @IBAction func backTapped(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeObserverForData()
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
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.showModel != nil {
            let availableWidth = self.view.frame.width - 2 * DimenRes.medium_padding
            let realDesHeight = fakeLabel.caculateHeight(availableWidth, self.showModel!.summary,true)
            let realBannerHeight = DimenRes.pivot_height_banner_detail_show + (realDesHeight - DimenRes.pivot_show_des_height)
            return CGSize(width: availableWidth, height: realBannerHeight)
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if kind == UICollectionView.elementKindSectionHeader && self.showModel != nil {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing:self.idHeader!), for: indexPath) as? DetailShowHeader else {
                fatalError("Invalid view type")
            }
            headerView.headerDelegate = self
            numberEpisode = showModel?.numEpisodes ?? 0
            headerView.setUpInfo(showModel, numberEpisode)
            return headerView
        }
        fatalError()
    }
}

extension DetailShowController: DetailShowHeaderDelegate {
    func shareShow(_ show: ShowModel, _ view: UIView) {
        self.parentVC?.shareWithDeepLink(show, view)
    }
    
    func goToInfo(_ show: ShowModel) {
        if self.parentVC == nil { return }
        NavigationManager.shared.goToInfo(currentVC: self.parentVC!, show: show)
    }
    
    func goToReview(_ show: ShowModel) {
        if self.parentVC == nil { return }
        NavigationManager.shared.goToReview(currentVC: self.parentVC!, show: show)
    }
    
    func goToSupport(_ show: ShowModel) {
        self.showAlertWithResId(
            titleId: StringRes.title_creator_support,
            messageId: StringRes.info_confirm_support,
            positiveId: StringRes.title_continue,
            negativeId: StringRes.title_cancel,
            completion: {
                if !show.tipSupportUrl.isEmpty && show.tipSupportUrl.starts(with: "http") {
                    ShareActionUtils.goToURL(linkUrl: show.tipSupportUrl)
                }
            })
    }
    
    func onSubscribe(_ show: ShowModel) {
        let isLogin = NavigationManager.shared.checkLogin(currentVC: self.parentVC,parentVC: self.parentVC)
        if isLogin { return }
        if isLogin { return }
        if !ApplicationUtils.isOnline() {
            self.parentVC?.showToast(with: StringRes.info_lose_internet)
            return
        }
        self.parentVC?.showProgress()
        let userId = SettingManager.getUserId()
        let isNewSub = !show.isSubscribed(userId)
        JamItPodCastApi.updateSubscribe(isNewSub, show.id) { (result) in
            self.parentVC?.dismissProgress()
            if let newShow = result {
                if newShow.isResultOk() {
                    show.subscribers = newShow.subscribers
//                    self.parentVC?.detailShowVC?.notifyWhenDataChanged()
                    let isSubcribe = show.isSubscribed(userId)
                    self.parentVC?.showToast(withResId: isSubcribe ? StringRes.info_subscribed_successfully: StringRes.info_unsubscribed_successfully)
//                    self.parentVC?.libraryVC?.subscribeShow(show, isSubcribe)
                }
                else{
                    let msg = !newShow.message.isEmpty ?  newShow.message : getString(StringRes.info_server_error)
                    self.parentVC?.showToast(with: msg)
                }
           
            }
        }
    }
}

