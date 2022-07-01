//
//  NewTopicCell.swift
//  jamit
//
//  Created by Prof K on 3/16/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewTopicCell: UICollectionViewCell {
    
    static let identifier = "NewTopicCell"
    var viewModel: CatergoryViewModel?
    
    let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 5
        view.alignment = .center
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblName: UILabel = {
        let label = UILabel()
        label.textColor = .white
//        label.textColor = .darkGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgTopic: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var topic: TopicModel!
    private let chatArraysColors = ColorRes.array_categories_colors
    private var sizeArray: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        setupView()
        self.sizeArray = chatArraysColors.count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView() {
        contentView.addSubview(containerView)
        containerView.pin(to: contentView)
        containerView.addArrangedSubview(imgTopic)
        containerView.addArrangedSubview(lblName)
        lblName.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            lblName.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
//            lblName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lblName.widthAnchor.constraint(equalToConstant: 240),
            lblName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            imgTopic.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
            imgTopic.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8)
        ])
        
    }
    
    func updateUI(_ model: TopicModel, _ font: UIFont, _ pos: Int) {
        self.topic = model
        self.lblName.text = model.name
        self.lblName.font = font
        let avatar = model.topicID
        let bgColor = getColor(hex: chatArraysColors[pos%self.sizeArray])
        self.containerView.backgroundColor = bgColor
        
        guard avatar.starts(with: "http") else {
            imgTopic.isHidden = true
            return
        }
        self.imgTopic.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_actionbar_logo_36dp))
       
        
    }
}
