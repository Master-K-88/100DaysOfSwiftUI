//
//  AppConfigModel.swift
//  RadioSpain
//
//  Created by Do Trung Bao on 4/9/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
class ConfigModel: AbstractModel {
    
    var nativeAdId = ""
    var bannerId = ""
    var interstitialId = ""
    var appId = ""
    var publisherId = ""
    
    override func initFromDict(_ dict: [String : Any]?) {
        super.initFromDict(dict)
        self.bannerId = self.parseValueFromDict("banner_id") ?? ""
        self.nativeAdId = self.parseValueFromDict("native_id") ?? ""
        self.interstitialId = self.parseValueFromDict("interstitial_id") ?? ""
        self.appId = self.parseValueFromDict("app_id") ?? ""
        self.publisherId = self.parseValueFromDict("publisher_id") ?? ""
    }
 
   
}
