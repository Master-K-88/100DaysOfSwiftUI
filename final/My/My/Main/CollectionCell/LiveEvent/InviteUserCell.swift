//
//  InviteUserCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit
protocol InviteUserDelegate {
    func onInvite(_ user: UserModel)
}
class InviteUserCell: UICollectionViewCell {

    @IBOutlet var rootLayout: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnInvite: AutoFillButton!
    var user: UserModel!
    var delegate: InviteUserDelegate?
    
    private let colorInvite = getColor(hex: ColorRes.subscribe_color)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func inviteTap(_ sender: Any) {
        self.delegate?.onInvite(user)
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
        self.btnInvite.isEnabled = !user.isInvited
        let titleId = user.isInvited ? StringRes.title_invited : StringRes.title_invite
        self.btnInvite.setTitle(getString(titleId), for: .normal)
        self.btnInvite.backgroundColor = user.isInvited ? .clear : colorInvite
        self.btnInvite.setTitleColor(.white, for: .normal)
        self.btnInvite.borderWidth = user.isInvited ? CGFloat(1) : CGFloat(0)
        self.btnInvite.borderColor = user.isInvited ? .white : .clear
        
    }
}
