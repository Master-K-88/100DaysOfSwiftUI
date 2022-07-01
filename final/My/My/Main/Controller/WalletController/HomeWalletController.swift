//
//  HomeWalletController.swift
//  jamit
//
//  Created by Prof K on 6/5/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class HomeWalletController: JamitRootViewController {
    
    var parentVC: MainController?
    var dismissDelegate: DismissDelegate?
    
    private let walletData: [WalletData] = [
        WalletData(icon: UIImage(named: "ic_meta_mask") ?? UIImage(), name: "Metamask"),
        WalletData(icon: UIImage(named: "ic_coin_base") ?? UIImage(), name: "Coinbase Wallet"),
        WalletData(icon: UIImage(named: "ic_wallet_connect") ?? UIImage(), name: "WalletConnect")
    ]
    
    private let walletIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_wallet")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose Your Wallet"
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    private let infoLabel: LinkTextView = {
        let label = LinkTextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = getColor(hex: "#101010")
        let tu = "Terms of Service"
        let pp = "Privacy Policy"
        label.text = "By connecting your wallet, you agree to our \(tu) and our \(pp)"
        label.font = UIFont(name: "Poppins-Regular", size: 18)
        label.addLinks([
            tu: "https://some.com/tu",
            pp: "https://some.com/pp"
        ])
        let linkColor = getColor(hex: ColorRes.color_accent)
//        let theAttribute = [NSAttributedString.Key.foregroundColor: linkColor, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        let theAttribute = [NSAttributedString.Key.foregroundColor: linkColor] as [NSAttributedString.Key : Any]
        label.linkTextAttributes = theAttribute
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let walletView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var walletsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = getColor(hex: ColorRes.color_accent)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        button.setTitle("Skip for Now", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.cornerRadius = 12
        return button
    }()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        infoLabel.onLinkTap = { url in
            print("url: \(url)")
            return true
        }
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        view.backgroundColor = getColor(hex: "#101010")
        view.addSubview(walletIcon)
        view.addSubview(optionLabel)
        view.addSubview(infoLabel)
        view.addSubview(walletView)
        view.addSubview(skipButton)
        
        setupConstraints()
        walletsCollectionView.backgroundColor = getColor(hex: "#101010")
        walletsCollectionView.register(WalletCell.self, forCellWithReuseIdentifier: WalletCell.identifier)
        walletView.addSubview(walletsCollectionView)
        walletsCollectionView.pin(to: walletView)
        walletsCollectionView.dataSource = self
        walletsCollectionView.delegate = self
    }
    
    private func setupConstraints() {
        let width = view.bounds.width
        NSLayoutConstraint.activate([
            walletIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            walletIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            walletIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            walletIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            optionLabel.topAnchor.constraint(equalTo: walletIcon.bottomAnchor, constant: 30),
            optionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24),
            optionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24),
            
            infoLabel.topAnchor.constraint(equalTo: optionLabel.bottomAnchor,constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: optionLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: optionLabel.trailingAnchor),
            
            walletView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor,constant: 20),
            walletView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            walletView.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            walletView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            skipButton.topAnchor.constraint(equalTo: walletView.bottomAnchor, constant: 20),
            skipButton.widthAnchor.constraint(equalToConstant: width - 48),
            skipButton.heightAnchor.constraint(equalToConstant: 52),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension HomeWalletController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walletData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = walletsCollectionView.dequeueReusableCell(withReuseIdentifier: WalletCell.identifier, for: indexPath) as? WalletCell else {
            print("This is other collection printed for now")
            return UICollectionViewCell()
        }
        let model = walletData[indexPath.row]
        cell.updateUI(with: model)
        return cell
    }
    
    
}


extension HomeWalletController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width - 48
        return CGSize(width: width, height: width * 0.22)
        }
    
}
