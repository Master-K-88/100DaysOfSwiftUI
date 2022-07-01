//
//  UserFlatListCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

class TrendingUserCell: UICollectionViewCell {

    private let RATE_ICON_RECORD: CGFloat = 0.140351
    
    @IBOutlet weak var layoutImage: UIView!
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var iconRecord: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    var user: UserModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ model: UserModel, _ width: CGFloat){
        self.user = model
        self.lblName.text = model.username
        
        self.iconRecord.isHidden = !model.isYourStory()
        self.iconRecord.cornerRadius = (width * RATE_ICON_RECORD)/2
        self.iconRecord.layoutIfNeeded()
        
        self.layoutImage.cornerRadius = width / 2
        self.imgUser.cornerRadius = (width - CGFloat(2)) / 2
        self.layoutImage.layoutIfNeeded()
        
        let avatar = model.avatar
        if avatar.starts(with: "http") {
            self.imgUser.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else {
            self.imgUser.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
    }
}
