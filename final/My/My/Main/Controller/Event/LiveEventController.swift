//
//  LiveEventController.swift
//  jamit
//
//  Created by Do Trung Bao on 29/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit
import VoxeetSDK
import AVFoundation

struct StateResource {
    var imgResId: String = ImageRes.ic_event_waiting_24dp
    var bgColor: UIColor?
    var tintColor: UIColor?
    
    init(imgResId: String, bgColor: UIColor? , tintColor: UIColor?) {
        self.imgResId = imgResId
        self.bgColor = bgColor
        self.tintColor = tintColor
    }
}

class LiveEventController: ParentViewController {
    
    private let CONFIRM_MY_USER = 1
    private let CONFIRM_MY_USER_WITH_SUPPORT_URL = 2
    private let CONFIRM_USER = 3
    private let CONFIRM_USER_WITH_SUPPORT_URL = 4
    
    private let NUM_COLUMN_USER: CGFloat = 4.0
    
    var event: EventModel?
    private var isMicOn = true
    private var currentUserId = ""
    private var currentUserType = 0
    
    private var participants: [DolbyParticipant]?
    private var currentUser: UserModel!
    private var listCacheUsers: [String:UserModel]?
    private var listStates: [VTParticipantStatus: StateResource]?
    
    private var stateInActiveColor = getColor(hex: ColorRes.state_color_in_active)
    private var stateErrorColor = getColor(hex: ColorRes.state_color_error)
    var listSpeaker: [DolbyRequestSpeaker]?
    
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblTitleRoom: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblTitle: AutoFillLabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLive: UIView!
    @IBOutlet weak var imgWaiting: AutoFillLabel!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnRaiseHand: UIButton!
//    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var layoutBtAction: UIView!
    @IBOutlet weak var layoutContent: UIView!
    
    var parentVC: ParentViewController?
    var dolbySdkManager: DolbySdkManager?
    var recordingSession: AVAudioSession?
    
    private var pivotType = 0
    private var pivotUser: UserModel?
    private var pivotParticipant: VTParticipant?
    
    private let idCell = String(describing: LiveUserCell.self)
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: DimenRes.medium_padding,
                                             bottom: 0.0, right: DimenRes.medium_padding)
    private var cellWidth: CGFloat = 0.0
    private var cellHeight: CGFloat = 0.0
    private var countVC = 0
    
    private var inviteUsersVC: NewInvitationUserController?
    private var manageSpeakerVC: SpeakerUserController?
    
    override func setUpData() {
        if self.event == nil {
            self.goBackToMain()
            return
        }
        self.currentUserId = SettingManager.getUserId()
        
        //create user id event
        let isHostEvent = event?.isHostEvent(currentUserId) ?? false
        let isSpeaker = event?.isEventSpeaker(currentUserId) ?? false
        self.currentUserType = DolbySdkManager.getUserType(isHostEvent, isSpeaker)
        self.isMicOn = isHostEvent || isSpeaker
        
        self.currentUser = UserModel()
        self.currentUser.userID = currentUserId
        self.currentUser.username = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
        self.currentUser.avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
        
        self.setUpInfo()
        self.initStateResource()
        
    }
    
    private func setUpInfo() {
        let canShowInvite = self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST || self.currentUserType ==  IDolbyConstant.DLB_USER_TYPE_SPEAKER
        self.btnInvite.isHidden = !canShowInvite
        self.lblTitleRoom.text = event?.title
        self.lblTopic.text = event?.getTopic()
        
        self.collectionView.register(UINib(nibName: idCell, bundle: nil), forCellWithReuseIdentifier: idCell)

        self.updateStateMic()
        self.updateRaiseHand()
        
    }
    
    private func initStateResource() {
        if self.listStates != nil {
            return
        }
        self.listStates = [:]
        let stateWaiting = StateResource(imgResId: ImageRes.ic_event_waiting_24dp, bgColor: .white, tintColor: stateInActiveColor)
        
        let stateNormal = StateResource(imgResId: ImageRes.ic_mic_off_24dp, bgColor: .white, tintColor: stateInActiveColor)
        
        let stateError = StateResource(imgResId: ImageRes.ic_event_warning_24dp, bgColor: .white, tintColor: stateErrorColor)
        
        let stateExit = StateResource(imgResId: ImageRes.ic_event_exit_24dp, bgColor: .white, tintColor: stateInActiveColor)
        
        self.listStates?[.warning] = stateError
        self.listStates?[.error] = stateError
        
        self.listStates?[.connected] = stateNormal
        self.listStates?[.inactive] = stateNormal
        
        self.listStates?[.reserved] = stateWaiting
        self.listStates?[.connecting] = stateWaiting
        
        self.listStates?[.decline] = stateExit
        self.listStates?[.left] = stateExit
        self.listStates?[.kicked] = stateExit
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //check permission recording first before initing dolby sdk
        self.checkRecordPermission({
            self.initDolbySdk()
        })
    }
    
    
    func initDolbySdk() {
        if self.event == nil { return }
        if self.dolbySdkManager == nil {
            let dolbySdkManager = DolbySdkManager(currentVC: self)
            self.dolbySdkManager = dolbySdkManager
            self.dolbySdkManager?.loginDelegate = self
            self.dolbySdkManager?.event = self.event!
            if dolbySdkManager.isInitiatedDolby {
                dolbySdkManager.loginToDolby()
            }
        }
        else{
            self.dolbySdkManager?.onRefreshParticipants()
        }
    }
    
    @IBAction func inviteTap(_ sender: Any) {
        self.goToInviteUser()
        
//        view.addGestureRecognizer()
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.backToHome()
    }
    
    @IBAction func shareTap(_ sender: Any) {
        if let event = self.event {
            self.shareWithDeepLink(event, sender as? UIView)
        }
    }
    
    @IBAction func leaveTap(_ sender: Any) {
        self.backToHome()
    }
    
    @IBAction func micTap(_ sender: Any) {
        self.turnOnOffMic()
    }
    
    @IBAction func raiseHandTap(_ sender: Any) {
//        self.sendRaiseHandMessage()
        let raiseHandVC = RaiseHandController()
        raiseHandVC.dismissDelegate = self
        self.addControllerAsPopup(controller: raiseHandVC)
//        addBottomSheet(startHP: 0, startVP: view.layer.frame.size.height * 0.6, width: view.layer.frame.size.width, height: view.layer.frame.size.height * 0.4, controller: raiseHandVC)
        
    }
    
    func addBottomSheet(startHP: CGFloat, startVP: CGFloat, width: CGFloat, height: CGFloat, controller : UIViewController){
//        let width = containerView.bounds.width
//        let height = containerView.bounds.height

//        self.view.addProfileBlurEffect()
        controller.view.frame = CGRect(x: startHP, y: startVP, width: width, height: height)
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
//        self.segment.isHidden = true
//        self.bgTab.isHidden = true
//        self.refreshContainerBottom()
    }
    
    private func sendRaiseHandMessage() {
        if self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST {
            self.goToRaiseHand()
        }
        else if self.currentUserType == IDolbyConstant.DLB_USER_TYPE_LISTENER {
            if let dolbyUserId = VoxeetSDK.shared.session.participant?.id {
                let msg = DolbyMessage.buildCommandMsg(IDolbyConstant.SCHEME_SPEAKER_URI, dolbyUserId, IDolbyConstant.CMD_REQUEST_RAISE_HAND)
                self.dolbySdkManager?.sendMessage(msg, true, {
                    self.btnRaiseHand.isHidden = true
                })
            }
        }
    }
    
    private func goToInviteUser() {
//        self.inviteUsersVC = InvitationUserController.create(IJamitConstants.STORYBOARD_EVENT) as? InvitationUserController
//        guard self.inviteUsersVC != nil else {
//            return
//        }
        self.inviteUsersVC = NewInvitationUserController()
        self.inviteUsersVC?.parentVC = self
        self.inviteUsersVC?.event = event
        self.inviteUsersVC?.isAllowRefresh = false
        self.inviteUsersVC?.dismissDelegate = self
        self.addControllerAsPopup(controller: self.inviteUsersVC!)
    }
    
    private func goToRaiseHand() {
        self.btnRaiseHand.setImage(UIImage(named: ImageRes.ic_raise_hand_36dp), for: .normal)
        
        self.manageSpeakerVC = SpeakerUserController.create(IJamitConstants.STORYBOARD_EVENT) as? SpeakerUserController
        guard (self.manageSpeakerVC != nil) else {
            return
        }
        manageSpeakerVC?.parentVC = self
        manageSpeakerVC?.event = event
        manageSpeakerVC?.isAllowRefresh = false
        manageSpeakerVC?.dismissDelegate = self
        addControllerOnContainer(controller: self.manageSpeakerVC!)
    }
    
    private func addControllerOnContainer(controller : UIViewController){
        controller.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
        self.showOrHideLayoutContainer(true)
    }
    
    private func addControllerAsPopup(controller : UIViewController){
        controller.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
//        view.alpha = 0.5
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
        self.showLiveOrHideLayoutContainer(true)
    }
    
    private func turnOnOffMic() {
        if !self.isHasRecordPermission() { return }
        let isNewMicOn = !self.isMicOn
        if self.dolbySdkManager != nil {
            self.showProgress()
            if isNewMicOn {
                self.dolbySdkManager?.startAudio({
                    self.dismissProgress()
                    self.isMicOn = true
                    self.updateStateMic()
                })
            }
            else{
                self.dolbySdkManager?.stopAudio({
                    self.dismissProgress()
                    self.isMicOn = false
                    self.updateStateMic()
                })
            }
        }
        
    }
    
    private func updateStateMic() {
        let isCanSpeak = self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST || self.currentUserType == IDolbyConstant.DLB_USER_TYPE_SPEAKER
        self.btnMic.isHidden = !isCanSpeak
        
//        let imgResMic = isMicOn ? ImageRes.ic_mic_on_36dp : ImageRes.ic_mic_off_36dp
        let imgResSend = ImageRes.ic_menu
        self.btnMic.setImage(UIImage(named: imgResSend), for: .normal)
//        self.btnMic.tintColor = isMicOn ? .white : getColor(hex: ColorRes.main_second_text_color)
    }

    private func updateRaiseHand() {
        let canShowRaiseHand = self.currentUserType == IDolbyConstant.DLB_USER_TYPE_LISTENER || self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST
        self.btnRaiseHand.isHidden = !canShowRaiseHand
    }

    private func showLoading(_ isLoad: Bool) {
        self.imgWaiting.isHidden = !isLoad
        if isLoad {
            self.layoutContent.isHidden = true
            self.layoutBtAction.isHidden = true
        }
    }
    
    
    private func addSpeakerToQueue(_ message: DolbyMessage) {
        if self.listSpeaker == nil {
            self.listSpeaker = []
        }
        let oldSpeaker = self.listSpeaker?.first(where: { speaker in
            return speaker.participant.isEqual(message.participant)
        })
        if oldSpeaker == nil {
            let speaker = DolbyRequestSpeaker(message.participant, false)
            self.listSpeaker?.insert(speaker, at: 0)
        }
        else{
            oldSpeaker?.isHasPermission = false
        }
        self.manageSpeakerVC?.isStartLoadData = false
        self.manageSpeakerVC?.startLoadData()
    }
    
    //update speaker state data on collection view
    private func updateSpeakerUI(_ speaker: VTParticipant, _ userType: Int) {
        let speakerId = speaker.id ?? ""
        if self.participants != nil && !self.participants!.isEmpty && !speakerId.isEmpty {
            let index = self.participants?.firstIndex(where: { dolby in
                let id = dolby.participant?.id ?? ""
                return !id.isEmpty && id.elementsEqual(speakerId)
            }) ?? -1
            if index >= 0 {
                let participant = self.participants?[index]
                participant?.isSpeaking = userType == IDolbyConstant.DLB_USER_TYPE_SPEAKER
                participant?.userType = userType
                let indexPath = IndexPath(row: index, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    //update mic state data on collection view
    private func updateMicStateUI(_ participant: VTParticipant, _ state: Int) {
        JamitLog.logE("=======>updateMicState=\(participant)===>state=\(state)")
        let speakerId = participant.id ?? ""
        if self.participants != nil && !self.participants!.isEmpty && !speakerId.isEmpty {
            let index = self.participants?.firstIndex(where: { dolby in
                let id = dolby.participant?.id ?? ""
                return !id.isEmpty && id.elementsEqual(speakerId)
            }) ?? -1
            if index >= 0 {
                let participant = self.participants?[index]
                participant?.isMicOn = state == IDolbyConstant.TYPE_ADDED_STREAM
                let indexPath = IndexPath(row: index, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }
            
        }
    }
    //update active current speaker on collection view
    private func updateActiveCurrentSpeakerUI(_ speaker: VTParticipant?) {
        let size = self.participants?.count ?? 0
        if size > 0 {
            let speakerId = speaker?.id
            var currentIndex = 0
            for dolby in self.participants! {
                if speakerId == nil && dolby.isSpeaking {
                    dolby.isSpeaking = false
                    currentIndex += 1
                    continue
                }
                let id = dolby.participant?.id ?? ""
                if !id.isEmpty && speakerId != nil && id.elementsEqual(speakerId!) {
                    dolby.isSpeaking = true
                    let indexPath = IndexPath(row: currentIndex, section: 0)
                    self.collectionView.reloadItems(at: [indexPath])
                    break
                }
                currentIndex += 1
            }
            //reset all current speaker
            if currentIndex == size {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func backToHome(){
        if !self.imgWaiting.isHidden {
            self.goBackToMain()
            return
        }
        self.showDialogConfirmLeave()
    }
    
    private func showDialogConfirmLeave() {
        self.showAlertWithResId(
            titleId: StringRes.title_confirm,
            messageId: StringRes.info_confirm_leave,
            positiveId: StringRes.title_leave,
            negativeId: StringRes.title_cancel,
            completion: {
                self.onLeaveEvent(false)
            })
    }
    
    private func onLeaveEvent(_ isEventEnded: Bool) {
        if self.dolbySdkManager != nil {
            self.dolbySdkManager?.leaveConference({
                let isEventStop = self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST || isEventEnded
                let msgId = isEventStop ? StringRes.info_event_stop : StringRes.info_leave_event
                self.goBackToMain(msgId)
            })
            return
        }
        self.goBackToMain()
    }
    
    private func goBackToMain(_ msgId: String? = nil) {
        self.parentVC?.msgId = msgId
        self.dismissDetail()
        self.onDestroy()
    }
    
    private func onDestroy() {
        JamitLog.logE("====>onDestroy live event page")
        self.dolbySdkManager?.onDestroy()
        self.dolbySdkManager = nil
        
        self.listSpeaker?.removeAll()
        self.listSpeaker = nil
        
        self.listCacheUsers?.removeAll()
        self.listCacheUsers = nil
        
        self.listStates?.removeAll()
        self.listStates = nil
    }
    
    private func checkRecordPermission(_ callback: (()->Void)? = nil) {
        self.recordingSession = AVAudioSession.sharedInstance()
        do {
            try self.recordingSession?.setCategory(.playAndRecord, mode: .default)
            try self.recordingSession?.setActive(true)
            let resultPermisson = self.recordingSession?.recordPermission
            if resultPermisson == AVAudioSession.RecordPermission.granted {
                callback?()
                return
            }
            self.recordingSession?.requestRecordPermission({ (granted) in
                DispatchQueue.main.async {
                    if !granted {
                        self.goBackToMain(StringRes.info_permission_denied)
                    }
                    else{
                        callback?()
                    }
                }
            })
            return
        }
        catch {
            self.goBackToMain(StringRes.info_permission_unknow_error)
        }
    }
    
    private func isHasRecordPermission() -> Bool {
        if self.recordingSession == nil { return false}
        let resultPermisson = self.recordingSession?.recordPermission
        return resultPermisson == AVAudioSession.RecordPermission.granted
    }
    
    private func showSnackBarMsg(_ msg: String, _ actionStrId: String? = nil, _ callback: (()->Void)? = nil) {
        let actionStr = actionStrId != nil ? getString(actionStrId!) : ""
        if !actionStr.isEmpty {
            AppSnackBar.make(
                in: self.layoutContent,
                message: msg,
                duration: .lengthLong).setAction(with: actionStr, action: {
                    callback?()
                }).show()
        }
        else{
            AppSnackBar.make(
                in: self.layoutContent,
                message: msg,
                duration: .lengthLong).show()
        }
      
    }
    
    private func addUserToCache(_ user: UserModel, _ userName: String) {
        if self.listCacheUsers == nil {
            self.listCacheUsers = [:]
        }
        self.listCacheUsers?[userName] = user
    }

    private func getUserFromCache(_ userName: String) -> UserModel? {
        return self.listCacheUsers?[userName]
    }
    
    public func showOrHideLayoutContainer(_ isShow: Bool) {
        self.containerView.isHidden = !isShow
        self.layoutContent.isHidden = isShow
        self.layoutBtAction.isHidden = isShow
    }
    
    public func showLiveOrHideLayoutContainer(_ isShow: Bool) {
        self.containerView.isHidden = !isShow
        self.layoutContent.isHidden = false
        self.layoutBtAction.isHidden = false
    }
    
    //User profile display
    private func startDetailUser(_ dolbyUser: DolbyParticipant) {
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        let participant = dolbyUser.participant
        if participant == nil { return }
        
        let userName = participant?.info.name ?? ""
        if userName.isEmpty { return }
        
        let cacheUser = self.getUserFromCache(userName)
        if cacheUser != nil {
            self.showDialogProfile(cacheUser!, participant!)
            return
        }
        self.showProgress()
        JamItPodCastApi.getUserInfo(userName) { result in
            self.dismissProgress()
            if let user = result {
                self.addUserToCache(user, userName)
                self.showDialogProfile(user, participant!)
                return
            }
            self.showToast(with: StringRes.info_server_error)
        }
    }
    
    //User profile display
    private func showDialogProfile(_ user: UserModel, _ participant: VTParticipant) {
        self.pivotUser = user
        self.pivotParticipant = participant
        let numFollow = user.followers?.count ?? 0
        
        var resource = ConfirmResource()
        resource.title = user.username
        resource.msg = StringUtils.formatNumberSocial(StringRes.format_follower, StringRes.format_followers,Int64(numFollow))
        resource.artwork = user.avatar
        
        let supportUrl = user.tipSupportUrl
        let hasSupportURl = !supportUrl.isEmpty && supportUrl.starts(with: "http")
        resource.isTopAction = hasSupportURl
        let isMyUser = user.isMyUserId(currentUserId)
        if isMyUser {
            resource.negStrId = hasSupportURl ? StringRes.title_send_a_tip: StringRes.title_cancel
            self.pivotType = hasSupportURl ? CONFIRM_MY_USER_WITH_SUPPORT_URL : CONFIRM_MY_USER
        }
        else{
            //TODO check YOU are in follower list of this user
            let isFollower = user.isFollowerUser(currentUserId)
            resource.posBgColorId = isFollower ? ColorRes.subscribed_color : ColorRes.subscribe_color
            resource.posStrId = isFollower ? StringRes.title_unfollow : StringRes.title_follow
            resource.strokeColor = isFollower ? .white : .clear
            
            let status = participant.status
            let isCanKicked = status == .connecting || status == .error || status == .connected
                || status == .warning || status == .inactive
            resource.negStrId = isCanKicked && self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST
                ? StringRes.title_kick_off : StringRes.title_cancel
            if hasSupportURl {
                resource.topActionResImg = ImageRes.ic_support_36dp
            }
            self.pivotType = hasSupportURl ? CONFIRM_USER_WITH_SUPPORT_URL : CONFIRM_USER
        }
        self.showDialogConfirm(resource, self)
    }
    
    private func updateFollowingUser(_ user: UserModel, _ isFollower: Bool) {
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        JamItPodCastApi.updateFollow(isFollower, user.userID) { result in
            self.dismissProgress()
            if result != nil && result!.isResultOk() {
                let msgId = isFollower ? StringRes.info_follow_successfully : StringRes.info_unfollow_successfully
                self.showToast(withResId: msgId)
                user.updateFollower(self.currentUser, isFollower)
                return
            }
            self.showToast(withResId: StringRes.info_server_error)
        }
    }
}

extension LiveEventController: DismissDelegate {
    func dismiss(controller: UIViewController) {
        self.countVC -= 1
        if self.countVC <= 0 {
            self.countVC = 0
            self.showOrHideLayoutContainer(false)
            self.manageSpeakerVC = nil
            self.inviteUsersVC = nil
        }
    }
}

extension LiveEventController: DolbyLoginDelegate {
    
    func onLoginDone() {
        JamitLog.logD("======>onLoginDone")
        self.dolbySdkManager?.registerSpeakerEvent(self)
        self.dolbySdkManager?.conferenceDelegate = self
        self.dolbySdkManager?.participantDelegate = self
        self.dolbySdkManager?.inviteUserDelegate = self
        self.dolbySdkManager?.messageDelegate = self
        self.dolbySdkManager?.streamDelegate = self
        self.dolbySdkManager?.joinConference()
    }
    func onLoginError(_ error: NSError?) {
        JamitLog.logD("======>onLoginError")
        self.goBackToMain(StringRes.info_server_error)
    }
}

extension LiveEventController: DolbyStreamUpdateDelegate, ActiveSpeakerDelegate {
    
    func onActiveSpeakerUpdated(_ participant: VTParticipant?) {
        self.updateActiveCurrentSpeakerUI(participant)
    }
    
    
    func onUpdateStream(_ participant: VTParticipant, _ state: Int) {
        self.updateMicStateUI(participant, state)
    }
}

// confirm delegate when clicking icon user to show profile
extension LiveEventController: ConfirmDelegate {
    
    func onCancel() {
        if self.pivotType == CONFIRM_MY_USER_WITH_SUPPORT_URL {
            if let url = self.pivotUser?.tipSupportUrl {
                ShareActionUtils.goToURL(linkUrl: url)
            }
        }
        else if self.pivotType == CONFIRM_USER_WITH_SUPPORT_URL || self.pivotType == CONFIRM_USER {
            if let participant = self.pivotParticipant {
                let status = participant.status
                let isCanKicked = status == .connecting || status == .error || status == .connected
                    || status == .warning || status == .inactive
                if self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST && isCanKicked {
                    self.dolbySdkManager?.kickConference(participant)
                }
            }
        }
        self.pivotType = 0
    }
    
    func onConfirm() {
        if self.pivotUser == nil { return }
        if self.pivotType == CONFIRM_USER_WITH_SUPPORT_URL || self.pivotType == CONFIRM_USER {
            let isFollower = self.pivotUser?.isFollowerUser(currentUserId) ?? false
            let isNewFollower = !isFollower
            self.updateFollowingUser(self.pivotUser!, isNewFollower)
        }
        self.pivotType = 0
    }
    
    func onTopAction() {
        if self.pivotType == CONFIRM_USER_WITH_SUPPORT_URL {
            if let url = self.pivotUser?.tipSupportUrl {
                ShareActionUtils.goToURL(linkUrl: url)
            }
        }
        self.pivotType = 0
    }
    
    
}

extension LiveEventController: DolbyConferenceDelegate {
    
    func onPreJoinConference() {
        self.showLoading(true)
    }
    
    func onJoinedConference(_ conference: VTConference) {
        if !self.imgWaiting.isHidden {
            self.showLoading(false)
        }
        self.layoutContent.isHidden = false
        self.layoutBtAction.isHidden = false
        
        // Start recording live room
        VoxeetSDK.shared.recording.start { error in
            if error != nil {
                guard let error = error else {
                    return
                }
                let newError = error.localizedDescription
                self.showAlertWith(title: "Recording", message: String(newError.split(separator: ":")[1]))
            }
            if error == nil {
                self.showAlertWith(title: "Recording", message: "This room is being recorded")
            }
        }
        
        self.dolbySdkManager?.stopAudio({
            self.dismissProgress()
            self.isMicOn = false
            self.updateStateMic()
        })
        
        //TODO after joining done, we will register headset event
        //dolbySdkManager.registerDolbyHeadset(this::onUpdateHeadset);
    }
    
    func onJoinedError(_ error: NSError?) {
        self.showLoading(false)
        JamitLog.logE("======>onJoinedError=\(String(describing: error))")
        guard let error = error else {
            return
        }
        let newError = error.localizedDescription
        self.showAlertWith(title: "Error", message: String(newError.split(separator: ":")[1]))
//        self.goBackToMain(StringRes.info_server_error)
    }
    
    
}

extension LiveEventController: DolbyInviteUserDelegate {
    
    func onInviteUser(_ user: UserModel, _ participant: VTParticipant?) {
        if participant != nil {
            
            //check if we already have user, we will not add again
            let id = participant?.id ?? ""
            let oldUser = self.participants?.first(where: { user in
                let cpId = user.participant.id ?? ""
                return !id.isEmpty && !cpId.isEmpty && cpId.elementsEqual(id)
            })
            if oldUser != nil {
                user.isInvited = true
                self.collectionView.reloadData()
//                self.inviteUsersVC?.notifyWhenDataChanged()
                return
            }
            let dolbyUser = DolbyParticipant(participant!, IDolbyConstant.DLB_USER_TYPE_LISTENER)
            self.participants?.append(dolbyUser)
            self.collectionView.reloadData()
            self.event?.addInvite(user.userID)
            user.isInvited = true
            
//            self.inviteUsersVC?.notifyWhenDataChanged()
 
        }
    }
    
    func onInviteError(_ error: NSError?) {
        self.showToast(withResId: StringRes.info_invite_error)
    }
    
}

extension LiveEventController: DolbyParticipantDelegate {
    
    func onUpdateParticipant(_ listParticipants: [DolbyParticipant]) {
        self.participants = listParticipants
        self.collectionView.reloadData()
        if listParticipants.isEmpty {
            // Stop recording when no is in room
            VoxeetSDK.shared.recording.stop { error in
                    if error == nil {
                        
                    }
                }
        }
    }
    
    // this one is working on IO thread, when update ui we need to call on main thread
    func onUpdateParticipantSpeaker(_ listSpeakers: [DolbyRequestSpeaker]?) {
        if listSpeakers != nil && currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST {
            JamitLog.logE("=====>onUpdateParticipantSpeaker=\(String(describing: listSpeakers?.count))")
            if self.listSpeaker == nil {
                self.listSpeaker = []
            }
            let isEmpty = self.listSpeaker?.isEmpty ?? true
            listSpeakers?.forEach({ newSpeaker in
                if isEmpty {
                    self.listSpeaker?.append(newSpeaker)
                }
                else{
                    let oldSpeaker = self.listSpeaker?.first(where: { current in
                        return current.equalElement(newSpeaker)
                    })
                    if oldSpeaker == nil {
                        self.listSpeaker?.append(newSpeaker)
                    }
                }
            })
            DispatchQueue.main.async {
                self.manageSpeakerVC?.isStartLoadData = false
                self.manageSpeakerVC?.startLoadData()
            }
        }
    }
    
    func onKickedParticipant(_ participant: VTParticipant) {
        JamitLog.logE("====>onKickedParticipant")
        self.goBackToMain(StringRes.info_my_kicked_off)
    }
    
    func onEndedEvent() {
        if self.currentUserType != IDolbyConstant.DLB_USER_TYPE_HOST {
            self.onLeaveEvent(true)
        }
    }
    
    func onHostUpdatedSpeaker(_ participant: VTParticipant, _ isSpeaker: Bool) {
        let userType = isSpeaker ? IDolbyConstant.DLB_USER_TYPE_SPEAKER : IDolbyConstant.DLB_USER_TYPE_LISTENER
        self.updateSpeakerUI(participant, userType)
    }
    
}

extension LiveEventController: DolbyMessageDelegate {
    
    func onReceivedMessage(_ message: DolbyMessage) {
        let externalId = message.externalId
        let isMyMessage = externalId.elementsEqual(self.currentUserId)
        JamitLog.logE("======>onReceivedMessage message=\(message)==>externalId=\(externalId)==>isMyMessage=\(isMyMessage)==>cmd=\(message.command)")
        if message.isCommandMsg && !isMyMessage {
            let command = message.command
            if command == IDolbyConstant.CMD_REQUEST_RAISE_HAND {
                self.processRequestRaiseHand(message)
            }
            else if command == IDolbyConstant.CMD_RESET_RAISE_HAND {
                self.processRequestResetRaiseHand(message)
            }
            else if command == IDolbyConstant.CMD_ACCEPT_RAISE_HAND || command == IDolbyConstant.CMD_DECLINE_RAISE_HAND {
                self.processAcceptRaiseHand(message)
            }
            else if command == IDolbyConstant.CMD_REMOVED_SPEAKER {
                self.processRemoveSpeaker(message)
            }
        }
    }
    
    private func processRequestResetRaiseHand(_ message: DolbyMessage) {
        //if user is host or speaker, we can skip this option
        if self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST || self.currentUserType == IDolbyConstant.DLB_USER_TYPE_SPEAKER {
            return
        }
        let payloadUserId = message.payloadUserId ?? ""
        let currentDolbyUserId = VoxeetSDK.shared.session.participant?.id ?? ""
        if !payloadUserId.isEmpty, !currentDolbyUserId.isEmpty,
           currentDolbyUserId.elementsEqual(payloadUserId) {
            self.currentUserType = IDolbyConstant.DLB_USER_TYPE_LISTENER
            self.showToast(withResId: StringRes.info_reset_raise_hand)
            self.btnRaiseHand.isHidden = false
        }
    }
    
    private func processAcceptRaiseHand(_ message: DolbyMessage) {
        let userName = message.userName
        let command = message.command
        let payloadUserId = message.payloadUserId ?? ""
        if !userName.isEmpty && !payloadUserId.isEmpty {
            let formatStr = getString(command == IDolbyConstant.CMD_ACCEPT_RAISE_HAND ? StringRes.format_host_accept_speaker
                                        : StringRes.format_host_decline_speaker)
            if let targetParticipant = self.dolbySdkManager?.findParticipantById(payloadUserId) {
                let targetExternalId = targetParticipant.info.externalID ?? ""
                let targetName = targetParticipant.info.name ?? ""
                if !targetExternalId.isEmpty && !targetName.isEmpty {
                    let msg = String(format: formatStr, userName, targetName)
                    self.showSnackBarMsg(msg)
                    
                    //TODO HOST ACCEPT YOU AS SPEAKER
                    if targetExternalId.elementsEqual(self.currentUserId)
                        && command == IDolbyConstant.CMD_ACCEPT_RAISE_HAND {
                        self.processWhenHostAcceptSpeaker()
                    }
                }
            }
        }
    }
    
    private func processRequestRaiseHand(_ message: DolbyMessage) {
        let userName = message.userName
        if !userName.isEmpty {
            let msg = String(format: getString(StringRes.format_request_speaker), userName)
            if self.currentUserType == IDolbyConstant.DLB_USER_TYPE_HOST {
                if self.manageSpeakerVC == nil {
                    self.btnRaiseHand.setImage(UIImage(named: ImageRes.ic_raise_hand_dot_36dp), for: .normal)
                }
                self.showSnackBarMsg(msg, StringRes.title_edit) {
                    self.goToRaiseHand()
                }
                self.addSpeakerToQueue(message)
            }
            else {
                self.showSnackBarMsg(msg)
            }
        }
    }
    
    private func processRemoveSpeaker(_ message: DolbyMessage) {
        let payloadUserId = message.payloadUserId ?? ""
        let userName = message.userName
        if !payloadUserId.isEmpty && !userName.isEmpty {
            //TODO check if it is my user id we will update system
            let targetParticipant = self.dolbySdkManager?.findParticipantById(payloadUserId)
            let info = targetParticipant?.info
            if targetParticipant == nil || info == nil {
                return
            }
            
            //TODO show MESSAGE to inform
            let formatStr = getString(StringRes.format_host_remove_speaker)
            let msg = String(format: formatStr, userName, info?.name ?? "")
            self.showSnackBarMsg(msg)

            let externalId = info?.externalID ?? ""
            let isMyUserId = externalId.elementsEqual(self.currentUserId)
            if self.currentUserType == IDolbyConstant.DLB_USER_TYPE_SPEAKER && isMyUserId {
                self.currentUserType = IDolbyConstant.DLB_USER_TYPE_LISTENER
//                self.btnInvite.isHidden = true
                self.btnRaiseHand.isHidden = false
                self.isMicOn = false
                self.updateStateMic()
                if let current = VoxeetSDK.shared.session.participant {
                    self.updateSpeakerUI(current, self.currentUserType)
                }
            }
        }
        
    }
    
    private func processWhenHostAcceptSpeaker() {
        self.event?.updateSpeaker(self.currentUserId, true)
        self.btnInvite.isHidden = false
        self.btnRaiseHand.isHidden = true
        self.currentUserType = IDolbyConstant.DLB_USER_TYPE_SPEAKER
        self.isMicOn = true
        self.updateStateMic()
        
        self.dolbySdkManager?.startAudio({
            if let current = VoxeetSDK.shared.session.participant {
                self.updateSpeakerUI(current, self.currentUserType)
            }
        })
    
    }

}

extension LiveEventController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.participants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idCell, for: indexPath)
        let pos: Int = indexPath.row
        if let participant = self.participants?[pos] {
            self.renderCell(cell:cell,model: participant )
        }
        return cell
    }
    
    private func renderCell(cell: UICollectionViewCell, model: DolbyParticipant){
        (cell as? LiveUserCell)?.listStates = self.listStates
        (cell as? LiveUserCell)?.currentUserType = self.currentUserType
        (cell as? LiveUserCell)?.dolbySdkManager = self.dolbySdkManager
        (cell as? LiveUserCell)?.updateUI(model, cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pos: Int = indexPath.row
        if let participant = self.participants?[pos] {
            self.startDetailUser(participant)
        }
    }

}

extension LiveEventController: UICollectionViewDelegateFlowLayout{
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellWidth == 0 {
            self.cellWidth = (self.view.frame.width - (NUM_COLUMN_USER + 1) * DimenRes.medium_padding)/NUM_COLUMN_USER
            self.cellHeight = self.cellWidth * IJamitConstants.RATE_EVENT_LIVE_USER + self.cellWidth
        }
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
  
   
    
}
