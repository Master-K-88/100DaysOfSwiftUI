//
//  InvitationUserController.swift
//  jamit
//
//  Created by Do Trung Bao on 31/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

class InvitationUserController: BaseCollectionController {
    
    @IBOutlet weak var tfSearch: AutoFillTextField!
    
    var event: EventModel!
    var dismissDelegate: DismissDelegate?
    var parentVC: LiveEventController?
    var keyword = ""
    
    override func setUpUI() {
        super.setUpUI()
        self.tfSearch.placeholderColor(color: getColor(hex: ColorRes.main_second_text_color))
        self.registerTapOutSideRecognizer()
        self.tfSearch.delegate = self
    }
 
    override func getIDCellOfCollectionView() -> String {
        return String(describing: InviteUserCell.self)
    }
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getStringNoDataID() -> String{
        return StringRes.info_no_data_find_user
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if !self.keyword.isEmpty, ApplicationUtils.isOnline() {
            JamItPodCastApi.searchUsers(keyword) { result in
                if let listUsers = result {
                    completion(self.convertListModelToResult(listUsers))
                    return
                }
                completion(nil)
            }
            return
        }
        completion(nil)
    }
    
    @IBAction func shareTap(_ sender: Any) {
        self.parentVC?.shareWithDeepLink(self.event, sender as? UIView)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.hideVirtualKeyboard()
        self.unregisterTapOutSideRecognizer()
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    override func hideVirtualKeyboard() {
        self.tfSearch.resignFirstResponder()
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        if let user = model as? UserModel {
            (cell as? InviteUserCell)?.delegate = self
            (cell as? InviteUserCell)?.updateUI(user)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * CGFloat(2)
        let availableWidth = view.frame.width - paddingSpace
        let sizeHeight = DimenRes.row_flat_list_user_height
        return CGSize(width: availableWidth, height: CGFloat(sizeHeight))
    }
}

extension InvitationUserController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.keyword = self.tfSearch.text ?? ""
        if !self.keyword.isEmpty {
            self.tfSearch.text = ""
            self.isStartLoadData = false
            self.startLoadData()
        }
        return true
    }
}

extension InvitationUserController: InviteUserDelegate {
    func onInvite(_ user: UserModel) {
        self.parentVC?.dolbySdkManager?.inviteUser(user)
    }
}
