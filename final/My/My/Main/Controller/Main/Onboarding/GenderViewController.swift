//
//  GenderViewController.swift
//  jamit
//
//  Created by Prof K on 5/30/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class GenderViewController: JamitRootViewController {
    
    lazy var scrollContainer: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var genderContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Bold", size: 32)
        label.text = "What’s your gender?"
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.text = "This help us find you more relevant content"
        return label
    }()
    
    lazy var maleSelectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var maleSelectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var maleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.text = "Male"
        return label
    }()
    
    lazy var femaleSelectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var femaleSelectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var femaleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.text = "Female"
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 23
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    func setupView() {
        view.addSubview(scrollContainer)
        scrollContainer.pin(to: view)
        scrollContainer.addSubview(genderContainerView)
        genderContainerView.pin(to: scrollContainer)
        genderContainerView.addSubview(titleLabel)
        genderContainerView.addSubview(infoLabel)
        genderContainerView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(maleSelectionView)
        maleSelectionView.addSubview(maleSelectionImageView)
        maleSelectionView.addSubview(maleLabel)
        contentStackView.addArrangedSubview(femaleSelectionView)
        femaleSelectionView.addSubview(femaleSelectionView)
        femaleSelectionView.addSubview(femaleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: genderContainerView.topAnchor, constant: 128),
            titleLabel.leadingAnchor.constraint(equalTo: genderContainerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: genderContainerView.trailingAnchor, constant: -24),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: genderContainerView.trailingAnchor, constant: -72),
            
            contentStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            maleSelectionImageView.topAnchor.constraint(equalTo: maleSelectionView.topAnchor),
            maleSelectionImageView.leadingAnchor.constraint(equalTo: maleSelectionView.leadingAnchor),
            maleSelectionImageView.trailingAnchor.constraint(equalTo: maleSelectionView.trailingAnchor),
            maleSelectionImageView.heightAnchor.constraint(equalTo: maleSelectionView.heightAnchor, multiplier: 0.8),
            
            maleLabel.bottomAnchor.constraint(equalTo: maleSelectionView.bottomAnchor, constant: -20),
            maleLabel.centerXAnchor.constraint(equalTo: maleSelectionView.centerXAnchor),
            maleSelectionImageView.heightAnchor.constraint(equalTo: maleSelectionView.heightAnchor, multiplier: 0.1),
            
            femaleSelectionImageView.topAnchor.constraint(equalTo: femaleSelectionView.topAnchor),
            femaleSelectionImageView.leadingAnchor.constraint(equalTo: femaleSelectionView.leadingAnchor),
            femaleSelectionImageView.trailingAnchor.constraint(equalTo: femaleSelectionView.trailingAnchor),
            femaleSelectionImageView.heightAnchor.constraint(equalTo: femaleSelectionView.heightAnchor, multiplier: 0.8),
            
            femaleLabel.bottomAnchor.constraint(equalTo: femaleSelectionView.bottomAnchor, constant: -20),
            femaleLabel.centerXAnchor.constraint(equalTo: femaleSelectionView.centerXAnchor),
            femaleSelectionImageView.heightAnchor.constraint(equalTo: femaleSelectionView.heightAnchor, multiplier: 0.1),
            
            
        ])
    }
    
    func configurVC(with data: [String]) {
        
    }

}
