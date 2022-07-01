//
//  StreamManager.swift
//  Created by YPY Global on 2/17/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import FRadioPlayer
import AVFoundation

protocol StreamDelegate {
    func onUpdatePlayerState(_ playerState: FRadioPlayerState)
    func onUpdatePlaybackState(_ playbackState: FRadioPlaybackState)
    func onUpdatePosition(_ current: Float, _ duration: Float)
}

enum PlayerAction: Int {
    case Play = 0, Pause, Next, Previous, TogglePlay, Stop, LostConnect, Forward, Rewind
}

public class StreamManager : NSObject{
    
    let TIME_CONTROL_STATUS = "timeControlStatus"
    static let shared: StreamManager = StreamManager()
    private var currentIndex: Int = -1
    private var listModels = [EpisodeModel]()
    
    //MUST TO KEEP TO HAVE AUDIO SESSION
    private let fRadioPlayer = FRadioPlayer.shared
    
    private var fMusicPlayer: AVPlayer?
    
    var currentModel: EpisodeModel?
    var streamInfo: StreamInfoModel = StreamInfoModel()
    
    var playerState: FRadioPlayerState = FRadioPlayerState.urlNotSet
    var playbackState: FRadioPlaybackState = FRadioPlaybackState.stopped
    
    var delegate: StreamDelegate?
    
    private var isRealPlaying : Bool = false
    private var isCheckPause  = false
    private var rateObserver: NSKeyValueObservation?
    var timeObsever : Any?
    var artwork: UIImage?
    var playCountTimer = Timer()
    
    override init() {
        super.init()
        self.fRadioPlayer.delegate = self
        
    }
 
    private func resetPlayCountTimer() {
        if self.playCountTimer.isValid {
            self.playCountTimer.invalidate()
        }
    }
    
    func onResetData () {
        self.resetPlayCountTimer()
        self.listModels.removeAll()
        self.currentIndex = -1
        self.currentModel = nil
        self.streamInfo.onResetData()
    }
    
    func isHavingList() -> Bool {
        return listModels.count > 0
    }
    
    func isSelectedTrack(_ id: String) -> Bool {
        return self.currentModel != nil && self.currentModel!.id.elementsEqual(id)
    }
    
    func updateFavorite (_ episode: EpisodeModel, _ isFav: Bool) -> Bool {
        let currentModel = self.listModels.first(where: {$0.equalElement(episode)})
        if currentModel != nil {
            currentModel!.likes = episode.getLikes()
            return true
        }
        return false
    }

    func setCurrentModel(_ model: EpisodeModel?) -> Bool {
        let size = listModels.count
        if size > 0 && model != nil, let index: Int = listModels.firstIndex(where: {$0.equalElement(model)}) {
            if index >= 0 {
                self.currentIndex = index
                self.currentModel = listModels [index]
                self.streamInfo.onResetData()
                return true
            }
        }
        return false
    }
    
    func isMusicReadyPlay() -> Bool {
        if self.fMusicPlayer != nil{
            return self.fMusicPlayer!.status == AVPlayer.Status.readyToPlay
        }
        return false
    }
    
    func isPlayerStopped () -> Bool {
        return !isHavingList() && playbackState == FRadioPlaybackState.stopped
    }
    
    func isPlaying () -> Bool {
        if !self.isOfflineFile() {
            let isPlaying: Bool = playbackState == FRadioPlaybackState.playing
            return isPlaying
        }
        else{
            if self.fMusicPlayer != nil{
              return self.isMusicReadyPlay() && self.isRealPlaying
            }
        }
        return false
    }
    
    func isLoading () -> Bool {
        return self.playerState == FRadioPlayerState.loading
    }
    
    func setListModel (_ list: [EpisodeModel]!) {
        if !isSameList(list) {
            onResetData()
            //clone model to advoid error
            let isPremium = MemberShipManager.shared.isPremiumMember()
            for model in list {
                if !model.isPremium {
                    let cloneModel = model.clone()
                    if cloneModel != nil {
                        self.listModels.append(cloneModel!)
                    }
                }
                else{
                    if isPremium {
                        let cloneModel = model.clone()
                        if cloneModel != nil {
                            self.listModels.append(cloneModel!)
                        }
                    }
                }
            }
            let size = self.listModels.count
            if size > 0 {
                self.currentIndex = 0
                self.currentModel = self.listModels[self.currentIndex]
            }
        }
    }
    
    private func isSameList (_ listCompared: [EpisodeModel]?) -> Bool {
        let size1 = self.listModels.count
        let size2 = (listCompared != nil ? listCompared?.count : 0)!
        if size1 == size2 && size2 > 0  {
            for i in 0..<size1 {
                let model1: EpisodeModel = self.listModels[i]
                let model2: EpisodeModel = (listCompared?[i])!
                if  !model1.equalElement(model2) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func nextRadio () {
        changeRadio(count: 1)
    }
    
    func prevRadio () {
        changeRadio(count: -1)
    }
        
    private func changeRadio (count: Int) {
        let size = listModels.count
        if size > 0 {
            self.currentIndex = self.currentIndex + count
            if self.currentIndex >= size {
                self.currentIndex = 0
            }
            if self.currentIndex < 0 {
                self.currentIndex = size - 1
            }
            self.currentModel = listModels[self.currentIndex]
            startMusicAction(action: PlayerAction.Play)
        }
    }
    
    func startMusicAction (action: PlayerAction) {
        switch action {
        case .Play:
            self.releaseAllPlayer()
            if self.delegate != nil {
                self.delegate?.onUpdatePlayerState(FRadioPlayerState.loading)
            }
            DispatchQueue.global().async {
                let urlStream = self.currentModel?.getLinkStream() ?? ""
                JamitLog.logE("====>urlStream=\(urlStream)")
                DispatchQueue.main.async {
                    if urlStream.isEmpty  || (!ApplicationUtils.isOnline() && urlStream.starts(with: "http") && !self.currentModel!.isOfflineFile()) {
                        if self.delegate != nil {
                            self.delegate?.onUpdatePlayerState(FRadioPlayerState.error)
                        }
                        return
                    }
                    if !urlStream.isEmpty {
                        self.createMusicPlayer(urlStream)
                        self.startSchedulePlayCountTimer()
                    }
                }
            }
            break
        case .Next:
            nextRadio()
            break
        case .Previous:
            prevRadio()
            break
        case .Stop:
            self.onStop()
            break
        case .Pause:
            self.onPause()
            break
        case .TogglePlay:
            onTogglePlay()
            break
        case .LostConnect:
            self.onStop()
            break
        case .Forward:
            self.onSeekWithSign(sign: 1)
            break
        case .Rewind:
            self.onSeekWithSign(sign: -1)
            break
        }
    }
    
    private func createMusicPlayer(_ urlPlay: String) {
        self.fMusicPlayer = AVPlayer()
        self.rateObserver = self.fMusicPlayer!.observe(\.rate, options:  [.new, .old], changeHandler: { (player, change) in
            if self.playerState == FRadioPlayerState.readyToPlay {
                self.isRealPlaying = player.rate != 0
            }
        })
        self.fMusicPlayer!.addObserver(self, forKeyPath: TIME_CONTROL_STATUS, options: [.old, .new], context: nil)
        self.timeObsever = self.fMusicPlayer!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (progressTime) in
                if let duration = self?.fMusicPlayer?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if !durationSeconds.isNaN {
                    let seconds = CMTimeGetSeconds(progressTime)
                    DispatchQueue.main.async {
                        if self?.delegate != nil {
                            self?.delegate?.onUpdatePosition(Float(seconds), Float(durationSeconds))
                        }
                    }
                }
            }
            
        }
        
        //set up obsever when video played done
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.setUpAudioInterruptionObserver()
        
        var playerItem: AVPlayerItem?
        
        //MARK: OFFLINE SONG PLAYER
        if !urlPlay.starts(with: "http") {
            guard let cacheDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                self.delegate?.onUpdatePlayerState(FRadioPlayerState.error)
                return
            }
            let fileUrl = cacheDirectoryUrl.appendingPathComponent(urlPlay)
            //MARK: must to add MIME to run offline audio
            let asset = AVURLAsset(url: fileUrl)
            playerItem = AVPlayerItem(asset: asset)
        }
        else{
            if let urlMusic = URL(string: urlPlay) {
               let asset = AVAsset(url: urlMusic)
               playerItem = AVPlayerItem(asset: asset)
            }
        }
        if playerItem != nil {
            self.fMusicPlayer!.replaceCurrentItem(with: playerItem!)
            self.fMusicPlayer!.play()
            
            //reset state
            self.playbackState = FRadioPlaybackState.stopped
            self.playerState = FRadioPlayerState.loading
            self.delegate?.onUpdatePlayerState(FRadioPlayerState.loading)
        }
        
    }
    
    //when video is done, next to new music
    @objc func playerEndedPlaying(_ notification: Notification) {
        self.nextRadio()
    }
    
    private func onStop(){
        self.onResetData()
        self.releaseAVPlayer()
        self.playbackState = FRadioPlaybackState.stopped
        self.delegate?.onUpdatePlaybackState(FRadioPlaybackState.stopped)
    }
    
    private func releaseAVPlayer() {
        if self.fMusicPlayer != nil {
            if isPlaying() {
                self.fMusicPlayer!.pause()
            }
            //Remove Observer
            if self.rateObserver != nil {
                self.rateObserver!.invalidate()
            }
            if  self.timeObsever != nil {
                self.fMusicPlayer!.removeTimeObserver(self.timeObsever!)
                self.timeObsever = nil
            }
    
            self.fMusicPlayer!.removeObserver(self, forKeyPath: TIME_CONTROL_STATUS)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            //remove observer to check audio interrupt
            NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
            self.fMusicPlayer = nil
            
        }
    }
    
    private func onPause(){
        if self.fMusicPlayer != nil && self.isPlaying() {
            self.fMusicPlayer!.pause()
        }
    }
    
    private func releaseAllPlayer() {
        self.resetPlayCountTimer()
        if self.fMusicPlayer != nil {
            self.releaseAVPlayer()
        }
        self.playbackState = FRadioPlaybackState.stopped
        self.delegate?.onUpdatePlaybackState(self.playbackState)
        
    }
    
    private func onTogglePlay() {
       if self.isPlaying() {
            self.fMusicPlayer!.pause()
        }
        else{
            if self.isMusicReadyPlay() {
                self.fMusicPlayer!.play()
            }
        }
    }
    
    func isOfflineFile() -> Bool {
        return self.currentModel?.isOfflineFile() ?? false
    }
       
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == TIME_CONTROL_STATUS, let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
           let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
           let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
           if newStatus != oldStatus {
               DispatchQueue.main.async {[weak self] in
                   self?.isRealPlaying = (newStatus == .playing)
                   if newStatus == .playing{
                       if self?.delegate != nil {
                           self?.playbackState = FRadioPlaybackState.playing
                           self?.playerState = FRadioPlayerState.readyToPlay
                           self?.delegate?.onUpdatePlayerState(FRadioPlayerState.readyToPlay)
                           self?.delegate?.onUpdatePlaybackState(FRadioPlaybackState.playing)
                       }
                   }
                   else if newStatus == .paused {
                       if self?.delegate != nil {
                           self?.playbackState = FRadioPlaybackState.paused
                           self?.playerState = FRadioPlayerState.readyToPlay
                           self?.delegate?.onUpdatePlaybackState(FRadioPlaybackState.paused)
                       }
                   }
                   else{
                       if self?.delegate != nil {
                           self?.playerState = FRadioPlayerState.loading
                           self?.playbackState = FRadioPlaybackState.stopped
                           self?.delegate?.onUpdatePlayerState(FRadioPlayerState.loading)
                       }
                   }
               }
           }
        }
    }
    
    func onSeekWithSign(sign: Int){
        if self.isMusicReadyPlay() && (sign == -1 || sign == 1) {
            if let duration = self.fMusicPlayer?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if !durationSeconds.isNaN {
                    if let current = self.fMusicPlayer?.currentItem?.currentTime() {
                        var currentPos = Float(CMTimeGetSeconds(current))
                        let deltaSeek = sign > 0 ? IJamitConstants.FORWARD_SEEK_SECONDS : IJamitConstants.REWIND_SEEK_SECONDS
                        currentPos = currentPos + Float(sign * deltaSeek)
                        if currentPos < 0 {
                            currentPos = 0
                        }
                        if currentPos > Float(durationSeconds) {
                            currentPos = Float(durationSeconds) - 1
                        }
                        JamitLog.logE("==========>onSeekWithSign currentPos=\(currentPos)")
                        self.onSeek(time: currentPos)
                    }
                    
                }
            }
        }
    }
       
    func onSeek(time: Float = 0, percent: Float = 0) {
        if time >= 0 || percent > 0 {
            if percent > 0 {
                if self.isMusicReadyPlay() {
                    if let duration = self.fMusicPlayer?.currentItem?.duration {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        if !durationSeconds.isNaN {
                            let timeSeek = percent * Float(durationSeconds)
                            self.fMusicPlayer?.seek(to: CMTime(value: CMTimeValue(timeSeek * 1000), timescale: 1000))
                        }
                    }
                }
            }
            else{
                 self.fMusicPlayer?.seek(to: CMTime(value: CMTimeValue(time * 1000), timescale: 1000))
            }
            
        }
    }
    
    
    func startSchedulePlayCountTimer () {
        self.resetPlayCountTimer()
        self.playCountTimer = Timer.scheduledTimer(timeInterval: TimeInterval(IJamitConstants.PLAY_COUNT_TIME), target: self, selector: #selector(updatePlayCount), userInfo: nil, repeats: true)
    }
    
    @objc func updatePlayCount() {
        if ApplicationUtils.isOnline() {
            if let episode = self.currentModel  {
                JamItPodCastApi.playCount(episode.id) { (result) in
                    JamitLog.logE("====>updatePlayCount tracked=\(String(describing: (result)?.tracked))")
                }
            }
        }
        self.resetPlayCountTimer()
    }
    
       
    //Observe for Interruption Notifications to check phone call start or end
    private func setUpAudioInterruptionObserver() {
       let notificationCenter = NotificationCenter.default
       notificationCenter.addObserver(self,
                                      selector: #selector(handleInterruption),
                                      name: AVAudioSession.interruptionNotification,
                                      object: nil)
    }

    @objc func handleInterruption(notification: Notification) {
       guard let userInfo = notification.userInfo,
           let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
           let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
               return
       }
       if type == .began {
           // Interruption began, take appropriate actions
       }
       else if type == .ended {
           if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
               let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
               if options.contains(.shouldResume) {
                   // Interruption Ended - playback should resume
                   JamitLog.logE("Interruption Ended - playback should resume")
                   self.onTogglePlay()
               }
               else {
                   JamitLog.logE("Interruption Ended - playback should NOT resume")
                   // Interruption Ended - playback should NOT resume
               }
           }
       }
    }
    
}

extension StreamManager : FRadioPlayerDelegate {
    
    public func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        self.playerState = state
        if self.delegate != nil {
            self.delegate?.onUpdatePlayerState(state)
        }
    }
    
    public func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        self.playbackState = state
        if self.delegate != nil {
            self.delegate?.onUpdatePlaybackState(state)
        }
    }
    
    public func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        
    }
    
    public func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
       
    }
    
    
}
