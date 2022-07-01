//
//  ProfileFlatListCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

class ProfileFlatListCell: UICollectionViewCell {

    @IBOutlet var rootLayout: UIView!
//    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var profileModel: AbstractModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(_ model: AbstractModel){
        self.profileModel = model
        self.lblName.text = model.name
//        self.imgIcon.image = UIImage(named: model.img)
    }
}
