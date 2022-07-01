//
//  UpCommingEventCell.swift
//  jamit
//
//  Created by Do Trung Bao on 19/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

protocol UpcommingEventDelegate {
    func onSubscribe(_ event: EventModel, _ controller: JamitRootViewController?)
}

class UpCommingEventCell: BaseEventCell {
    
    @IBOutlet var btnNotify: UIButton!
    @IBOutlet var lblDate: UILabel!
    
    var upcommingDelegate: UpcommingEventDelegate?
    var controller: JamitRootViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func notifyTap(_ sender: Any) {
        self.upcommingDelegate?.onSubscribe(event,controller)
    }
    
    override func updateUI(_ event: EventModel, _ currentUserId: String, _ avatarWidth: CGFloat) {
        super.updateUI(event,currentUserId,avatarWidth)
        
        formateEventDate(event)
        
        
        let isHostEvent = event.isHostEvent(currentUserId)
        let isSubscribed = event.isSubscribed(currentUserId)
        if isHostEvent {
            self.btnNotify.setTitle(getString(StringRes.title_manage), for: .normal)
        }
        else {
            self.btnNotify.setTitle(getString(isSubscribed ? StringRes.title_remove_me : StringRes.title_notify_me), for: .normal)
        }
    }
    
    fileprivate func formateEventDate(_ event: EventModel) {
        let eventDate = event.startTime
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: eventDate) {
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
            let currentEventDate:String = dateFormatter.string(from: date as Date)
            let eventDay = currentEventDate.prefix(currentEventDate.count - 5)
            let eventTime = currentEventDate.suffix(5)
            let eventHour = eventTime.prefix(2)
            if eventHour.compare("12") == .orderedAscending {
                self.lblDate.text = "\(eventDay) \(eventTime)AM"
            } else if eventHour.compare("12") == .orderedSame {
                let eventMin = eventTime.suffix(2)
                if eventMin.compare("00") == .orderedSame {
                    self.lblDate.text = "\(eventDay) \(eventTime)NOON"
                } else {
                    self.lblDate.text = "\(eventDay) \(eventTime)PM"
                }
            } else if eventHour.compare("12") == .orderedDescending {
                let eventHourInt:Int = Int(eventHour)!
                let newEventTime = eventHourInt - 12
                let statedEventTime: String = "\(newEventTime):\(eventTime.suffix(2))"
                self.lblDate.text = "\(eventDay) \(statedEventTime)PM"
            }
        }
    }
}
