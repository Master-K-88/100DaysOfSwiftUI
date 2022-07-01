//
//  FriendStoryController.swift
//  jamit
//
//  Created by Do Trung Bao on 8/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class FriendStoryController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var menuDelegate: MenuEpisodeDelegate?
    var dismissDelegate: DismissDelegate?
    var parentVC: MainController?
    var profileDelegate: ProfileViewDelegate?
    
    var avatarDelegate: AvatarDelegate?
    var eventDelegate: EventTotalDelegate?
    private let myPickerController = UIImagePickerController()
    private var pickedImage: UIImage?
    
    var userModel: UserModel?
    
    var idHeader: String?
    var nativeCell: String?
    var numberStory = 0
    
    var frnFav: [EpisodeModel]?
    var frnShort: [EpisodeModel]?
    
    var friendHeader: ProfileHeader?
    
    override func setUpUI() {
        super.setUpUI()
        profileDelegate = ProfileViewDelegate(currentVC: (parentVC?.profileVC)!)
        self.idHeader = String(describing: ProfileHeader.self)
        self.collectionView?.register(UINib(nibName: self.idHeader!,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.idHeader!)
        
        self.nativeCell = String(describing: EpisodeNativeAdCell.self)
        self.collectionView.register(UINib(nibName: self.nativeCell!, bundle: nil), forCellWithReuseIdentifier: self.nativeCell!)
        
        profileDelegate?.likeListener = {
//            self.onRefreshData(false)
            if let frnFav = self.frnFav {
                if frnFav.isEmpty {
                    self.listModels = frnFav
                    DispatchQueue.main.async {
                        self.lblNodata.isHidden = false
                        self.lblNodata.text = getString(StringRes.profile_no_likes)
                        self.collectionView.reloadData()
                    }
                    
                } else {
                    self.listModels = frnFav
                    DispatchQueue.main.async {
                        self.lblNodata.isHidden = true
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        profileDelegate?.shortListener = {
            if let frnShort = self.frnShort {
                if frnShort.isEmpty {
                    self.listModels = frnShort
                    DispatchQueue.main.async {
                        self.lblNodata.isHidden = false
                        self.lblNodata.text = getString(StringRes.profile_no_short)
                        self.collectionView.reloadData()
                    }
                    self.collectionView.reloadData()
                } else {
                    self.listModels = frnShort
                    DispatchQueue.main.async {
                        self.lblNodata.isHidden = true
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunc(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func setUpCustomizeUI() {
        let titleText = String(format: getString(StringRes.format_title_story), self.userModel?.username ?? "")
        self.lblTitle.text = titleText.prefix(1).capitalized + titleText.suffix(titleText.count - 1)
    }
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: EpisodeStoryFlatListCell.self)
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        let userName = self.userModel?.username ?? ""
        guard let userId = self.userModel?.userID else {return}
        if  !userName.isEmpty && ApplicationUtils.isOnline(){
            JamItPodCastApi.getUserInfo(userName) { (result) in
                if let userInfo = result {
                    self.userModel = userInfo
                    self.userModel?.followers = userInfo.followers
                    self.userModel?.following = userInfo.following
                    self.userModel?.tipSupportUrl = userInfo.tipSupportUrl
                    self.startCreateProfileItem(completion)
                }
            }
            
            
                    JamItPodCastApi.getUserStories(self.userModel!.userID) { (list) in
                        self.frnShort = list
                        if let short = self.friendHeader?.shortSelected {
                            if short {
                        self.lblNodata.isHidden = (list?.count ?? 0) > 0
                        completion(self.convertListModelToResult(list))
                    }
                }
            }
            
            JamItPodCastApi.getFrndFavEpisode(userId) { (list) in
                self.frnFav = list
                if let like = self.friendHeader?.likesSelected {
                    if like {
                        let size = list?.count ?? 0
                        self.lblNodata.isHidden = size > 0
                        if size > 0 {
                            for model in list! {
                                model.likes = [userId]
                            }
                        } else {
                            DispatchQueue.main.async {
                                let msgIdFormat = StringRes.friend_no_like
                                let uname = self.userModel?.username ?? ""
                                let msg = String(format: getString(msgIdFormat), uname, uname)
                                self.lblNodata.text = msg
                            }
                        }
                        
                        completion(self.convertListModelToResult(list))
                    }
                }
            }
            
            return
        }
        completion(nil)
    }
    
    private func startCreateProfileItem(_ completion: @escaping (ResultModel?) -> Void) {
        DispatchQueue.global().async {
            let size = 1 //IJamitConstants.ARRAY_IDS_PROFILE.count
            let resultModel = ResultModel(200,"Ok")
            if size > 0 {
                let isPremium = MemberShipManager.shared.isPremiumMember()
                var listModels : [AbstractModel] = []
                let id = IJamitConstants.ARRAY_IDS_PROFILE[0]
                let name = getString(StringRes.array_profiles[0])
                let img = ImageRes.array_img_profiles[0]
                if !isPremium  {
                    let model = AbstractModel(id,name,img)
                    listModels.append(model)
                }
            }
            completion(resultModel)
        }
    }
    
    override func notifyWhenDataChanged() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
//    override func doOnNextWithListModel(_ listModels: inout [JsonModel]?, _ offset: Int, _ isGetNew: Bool) {
//        self.numberStory = listModels?.count ?? 0
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
            if model.isShowAds {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.nativeCell!, for: indexPath)
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
            let cell = cell as! EpisodeFlatListCell
            cell.isMyStories = false
            cell.isUserStories = true
            cell.menuDelegate = self.menuDelegate
            cell.listModels = self.listModels as? [EpisodeModel]
            cell.typeVC = self.typeVC
            cell.itemDelegate = self.itemDelegate
            cell.updateUI(episode)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let availableWidth = self.view.frame.width
        let bannerSize = (availableWidth * IJamitConstants.RATE_PROFILE_BANNER).rounded()
        return CGSize(width: availableWidth, height: bannerSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if (kind == UICollectionView.elementKindSectionHeader){
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing:self.idHeader!), for: indexPath) as? ProfileHeader else {
                fatalError("Invalid view type")
            }
            
//            headerView.delegate = profileDelegate
            headerView.parentVC = self
            headerView.setUpInfo(self.userModel, self.numberStory)
            self.friendHeader = headerView
            return headerView
        }
        fatalError()
    }
    
    func updateFollow( _ isFolow: Bool) {
        self.friendHeader?.updateFollow(isFolow)
    }
    
    
    @objc func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            friendHeader?.myShorts()
        }
        else if gesture.direction == .left {
            friendHeader?.myLikes()
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
}
