//
//  TabBuilder.swift
//  Created by YPY Global on 1/9/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

struct TabBuilder {
    
    static func buildSegmentioView(content: [SegmentioItem] , segmentioView: Segmentio, segmentioStyle: SegmentioStyle,tabBgColor: UIColor = .black,indicator: SegmentioIndicatorOptions? = nil) {
        segmentioView.setup(
            content: content,
            style: segmentioStyle,
            options: segmentioOptions(segmentioStyle: segmentioStyle,tabBgColor: tabBgColor,indicator: indicator)
        )
    }
    
    private static func segmentioOptions(segmentioStyle: SegmentioStyle,tabBgColor: UIColor, indicator: SegmentioIndicatorOptions? = nil) -> SegmentioOptions {
        var imageContentMode = UIView.ContentMode.center
        switch segmentioStyle {
        case .imageBeforeLabel, .imageAfterLabel:
            imageContentMode = .scaleAspectFit
        default:
            break
        }
        return SegmentioOptions(
            backgroundColor: tabBgColor,
            maxVisibleItems: 5,
            scrollEnabled: true,
            indicatorOptions: indicator,
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates(),
            animationDuration: 0.3
        )
    }
    
    private static func segmentioStates() -> SegmentioStates {
        let font = UIFont(name: IJamitConstants.FONT_SEMI_BOLD, size: DimenRes.tab_font_size) ?? UIFont.systemFont(ofSize: DimenRes.tab_font_size)
        
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor.clear,
                titleFont: font,
                titleTextColor: getColor(hex: ColorRes.label_color)
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor.clear,
                titleFont: font,
                titleTextColor: getColor(hex: ColorRes.tab_text_focus_color)
            ),
            highlightedState: segmentioState(
                backgroundColor: UIColor.clear,
                titleFont: font,
                titleTextColor: getColor(hex: ColorRes.tab_text_focus_color)
            )
        )
    }
    
    private static func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(
            backgroundColor: backgroundColor,
            titleFont: titleFont,
            titleTextColor: titleTextColor
        )
    }
    
    public static func segmentioIndicatorOptions(_ color: UIColor) -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: CGFloat(DimenRes.tab_indicator_height),
            color: color
        )
    }
    
    private static func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .bottom,
            height: 1,
            color: UIColor.clear
        )
    }
    
    private static func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 0,
            color: UIColor.clear
        )
    }
}
