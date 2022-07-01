//
//  LiveEventCell.swift
//  jamit
//
//  Created by Do Trung Bao on 19/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

protocol LiveEventDelegate {
    func onJoin(_ event: EventModel, _ isAcceptInvite: Bool)
}

class LiveEventCell: BaseEventCell {
    
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var lblNumListener: UILabel!
    
    var liveDelegate: LiveEventDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func joinTap(_ sender: Any) {
        if self.event == nil || self.currentUserId == nil { return }
        let isSubscribed = self.event.isSubscribed(self.currentUserId)
        let isInvited = self.event.isInvitedUser(self.currentUserId)
        let isHostEvent = self.event.isHostEvent(self.currentUserId)
        self.liveDelegate?.onJoin(event, !isSubscribed && isInvited && !isHostEvent)
    }
  
    override func updateUI(_ event: EventModel, _ currentUserId: String, _ avatarWidth: CGFloat) {
        super.updateUI(event,currentUserId,avatarWidth)
        let isInvited = event.isInvitedUser(currentUserId)
        let isHostEvent = event.isHostEvent(currentUserId)
        let str = getString(isInvited && !isHostEvent ? StringRes.title_accept_join : StringRes.title_join_now)
        self.btnJoin.setTitle(str, for: .normal)
        
        if event.numListeners > 0 {
            self.lblNumListener.text = StringUtils.formatNumberSocial(StringRes.format_listener,
                                                                      StringRes.format_listeners,
                                                                      event.numListeners)
            
        }
        else{
            self.lblNumListener.text = getString(StringRes.info_be_first_one)
        }
    }
}
