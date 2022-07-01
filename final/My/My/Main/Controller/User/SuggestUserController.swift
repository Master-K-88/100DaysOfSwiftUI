//
//  SuggestUserController.swift
//  jamit
//  Created by Do Trung Bao on 23/12/2020.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class SuggestUserController: BaseCollectionController {
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: UserFlatListCell.self)
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        if ApplicationUtils.isOnline() {
            let userId = SettingManager.getUserId()
            JamItPodCastApi.getSuggestUsers(userId) { (list) in
                let result = self.convertListModelToResult(list)
                completion(result)
            }
            return
        }
        completion(nil)
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
