//
//  ListenOfflineController.swift
//  iLandMusic
//  Created by iLandMusic on 11/1/19.
//  Copyright © 2019 iLandMusic. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing
import Alamofire

//class ListenOfflineController: JamitRootViewController{
//    
//    let deltaPercent = Double(3)
//    
//    @IBOutlet weak var btnCancel: UIButton!
//    @IBOutlet weak var circularProgress: UICircularProgressRing!
//    
//    //set parent view controller
//    var parentVC: JamitRootViewController?
//    
//    var episodeModel: EpisodeModel? // model to download
//    var pivotProcess = Double(0)
//    var downloadRequest: Alamofire.Request?
//    
//    @IBOutlet weak var lblProgress: UILabel!
//    
//    override func setUpUI() {
//        super.setUpUI()
//        self.btnCancel.setTitle(getString(StringRes.title_cancel).uppercased(), for: .normal)
//    
//        self.circularProgress.style = .ontop
//        self.circularProgress.outerRingWidth = DimenRes.medium_padding
//        self.circularProgress.innerRingWidth = DimenRes.medium_padding
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.startListenOffline()
//    }
//    
//    @IBAction func cancelTap(_ sender: Any) {
//        self.cancelDownload()
//        self.dismiss(animated: false, completion: nil)
//    }
//    
//    func cancelDownload(){
//        if self.downloadRequest != nil {
//            self.downloadRequest?.cancel()
//        }
//        if self.episodeModel != nil {
//            TotalDataManager.shared.deleteDownloadFileOfTrack(self.episodeModel!)
//        }
//    }
//    
//    private func startListenOffline(){
//        if self.episodeModel != nil && self.downloadRequest == nil {
//            self.showToast(with: "Continue in the background")
//            self.showAlertWithResId(titleId: "Download", messageId: "Downloading Audio", positiveId: nil, negativeId: nil, completion: nil, cancel: .none)
//            let linkDownload = self.episodeModel!.linkDownload
//            if linkDownload.isEmpty {
//                self.showToast(withResId: StringRes.info_download_error)
//                return
//            }
//            if !StorageUtils.checkFreeStorage(IJamitConstants.MINIMUM_FREE_STORAGE){
//                self.showToast(withResId: StringRes.info_sdcard_error)
//                return
//            }
//            let fileName = TotalDataManager.shared.getFileDownloadName(self.episodeModel!)
//            JamitLog.logD("===>downloaded fileName=\(fileName)")
//            if !fileName.isEmpty {
//                let destination: DownloadRequest.Destination = { _, _ in
//                    let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//                    let fileUrl = documentsURL.appendingPathComponent(fileName)
//                    return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
//                }
//                
//                JamitLog.logD("===>link download=\(linkDownload)")
//                self.downloadRequest = AF.download(linkDownload, to: destination)
//                    .downloadProgress { progress in
//                        var percent = progress.fractionCompleted * 100.0
//                        percent.round()
//                        if percent > 100 {
//                            percent = 100
//                        }
//                        let deltaPercent = percent - self.pivotProcess
//                        if  deltaPercent > self.deltaPercent || percent == 100 {
//                            self.pivotProcess = percent
//                            self.updateProgress(self.pivotProcess)
//                        }
//                    }
//                    .response { response in
//                        if response.error == nil {
//                            if (response.fileURL?.path) != nil {
//                                if let trackModel = self.episodeModel!.clone() {
//                                    trackModel.path = fileName
//                                    self.episodeModel!.path = fileName
//                                    DispatchQueue.global().async {
//                                        TotalDataManager.shared.addModelToCache(IJamitConstants.TYPE_VC_DOWNLOAD, trackModel)
//                                        DispatchQueue.main.async {
//                                            //block action
//                                            if self.downloadRequest != nil {
//                                                self.downloadRequest?.cancel()
//                                            }
//                                            //notify to data
//                                            let userInfo  = [
//                                                IJamitConstants.KEY_ID:self.episodeModel!.id,
//                                                IJamitConstants.KEY_VC_TYPE:IJamitConstants.TYPE_VC_DOWNLOAD] as [String : Any]
//                                            NotificationCenter.default.post(name: Notification.Name(IJamitConstants.BROADCAST_DATA_CHANGE), object: nil, userInfo: userInfo)
//                                            
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
//                                        }
//                                            
//                                    }
//                                    return
//
//                                }
//                                self.downloadRequest?.cancel()
//                                self.dismiss(animated: true, completion: {
//                                    if self.parentVC != nil {
//                                        self.parentVC?.showToast(withResId: StringRes.info_saved_song_success)
//                                        (self.parentVC as? PlayingControler)?.updateInfo(true)
//                                    }
//                                })
//                                return
//                            }
//                        }
//                        self.showToast(withResId: StringRes.info_download_error)
//                }
//                return
//            }
//        }
//        self.dismiss(animated: false, completion: nil)
//        
//    }
//    
//    func updateProgress(_ percent: Double){
//        if percent > 0 {
//            self.lblProgress.textColor = getColor(hex: ColorRes.color_accent)
//            self.lblProgress.text = String(Int(percent)) + "%"
//            self.circularProgress.startProgress(to: CGFloat(percent),duration:0.1)
//        }
//        else{
//            self.lblProgress.textColor = getColor(hex: ColorRes.dialog_color_main_text)
//            self.lblProgress.text = getString(StringRes.info_process_loading)
//        }
//    }
//}
