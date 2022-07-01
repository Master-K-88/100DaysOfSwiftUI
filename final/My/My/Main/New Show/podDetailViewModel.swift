//
//  podDetailViewModel.swift
//  jamit
//
//  Created by Prof K on 5/5/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
class PodDetailViewModel {
    var listTopics: [TopicModel]?
    var episodeModel: [EpisodeModel]?
    var showModel: ShowModel?
    var reloadTopic: (() -> Void)?
    var reloadEpisode: (() -> Void)?
    
    init (showModel: ShowModel) {
        self.showModel = showModel
        getData()
    }
    func getData() {
        JamItPodCastApi.getTopics { listTopics in
            self.listTopics = listTopics
            self.reloadTopic?()
            JamItPodCastApi.getEpisodesOfShow(self.showModel!.id) { (list) in
                self.episodeModel = list
                self.reloadEpisode?()
            }
        }
    }
}
