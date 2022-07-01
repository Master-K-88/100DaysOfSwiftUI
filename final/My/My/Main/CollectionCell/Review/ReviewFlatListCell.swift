//
//  RadioFlatListCell.swift
//  Created by YPY Global on 12/21/18.
//  Copyright © 2018 YPY Global. All rights reserved.
//

import UIKit
import MarqueeLabel
import UIKit
protocol ReviewDelegate {
    func deleteReview(_ review: ReviewModel)
    func clickUser(_ review: ReviewModel)
}
class ReviewFlatListCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: MarqueeLabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblCreatedData: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var rootLayout: UIView!
    
    var delegate: ReviewDelegate?
    
    let userId = SettingManager.getUserId()
    
    var review: ReviewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ review: ReviewModel) {
        self.review = review
        self.imgAvatar.cornerRadius = self.imgAvatar.frame.size.width / CGFloat(2)
        self.lblName.text = review.author.username
        self.lblCreatedData.text = review.getStrTimeAgo()
        self.lblReview.text = review.text
        self.btnDelete.isHidden = !review.isMyComment(userId)
        let avatar = review.author.avatar
        if avatar.starts(with: "http") {
            self.imgAvatar.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else {
            self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        if self.review != nil {
            self.delegate?.deleteReview(self.review!)
        }
    }
    @IBAction func avatarClick(_ sender: Any) {
        if self.review != nil {
            self.delegate?.clickUser(self.review!)
        }
    }
}

