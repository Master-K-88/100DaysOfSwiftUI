//
//  NewPodcastCell.swift
//  jamit
//
//  Created by Prof K on 3/13/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

protocol FeaturedDelegate {
    func goToFeaturedShow(_ show: ShowModel)
}
class NewPodcastCell: UICollectionViewCell {
    static let identifier = "NewPodcastCell"
    var podcastViewModel: PodcastViewModel?
    var showDelegate: FeaturedDelegate?
    var showModel: ShowModel!
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgPodcastView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: ImageRes.img_default)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblPodcastTitle: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .natural
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblPodcastAuthor: UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPodcastCellView()
        
        setupConstraints()
        imgPodcastView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToShow)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        podcastCellListener()
        if let showModel = showModel {
            podcastViewModel?.updateUI(showModel)
        }
        
    }
    
    func podcastCellListener() {
        podcastViewModel?.kingFisherCompletion = { [weak self] urlString, placeHolderString in
            self?.imgPodcastView.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: placeHolderString))
        }
        
        podcastViewModel?.defaultImage = { [weak self] defaultImg in
            DispatchQueue.main.async {
                self?.imgPodcastView.image = UIImage(named: defaultImg)
            }
        }
        
        podcastViewModel?.authDescr = { [weak self] authorName, titleEpisode in
            DispatchQueue.main.async {
                self?.lblPodcastTitle.text = titleEpisode
                self?.lblPodcastAuthor.text = authorName
            }
            
        }
    }
    
    fileprivate func setupPodcastCellView() {
        contentView.backgroundColor = .clear
        imgPodcastView.layer.cornerRadius = 10
        imgPodcastView.clipsToBounds = true
        podcastCellListener()
        contentView.addSubview(imgPodcastView)
        imgPodcastView.pin(to: contentView, top: 0, left: 0, bottom: nil, right: 0)
        contentView.addSubview(containerView)
        containerView.pin(to: contentView, top: nil, left: 0, bottom: 0, right: 0)
        containerView.addArrangedSubview(lblPodcastTitle)
        containerView.addArrangedSubview(lblPodcastAuthor)
        containerView.backgroundColor = UIColor(named: ColorRes.cell_bgcolor)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imgPodcastView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            lblPodcastTitle.heightAnchor.constraint(equalToConstant: 15),
            lblPodcastAuthor.heightAnchor.constraint(equalToConstant: 16),
            
            containerView.topAnchor.constraint(equalTo: imgPodcastView.bottomAnchor, constant: 15),
        ])
       
    }
    
    @objc func goToShow() {
        self.showDelegate?.goToFeaturedShow(self.showModel)
        
    }
}
