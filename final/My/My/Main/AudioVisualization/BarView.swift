//
//  BarView.swift
//  jamit
//
//  Created by Prof K on 3/28/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

let numberOfSamples: Int = 75
struct BarView: View {
    // 1
    var value: CGFloat
    
    var body: some View {
        ZStack {
            // 2
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [.gray, .white]),
                                     startPoint: .top,
                                     endPoint: .bottom))
            // 3
.frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
            
        }
    }
    
}
