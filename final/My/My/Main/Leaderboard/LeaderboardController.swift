//
//  LeaderboardController.swift
//  jamit
//
//  Created by Prof K on 12/9/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class LeaderboardController: BaseCollectionController {
    
    var idAdCell: String?
    var parentVC: MainController?
    var numberStory: Int?
    
    private var heightItemGrid: CGFloat = 0.0
    private var avatarWidth: CGFloat = 0.0
    
    var headerView: LeaderBoardCollectionViewCell?
    var dismissDelegate: DismissDelegate?
    var friendVC: NewUserProfileController?
    
    private var idCell : String = ""
    var newIndex: Int = 0
    
    override func setUpUI() {
        super.setUpUI()
        self.idAdCell = String(describing: EpisodeNativeAdCell.self)
        self.collectionView?.register(UINib(nibName: self.idAdCell!,bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.idAdCell!)
    }
    
    override func setUpCollectionView() {
        self.collectionView.register(UINib(nibName: String(describing: LeaderBoardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: LeaderBoardCollectionViewCell.self))
        
    }
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func updateInfo() {
        let size = self.listModels?.count ?? 0
        self.lblNodata.isHidden = size > 0
        idCell = getIDCellOfCollectionView()    }
    
    override func setUpCustomizeUI() {
        
    }
    
    private func getCellId(_ event: EventModel) -> String? {
        return String(describing: LeaderBoardCollectionViewCell.self)
    }
    
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        DispatchQueue.global().async {
            let setting = TotalDataManager.shared.getSetting()
            let isShow = setting != nil
            if SettingManager.isLoginOK() && ApplicationUtils.isOnline() && isShow {
                
                JamItPodCastApi.leaderBoard { leaderResponse in
                    if let leaderbboardModel = leaderResponse {
                        completion(self.convertListModelToResult(leaderbboardModel))
                        
                        self.listModels = leaderbboardModel
                    }
                    completion(self.convertListModelToResult(self.listModels))
                }
                self.startCreateProfileItem(completion)
                
            }
        }
    }
    
    func getUserInfo(userName: String,_ completion: @escaping (UserModel?) -> Void) {
        DispatchQueue.global().async {
            JamItPodCastApi.getUserInfo( userName) { (result) in
                completion(result)
            }
        }
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
    
    override func getIDCellOfCollectionView() -> String {
        let newValue = String(describing: LeaderBoardCollectionViewCell.self)
        return newValue
        
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        if let item = model as? LeaderboardModel {
            let cell = cell as! LeaderBoardCollectionViewCell
            cell.updateUI(item, index: self.newIndex)
            
        }
    }
    
    
    override func onBroadcastDataChanged(notification: Notification) {
        guard let id: String = notification.userInfo![IJamitConstants.KEY_ID] as? String else {
            notifyWhenDataChanged()
            return
        }
        guard let isFav: Bool = notification.userInfo![IJamitConstants.KEY_IS_FAV] as? Bool else {
            notifyWhenDataChanged()
            return
        }
        if isFav {
            onRefreshData(true)
        }
        else{
            if  self.listModels != nil && self.listModels!.count > 0 {
                let indexItem: Int = self.listModels!.firstIndex(where: {
                    let radio: EpisodeModel = ($0 as? EpisodeModel)!
                    return radio.id.elementsEqual(id)
                })!
                if indexItem >= 0 {
                    self.listModels!.remove(at: indexItem)
                }
                self.lblNodata.isHidden = self.listModels!.count != 0
                self.notifyWhenDataChanged()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        idCell = getIDCellOfCollectionView()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idCell, for: indexPath)
        if self.listModels != nil {
            if let item = self.listModels?[indexPath.row] as? EpisodeModel {
                if item.isShowAds {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idAdCell!, for: indexPath)
                    renderCell(cell: cell, model: item)
                    return cell
                }
            } else {
                if let item = self.listModels?[indexPath.row] {
                    self.newIndex = indexPath.row + 1
                    self.renderCell(cell: cell, model: item)
                }
                
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizeHeight = DimenRes.size_image_music_widget
        let sizeWidth = self.view.frame.width - 20
        return CGSize(width: sizeWidth, height: CGFloat(sizeHeight))
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let listModels = listModels {
            return listModels.count
        }
        return 0
    }
    
    @IBAction func backTapped(_ sender: Any) {
        view.removeFromSuperview()
        parentVC?.segment.isHidden = false
        parentVC?.bgTab.isHidden = false
        parentVC?.refreshContainerBottom()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pos: Int = indexPath.row
        if self.listModels != nil {
            if let item = listModels![pos] as? LeaderboardModel {
                DispatchQueue.global().async {
                    JamItPodCastApi.getUserInfo(item.username) { (user) in
                        if let user = user {
                            
                            self.friendVC = NewUserProfileController.create(IJamitConstants.STORYBOARD_STORY) as? NewUserProfileController
                            self.friendVC?.typeVC = IJamitConstants.TYPE_VC_USER_STORIES
                            self.friendVC?.itemDelegate = self.parentVC
//                            self.friendVC?.menuDelegate = self.parentVC?.menuDelegate
                            self.friendVC?.parentVC = self.parentVC
                            self.friendVC?.userModel = user
//                            self.friendVC?.isAllowRefresh = true
//                            self.friendVC?.isShowHeader = true
                            self.friendVC?.dismissDelegate = self.parentVC
//                            self.friendVC?.isAllowAddObserver = true
                            self.parentVC?.addControllerOnContainer(controller: self.friendVC!)
                        }
                    }
                }
            }
        }
    }
    
}
