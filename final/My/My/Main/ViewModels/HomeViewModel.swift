//
//  HomeViewModel.swift
//  jamit
//
//  Created by Prof K on 3/11/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    var audioPodcast: ((Int) -> Void)?
    var liveEvent: (() -> Void)?
    var shortTapped: (() -> Void)?
    var episodes: [EpisodeModel]?
    var listFeaturedPodcast: [ShowModel]?
    var loadCompetion: (() -> Void)?
    
    
    init() {
        fetchFeaturedEpisodeData()
        fetchTrendingPodcastData()
        loadCompetion?()
    }
    
    func fetchFeaturedEpisodeData() {
        JamItPodCastApi.getFeaturedEpisodes { (list) in
            //            self.episodes = []
            self.episodes = list
        }
        
        
    }
    
    func fetchTrendingPodcastData() {
        JamItPodCastApi.getTrendingPodcast { (list) in
            //                self.listFeaturedPodcast = []
            self.listFeaturedPodcast = list
        }
        
        
    }
    
    
    func goToFeatured(_ typeVC: Int) {
        if typeVC == IJamitConstants.TYPE_VC_FEATURED_AUDIO_BOOK || typeVC == IJamitConstants.TYPE_VC_FEATURED_PODCASTS {
            audioPodcast?(typeVC)
        }
        else if typeVC == IJamitConstants.TYPE_VC_FEATURED_STORY {
            shortTapped?()
        }
        else if typeVC == IJamitConstants.TYPE_VC_FEATURED_EVENT {
            liveEvent?()
        }
    }
}
