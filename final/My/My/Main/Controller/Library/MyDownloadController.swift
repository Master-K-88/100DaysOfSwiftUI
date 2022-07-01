//
//  MyDownloadController.swift
//  jamit
//  Created by YPY Global on 12/25/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class MyDownloadController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    
    var menuDelegate: MenuEpisodeDelegate?
    var dismissDelegate: DismissDelegate?
    var parentVC: MainController?

    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: NewEpisodeFlatListCell.self)
    }
      
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let item = model as! EpisodeModel
        let cell = cell as! NewEpisodeFlatListCell
        
        cell.updateUI(item)
        cell.menuDelegate = self.menuDelegate
        cell.listModels = self.listModels as? [EpisodeModel]
        cell.typeVC = self.typeVC
        cell.showDelegate = self
        cell.itemDelegate = self.itemDelegate
    }
    
    override func onBroadcastDataChanged(notification: Notification) {
        guard let typeVC: Int = notification.userInfo![IJamitConstants.KEY_VC_TYPE] as? Int else {
            self.notifyWhenDataChanged()
            return
        }
        if typeVC != 0 {
            onRefreshData(true)
        }
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
    
    override func getStringNoDataID() -> String {
        return StringRes.info_no_favorite
    }
    
    func showDialogDeleteOffline(_ episode: EpisodeModel){
        let msg = getString(StringRes.info_delete_file)
        let titleCancel = getString(StringRes.title_cancel)
        let titleDelete = getString(StringRes.title_delete)
        self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleDelete, negative: titleCancel, completion: {
            DispatchQueue.global().async {
                let b = self.totalDataMng.removeModelInCache(IJamitConstants.TYPE_VC_DOWNLOAD, episode)
                if b {
                    self.totalDataMng.deleteDownloadFileOfTrack(episode)
                }
                DispatchQueue.main.async {
                    self.deleteModel(episode)
//                    self.parentVC?.libraryVC?.updateInfoDownload()
                    if StreamManager.shared.isHavingList() {
                       let currentModel = StreamManager.shared.currentModel
                       if currentModel != nil && currentModel!.equalElement(episode){
                        self.parentVC?.startMusicAction(.Stop)
                       }
                    }
                }
            }
        })
    }
   
}
extension MyDownloadController : GoToShowDelegate {
    
    func goToShowOf(_ model: EpisodeModel) {
        self.itemDelegate?.clickItem(list: [], model: model.getShowModel(), position: 0)
    }

}
