//
//  BaseEventCell.swift
//  jamit
//
//  Created by Do Trung Bao on 19/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

protocol BaseEventDelegate {
    func onShare(_ event: EventModel, _ pivotView: UIView?)
    func onGoToProfile(_ event: EventModel)
}

class BaseEventCell: UICollectionViewCell {
    
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var lblAuthor: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTopic: UILabel!
    @IBOutlet var imgAvatar: UIImageView!
    
    var event: EventModel!
    var currentUserId: String!
    var baseDelegate: BaseEventDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblAuthor.isUserInteractionEnabled = true
        self.lblAuthor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile)))
        
        self.imgAvatar.isUserInteractionEnabled = true
        self.imgAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile)))
    }
    
    @objc func goToProfile() {
        self.baseDelegate?.onGoToProfile(event)
    }
    
    @IBAction func shareTap(_ sender: Any) {
        self.baseDelegate?.onShare(event,btnShare)
    }
    
    func updateUI(_ event: EventModel, _ currentUserId: String, _ avatarWidth: CGFloat) {
        self.event = event
        self.currentUserId = currentUserId
        self.lblTitle.text = event.title
        self.lblTopic.text = event.getTopic()
        self.lblAuthor.text = event.getAuthor()
        
        self.imgAvatar.cornerRadius = avatarWidth / 2
        self.imgAvatar.layoutIfNeeded()
        
        let imgUrl = event.host?.avatar ?? ""
        if imgUrl.starts(with: "http") {
            self.imgAvatar.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.ic_circle_avatar_default))
        }
        else {
            self.imgAvatar.image = UIImage(named: ImageRes.ic_circle_avatar_default)
        }
       
    }
}
