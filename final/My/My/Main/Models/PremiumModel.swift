//
//  PremiumModel.swift
//  RadioPL
//
//  Created by YPY Global on 9/20/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation

class PremiumModel: AbstractModel {
    
    public static let STATUS_BTN_BUY = 1
    public static let STATUS_BTN_PURCHASED = 2
    public static let STATUS_BTN_SKIP = 3
    
    var productId = ""
    var price = ""
    var duration = ""
    var labelBtnBuy = ""
    
    var statusBtn = STATUS_BTN_BUY
    
    public required init() {
        super.init()
    }
    
    init(_ id: Int, _ name: String, _ img: String,_ productId: String) {
        super.init(id,name,img)
        self.productId = productId
    }
    
    
}
