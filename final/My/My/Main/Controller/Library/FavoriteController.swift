//
//  FavoriteController.swift
//  Created by YPY Global on 4/11/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class FavoriteController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    
    var menuDelegate: MenuEpisodeDelegate?
    var dismissDelegate: DismissDelegate?
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if ApplicationUtils.isOnline() && SettingManager.isLoginOK() {
            JamItPodCastApi.getUserFavEpisode { (list) in
                let size = list?.count ?? 0
                if size > 0 {
                    for model in list! {
                        model.likes = [SettingManager.getUserId()]
                    }
                }
                completion(self.convertListModelToResult(list))
            }
            return
        }
        completion(self.convertListModelToResult([]))
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
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: NewEpisodeFlatListCell.self)
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let item = model as! EpisodeModel
        let cell = cell as! NewEpisodeFlatListCell
        cell.updateUI(item)
        if item.audioType == "short" {
            cell.imgEpisode.isHidden = true
        } else {
            cell.imgEpisode.isHidden = false
        }
        cell.menuDelegate = self.menuDelegate
        cell.showDelegate = self
        cell.listModels = self.listModels as? [EpisodeModel]
        cell.typeVC = self.typeVC
        cell.itemDelegate = self.itemDelegate
    }
    
    override func getStringNoDataID() -> String {
        return StringRes.info_no_favorite
    }
    
    @IBAction func backTap(_ sender: Any) {
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
}
extension FavoriteController : GoToShowDelegate {
    
    func goToShowOf(_ model: EpisodeModel) {
        self.itemDelegate?.clickItem(list: [], model: model.getShowModel(), position: 0)
    }

}
