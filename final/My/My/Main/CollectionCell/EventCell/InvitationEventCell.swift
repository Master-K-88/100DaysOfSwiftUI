//
//  InvitationEventCell.swift
//  jamit
//
//  Created by Do Trung Bao on 24/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

protocol InvitationEventDelegate {
    func onSubscribe(_ model: EventModel, _ controller: JamitRootViewController?)
    func onLiveJoin(_ model: EventModel, _ isAcceptInvite: Bool)
}

class InvitationEventCell: BaseEventCell {
    
    @IBOutlet weak var btnDecline: AutoFillButton!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgState: UIImageView!
    
    var inviteDelegate: InvitationEventDelegate?
    var controller: JamitRootViewController?
    
    private let cardColorComing = getColor(hex: ColorRes.card_color_upcoming)
    private let cardColorLive = getColor(hex: ColorRes.card_color_live)
    private let colorLive = getColor(hex: ColorRes.color_live)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func joinTap(_ sender: Any) {
        let isLive = event.isLiveEvent()
        if isLive {
            self.inviteDelegate?.onLiveJoin(event, true)
        }
        else{
            self.inviteDelegate?.onSubscribe(event, controller)
        }
    }
    
    @IBAction func declineTap(_ sender: Any) {
        let isLive = event.isLiveEvent()
        if isLive {
            self.inviteDelegate?.onLiveJoin(event, false)
        }
    }
    
    override func updateUI(_ event: EventModel, _ currentUserId: String, _ avatarWidth: CGFloat) {
        super.updateUI(event,currentUserId,avatarWidth)
        let isLive = event.isLiveEvent()
        self.lblSubTitle.text = isLive ? event.getTopic() : event.time
        self.btnDecline.isHidden = !isLive
        
        self.imgState.image = UIImage(named: isLive ? ImageRes.ic_event_live_36dp : ImageRes.ic_event_upcoming_36dp)
        self.imgState.tintColor = isLive ? colorLive : .white
        self.rootLayout.backgroundColor = isLive ? cardColorLive : cardColorComing
        
        let isSubscribed = event.isSubscribed(currentUserId)
        if (isLive) {
            self.btnJoin.setTitle(getString(StringRes.title_accept_join), for: .normal)
        }
        else {
            let textId = isSubscribed ? StringRes.title_remove_me : StringRes.title_notify_me
            self.btnJoin.setTitle(getString(textId), for: .normal)
        }
        
    }
}
