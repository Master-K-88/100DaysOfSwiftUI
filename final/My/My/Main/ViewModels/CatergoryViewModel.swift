//
//  CatergoryViewModel.swift
//  jamit
//
//  Created by Prof K on 3/16/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import Foundation

class CatergoryViewModel {
    
    var btnCatSelected: Bool = false
    var btnTopicSelected: Bool = false
    var isCatSelected: (() -> Void)?
    var isTopicSelected: (() -> Void)?
    var listCategory: [CategoryModel]?
    var listPopularTopics: [TopicModel]?
    var kingFisherCompletion: ((String, String) -> Void)?
    var defaultImage: ((String) -> Void)?
    var topicDescr: ((String) -> Void)?
    
    init() {
        fetchData()
        catButtonSelected()
    }
    
    func catButtonSelected() {
        btnCatSelected = !btnCatSelected
        if btnCatSelected {
            btnTopicSelected = false
            isCatSelected?()
        }
    }
    
    func topicButtonSelected() {
        btnTopicSelected = !btnTopicSelected
        if btnTopicSelected {
            btnCatSelected = false
            isTopicSelected?()
        }
    }
    
    func fetchData() {
        JamItPodCastApi.getCategories { (list) in
            self.listCategory = list
            JamItPodCastApi.getTopics { (topics) in
                self.listPopularTopics = topics
            }
        }
    }
    
    func updateUI(_ model: TopicModel) {
        topicDescr?(model.name)
        let avatar = model.topicID
        if avatar.starts(with: "http") {
            kingFisherCompletion?(avatar, ImageRes.ic_actionbar_logo_36dp)
        }
        else {
            defaultImage?(ImageRes.ic_actionbar_logo_36dp)
        }
    }
}
