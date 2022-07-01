//
//  NewCategoryCell.swift
//  jamit
//
//  Created by Prof K on 3/16/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewCategoryCell: UICollectionViewCell {
    
    static let identifier = "NewCategoryCell"
    
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
    var catModel: CategoryModel?
    
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
//        setupConstraints()
    }
    
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            lblCategory.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            lblCategory.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//        ])
//    }
    
    func updateUI(_ model: CategoryModel, _ pos: Int) {
        self.catModel = model
        self.lblCategory.text = model.name
        self.containerView.backgroundColor = getColor(hex: chatArraysColors[pos%self.sizeArray])
    }
}
