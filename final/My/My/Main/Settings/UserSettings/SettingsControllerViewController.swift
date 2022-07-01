//
//  SettingsControllerViewController.swift
//  jamit
//
//  Created by Prof K on 10/18/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class SettingsControllerViewController: BaseCollectionController {

    var idSignOut: String?
    var parentVC: MainController?
    var submitPodcast: TabSubmitPodcast?
    var user: UserModel?

    override func setUpUI() {
        super.setUpUI()
        self.itemDelegate = self

        self.idSignOut = String(describing: ProfileButtonCell.self)
        self.collectionView.register(UINib(nibName: self.idSignOut!, bundle: nil), forCellWithReuseIdentifier: self.idSignOut!)

    }

    override func getUIType() -> UIType {
        return .FlatList
    }

    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        let setting = TotalDataManager.shared.getSetting()
        let isShow = setting != nil && setting!.showAudioTypes
        if SettingManager.isLoginOK() && ApplicationUtils.isOnline() && isShow {
            let userName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            JamItPodCastApi.getUserInfo( userName) { (result) in
                self.user = result
                self.startCreateProfileItem(completion)
            }
            return
        }
        self.user = nil
        startCreateProfileItem(completion)
    }

    private func startCreateProfileItem(_ completion: @escaping (ResultModel?) -> Void) {
        DispatchQueue.global().async {
            let size = IJamitConstants.ARRAY_IDS_PROFILE.count
            let resultModel = ResultModel(200,"Ok")
            if size > 0 {
                let isPremium = MemberShipManager.shared.isPremiumMember()
                var listModels : [AbstractModel] = []
                for i in 0..<size {
                    let id = IJamitConstants.ARRAY_IDS_PROFILE[i]
                    let name = getString(StringRes.array_profiles[i])
                    if i == 0 {
                        if !isPremium  {
                            let model = AbstractModel(id,name)
                            listModels.append(model)
                        }
                    }
                    else{
                        let model = AbstractModel(id,name)
                        listModels.append(model)
                    }
                }
                if SettingManager.isLoginOK() {
                    let signOut = AbstractModel(IJamitConstants.ID_SIGN_OUT, getString(StringRes.title_sign_out),"")
                    listModels.append(signOut)
                }
                resultModel.listModel = listModels
            }
            completion(resultModel)
        }
    }


    override func getIDCellOfCollectionView() -> String {
        return String(describing: ProfileFlatListCell.self)
    }

    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let item = model as! AbstractModel
        if item.id == IJamitConstants.ID_SIGN_OUT {
            let cell = cell as! ProfileButtonCell
            cell.updateUI(item)
        }
        else{
            let cell = cell as! ProfileFlatListCell
            cell.updateUI(item)
        }

    }

    //override render cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.listModels![indexPath.row] as! AbstractModel
        if model.id == IJamitConstants.ID_SIGN_OUT {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idSignOut!, for: indexPath)
            self.renderCell(cell: cell, model: model)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.listModels![indexPath.row] as! AbstractModel
        var sizeHeight = DimenRes.height_item_profile
        if model.id == IJamitConstants.ID_SIGN_OUT {
            sizeHeight = sizeHeight + CGFloat(2) * DimenRes.medium_padding
        }
        return CGSize(width: self.view.frame.width, height: CGFloat(sizeHeight))
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        guard let parentVC = parentVC else {
            submitPodcast?.layoutBtAction.isHidden = false
            self.removeFromParent()
            self.view.removeFromSuperview()
            return
        }
        self.view.removeFromSuperview()
        parentVC.segment.isHidden = false
        parentVC.bgTab.isHidden = false
        parentVC.refreshContainerBottom()
    }


    func signOut() {
        self.isStartLoadData = false
        self.startLoadData()
        self.goToLogin()
    }

    func goToRecording() {
        NavigationManager.shared.goToRecording(currentVC: self.parentVC!)
    }

    func goToLogin() {
        NavigationManager.shared.goToLogin(currentVC: self.parentVC!)
    }

    func goToMyStories() {
        if let myStoryVC = self.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_MY_STORIES) {
            self.parentVC?.myStoryVC = myStoryVC
            self.parentVC?.addControllerOnContainer(controller: myStoryVC)
        }
    }

    func goToSocialPage(_ type: Int) {
        if self.user != nil {
            self.parentVC?.goToSocialPage(self.user!, type)
        }
    }




}

extension SettingsControllerViewController: AppItemDelegate {
    func gotoEpisodeDetail(_ model: JsonModel) {
        
    }
    
    func clickItem(list: [JsonModel], model: JsonModel, position: Int) {
        if model is AbstractModel {
            let menuModel = model as! AbstractModel
            if menuModel.id < 0{
                onProfileMenuItemSelected(menuModel.id)
            }
        }
    }
    
    func onProfileMenuItemSelected(_ id: Int) {
        switch id {
        case IJamitConstants.ID_UPDATE_PREMIUM:
            NavigationManager.shared.goToUpgradeMember(currentVC: self.parentVC)
            break
        case IJamitConstants.ID_RATE_US:
            ShareActionUtils.rateMe(appId: IJamitConstants.APP_ID)
            break
        case IJamitConstants.ID_VISIT_WEBSITE:
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_WEBSITE)
            break
        case IJamitConstants.ID_VISIT_FACEBOOK:
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_FACEBOOK)
            break
        case IJamitConstants.ID_VISIT_INSTA:
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_INSTAGRAM)
            break
        case IJamitConstants.ID_VISIT_TWITTER:
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_TWITTER)
            break
        case IJamitConstants.ID_TELL_A_FRIEND:
            let msg = String.init(format: getString(StringRes.format_share_app), getString(StringRes.app_name))
            self.shareContent(msg,IJamitConstants.APP_ID)
            break
        case IJamitConstants.ID_CONTACT_US:
            let subject = getString(StringRes.title_contact_us) + " iOS - " + getString(StringRes.app_name)
            self.shareViaEmail(recipients: [IJamitConstants.YOUR_CONTACT_EMAIL], subject: subject, body: "")
            break
        case IJamitConstants.ID_PRIVACY_POLICY:
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_PRIVACY_POLICY)
            break
        case IJamitConstants.ID_TERM_OF_USE:
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_TERM_OF_USE)
            break
        case IJamitConstants.ID_SIGN_OUT:
            self.showAlertWithResId(titleId: StringRes.title_confirm, messageId: StringRes.info_logout, positiveId: StringRes.title_sign_out, negativeId: StringRes.title_cancel, completion: {
                self.parentVC?.dolbySdkManager?.logoutToDolby()
                SettingManager.logOut()
                MemberShipManager.shared.resetIAP()
                self.signOut()
            })
            break
        default:
            break
        }
    }
    
}
//extension SettingsControllerViewController: ProfileDelegate {
//    func followUser(_ user: UserModel) {
//        
//    }
//    
//    func goToUserEvents(_ user: UserModel) {
//        
//    }
//    
//    func goToMyHighLight() {
//        
//    }
//    
//    func goToEditProfile() {
//        
//    }
//    
//    func updateLikeSelection() {
//        
//    }
//    
//    func updateShortSelection() {
//        
//    }
//    
//    
//    
//    
//    
//}
