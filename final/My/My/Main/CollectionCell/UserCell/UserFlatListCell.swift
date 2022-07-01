//
//  UserFlatListCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

class UserFlatListCell: UICollectionViewCell {

    @IBOutlet var rootLayout: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var user: UserModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ model: UserModel){
        self.user = model
        self.lblName.text = model.username
        let avatar: String = model.avatar
        if avatar.starts(with: "http") {
            self.imgIcon.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else {
            self.imgIcon.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
    }
}
