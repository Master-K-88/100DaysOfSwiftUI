//
//  RaiseHandController.swift
//  jamit
//
//  Created by Prof K on 4/29/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class RaiseHandController: JamitRootViewController {

    private let nevermindButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEVER MIND", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        button.setTitleColor(getColor(hex: "#B7B7BC"), for: .normal)
//        button.borderWidth = 1
//        button.borderColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var dismissDelegate: LiveEventController?
    
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = getColor(hex: "#171717")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgHandRaised: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageRes.ic_raise_hand)
//        imageView.tintColor = getColor(hex: "#ffae29")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let handLabel: UILabel = {
        let label = UILabel()
        label.text = "Raise your hand?"
        label.font = UIFont(name: "Poppins-Medium", size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let handInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "This will let the speakers know you have something you'd like to say?"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let raiseHandButton: UIButton = {
        let button = UIButton()
        button.setTitle("Raise hand", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 18)
        button.backgroundColor = getColor(hex: "#FFAE29")
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.borderWidth = 1
//        button.borderColor = .gray
        return button
    }()
    var nevermindLine: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: "#B7B7BC")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nevermindButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        raiseHandButton.cornerRadius = 12
        view.backgroundColor = .clear
//        print("This is raise hand 🖐")
        setupView()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        view.addSubview(bgView)
        bgView.pin(to: view)
        view.addSubview(contentView)
        contentView.addSubview(imgHandRaised)
        contentView.addSubview(handInfoLabel)
        contentView.addSubview(nevermindButton)
        contentView.addSubview(handLabel)
        nevermindButton.addSubview(nevermindLine)
        contentView.addSubview(raiseHandButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.52),
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.5),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imgHandRaised.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgHandRaised.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imgHandRaised.heightAnchor.constraint(equalToConstant: 60),
            imgHandRaised.widthAnchor.constraint(equalToConstant: 60),
            
            handInfoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            handInfoLabel.topAnchor.constraint(equalTo: handLabel.bottomAnchor, constant: 9),
            handInfoLabel.widthAnchor.constraint(equalToConstant: 276),
            
            handLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            handLabel.topAnchor.constraint(equalTo: imgHandRaised.bottomAnchor, constant: 20),
            
            raiseHandButton.topAnchor.constraint(equalTo: handInfoLabel.bottomAnchor, constant: 30),
            raiseHandButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            raiseHandButton.heightAnchor.constraint(equalToConstant: 56),
            raiseHandButton.widthAnchor.constraint(equalToConstant: 182),
            
            nevermindButton.topAnchor.constraint(equalTo: raiseHandButton.bottomAnchor, constant: 24),
            nevermindButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nevermindButton.heightAnchor.constraint(equalToConstant: 21),
            nevermindButton.widthAnchor.constraint(equalToConstant: 84),
            
            nevermindLine.bottomAnchor.constraint(equalTo: nevermindButton.bottomAnchor, constant: -2),
            nevermindLine.leadingAnchor.constraint(equalTo: nevermindButton.leadingAnchor),
            nevermindLine.trailingAnchor.constraint(equalTo: nevermindButton.trailingAnchor),
            nevermindLine.heightAnchor.constraint(equalToConstant: 1),
            
            
        ])
    }
    
    @objc func removeInviteScreen() {
//        removeView()
        print("Tapped inside the view")
    }
    
    func removeView() {
        self.hideVirtualKeyboard()
        self.unregisterTapOutSideRecognizer()
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(removeInviteScreen))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        self.contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.contentView) else { return }
        if !view.frame.contains(location) {
            removeView()
        } else {
            print("Tapped inside the view")
        }
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
//        self.isDestroy = true
        self.view.removeFromSuperview()
        self.dismissDelegate?.dismiss(controller: self)
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
}

extension RaiseHandController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
