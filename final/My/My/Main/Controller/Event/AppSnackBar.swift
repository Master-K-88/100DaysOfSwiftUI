//
//  AppSnackBar.swift
//  jamit
//
//  Created by Do Trung Bao on 01/09/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit
import SnackBar

class AppSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = getColor(hex: ColorRes.snack_bar_bg_color)
        style.textColor = getColor(hex: ColorRes.snack_bar_text_color)
        style.actionTextColor = getColor(hex: ColorRes.snack_bar_action_color)
        style.actionTextColorAlpha = 1.0
        style.font = UIFont(name: IJamitConstants.FONT_BOLD, size: DimenRes.text_size_subhead)
            ?? UIFont.systemFont(ofSize: DimenRes.text_size_subhead)
        return style
    }
}

