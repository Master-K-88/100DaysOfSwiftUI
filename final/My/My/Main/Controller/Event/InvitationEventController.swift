//
//  InvitationEventController.swift
//  jamit
//
//  Created by Do Trung Bao on 24/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

class InvitationEventController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var dismissDelegate: DismissDelegate?
    
    var screenTitle: String?
    private var avatarWidth: CGFloat = 0.0
    private var heightItemGrid: CGFloat = 0.0
    private let currentUserId = SettingManager.getUserId()
    
    var parentVC: MainController?
    var eventDelegate: EventTotalDelegate?
 
    override func getIDCellOfCollectionView() -> String {
        return String(describing: InvitationEventCell.self)
    }
    
    override func getUIType() -> UIType {
        return .CardList
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if ApplicationUtils.isOnline() {
            JamItEventApi.getEventInvitations { events in
                completion(self.convertListModelToResult(events))
            }
            return
        }
        completion(nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeObserverForData()
        self.dismissDelegate?.dismiss(controller: self)
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
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.widthItemGrid == 0 && self.heightItemGrid == 0 {
            self.widthItemGrid = self.view.frame.width - 2 * DimenRes.medium_padding
            self.heightItemGrid = self.widthItemGrid * IJamitConstants.RATE_2_1
            self.avatarWidth = self.heightItemGrid  * IJamitConstants.RATE_AVATAR_EVENT_CELL
        }
        return CGSize(width: self.widthItemGrid, height: self.heightItemGrid)
        
    }
    
    //override for collectionView
    override func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        (cell as? InvitationEventCell)?.updateUI(model as! EventModel, self.currentUserId,self.avatarWidth)
        (cell as? InvitationEventCell)?.baseDelegate = self.eventDelegate
        (cell as? InvitationEventCell)?.controller = self
        (cell as? InvitationEventCell)?.inviteDelegate = self
    }
    
    //override to did not do anything, we only have action via button
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
    
    
}
extension InvitationEventController: InvitationEventDelegate {
    
    func onSubscribe(_ model: EventModel, _ controller: JamitRootViewController?) {
        self.eventDelegate?.onSubscribe(model, controller)
    }
    
    func onLiveJoin(_ model: EventModel, _ isAcceptInvite: Bool) {
        self.eventDelegate?.onLiveJoinFromInvitation(model, isAcceptInvite)
    }
    
}
