//
//  NewEventCell.swift
//  jamit
//
//  Created by Prof K on 3/14/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewEventCell: UICollectionViewCell {
    static let identifier = "NewEventCell"
    
    //MARK: - Container view for the cell
    let containerView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Upper part of the cell
    let upperView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lower part of the cell
    let lowerView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Content of the upper part of the cell
    let imgHostUser1: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: ImageRes.img_default)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblEventTitle: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.textColor = getColor(hex: "#B7B7BC")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblEventTopic: UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnMore: UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .white
//        button.setImage(UIImage(named: "ic_more_vert_white_36dp"), for: .normal)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Content of the lower part of the cell
    
    
    // Images in stack view
    let imgStackView: UIStackView = {
       let view = UIStackView()
        view .spacing = -10
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgHost1: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "ic_avatar_48dp")
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgHost2: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "ic_avatar_48dp")
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgHost3: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "ic_avatar_48dp")
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // stack view for number of people in the event
    
    let infoEventStack: UIStackView = {
       let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstInfoView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = getColor(hex: "#000000")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // statck view of the first infon view
    
    let firstInfoContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.backgroundColor = .clear
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstInfoImg: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .clear
        image.image = UIImage(named: "ic_user_white_24dp")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let firstInfoLabel: UILabel = {
       let label = UILabel()
        label.text = "155"
        label.backgroundColor = .clear
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // second info with stack view
    let secondInfoView: UIView = {
       let view = UIView()
        view.cornerRadius = 10
        view.backgroundColor = getColor(hex: "#000000")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondInfoContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.backgroundColor = .clear
        view.alignment = .center
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let secondInfoImg: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .clear
        image.tintColor = .white
        image.image = UIImage(systemName: "message.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let secondInfoLabel: UILabel = {
       let label = UILabel()
        label.text = "589"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Stack view for guest users
    
    let usersStackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstUserInfo: UILabel = {
       let label = UILabel()
        label.text = "Lena Marsh 💬"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondUserInfo: UILabel = {
       let label = UILabel()
        label.text = "Minerva Spencer 💬"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Dashed Line
    let dashLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var event: EventModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPodcastCellView()
        setupConstraints()
        let pointX = contentView.frame.size.width - 20
        let pointY = contentView.frame.size.height * 0.37
        createDashedLine(from: CGPoint(x: 20, y: pointY), to: CGPoint(x: pointX, y: pointY), view: contentView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupPodcastCellView()
        setupConstraints()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgHost1.isHidden = true
        imgHost2.isHidden = true
        imgHost3.isHidden = true
        lblEventTitle.text = ""
        lblEventTopic.text = ""
        firstInfoLabel.text = ""
        secondInfoLabel.text = "\(0)"
        firstUserInfo.text = ""
        secondUserInfo.text = ""
    }
    
    fileprivate func setupPodcastCellView() {
        contentView.backgroundColor = getColor(hex: "#1B1C1F")
        contentView.cornerRadius = 20
        firstInfoContentView.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.pin(to: contentView)
        
//        containerView.addArrangedSubview(imgPodcastView)
//        ic_avatar_48dp for blank images
        
        imgHost3.layer.cornerRadius = contentView.layer.frame.size.height * 0.078
        imgHost3.clipsToBounds = true
        
        imgHost2.layer.cornerRadius = contentView.layer.frame.size.height * 0.078
        imgHost2.clipsToBounds = true
        
        imgHost1.layer.cornerRadius = contentView.layer.frame.size.height * 0.078
        imgHost1.clipsToBounds = true
        
        
        containerView.addArrangedSubview(upperView)
        upperView.addSubview(lblEventTitle)
        upperView.addSubview(lblEventTopic)
        upperView.addSubview(dashLineView)
        upperView.addSubview(btnMore)
        containerView.addArrangedSubview(lowerView)
        
        lowerView.addSubview(imgStackView)
        imgStackView.addArrangedSubview(imgHost1)
        imgStackView.addArrangedSubview(imgHost2)
        imgStackView.addArrangedSubview(imgHost3)
        
        imgStackView.semanticContentAttribute = .forceRightToLeft
        
        lowerView.addSubview(infoEventStack)
        infoEventStack.addArrangedSubview(firstInfoView)
        infoEventStack.addArrangedSubview(secondInfoView)
        
        firstInfoView.addSubview(firstInfoContentView)
        firstInfoContentView.pin(to: firstInfoView, top: 5, left: 10, bottom: -5, right: -10)
        firstInfoContentView.addArrangedSubview(firstInfoImg)
        firstInfoContentView.addArrangedSubview(firstInfoLabel)
        
        secondInfoView.addSubview(secondInfoContentView)
        secondInfoContentView.pin(to: secondInfoView, top: 5, left: 10, bottom: -5, right: -10)
        secondInfoContentView.addArrangedSubview(secondInfoImg)
        secondInfoContentView.addArrangedSubview(secondInfoLabel)
        
        lowerView.addSubview(usersStackView)
        usersStackView.addArrangedSubview(firstUserInfo)
        usersStackView.addArrangedSubview(secondUserInfo)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            upperView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4),
            lowerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            lblEventTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            lblEventTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lblEventTitle.heightAnchor.constraint(equalTo: upperView.heightAnchor, multiplier: 0.3),
            
            lblEventTopic.topAnchor.constraint(equalTo: lblEventTitle.bottomAnchor),
            lblEventTopic.leadingAnchor.constraint(equalTo: lblEventTitle.leadingAnchor),
            lblEventTopic.heightAnchor.constraint(equalTo: upperView.heightAnchor, multiplier: 0.35),
            
            btnMore.topAnchor.constraint(equalTo: lblEventTitle.topAnchor),
            btnMore.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            btnMore.heightAnchor.constraint(equalTo: upperView.heightAnchor, multiplier: 0.2),
            
            imgStackView.topAnchor.constraint(equalTo: lowerView.topAnchor, constant: 20),
            imgStackView.leadingAnchor.constraint(equalTo: lblEventTitle.leadingAnchor),
            
            imgHost1.heightAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.3),
            imgHost1.widthAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.3),
            
            firstInfoView.heightAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.25),
            firstInfoView.topAnchor.constraint(equalTo: imgStackView.bottomAnchor, constant: 12),
            firstInfoView.widthAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.65),
            firstInfoView.leadingAnchor.constraint(equalTo: imgStackView.leadingAnchor),
            
            firstInfoImg.heightAnchor.constraint(equalTo: firstInfoContentView.heightAnchor, multiplier: 1.0),
            firstInfoImg.widthAnchor.constraint(equalTo: firstInfoContentView.heightAnchor, multiplier: 1.0),
//            firstInfoLabel.widthAnchor.constraint(equalTo: firstInfoContentView.heightAnchor, multiplier: 1.0),
            
            secondInfoView.heightAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.25),
            secondInfoView.topAnchor.constraint(equalTo: imgStackView.bottomAnchor, constant: 12),
            secondInfoView.widthAnchor.constraint(equalTo: lowerView.heightAnchor, multiplier: 0.65),
            
            secondInfoImg.heightAnchor.constraint(equalTo: secondInfoContentView.heightAnchor, multiplier: 0.8),
            secondInfoImg.widthAnchor.constraint(equalTo: secondInfoContentView.heightAnchor, multiplier: 0.8),
//            secondInfoLabel.widthAnchor.constraint(equalTo: secondInfoContentView.heightAnchor, multiplier: 0.8),
            
            usersStackView.topAnchor.constraint(equalTo: imgStackView.topAnchor),
            usersStackView.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor, constant: -20)
            
        ])
       
    }
    
    func configure(with model: EventModel) {
        imgHost1.isHidden = true
        imgHost2.isHidden = true
        imgHost3.isHidden = true
        lblEventTitle.text = model.title
        lblEventTopic.text = model.getTopic()
        firstInfoLabel.text = "\(model.speakers?.count ?? 0 + Int(model.numListeners))"
        secondInfoLabel.text = "\(0)"
        firstUserInfo.text = ""
        secondUserInfo.text = ""
        guard let avatar = model.host?.avatar else {
            return
        }
        imgHost1.isHidden = false
        self.imgHost1.kf.setImage(with: URL(string: avatar), placeholder: UIImage(named: ImageRes.img_default))
    }
}
