//
//  SheetMenuAppearance.swift
//  jamit
//
//  Created by Do Trung Bao on 18/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import Sheeeeeeeeet

class SheetMenuAppearance: ActionSheetAppearance {
    
    override func apply() {
        super.apply()
        
        let view = ActionSheetTableView.appearance()
        view.backgroundColor = getColor(hex: ColorRes.dialog_bg_color)
        view.separatorColor = getColor(hex: ColorRes.dialog_divider_color)
        
        let item = ActionSheetItemCell.appearance()
        item.titleColor = getColor(hex: ColorRes.dialog_color_main_text)
    }
}
