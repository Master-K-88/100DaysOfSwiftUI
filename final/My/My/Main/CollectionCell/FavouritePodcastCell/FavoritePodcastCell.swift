//
//  FavoritePodcastCell.swift
//  jamit
//
//  Created by Prof K on 6/2/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    static let identifier = "FavoritePodcastCell"
    //    var podcastViewModel: PodcastViewModel?
    //    var showDelegate: FeaturedDelegate?
    var showModel: ShowModel!
    
    private let favoriteButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.cornerRadius = 15
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.clipsToBounds = true
        imageView.tintColor = .systemPink
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.cornerRadius = 10
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgPodcastView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "img_default_circle")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPodcastCellView()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    fileprivate func setupPodcastCellView() {
        contentView.backgroundColor = .clear
        imgPodcastView.layer.cornerRadius = 10
        imgPodcastView.clipsToBounds = true
        favoriteButton.imageView?.clipsToBounds = true
        contentView.addSubview(bgView)
        bgView.pin(to: contentView)
        bgView.addSubview(imgPodcastView)
        bgView.addSubview(favoriteButtonImage)
        imgPodcastView.pin(to: bgView, top: 0, left: 0, bottom: 0, right: 0)
        favoriteButtonImage.addSubview(favoriteButton)
        favoriteButton.pin(to: favoriteButtonImage)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            favoriteButtonImage.bottomAnchor.constraint(equalTo: imgPodcastView.bottomAnchor, constant: -4),
            favoriteButtonImage.trailingAnchor.constraint(equalTo: imgPodcastView.trailingAnchor, constant: -4),
        ])
        
    }
    
}
