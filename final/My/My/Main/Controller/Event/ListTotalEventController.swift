//
//  ListTotalEventController.swift
//  jamit
//
//  Created by Do Trung Bao on 23/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

class ListTotalEventController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var dismissDelegate: DismissDelegate?
    
    var screenTitle: String?
    private var avatarWidth: CGFloat = 0.0
    private var heightItemGrid: CGFloat = 0.0
    private var currentUserId: String = ""
    
    var eventType: String?
    var eventUserId: String?
    
    var parentVC: MainController?
    var eventDelegate: EventTotalDelegate?
 
    override func setUpCustomizeUI() {
        self.lblTitle.text = self.screenTitle
        self.currentUserId = SettingManager.getUserId()
    }
    
    override func setUpCollectionView() {        
        self.collectionView.register(UINib(nibName: String(describing: LiveEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: LiveEventCell.self))
        
        self.collectionView.register(UINib(nibName: String(describing: UpCommingEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: UpCommingEventCell.self))
        
        self.collectionView.register(UINib(nibName: String(describing: PastEventCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PastEventCell.self))
    }
    
    override func getUIType() -> UIType {
        return .CardList
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if ApplicationUtils.isOnline() {
            if self.eventUserId != nil && !self.eventUserId!.isEmpty {
                JamItEventApi.getUserEvents(self.eventUserId!) { events in
                    completion(self.convertListModelToResult(events))
                }
                return
            }
            if self.eventType != nil && !self.eventType!.isEmpty {
                JamItEventApi.getListTypeEvents(self.eventType!) { events in
                    completion(self.convertListModelToResult(events))
                }
                return
            }
        }
        completion(nil)
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let event = listModels?[indexPath.row] as? EventModel {
            if let idCell = self.getCellId(event) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath)
                self.renderCell(cell: cell, model: event)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        (cell as! BaseEventCell).updateUI(model as! EventModel, self.currentUserId,self.avatarWidth)
        (cell as! BaseEventCell).baseDelegate = self.eventDelegate
        (cell as? PastEventCell)?.pastDelegate = self.eventDelegate
        
        (cell as? UpCommingEventCell)?.upcommingDelegate = self.eventDelegate
        (cell as? UpCommingEventCell)?.controller = self
        
        (cell as? LiveEventCell)?.liveDelegate = self.eventDelegate
    }
    
    //override to did not do anything, we only have action via button
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
    
    private func getCellId(_ event: EventModel) -> String? {
        let type = eventType != nil && !eventType!.isEmpty ? eventType! : event.status
        if type.elementsEqual(EventModel.STATUS_LIVE) {
            return String(describing: LiveEventCell.self)
        }
        else if type.elementsEqual(EventModel.STATUS_UPCOMING) || type.elementsEqual(EventModel.STATUS_UPCOMING1) {
            return String(describing: UpCommingEventCell.self)
        }
        else if type.elementsEqual(EventModel.STATUS_PAST) {
            return String(describing: PastEventCell.self)
        }
        return nil
    }
    
}
