//
//  PodcasterCell.swift
//  jamit
//
//  Created by Prof K on 6/2/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

protocol FollowButtonTapped {
    func btnFollowTapped(_ title: String)
}

class PodcasterCell: UICollectionViewCell {
    
    static let identifier = "PodcasterCell"
    var delegate: FollowButtonTapped?
    
    //MARK: - Image for the collection cell
    let imgPodcaster: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageRes.ic_avatar_48dp)
        view.backgroundColor = getColor(hex: "#828282")
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: "#435543")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Labels in stack view
    
    lazy var lblView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lblPodcasterName: UILabel = {
        let label = UILabel()
        label.text = "Jamit"
        label.font = UIFont(name: "Poppins-Bold", size: 16)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lblAbout: UILabel = {
        let label = UILabel()
        label.text = "About Me"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var btnFollow: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = getColor(hex: "#828282")
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        button.titleLabel?.minimumScaleFactor = 0.2
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellViews()
        contentViewSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deselectedCell()
        imgPodcaster.image = UIImage(named: ImageRes.img_default)
        lblPodcasterName.text = ""
        lblAbout.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followButtonTapped() {
        btnFollow.titleLabel?.minimumScaleFactor = 0.2
        btnFollow.titleLabel?.adjustsFontSizeToFitWidth = true
        let newTitle = btnFollow.titleLabel?.text == "Follow" ? "Unfollow" : "Follow"
        let newColor = btnFollow.titleLabel?.text == "Follow" ? getColor(hex: ColorRes.subscribe_color) : getColor(hex: "#828282")
        let newTitleColor = btnFollow.titleLabel?.text == "Follow" ? getColor(hex: "#FFFFFF") : getColor(hex: "#000000")
        btnFollow.setTitleColor(newTitleColor, for: .normal)
        btnFollow.backgroundColor = newColor
        btnFollow.setTitle(newTitle, for: .normal)
        delegate?.btnFollowTapped(btnFollow.titleLabel?.text ?? "")
    }
    
    fileprivate func setupCellViews() {
//        contentView.cornerRadius = 20
        contentView.addSubview(bgView)
        bgView.pin(to: contentView)
        
        bgView.addSubview(imgPodcaster)
        bgView.addSubview(lblPodcasterName)
        bgView.addSubview(lblAbout)
        bgView.addSubview(btnFollow)
    }
    
    fileprivate func contentViewSetup() {
        imgPodcaster.cornerRadius = 24
        imgPodcaster.clipsToBounds = true
        bgView.cornerRadius = 5
        btnFollow.cornerRadius = 5
        NSLayoutConstraint.activate([
            imgPodcaster.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),
            imgPodcaster.heightAnchor.constraint(equalToConstant: 48),
            imgPodcaster.widthAnchor.constraint(equalToConstant: 48),
            imgPodcaster.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            lblPodcasterName.topAnchor.constraint(equalTo: imgPodcaster.topAnchor),
            lblPodcasterName.leadingAnchor.constraint(equalTo: imgPodcaster.trailingAnchor, constant: 5),
            lblPodcasterName.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.5),
            lblPodcasterName.heightAnchor.constraint(equalTo: bgView.heightAnchor, multiplier: 0.4),
            
            lblAbout.topAnchor.constraint(equalTo: lblPodcasterName.bottomAnchor, constant: 1),
            lblAbout.leadingAnchor.constraint(equalTo: lblPodcasterName.leadingAnchor),
            lblAbout.trailingAnchor.constraint(equalTo: lblPodcasterName.trailingAnchor),
            lblAbout.heightAnchor.constraint(equalTo: bgView.heightAnchor, multiplier: 0.25),
            
            btnFollow.trailingAnchor.constraint(equalTo: bgView.trailingAnchor,constant: -10),
            btnFollow.heightAnchor.constraint(equalTo: bgView.heightAnchor, multiplier: 0.5),
            btnFollow.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            btnFollow.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.2),
        ])
    }
    
    fileprivate func deselectedCell() {
        btnFollow.setTitle("Follow", for: .normal)
        btnFollow.setTitleColor(.black, for: .normal)
        btnFollow.backgroundColor = getColor(hex: "#828282")
    }

}
