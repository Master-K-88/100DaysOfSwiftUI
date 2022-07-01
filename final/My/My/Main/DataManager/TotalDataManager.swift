//
//  TotalDataManager.swift
//  Created by YPY Global on 3/5/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation

public class TotalDataManager {
    static let shared = TotalDataManager()
    
    var cache: YPYCacheDataModel = YPYCacheDataModel()
    var appConfigure: ConfigModel?
    var jamItLocale: JamItLocaleModel?
    var deepLink: DeepLinkModel?
    
    init() {
        cache.addSaveMode(IJamitConstants.TYPE_VC_TAB_HOME,EpisodeModel.self )
        cache.addSaveMode(IJamitConstants.TYPE_VC_TAB_CATEGORIES, CategoryModel.self)
        cache.addSaveMode(IJamitConstants.TYPE_VC_FAVORITE, EpisodeModel.self)
        cache.addSaveMode(IJamitConstants.TYPE_VC_DOWNLOAD, EpisodeModel.self)
        cache.addSaveMode(IJamitConstants.TYPE_SETTING, SettingModel.self)
    }
    
    func getListData(_ id : Int) -> [JsonModel]? {
        return cache.getListCacheData(id)
    }
    
    func isCacheExisted(_ id : Int) -> Bool {
        return cache.isCacheExisted(id)
    }
    
    func readTypeData (_ id: Int) {
        cache.readCacheData(id)
    }
    
    func setListCacheData(_ id: Int, _ listModel: [JsonModel]){
        cache.setListCacheData(id, listModel)
    }
    
    func readConfigure() {
        if let resultModel = JsonParsingUtils.getListDataFromAssets(IJamitConstants.FILE_CONFIG_JSON, IJamitConstants.FORMAT_JSON, ConfigModel.self) {
            if let model = resultModel.firstModel() as? ConfigModel {
                self.appConfigure = model
            }
        }
    }
    
    func readCacheAndData(_ callback: (() -> Void)? = nil) {
        if self.appConfigure != nil {
            self.cache.readAllCache()
        }
        if callback != nil {
            callback!()
        }
        
    }
    
    func getSetting() -> SettingModel? {
        let list = self.getListData(IJamitConstants.TYPE_SETTING)
        let size = list?.count ?? 0
        if size > 0 {
            return list?[0] as? SettingModel
        }
        return nil
    }
    func getNativeId() -> String {
        return self.appConfigure?.nativeAdId ?? ""
    }
    

    func onDestroy() {
        cache.onDestroy()
    }
    
    func addModelToCache(_ type: Int, _ model: JsonModel){
        addModelToCache(type,0,model)
    }
    func addModelToCache(_ type: Int,_ pos: Int, _ model: JsonModel){
        cache.addModelInCache(type,pos, model)
    }
    
    func removeModelInCache(_ type: Int, _ model: JsonModel) -> Bool {
        return cache.removeModelInCache(type, model)
    }

    func getFileDownloaded(_ model: EpisodeModel) -> String? {
        if let fileDownloaded  = self.getDownloadFileNoCheck(model) {
            if let listModel = self.getListData(IJamitConstants.TYPE_VC_DOWNLOAD) as? [EpisodeModel]{
                for trackModel in listModel {
                    if trackModel.equalElement(model){
                        return fileDownloaded
                    }
                }
            }
        }
        return nil
    }
    
    func getDownloadFileNoCheck(_ model: EpisodeModel) -> String?{
        if let cacheDirectoryUrl = self.getDownloadDirectory() {
            let fileName = self.getFileDownloadName(model)
            if !fileName.isEmpty {
                let fileUrl = cacheDirectoryUrl.appendingPathComponent(fileName)
                let isFileExisted = FileManager.default.fileExists(atPath: fileUrl.path)
                if isFileExisted {
                    return fileName
                }
            }
        }
        return nil
    }
    
    func isFileDownloaded(_ model: EpisodeModel) -> Bool {
        let fileDownload = self.getFileDownloaded(model)
        return fileDownload != nil && !fileDownload!.isEmpty
    }
    
    func getFileDownloadName(_ model: EpisodeModel) -> String{
        var fileName = ""
        if model.isOfflineFile() {
            fileName = model.path
        }
        else{
            if let hash = ApplicationUtils.getMd5Hash(model.linkDownload) {
                let extensition =  URL(string: model.linkDownload)?.pathExtension ?? "mp3"
                fileName = IJamitConstants.FORMAT_CACHE + hash + "." + extensition
                JamitLog.logE("=======>fileName=\(fileName)")
            }
        }
        return fileName
    }

    func deleteDownloadFileOfTrack(_ model: EpisodeModel){
        if let cacheDirectoryUrl = self.getDownloadDirectory() {
            let fileName = self.getFileDownloadName(model)
            if !fileName.isEmpty {
                let fileUrl = cacheDirectoryUrl.appendingPathComponent(fileName)
                let isFileExisted = FileManager.default.fileExists(atPath: fileUrl.path)
                if isFileExisted {
                    do {
                        JamitLog.logE("========>start delete file \(fileUrl)")
                        try FileManager.default.removeItem(at: fileUrl)
                    }
                    catch let error as NSError {
                        JamitLog.logE("Error When deteting file: \(error.domain)")
                    }
                }
            }
        }
        
    }
    
    func getDownloadDirectory() -> URL?{
        guard let cacheDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cacheDirectoryUrl
    }
    
    func getRecordDirectory() -> URL?{
        guard let cacheDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let recordDirectory = cacheDirectoryUrl.appendingPathComponent(IJamitConstants.RECORD_FOLDER)
        let isExisted = FileManager.default.fileExists(atPath: recordDirectory.path)
        JamitLog.logE("=====>isExisted=\(isExisted)====>path=\(recordDirectory.path)")
        if !isExisted {
            do {
                try FileManager.default.createDirectory(atPath: recordDirectory.path,
                                                        withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                JamitLog.logE("=====>creating folder error=\(error.localizedDescription)")
                return nil
            }
        }
        return recordDirectory
    }
    
}
