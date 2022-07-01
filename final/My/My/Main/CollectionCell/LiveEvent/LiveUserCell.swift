//
//  LiveUserCell.swift
//  Created by YPY Global on 1/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit
import VoxeetSDK

//struct StateResource {
//    var imgResId: String = ImageRes.ic_event_waiting_24dp
//    var bgColor: UIColor?
//    var tintColor: UIColor?
//    
//    init(imgResId: String, bgColor: UIColor? , tintColor: UIColor?) {
//        self.imgResId = imgResId
//        self.bgColor = bgColor
//        self.tintColor = tintColor
//    }
//}

class LiveUserCell: UICollectionViewCell {

    private let RATE_ICON_RECORD: CGFloat = 0.3
    
    @IBOutlet weak var layoutImage: UIView!
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var layoutState: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgHost: UIImageView!
    @IBOutlet weak var imgState: UIImageView!
    
    private let stateActiveColor: UIColor = .white
    private let colorRecording = getColor(hex: ColorRes.color_recording)
    private let stateAvatarActive = getColor(hex: ColorRes.color_accent)
    private let stateAvatarNormal = getColor(hex: ColorRes.live_bg_avatar_normal)
    
    var dolbyUser: DolbyParticipant?
    var dolbySdkManager: DolbySdkManager?
    var currentUserType: Int = 0
    var listStates: [VTParticipantStatus:StateResource]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ dolbyUser: DolbyParticipant, _ width: CGFloat){
        self.dolbyUser = dolbyUser
        self.lblName.text = dolbyUser.participant.info.name
        if let avatar = dolbyUser.participant.info.avatarURL, avatar.starts(with: "http") {
            self.imgUser.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else{
            self.imgUser.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
        let cornerRadius = ((width - CGFloat(4)) / 2).rounded()
        self.imgUser.cornerRadius = cornerRadius
        self.layoutImage.cornerRadius = (width / 2).rounded()
        self.layoutImage.layoutIfNeeded()
        
        self.layoutState.cornerRadius = (width * RATE_ICON_RECORD)/2
        self.layoutState.layoutIfNeeded()
        
        let isCurrentHost = dolbyUser.isHost
        self.imgHost.isHidden = !isCurrentHost
        
        let isCurrentSpeaker = dolbyUser.isSpeaker
        let isCanSpeak = isCurrentHost || isCurrentSpeaker
        let isSpeaking = dolbyUser.isSpeaking
        
        let status = dolbyUser.participant.status
        self.updateState(status: status,
                         isCanSpeak: isCanSpeak,
                         isSpeaking: isSpeaking,
                         isMicON: dolbyUser.isMicOn)
    }
    
    private func updateState(status: VTParticipantStatus,
                             isCanSpeak: Bool,
                             isSpeaking: Bool,
                             isMicON: Bool) {
        if let resource = self.listStates?[status] {
            self.imgState.image = UIImage(named: resource.imgResId)
            self.layoutState.backgroundColor = resource.bgColor ?? .white
            self.imgState.tintColor = resource.tintColor
        }
        let isCanShowState = dolbySdkManager?.canShowState(status: status) ?? false
        self.layoutState.isHidden = !isCanSpeak && !isCanShowState
        if !isCanShowState {
            self.imgState.image = UIImage(named: isMicON ? ImageRes.ic_mic_on_24dp : ImageRes.ic_mic_off_24dp)
        }
        if isSpeaking && (isCanSpeak || currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST) && isMicON {
            self.layoutState.backgroundColor = colorRecording
            self.imgState.tintColor = stateActiveColor
            self.layoutImage.backgroundColor = stateAvatarActive
        }
        else {
            self.layoutImage.backgroundColor = stateAvatarNormal
        }
    }
}
