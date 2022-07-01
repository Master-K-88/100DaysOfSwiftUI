//
//  SettingModel.swift
//  jamit
//
//  Created by Do Trung Bao on 8/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class SettingModel: JamitResponce {
    
    var showAudioTypes = false
    var showStoryTypes = false
    var isTipSupport = false
    var showLiveTypes = false
    
    var hasAudioType: Bool {
        get {
            return self.showLiveTypes || self.showAudioTypes || self.showStoryTypes
        }
    }
    
    var isShowLive: Bool {
        get {
            return self.showLiveTypes
        }
    }
    
    var isShowPodcast: Bool {
        get {
            return self.hasAudioType
        }
    }
    
    var isShowStory: Bool {
        get {
            return self.hasAudioType
        }
    }
    
    var isShowAudioBook: Bool {
        get {
//            return self.showLiveTypes || self.showAudioTypes
            return false
        }
    }
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.showStoryTypes = self.parseValueFromDict("show_story_types") ?? false
        self.showAudioTypes = self.parseValueFromDict("show_audio_types") ?? false
        self.showLiveTypes = self.parseValueFromDict("show_live_types") ?? false
        self.isTipSupport = self.parseValueFromDict("show_creator_payments") ?? false
    }
    
    override func createDictToSave() -> [String : Any]? {
        var dicts = super.createDictToSave()
        dicts?.updateValue(showStoryTypes, forKey: "show_story_types")
        dicts?.updateValue(showAudioTypes, forKey: "show_audio_types")
        dicts?.updateValue(showLiveTypes, forKey: "show_live_types")
        dicts?.updateValue(isTipSupport, forKey: "show_creator_payments")
        return dicts
    }
    
}
