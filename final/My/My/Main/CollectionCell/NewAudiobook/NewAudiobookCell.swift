//
//  NewAudiobookCell.swift
//  jamit
//
//  Created by Prof K on 3/22/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewAudiobookCell: UICollectionViewCell {
    static let identifier = "NewAudiobookCell"
    
    private let imgAudiobook: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: ImageRes.img_default)
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let audiobookDetailStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    var audioViewModel: AudiobookViewModel?
//    var showDelegate: FeaturedDelegate?
    var showModel: ShowModel?
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let lblAudiobookTitle: UILabel = {
        let label = UILabel()
        label.text = "The armchair historian"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textAlignment = .natural
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblNumChapter: UILabel = {
        let label = UILabel()
        label.text = "21 Chapters"
        label.textColor = .white
        label.backgroundColor = .clear
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAudiobookCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupAudiobookCellView() {
        contentView.backgroundColor = .black
        imgAudiobook.layer.cornerRadius = 10
        imgAudiobook.clipsToBounds = true
//        audiobookCellListener()
        contentView.addSubview(imgAudiobook)
        imgAudiobook.pin(to: contentView, top: 0, left: 0, bottom: nil, right: 0)
        contentView.addSubview(containerView)
        containerView.pin(to: contentView, top: nil, left: 0, bottom: 0, right: 0)
        containerView.addArrangedSubview(lblAudiobookTitle)
        containerView.addArrangedSubview(lblNumChapter)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imgAudiobook.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.74),
            
            containerView.topAnchor.constraint(equalTo: imgAudiobook.bottomAnchor, constant: 15),
        ])
       
    }
}
