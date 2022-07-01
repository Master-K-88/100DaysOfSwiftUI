//
//  ListUserController.swift
//  jamit
//
//  Created by YPY Global on 22/12/2020.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class ListUserController : BaseCollectionController {
    
    var parentVC: SocialInfoController?
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: UserFlatListCell.self)
    }
    
    override func onLoadData(_ isNeedRefresh: Bool, _ isNeedHideCollectView: Bool) {
        if isNeedRefresh {
            self.parentVC?.startLoadData(true)
            return
        }
        super.onLoadData(isNeedRefresh, isNeedHideCollectView)
    }
    
    override func startLoadData() {
        if !isStartLoadData {
            isStartLoadData = true
            self.showLoading(false)
            self.hideRefreshUI()
            setUpInfo(listModels)
        }
    }
    
    //override function to calculate height of category
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height:  DimenRes.row_flat_list_user_height)
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let user = model as! UserModel
        let cell = cell as! UserFlatListCell
        cell.updateUI(user)
    }
}
