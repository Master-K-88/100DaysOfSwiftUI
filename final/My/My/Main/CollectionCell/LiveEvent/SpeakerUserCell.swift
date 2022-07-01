//
//  SpeakerUserCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit
protocol SpeakerUserDelegate {
    func onEdit(_ speaker: DolbyRequestSpeaker)
}
class SpeakerUserCell: UICollectionViewCell {

    @IBOutlet var rootLayout: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var speaker: DolbyRequestSpeaker!
    var delegate: SpeakerUserDelegate?
    
    private let formatRequest = getString(StringRes.format_request_speaker)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editTap(_ sender: Any) {
        self.delegate?.onEdit(speaker)
    }
    
    func updateUI(_ speaker: DolbyRequestSpeaker){
        self.speaker = speaker
        if speaker.isHasPermission {
            self.lblName.text = speaker.userName
        }
        else{
            self.lblName.text = String(format: formatRequest, speaker.userName)
        }
        let avatar = speaker.userAvatar
        if avatar.starts(with: "http") {
            self.imgIcon.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else {
            self.imgIcon.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
    }
}
