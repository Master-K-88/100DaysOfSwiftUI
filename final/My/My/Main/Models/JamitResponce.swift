//
//  JamitResultModel.swift
//  jamit
//
//  Created by Do Trung Bao on 5/4/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation

public class JamitResponce: JsonModel {
    
    var errorCode = 0
    var message = ""
    var error = ""
    var urlDynamicLink = ""
    var duplicate = false
        
    public required init() {
        super.init()
    }
    
    init(errorCode: Int = 0, msg: String =  "", duplicate: Bool, error: String = "") {
        super.init()
        self.message = msg
        self.error = error
        self.errorCode = errorCode
        self.duplicate = duplicate
    }
    
    override func initFromDict(_ dictionary: [String : Any]?) {
        super.initFromDict(dictionary)
        self.errorCode = self.parseValueFromDict("error_code") ?? 0
        self.message = self.parseValueFromDict("msg", alternate: "message") ?? ""
        self.duplicate = self.parseValueFromDict("duplicate") ?? false
        self.error = self.parseValueFromDict("error") ?? ""
        
    }
 
    func isResultOk() -> Bool {
        return errorCode == 0
    }
    
    func buildUrlOpenLink() -> String? {
        return nil
    }
    
    func buildDynamicImageLink() -> String {
        return IJamitConstants.DEFAULT_URL_IMAGE
    }
    
    func buildDynamicTitleLink() -> String? {
        return nil
    }
    
    func buildDynamicDesLink() -> String? {
        return nil
    }
    
    func getShareStr() -> String {
        var strBuilder = ""
        let title = buildDynamicTitleLink() ?? ""
        if !title.isEmpty {
            strBuilder += title
        }
        if !urlDynamicLink.isEmpty {
            strBuilder += "\n"
            strBuilder += urlDynamicLink
        }
        return strBuilder
    }
    
}
