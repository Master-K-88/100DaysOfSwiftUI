//
//  BackgroundDownload.swift
//  jamit
//
//  Created by Prof K on 10/10/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
import Alamofire

class BackgroundDownload {
    
    var episodeModel: EpisodeModel?
    var cacheEpisode: [String] = []
    var downloadRequest: Alamofire.Request?
    var completionHandler: ((String)-> Void)?
    
    func startListenOffline(episode: EpisodeModel) {
        self.episodeModel = episode
        if cacheEpisode.contains(episode.title) {
            completionHandler?("\(episode.title) is now in your downloaded list")
        } else {
            cacheEpisode.append(episode.title)
            completionHandler?("Continue browsing")
        if self.episodeModel != nil && self.downloadRequest == nil {
            let linkDownload = self.episodeModel!.linkDownload
            if linkDownload.isEmpty {
                completionHandler?(StringRes.info_download_error)
                return
            }
            if !StorageUtils.checkFreeStorage(IJamitConstants.MINIMUM_FREE_STORAGE){
                completionHandler?(StringRes.info_sdcard_error)
                return
            }
            
            let fileName = TotalDataManager.shared.getFileDownloadName(self.episodeModel!)
            JamitLog.logD("===>downloaded fileName=\(fileName)")
            if !fileName.isEmpty {
                let destination: DownloadRequest.Destination = { _, _ in
                    let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                    let fileUrl = documentsURL.appendingPathComponent(fileName)
                    return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                JamitLog.logD("===>link download=\(linkDownload)")
                self.downloadRequest = AF.download(linkDownload, to: destination)
                    .downloadProgress { progress in
                        var percent = progress.fractionCompleted * 100.0
                        percent.round()
                        if percent > 100 {
                            percent = 100
                        }
//                        let deltaPercent = percent - self.pivotProcess
//                        if  deltaPercent > self.deltaPercent || percent == 100 {
//                            self.pivotProcess = percent
//                        self.cacheEpisode.remove(at: self.cacheEpisode.firstIndex(of: episode.title)!)
//                            self.updateProgress(self.pivotProcess)
//                        }
                    }
                    .response { response in
                        if response.error == nil {
                            if (response.fileURL?.path) != nil {
                                if let trackModel = self.episodeModel!.clone() {
                                    trackModel.path = fileName
                                    self.episodeModel!.path = fileName
                                    DispatchQueue.global().async {
                                        TotalDataManager.shared.addModelToCache(IJamitConstants.TYPE_VC_DOWNLOAD, trackModel)
                                        DispatchQueue.main.async {
                                            //block action
                                            if self.downloadRequest != nil {
                                                self.downloadRequest?.cancel()
                                            }
                                            //notify to data
                                            let userInfo  = [
                                                IJamitConstants.KEY_ID:self.episodeModel!.id,
                                                IJamitConstants.KEY_VC_TYPE:IJamitConstants.TYPE_VC_DOWNLOAD] as [String : Any]
                                            NotificationCenter.default.post(name: Notification.Name(IJamitConstants.BROADCAST_DATA_CHANGE), object: nil, userInfo: userInfo)
                                            
//                                            self.dismiss(animated: true, completion: {
//                                                if self.parentVC != nil {
//                                                    self.parentVC!.showToast(withResId: StringRes.info_saved_song_success)
//                                                    if(self.parentVC! is PlayingControler){
//                                                        (self.parentVC as! PlayingControler).updateInfo(true)
//                                                    }
//                                                    else if self.parentVC! is MainController{
//                                                        (self.parentVC as! MainController).playingVC?.updateInfo(true)
//                                                    }
//                                                }
//                                            })
                                        }
                                            
                                    }
                                    return

                                }
                                self.completionHandler?(StringRes.info_saved_song_success)
                                self.downloadRequest?.cancel()
                                
                                
//                                self.dismiss(animated: true, completion: {
//                                    if self.parentVC != nil {
//                                        self.parentVC?.showToast(withResId: StringRes.info_saved_song_success)
                                
//                                        (self.parentVC as? PlayingControler)?.updateInfo(true)
//                                    }
//                                })
                                return
                            }
                        }
                        self.completionHandler?(StringRes.info_download_error)
//                        self.showToast(withResId: StringRes.info_download_error)
                }
                return
            }
        }
//        self.dismiss(animated: false, completion: nil)
        
    }
    }
    
}
