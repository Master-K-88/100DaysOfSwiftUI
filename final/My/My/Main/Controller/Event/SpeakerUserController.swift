//
//  SpeakerUserController.swift
//  jamit
//
//  Created by Do Trung Bao on 31/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

class SpeakerUserController: BaseCollectionController {
    
    var event: EventModel!
    var dismissDelegate: DismissDelegate?
    var parentVC: LiveEventController?
    
    var pivotSpeaker: DolbyRequestSpeaker?
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: SpeakerUserCell.self)
    }
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getStringNoDataID() -> String{
        return StringRes.info_no_speaker
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if let speakers = self.parentVC?.listSpeaker {
            completion(self.convertListModelToResult(speakers))
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
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        if let user = model as? DolbyRequestSpeaker {
            (cell as? SpeakerUserCell)?.delegate = self
            (cell as? SpeakerUserCell)?.updateUI(user)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * CGFloat(2)
        let availableWidth = view.frame.width - paddingSpace
        let sizeHeight = DimenRes.row_flat_list_user_height
        return CGSize(width: availableWidth, height: CGFloat(sizeHeight))
    }
    
    override func deleteModel(_ model: JsonModel) {
        self.parentVC?.listSpeaker?.removeAll(where: { speaker in
            return speaker.equalElement(model)
        })
        super.deleteModel(model)
    }
    
}
extension SpeakerUserController: SpeakerUserDelegate {
    func onEdit(_ speaker: DolbyRequestSpeaker) {
        self.pivotSpeaker = speaker
        var resource = ConfirmResource()
        resource.title = getString(StringRes.title_permission)
        resource.msg = getString(!speaker.isHasPermission ? StringRes.info_confirm_turn_on_speaker : StringRes.info_confirm_turn_off_speaker)
        resource.artwork = speaker.userAvatar
        resource.posStrId = !speaker.isHasPermission ? StringRes.title_accept : StringRes.title_remove
        resource.negStrId = !speaker.isHasPermission ? StringRes.title_decline : StringRes.title_cancel
        resource.posTextColor = .white
        resource.posBgColorId = ColorRes.subscribe_color
        self.parentVC?.showDialogConfirm(resource, self)
    }
    
}

extension SpeakerUserController: ConfirmDelegate {
    
    func onCancel() {
        let isHasPermission = self.pivotSpeaker?.isHasPermission ?? false
        if let id = self.pivotSpeaker?.userId, !isHasPermission {
            let msgDeclined = DolbyMessage.buildCommandMsg(IDolbyConstant.SCHEME_HOST_URI, id, IDolbyConstant.CMD_DECLINE_RAISE_HAND)
            self.parentVC?.dolbySdkManager?.sendMessage(msgDeclined, false)
            self.deleteModel(self.pivotSpeaker!)
        }
    }
    
    func onConfirm() {
        let isHasPermission = self.pivotSpeaker?.isHasPermission ?? false
        if let participant = self.pivotSpeaker?.participant {
            let isHasSpeaker = !isHasPermission
            self.parentVC?.dolbySdkManager?.updateSpeakerOnServer(participant, isHasSpeaker, {
                self.pivotSpeaker?.isHasPermission = isHasSpeaker
                if isHasSpeaker {
                    self.notifyWhenDataChanged()
                }
                else{
                    self.deleteModel(self.pivotSpeaker!)
                }
                
            })
        }
    }
    
    func onTopAction() {
        
    }
    
    
}
