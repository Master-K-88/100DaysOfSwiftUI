//
//  LibraryViewModel.swift
//  jamit
//
//  Created by Prof K on 3/22/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class LibraryViewModel {
    var podcastSelectect: (() -> Void)?
    var audioSelectect: (() -> Void)?
    var seriesSelectect: (() -> Void)?
    
    func btnPodcast() {
        podcastSelectect?()
    }
    
    func btnAudio() {
        audioSelectect?()
    }
    
    func btnSeries() {
        seriesSelectect?()
    }
}
