//
//  DolbySdkManager.swift
//  jamit
//
//  Created by Do Trung Bao on 24/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit
import VoxeetSDK

public class DolbySdkManager: NSObject {
    
    private let TYPE_CONFIRM_INVITE = 1
    
    private var isSignedIn = false
    private var userId: String!
    
    var currentVC: ParentViewController!
    var event: EventModel = EventModel()
    
    var listParticipants: [String:DolbyParticipant]?
    var isRegisterEvent = false
    var isInitiatedDolby = false
    
    //this is delegate for home screen when waiting and listening Invite from another one
    var userInvitedDelegate: DolbyUserInvitedDelegate?
    
    var loginDelegate: DolbyLoginDelegate?
    var conferenceDelegate: DolbyConferenceDelegate?
    var participantDelegate: DolbyParticipantDelegate?
    var inviteUserDelegate: DolbyInviteUserDelegate?
    var messageDelegate: DolbyMessageDelegate?
    var streamDelegate: DolbyStreamUpdateDelegate?
    
    private var subInvitation: VTSubscribeInvitation?
    
    private var pivotType: Int = 0
    private var pivotEvent: EventModel?
    private var pivotConferenceId: String?
    private var pivotParticipant: VTParticipant?
    private var activeSpeakerDelegate: ActiveSpeakerDelegate?

    init(currentVC: ParentViewController) {
        super.init()
        self.currentVC = currentVC
        if SettingManager.isLoginOK() {
            self.isInitiatedDolby = true
            self.userId = SettingManager.getUserId()
        }
    }
    
    func registerSpeakerEvent(_ delegate: ActiveSpeakerDelegate?) {
        self.activeSpeakerDelegate = delegate
        if delegate != nil {
            DolbySpeakerTimer.shared.delegate = delegate
            DolbySpeakerTimer.shared.start()
        }
    }
    
    func loginToDolby() {
        if !isInitiatedDolby || !ApplicationUtils.isOnline() || isSignedIn {
            self.loginDelegate?.onLoginError(nil)
            return
        }
        let username = SettingManager.getSetting(SettingManager.KEY_USER_NAME);
        let avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
        let participantInfo = VTParticipantInfo(externalID: self.userId, name: username, avatarURL: avatar)
        VoxeetSDK.shared.session.open(info: participantInfo) { error in
            JamitLog.logE("==========>currentVC = \(String(describing: self.currentVC))===>loginToDolby=\(String(describing: error))")
            self.isSignedIn = error == nil
            if error == nil {
                self.loginDelegate?.onLoginDone()
            }
            else{
                self.loginDelegate?.onLoginError(error)
            }
        }
        
    }
    
    func logoutToDolby() {
        if !isInitiatedDolby || !ApplicationUtils.isOnline() || !isSignedIn { return }
        JamitLog.logE("=======>logoutToDolby")
        VoxeetSDK.shared.session.close { error in
            JamitLog.logE("======>error =\(String(describing: error))")
            self.isSignedIn = false
        }
    }
    

    func joinConference() {
        if checkFalseCondition() { return }
        
        //register conference delegate to listen event
        VoxeetSDK.shared.conference.delegate = self
        
        //register command delegate to listen event when receiving message
        VoxeetSDK.shared.command.delegate = self
        
        self.conferenceDelegate?.onPreJoinConference()
        let isHostEvent = event.isHostEvent(userId)
        let isSpeakerEvent = event.isEventSpeaker(userId)
        
        let options = VTConferenceOptions()
        options.params.dolbyVoice = true
        options.params.ttl = 0
        options.alias = event.title

        print("This is trying to debug \(isHostEvent) \(isSpeakerEvent)")
        VoxeetSDK.shared.conference.create(options: options) { conference in
            let options = VTJoinOptions()
            options.constraints.video = false
            
            
            
            VoxeetSDK.shared.conference.join(conference: conference, options: options) { conference in
                JamitLog.logE("======>joined=\(conference.id)===>status=\(self.getConfStatus(status: conference.status))==>rawValue=\(conference.status.rawValue)")
//                self.updateMyPermissions(isHostEvent, isSpeakerEvent)
//                self.updateParticipants()
                self.conferenceDelegate?.onJoinedConference(conference)
            } fail: { error in
                JamitLog.logE("======> joinConference invite error")
                self.conferenceDelegate?.onJoinedError(error)
            }

        } fail: { error in
            JamitLog.logE("======> joinConference invite error")
            self.conferenceDelegate?.onJoinedError(error)
        }

//        VoxeetSDK.shared.conference.fetch(conferenceID: event.eventId) { conference in
//            VoxeetSDK.shared.conference
//                .join(conference: conference, options: nil,
//                      success: { _ in
//                        JamitLog.logE("======>joined=\(conference.id)===>status=\(self.getConfStatus(status: conference.status))==>rawValue=\(conference.status.rawValue)")
//                        self.updateMyPermissions(isHostEvent, isSpeakerEvent)
//                        self.updateParticipants()
//                        self.conferenceDelegate?.onJoinedConference(conference)
//                      },
//                      fail: { error in
//                        JamitLog.logE("======> joinConference invite error")
//                        self.conferenceDelegate?.onJoinedError(error)
//                      })
//
//        }
    }
    
    
    func registerInvitedEvent(_ delegate: DolbyUserInvitedDelegate) {
        if self.isInitiatedDolby && self.userInvitedDelegate == nil {
            self.userInvitedDelegate = delegate
            VoxeetSDK.shared.notification.delegate = self
        }
    }

    func onDestroy() {
        JamitLog.logE("==========>currentVC = \(String(describing: self.currentVC))===>onDestroy DolbySDK")
        self.listParticipants?.removeAll()
        self.listParticipants = nil
        
        //unregister conference delegate
        VoxeetSDK.shared.conference.delegate = nil
        
        //unregister command delegate
        VoxeetSDK.shared.command.delegate = nil
        
        //unregister event notification
        VoxeetSDK.shared.notification.delegate = nil
        
        //unregister active speaker delegate
        if self.activeSpeakerDelegate != nil {
            DolbySpeakerTimer.shared.stop()
            self.activeSpeakerDelegate = nil
        }
    }
    
    private func showDialogConfirmInvitation(_ event: EventModel,
                                             _ conferenceId: String,
                                             _ participant: VTParticipant?) {
        let userInfo = participant?.info
        if userInfo == nil {
            self.userInvitedDelegate?.onInvitedError(nil)
            return
        }
        let name = userInfo?.name ?? ""
        var resource = ConfirmResource()
        resource.title = getString(StringRes.title_invitation)
        let formatMsg = getString(StringRes.format_invite_user)
        resource.msg = String(format: formatMsg,name, event.title)
        resource.artwork = userInfo?.avatarURL ?? ""
        resource.posBgColorId = ColorRes.color_notify_me
        resource.posTextColor = .black
        resource.posStrId = StringRes.title_accept
        resource.negStrId = StringRes.title_cancel
        
        self.pivotType = TYPE_CONFIRM_INVITE
        self.pivotEvent = event
        self.pivotConferenceId = conferenceId
        self.pivotParticipant = participant
        self.currentVC.showDialogConfirm(resource, self)
        

    }
    
    func confirmInviteOnServer(event: EventModel, confId: String, isAccepted: Bool) {
        if self.checkFalseCondition() {
            return
        }
        self.currentVC.showProgress()
        JamItEventApi.subscribeEvent(confId, isAccepted) { result in
            self.currentVC.dismissProgress()
            let isResultOk = result?.isResultOk() ?? false
            JamitLog.logE("======>terminateEvent isResultOk =\(isResultOk)")
            if !isResultOk {
                self.currentVC.showToast(withResId: StringRes.info_invite_error)
                self.userInvitedDelegate?.onInvitedError(nil)
                return
            }
            self.confirmInviteOnDolby(event: event, confId: confId, isAccepted: isAccepted)
        }
    }
    
    private func confirmInviteOnDolby(event: EventModel, confId: String, isAccepted: Bool) {
        if self.checkFalseCondition() {
            return
        }
        self.currentVC.showProgress()
        VoxeetSDK.shared.conference.fetch(conferenceID: confId) { conference in
            if isAccepted {
                JamitLog.logE("======> confirmInviteOnDolby joined=\(conference.id)")
                self.currentVC.dismissProgress()
                self.userInvitedDelegate?.onUserInvited(confId, event)
                
                //TODO, we should go to live page and join
//                VoxeetSDK.shared.conference
//                    .join(conference: conference, options: nil,
//                          success: { _ in
//                        JamitLog.logE("======> confirmInviteOnDolby joined=\(conference.id)")
//                            self.currentVC.dismissProgress()
//                            self.userInvitedDelegate?.onUserInvited(confId, event)
//
//                          },
//                          fail: { _ in
//                        JamitLog.logE("======> confirmInviteOnDolby invite error")
//                            self.currentVC.dismissProgress()
//                          })
            }
            else{
                VoxeetSDK.shared.notification.decline(conference: conference) { error in
                    self.currentVC.dismissProgress()
                    JamitLog.logE("======> confirmInviteOnDolby declined invite error=\(String(describing: error))")
                    if error == nil {
                        self.userInvitedDelegate?.onUserDeclined(confId, event)
                    }
                }
            }
        }
    }
    
    private func terminateEvent(_ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() {
            callback?()
            return
        }
        self.currentVC.showProgress()
        let eventId = event.eventId
        let hostId = event.host?.userID ?? ""
        JamItEventApi.terminateEvent(eventId, hostId) { result in
            self.currentVC.dismissProgress()
            let isResultOk = result?.isResultOk() ?? false
            JamitLog.logE("======>terminateEvent isResultOk =\(isResultOk)")
            if !isResultOk {
                self.currentVC.showToast(withResId: StringRes.info_server_error)
            }
            callback?()
        }
//        VoxeetSDK.shared.session.close { error in
//            if error != nil {
//                self.currentVC.showAlertWith(title: "Error", message: error!.localizedDescription)
//            } else {
//                self.currentVC.showAlertWith(title: "End Meeting", message: "The meeting has ended successfully")
//            }
//        }
    }
    
    func inviteUser(_ user: UserModel) {
        if self.checkFalseCondition() { return }
        if let conference = VoxeetSDK.shared.conference.current {
            let listParticipants = [VTParticipantInfo(externalID: user.userID, name: user.username, avatarURL: user.avatar)]
            self.currentVC.showProgress()
            VoxeetSDK.shared.notification.invite(conference: conference, participantInfos: listParticipants) { error in
                JamitLog.logE("======>inviteUser error =\(String(describing: error))")
                self.currentVC.dismissProgress()
                if error != nil {
                    self.currentVC.showToast(withResId: StringRes.info_invite_error)
                    self.inviteUserDelegate?.onInviteError(error!)
                    return
                }
                self.inviteUserOnServer(user)
            }
        }
        
    }
    
    private func inviteUserOnServer(_ user: UserModel) {
        if self.checkFalseCondition() { return }
        let eventId = event.eventId
        let friendId = user.userID
        self.currentVC.showProgress()
        JamItEventApi.inviteUser(eventId, friendId) { result in
            self.currentVC.dismissProgress()
            let isResultOk = result?.isResultOk() ?? false
            JamitLog.logE("======>inviteUserOnServer isResultOk =\(isResultOk)")
            self.currentVC.showToast(withResId: isResultOk ? StringRes.info_invite_success : StringRes.info_invite_error)
            if isResultOk {
                let participant = self.findParticipantByExternalId(user.userID)
                JamitLog.logE("======>inviteUserOnServer participant =\(String(describing: participant))")
                self.inviteUserDelegate?.onInviteUser(user, participant)
            }
            else{
                self.inviteUserDelegate?.onInviteError(nil)
            }
        }
    }
    
    func startAudio(_ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() {
            callback?()
            return
        }
        if let currentParticipant = VoxeetSDK.shared.session.participant {
            VoxeetSDK.shared.conference.startAudio(participant: currentParticipant) { error in
                JamitLog.logE("======>startAudio error =\(String(describing: error))")
                callback?()
                if error != nil {
                    self.currentVC.showToast(withResId: StringRes.info_send_audio_error)
                    return
                }
                self.currentVC.showToast(withResId: StringRes.info_send_audio_start)
                self.streamDelegate?.onUpdateStream(currentParticipant, IDolbyConstant.TYPE_ADDED_STREAM)
            }
            return
        }
        callback?()
    }
    
    func leaveConference(_ callback: (() -> Void)? = nil) {
        if !isInitiatedDolby || !isSignedIn { return}
        self.currentVC.showProgress()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            VoxeetSDK.shared.conference.leave { error in
                JamitLog.logE("======>leaveConference error =\(String(describing: error))")
                DispatchQueue.main.async {
                    if error != nil {
                        self.currentVC.dismissProgress()
                        callback?()
                        return
                    }
                    if self.event.isHostEvent(self.userId) {
                        self.terminateEvent(callback)
                        return
                    }
                    self.currentVC.dismissProgress()
                    callback?()
                }
               
            }
        }
       
    }
    
    func kickConference(_ participant: VTParticipant ,_ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() { return }
        self.currentVC.showProgress()
        VoxeetSDK.shared.conference.kick(participant: participant) { error in
            self.currentVC.dismissProgress()
            JamitLog.logE("======>kickConference error =\(String(describing: error))")
            if error == nil {
                self.currentVC.showToast(withResId: StringRes.info_kicked_off_success)
                callback?()
            }
        }
    }

    
    func stopAudio(_ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() {
            callback?()
            return
        }
        if let currentParticipant = VoxeetSDK.shared.session.participant {
            VoxeetSDK.shared.conference.stopAudio(participant: currentParticipant) { error in
                JamitLog.logE("======>stopAudio error =\(String(describing: error))")
                callback?()
                if error != nil {
                    self.currentVC.showToast(withResId: StringRes.info_stop_audio_error)
                    return
                }
                self.currentVC.showToast(withResId: StringRes.info_send_audio_stop)
                self.streamDelegate?.onUpdateStream(currentParticipant, IDolbyConstant.TYPE_REMOVED_STREAM)
            }
            return
        }
        callback?()
    }

    
    private func updateParticipants() {
        if let listParticipants = VoxeetSDK.shared.conference.current?.participants, listParticipants.count > 0 {
            if self.listParticipants == nil {
                self.listParticipants = [:]
            }
            var listFilters: [DolbyParticipant] = []
            let isMyEvent = event.isHostEvent(userId)
            var listSpeakers: [DolbyRequestSpeaker]? = isMyEvent ? [] : nil
            var indexSpeaker = 0
            var isEndedEvent = false
            for paticipant in listParticipants {
                let externalId = paticipant.info.externalID ?? ""
                let name = paticipant.info.name ?? ""
                let isMixer = paticipant.type == VTParticipantType.mixer
                if isMixer || name.isEmpty || name.elementsEqual("null")
                    || externalId.elementsEqual(IDolbyConstant.ID_EMPTY) {
                    continue
                }
                let isHostEvent = event.isHostEvent(externalId)
                let isSpeakerEvent = event.isEventSpeaker(externalId)
                let type = DolbySdkManager.getUserType(isHostEvent, isSpeakerEvent)
                JamitLog.logE("========>userType=\(type)==>externalId=\(externalId)")
                
                //create dolby user
                var dolbyUser = self.listParticipants?[externalId]
                if dolbyUser == nil {
                    dolbyUser = DolbyParticipant(paticipant, type)
                    dolbyUser?.isMicOn = isHostEvent || isSpeakerEvent
                    dolbyUser?.isSpeaking = isHostEvent || isSpeakerEvent
                }
                else{
                    dolbyUser?.participant = paticipant
                    dolbyUser?.userType = type
                }
                
                //start to check and import to list
                if isHostEvent {
                    isEndedEvent = paticipant.status == VTParticipantStatus.left
                    listFilters.insert(dolbyUser!, at: 0)
                    indexSpeaker += 1
                }
                else if isSpeakerEvent {
                    listFilters.insert(dolbyUser!, at: indexSpeaker)
                    indexSpeaker += 1
                    if listSpeakers != nil {
                        listSpeakers!.append(DolbyRequestSpeaker(paticipant, true))
                    }
                }
                else{
                    listFilters.append(dolbyUser!)
                }
                
                //update speaker first
                self.participantDelegate?.onUpdateParticipantSpeaker(listSpeakers)
                
                //TODO this one to check when other speaker or host enable again mic , it will need update
                self.listParticipants?[externalId] = dolbyUser
                DispatchQueue.main.async {
                    self.participantDelegate?.onUpdateParticipant(listFilters)
                    if isEndedEvent{
                        self.participantDelegate?.onEndedEvent()
                    }
                }
            }
        }
    }

    private func checkFalseCondition() -> Bool {
        if !isInitiatedDolby || !isSignedIn  { return true }
        if !ApplicationUtils.isOnline() {
            self.currentVC.showToast(withResId: StringRes.info_lose_internet)
            return true
        }
        return false
    }
    
    public static func getUserType(_ isHostEvent: Bool, _ isSpeakerEvent: Bool) -> Int {
        if isHostEvent {
            return IDolbyConstant.DLB_USER_TYPE_HOST
        }
        else if isSpeakerEvent {
            return IDolbyConstant.DLB_USER_TYPE_SPEAKER
        }
        else {
            return IDolbyConstant.DLB_USER_TYPE_LISTENER
        }
    }
    
    func canShowState(status: VTParticipantStatus) -> Bool {
        return status != .connected && status != .inactive && status != .connecting
    }
    
    func findParticipantByExternalId(_ externalID: String?)-> VTParticipant? {
        if externalID == nil || externalID!.isEmpty { return nil }
        if let listParticipants = VoxeetSDK.shared.conference.current?.participants, listParticipants.count > 0 {
            for paticipant in listParticipants {
                let externalId = paticipant.info.externalID ?? ""
                if externalId.elementsEqual(externalID!){
                    return paticipant
                }
            }
        }
        return nil
    }
    
    func findParticipantById(_ id: String?)-> VTParticipant? {
        if id == nil || id!.isEmpty { return nil }
        if let listParticipants = VoxeetSDK.shared.conference.current?.participants, listParticipants.count > 0 {
            for paticipant in listParticipants {
                let externalId = paticipant.id ?? ""
                if externalId.elementsEqual(id!){
                    return paticipant
                }
            }
        }
        return nil
    }
    
    func updateSpeakerOnServer(_ participant: VTParticipant, _ isSpeaker: Bool, _ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() { return }
        let dolbyUserId = participant.id ?? ""
        let speakerId = participant.info.externalID ?? ""
        let eventId = self.event.eventId
        let hostId = event.host?.userID ?? ""
        if dolbyUserId.isEmpty || speakerId.isEmpty || hostId.isEmpty { return }
        self.currentVC.showProgress()
        JamItEventApi.updateSpeaker(eventId, hostId, speakerId, isSpeaker) { result in
            print("The new user with id: \(speakerId)")
            self.currentVC.dismissProgress()
            let isResultOk = result?.isResultOk() ?? false
            JamitLog.logE("======>updateSpeakerOnServer isResultOk =\(isResultOk)")
            if !isResultOk {
                self.currentVC.showToast(withResId: StringRes.info_server_error)
                
                if isSpeaker {
                    //reset raise hand if calling to server error
                    let msgReset = DolbyMessage.buildCommandMsg(IDolbyConstant.SCHEME_HOST_URI, dolbyUserId, IDolbyConstant.CMD_RESET_RAISE_HAND)
                    self.sendMessage(msgReset,false, nil)
                }
                return
            }
            print("The new user is a \(isSpeaker) speaker")
//            self.parentVC?.processWhenHostAcceptSpeaker()
            self.updateSpeakerPermissions(participant,false, isSpeaker, true, callback)
//            self.updatePermissions(participant,false, true, true, callback)
        }
    }
    

    private func updateMyPermissions(_ isHost: Bool, _ isSpeaker: Bool) {
        let myParticipant = self.findParticipantByExternalId(userId)
        if myParticipant != nil {
            
            self.updatePermissions(myParticipant!, isHost, isSpeaker, false, nil)
        }
    }
    func updateRequest() {
        if let permissions = VoxeetSDK.shared.conference.current?.permissions {
                        permissionsUpdated(permissions: permissions.map {
                            print("I don't know what this is: \($0.rawValue)")
                            return $0.rawValue
                            
                        })
                    }
    }
    
    func updateSpeakerPermissions(_ participant: VTParticipant, _ isHost: Bool, _ isSpeaker: Bool, _ isForeground: Bool, _ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() { return }
        let externalId = participant.info.externalID ?? ""
        let userId = participant.id ?? ""
        let userName = participant.info.name ?? ""
        if externalId.isEmpty || userId.isEmpty {
            if isForeground {
                self.currentVC.showToast(withResId: StringRes.info_updated_error)
            }
            return
        }
        var listPermission: [VTParticipantPermissions] = []
        let join = VTParticipantPermissions(participant: participant, permissions: [.join, .stream, .sendAudio, .invite])
        
        listPermission.append(join)
        print("The user is: \(participant.info)")
        if isForeground {
            self.currentVC.showProgress()
        }
        VoxeetSDK.shared.conference.updatePermissions(participantPermissions: listPermission) { error in
            self.currentVC.dismissProgress()
            if error != nil {
                if isForeground {
                    print("The error is \(error)")
                    self.currentVC.showToast(withResId: StringRes.info_updated_error)
                }
                return
            }
            if isForeground {
                let msgIdFormat = isSpeaker ? StringRes.format_update_speaker : StringRes.format_update_no_speaker
                let msg = String(format: getString(msgIdFormat), userName)
                self.currentVC.showToast(with: msg)
                
                //TODO after accept done, host will send information to user
                let cmd = isSpeaker ? IDolbyConstant.CMD_ACCEPT_RAISE_HAND : IDolbyConstant.CMD_REMOVED_SPEAKER
                let msgAccept = DolbyMessage.buildCommandMsg(IDolbyConstant.SCHEME_HOST_URI, userId, cmd)
                self.sendMessage(msgAccept,false, nil)
                
                //TODO host update the speaker id to queue
                self.event.updateSpeaker(externalId, isSpeaker)
                callback?()
                self.participantDelegate?.onHostUpdatedSpeaker(participant, isSpeaker)
            }
            
        }
    }
    
    func updatePermissions(_ participant: VTParticipant, _ isHost: Bool, _ isSpeaker: Bool, _ isForeground: Bool, _ callback: (() -> Void)? = nil) {
        if self.checkFalseCondition() { return }
        let externalId = participant.info.externalID ?? ""
        let userId = participant.id ?? ""
        let userName = participant.info.name ?? ""
        updateRequest()
        if externalId.isEmpty || userId.isEmpty {
            if isForeground {
                print("The error is here")
                self.currentVC.showToast(withResId: StringRes.info_updated_error)
            }
            return
        }
        var listPermission: [VTParticipantPermissions] = []
        let join = VTParticipantPermissions(participant: participant, permissions: [.join, .stream])
//        join.permissions.append(.join)
//        join.permissions.append(.stream)
        if isSpeaker {
//            join.permissions.append(.invite)
            join.permissions.append(.kick)
            join.permissions.append(.sendAudio)
        }
        //if it is host, we will add all
        else if isHost {
            join.permissions.append(.invite)
            join.permissions.append(.sendAudio)
            join.permissions.append(.kick)
            join.permissions.append(.sendMessage)
            join.permissions.append(.sendVideo)
            join.permissions.append(.shareFile)
            join.permissions.append(.updatePermissions)
            join.permissions.append(.record)
        } else {
            join.permissions.append(.invite)
//            join.permissions.append(.kick)
        }
        
        listPermission.append(join)
        print("The user default id is: \(participant.info)")
        if isForeground {
            self.currentVC.showProgress()
        }
        VoxeetSDK.shared.conference.updatePermissions(participantPermissions: listPermission) { error in
            self.currentVC.dismissProgress()
            if error != nil {
                if isForeground {
                    print("The error is \(error)")
                    self.currentVC.showToast(withResId: StringRes.info_updated_error)
                }
                return
            }
            if isForeground {
                let msgIdFormat = isSpeaker ? StringRes.format_update_speaker : StringRes.format_update_no_speaker
                let msg = String(format: getString(msgIdFormat), userName)
                self.currentVC.showToast(with: msg)
                
                //TODO after accept done, host will send information to user
                let cmd = isSpeaker ? IDolbyConstant.CMD_ACCEPT_RAISE_HAND : IDolbyConstant.CMD_REMOVED_SPEAKER
                let msgAccept = DolbyMessage.buildCommandMsg(IDolbyConstant.SCHEME_HOST_URI, userId, cmd)
                self.sendMessage(msgAccept,false, nil)
                
                //TODO host update the speaker id to queue
                self.event.updateSpeaker(externalId, isSpeaker)
                callback?()
                self.participantDelegate?.onHostUpdatedSpeaker(participant, isSpeaker)
            }
            
        }
    }
    
    func sendMessage(_ message: String, _ isShowMsg: Bool, _ callback: (() -> Void)? = nil) {
        if checkFalseCondition() { return }
        VoxeetSDK.shared.command.send(message: message) { error in
            JamitLog.logE("======>sendMessage error =\(String(describing: error))")
            if isShowMsg {
                self.currentVC.showToast(withResId: error != nil ? StringRes.info_send_request_success : StringRes.info_send_request_success)
            }
            if error == nil {
                callback?()
            }
            
        }
    }
    
    
}
extension DolbySdkManager: VTCommandDelegate {
    
    public func received(participant: VTParticipant, message: String) {
        JamitLog.logE("=========>VTCommandDelegate received msage=\(String(describing: participant))==>message=\(message)")
        let dolbyMessage = DolbyMessage(participant, self.event.eventId)
        dolbyMessage.setMessage(message: message)
        self.messageDelegate?.onReceivedMessage(dolbyMessage)
    }
}

extension DolbySdkManager: VTConferenceDelegate {
    
    public func statusUpdated(status: VTConferenceStatus) {
        JamitLog.logE("=========>VTConferenceDelegate statusUpdated=\(self.getConfStatus(status: status))")
    }
    
    public func permissionsUpdated(permissions: [Int]) {
        
    }
    
    public func participantAdded(participant: VTParticipant) {
        JamitLog.logE("=========>participantAdded=\(String(describing: participant))")
        self.onRefreshParticipants()
    }
    
    public func participantUpdated(participant: VTParticipant) {
        JamitLog.logE("=========>participantUpdated=\(String(describing: participant))")
        if participant.status == .kicked {
            let externalId = participant.info.externalID ?? ""
            if externalId.isEmpty { return }
            let isHostEvent = self.event.isHostEvent(externalId)
            let isMyUserId = self.userId.elementsEqual(externalId)
            if !isHostEvent && isMyUserId {
                self.participantDelegate?.onKickedParticipant(participant)
                return
            }
        }
        self.onRefreshParticipants()
    }
    
    public func streamAdded(participant: VTParticipant, stream: MediaStream) {
        JamitLog.logE("====>streamAdded=\(String(describing: participant))")
        if participant.type != .mixer {
            self.streamDelegate?.onUpdateStream(participant, IDolbyConstant.TYPE_ADDED_STREAM)
        }
    }
    
    public func streamRemoved(participant: VTParticipant, stream: MediaStream) {
        JamitLog.logE("====>streamRemoved=\(String(describing: participant))")
        if participant.type != .mixer {
            self.streamDelegate?.onUpdateStream(participant, IDolbyConstant.TYPE_REMOVED_STREAM)
        }
    }

    public func streamUpdated(participant: VTParticipant, stream: MediaStream) {
        if participant.type != .mixer {
            let trackCount = stream.audioTracks.count
            JamitLog.logE("==========>streamUpdated trackCount =\(trackCount)")
            let type = trackCount > 0 ? IDolbyConstant.TYPE_ADDED_STREAM : IDolbyConstant.TYPE_REMOVED_STREAM
            self.streamDelegate?.onUpdateStream(participant, type)
        }
    }
    
    
    func onRefreshParticipants() {
        DispatchQueue.global().async {
            self.updateParticipants()
        }
    }
}

extension DolbySdkManager: VTNotificationDelegate {
    public func activeParticipants(notification: VTActiveParticipantsNotification) {
        
    }
    
    
    public func invitationReceived(notification: VTInvitationReceivedNotification) {
        JamitLog.logE("=====>=invitationReceived=\(notification.conferenceID)==>\(notification.conferenceAlias)")
        self.processGetDetailRoom(notification)
    }
    
    public func conferenceStatus(notification: VTConferenceStatusNotification) {
        
    }
    
    public func conferenceCreated(notification: VTConferenceCreatedNotification) {
        
    }
    
    public func conferenceEnded(notification: VTConferenceEndedNotification) {
        
    }
    
    public func participantJoined(notification: VTParticipantJoinedNotification) {
        
    }
    
    public func participantLeft(notification: VTParticipantLeftNotification) {
        
    }
    
    
    private func processGetDetailRoom(_ notification: VTInvitationReceivedNotification) {
        let conferenceID = notification.conferenceID
        if  conferenceID.isEmpty { return }
        let participant = notification.participant
        JamItEventApi.getDetailEvent(eventId: conferenceID) { result in
            if let event = result, event.isResultOk() {
                self.showDialogConfirmInvitation(event, conferenceID, participant)
                return
            }
            self.userInvitedDelegate?.onInvitedError(nil)
        }
    }
    
    
}
extension DolbySdkManager : ConfirmDelegate {
    
    func onConfirm() {
        JamitLog.logE("=======>DolbySdkManager onConfirm=\(self.pivotType)")
        if self.pivotType == TYPE_CONFIRM_INVITE {
            if self.pivotEvent == nil || self.pivotConferenceId == nil { return }
            self.confirmInviteOnServer(event: self.pivotEvent!, confId: self.pivotConferenceId!, isAccepted: true)
        }
        self.pivotType = 0
    }

    func onCancel() {
        JamitLog.logE("=======>DolbySdkManager onCancel=\(self.pivotType)")
        if self.pivotType == TYPE_CONFIRM_INVITE {
            if self.pivotEvent == nil || self.pivotConferenceId == nil { return }
            self.confirmInviteOnServer(event: self.pivotEvent!, confId: self.pivotConferenceId!, isAccepted: false)
        }
        self.pivotType = 0
    }
    func onTopAction() {}
    
}

extension DolbySdkManager {
    func getConfStatus(status: VTConferenceStatus) -> String{
        if status == .creating {
            return "creating"
        }
        else if status == .created {
            return "created"
        }
        else if status == .destroyed {
            return "destroyed"
        }
        if status == .ended {
            return "ended"
        }
        else if status == .error {
            return "error"
        }
        else if status == .joined {
            return "joined"
        }
        else if status == .joining {
            return "joining"
        }
        else if status == .leaving {
            return "leaving"
        }
        return "unknown"
        
    }
}
