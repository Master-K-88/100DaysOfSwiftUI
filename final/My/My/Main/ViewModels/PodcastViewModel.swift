//
//  PodcastViewModel.swift
//  jamit
//
//  Created by Prof K on 3/13/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class PodcastViewModel {
    
    var show: ShowModel?
    var kingFisherCompletion: ((String, String) -> Void)?
    var defaultImage: ((String) -> Void)?
    var authDescr: ((String, String) -> Void)?
    
    func updateUI(_ show: ShowModel) {
        self.show = show
        let imgUrl: String = show.imageUrl
        if imgUrl.starts(with: "http") {
            kingFisherCompletion?(imgUrl, ImageRes.img_default)
        }
        else {
            defaultImage?(ImageRes.img_default)
        }
        
        let authorName = show.author
        let episodeTitle = show.title
        
        authDescr?(authorName, episodeTitle)
    }

}
