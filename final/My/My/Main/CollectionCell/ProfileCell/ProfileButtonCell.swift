//
//  ProfileFlatListCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

class ProfileButtonCell: UICollectionViewCell {

    @IBOutlet var rootLayout: UIView!
    @IBOutlet weak var lblButton: UILabel!
    var profileModel: AbstractModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ model: AbstractModel){
        self.profileModel = model
        self.lblButton.text = model.name
        
    }
    
}
