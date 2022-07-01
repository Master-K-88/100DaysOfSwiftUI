//
//  LiveUserCell.swift
//  jamit
//
//  Created by Prof K on 5/4/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewLiveUserCell: UICollectionViewCell {
    
    static let identifier = "NewLiveUserCell"
    
    var viewModel: TrendingUsersViewModel?
    var model: UserModel!
    
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgUser: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageRes.ic_avatar_48dp)
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectedUser: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageRes.ic_check_white_36dp)
        view.backgroundColor = getColor(hex: "#B2DABB")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblUserName: UILabel = {
        let label = UILabel()
        label.text = "Testing Live test"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Regular", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        listeners()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgUser.image = UIImage(named: ImageRes.ic_avatar_48dp)
        lblUserName.text = nil
        
    }
    
    fileprivate func setupUserCellView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.pin(to: contentView)
        containerView.addArrangedSubview(imgUser)
        containerView.addSubview(selectedUser)
        containerView.addArrangedSubview(lblUserName)
    }
    
    private func listeners() {
        viewModel?.kingFisherCompletion = { [weak self] img, defaultImg in
            DispatchQueue.main.async {
                self?.imgUser.kf.setImage(with: URL(string: img), placeholder:  UIImage(named: defaultImg))
            }
        }
        
        viewModel?.defaultImage = { [weak self] defaultImg in
            DispatchQueue.main.async {
                self?.imgUser.image = UIImage(named: defaultImg)
            }
        }
        
        viewModel?.userName = { [weak self] username in
            DispatchQueue.main.async {
                self?.lblUserName.text = username
            }
        }
    }
    
    func populateUserInfo(with model: UserModel) {
        DispatchQueue.main.async {
            self.lblUserName.text = model.username
        }
        let avatar = model.avatar
        if avatar.starts(with: "http") {
            DispatchQueue.main.async {
                self.imgUser.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            }
        }
        else {
            imgUser.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
    }
    
    private func setupConstraints() {
        
        imgUser.layer.cornerRadius = contentView.frame.size.height * 0.35
        imgUser.clipsToBounds = true
        
        selectedUser.layer.cornerRadius = 7
        selectedUser.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imgUser.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            imgUser.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            imgUser.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 0),
            
            selectedUser.topAnchor.constraint(equalTo: imgUser.topAnchor, constant: 5),
            selectedUser.trailingAnchor.constraint(equalTo: imgUser.trailingAnchor, constant: 7),
            selectedUser.heightAnchor.constraint(equalToConstant: 14),
            selectedUser.widthAnchor.constraint(equalToConstant: 14),
        ])
       
    }
    
}

