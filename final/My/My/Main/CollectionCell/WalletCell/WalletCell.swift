//
//  WalletCell.swift
//  jamit
//
//  Created by Prof K on 6/5/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class WalletCell: UICollectionViewCell {
    
    static let identifier = "WalletCell"
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: "#101010")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let walletIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let walletName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Bold", size: 20)
        return label
    }()
    
    private let walletForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_arrow_right_grey_24dp"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let walletBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        contentView.addSubview(bgView)
        bgView.pin(to: contentView)
        bgView.addSubview(walletIcon)
        bgView.addSubview(walletName)
        bgView.addSubview(walletForwardButton)
        bgView.addSubview(walletBottomLine)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            walletIcon.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 0),
            walletIcon.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            walletIcon.widthAnchor.constraint(equalToConstant: 30),
            walletIcon.heightAnchor.constraint(equalToConstant: 30),
            
            walletName.leadingAnchor.constraint(equalTo: walletIcon.trailingAnchor, constant: 20),
            walletName.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            walletForwardButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1),
            walletForwardButton.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            walletForwardButton.widthAnchor.constraint(equalToConstant: 20),
            walletForwardButton.heightAnchor.constraint(equalToConstant: 20),
            
            walletBottomLine.bottomAnchor.constraint(equalTo: bgView.bottomAnchor),
            walletBottomLine.heightAnchor.constraint(equalToConstant: 2),
            walletBottomLine.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            walletBottomLine.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            
        ])
    }
    
    func updateUI(with data: WalletData) {
        walletIcon.image = data.icon
        walletName.text = data.name
    }
}
