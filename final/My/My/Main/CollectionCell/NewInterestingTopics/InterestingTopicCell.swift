//
//  InterestingTopicCell.swift
//  jamit
//
//  Created by Prof K on 6/2/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class InterestingTopicCell: UICollectionViewCell {
    
    static let identifier = "InterestingTopicCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblCategory: UILabel = {
        let label = UILabel()
        label.text = "Jamit"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chatArraysColors = ColorRes.array_categories_colors
    private var sizeArray: Int = 0
    var topicModel: InterestingTopics?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        self.sizeArray = chatArraysColors.count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.cornerRadius = 5
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(containerView)
        containerView.pin(to: contentView)
        containerView.addSubview(lblCategory)
        lblCategory.pin(to: containerView)
    }
    
    func updateUI(_ model: InterestingTopics) {
        self.topicModel = model
        self.lblCategory.text = model.title
        if model.selectedState {
            self.containerView.backgroundColor = getColor(hex: "#FFAE29")
        } else {
            self.containerView.backgroundColor = getColor(hex: "#212130")
        }
        
    }
}
