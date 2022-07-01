//
//  UserFlatListCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

class TopicCell: UICollectionViewCell {
    
    static let identifier = "TopicCell"

    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgTopic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var topic: TopicModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(_ model: TopicModel, _ font: UIFont){
        self.topic = model
        self.lblName.text = model.name
        self.lblName.font = font
        let avatar = model.topicID
        if avatar.starts(with: "http") {
            self.imgTopic.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_actionbar_logo_36dp))
        }
        else {
            self.imgTopic.image = UIImage(named: ImageRes.ic_actionbar_logo_36dp)
        }
    }
}
