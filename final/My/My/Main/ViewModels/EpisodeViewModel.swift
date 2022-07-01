//
//  EpisodeViewModel.swift
//  jamit
//
//  Created by Prof K on 3/12/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

class EpisodeViewModel {
    
    var episode: EpisodeModel?
    var listModels: [EpisodeModel]?
    var kingFisherCompletion: ((String, String) -> Void)?
    var defaultImage: ((String) -> Void)?
    var authDescr: ((String, String) -> Void)?
    var isItemSelected: ((UIColor, UIColor, UIColor) -> Void)?
    var itemState: ((UIImage) -> Void)?
    var playEpisodeItem: ((EpisodeModel) -> Void)?
    var playNonEpisodeItem: ((EpisodeModel, [EpisodeModel]?) -> Void)?
    var reloadCells: (() -> Void)?
    var reloadHomeCells: (() -> Void)?
    var itemSelected: (() -> Void)?
    var itemDeselected: (() -> Void)?
    
    private var colorSelected = getColor(hex: ColorRes.color_accent)
    private var colorTextHeader = getColor(hex: ColorRes.list_view_color_main_text)
    private var colorTextAuthor = getColor(hex: ColorRes.list_view_color_author_text)
    private var colorTextSecond = getColor(hex: ColorRes.list_view_color_second_text)
    
    func updateUI(with episode: EpisodeModel) {
        self.episode = episode
        let imgItem = episode.imageUrl
        if !imgItem.isEmpty && imgItem.starts(with: "http") {
            kingFisherCompletion?(imgItem, ImageRes.img_default)
        } else {
            defaultImage?(ImageRes.img_default)
        }
        
        let authorName = episode.getAuthor()
        let episodeTitle = episode.audioTitle
        
        authDescr?(authorName, episodeTitle)
        
        let isSelected = StreamManager.shared.isSelectedTrack(episode.id)
        let isPlaying = StreamManager.shared.isPlaying()
        self.updateSelected(isSelected)
        self.updateState(isSelected && isPlaying)
    }
    
    func updateSelected (_ isSelected: Bool) {
        isSelected ? itemSelected?() : itemDeselected?()
//        let authorName = isSelected ? colorSelected : colorTextAuthor
//        let itemMenu = isSelected ? colorSelected : colorTextSecond
//        DispatchQueue.main.async {
//            self.isItemSelected?(titleColor, authorName, itemMenu)
//        }
       
    }
    
    func updateState(_ isPlay: Bool) {
        guard let itemImage = UIImage(systemName: isPlay ? "pause.fill" : "play.fill") else {
            return
        }
        isPlay ? itemSelected?() : itemDeselected?()
        DispatchQueue.main.async {
            self.itemState?(itemImage)
        }
        
    }
    
    func playTapped(pos: Int = 0) {
        guard let episode = listModels?[pos] else {
            return
        }
        let isSelected = StreamManager.shared.isSelectedTrack(episode.id)
        let isReadyPlay = StreamManager.shared.isMusicReadyPlay()
        if isSelected && isReadyPlay {
            playEpisodeItem?(episode)
//            let isPlaying = StreamManager.shared.isPlaying()
//            self.updateSelected(isSelected)
//            self.updateState(isSelected && isPlaying)
        }
        else{
            if let listModels = self.listModels {
                playNonEpisodeItem?(episode, listModels)
                
//                let isPlaying = StreamManager.shared.isPlaying()
//                self.updateSelected(isSelected)
//                self.updateState(isSelected && isPlaying)
                
            }
        }
    }
}
