//
//  TrendingNowCell.swift
//  jamit
//
//  Created by Prof K on 3/11/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit
import Kingfisher

protocol MenuEpisodeDelegate {
    func showEpisodeMenu(_ view: UIView,_ model: EpisodeModel, _ typeVC: Int, _ isFromMyStories : Bool)
    func onTogglePlay(_ model: EpisodeModel)
    func onFollowTap(_ model: EpisodeModel)
}

protocol GoToShowDelegate {
    func goToShowOf(_ model: EpisodeModel)
    
}

class NewEpisodeFlatListCell: UICollectionViewCell {
    //MARK: - Indetifier for the collection cell
    static let identifier = "NewEpisodeFlatListCell"
    
    var episode: EpisodeModel!
    
    var menuDelegate: MenuEpisodeDelegate?
    var listModels: [EpisodeModel]?
    var itemDelegate: AppItemDelegate?
    var showDelegate: GoToShowDelegate?
    var typeVC : Int  = 0
    
    var isUserStories = false
    var isMyStories = false
    
    //MARK: - Stack view for all component within the cell
    let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 20
        view.alignment = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Image for the collection cell
    let imgEpisode: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageRes.img_default)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Labels in stack view
    
    let lblView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.text = "Default Title"
        label.font = UIFont(name: "Poppins-Bold", size: 16)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblAuthorName: UILabel = {
        let label = UILabel()
        label.text = "Default Author"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Buttons in stack view
    
    let btnView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.contentMode = .scaleAspectFill
        view.alignment = .center
        view.spacing = -5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnPlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnPlay: UIButton = {
        let button = UIButton()
        button.backgroundColor = getColor(hex: ColorRes.color_accent)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnMenu: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var btnPlaySelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellViews()
        
        contentViewSetup()
        imgEpisode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToShow)))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deselectedCell()
        lblTitle.text = ""
        lblAuthorName.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func selectedCell() {
        contentView.backgroundColor = getColor(hex: ColorRes.color_accent)
        btnPlay.isHidden = true
        lblTitle.textColor = UIColor.black
        lblAuthorName.textColor = .black
    }
    
    fileprivate func deselectedCell() {
        contentView.backgroundColor = UIColor(named: ColorRes.cell_bgcolor)
        btnPlay.isHidden = false
        lblTitle.textColor = UIColor.label
        lblAuthorName.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        btnPlay.addTarget(self, action: #selector(btnPlayTapped), for: .touchUpInside)
        btnMenu.addTarget(self, action: #selector(btnMenuTapped), for: .touchUpInside)
    }
    
    @objc func btnPlayTapped(sender: UIButton) {
        let isSelected = StreamManager.shared.isSelectedTrack(episode.id)
        let isReadyPlay = StreamManager.shared.isMusicReadyPlay()
        if isSelected && isReadyPlay {
            self.menuDelegate?.onTogglePlay(episode)
        }
        else{
            if self.listModels != nil {
                self.itemDelegate?.clickItem(list: self.listModels!, model: episode, position: 0)
            }
        }
        
    }
    
    @objc func btnMenuTapped(sender: UIButton) {        self.menuDelegate?.showEpisodeMenu(self.btnMenu, self.episode,self.typeVC,self.isMyStories)
    }
    
    @objc func goToShow() {
        self.showDelegate?.goToShowOf(self.episode)
    }
    
    fileprivate func setupCellViews() {
        contentView.cornerRadius = 20
        btnPlay.cornerRadius = ((contentView.frame.height - 20) * 0.4) / 2
        imgEpisode.layer.cornerRadius = 10
        imgEpisode.clipsToBounds = true

        btnPlay.imageView?.contentMode = .scaleAspectFit
        
        contentView.backgroundColor = getColor(hex: "1B1C1F")
        
        contentView.addSubview(containerView)
        containerView.pin(to: contentView, top: 10, left: 10, bottom: -10, right: 0)
        containerView.addArrangedSubview(imgEpisode)
        containerView.addArrangedSubview(lblView)
        lblView.addSubview(lblTitle)
        lblView.addSubview(lblAuthorName)
        containerView.addArrangedSubview(btnView)
        btnView.addArrangedSubview(btnPlayView)
        btnPlayView.addSubview(btnPlay)
        btnPlay.pin(to: btnPlayView)
        btnView.addArrangedSubview(btnMenu)
        containerView.backgroundColor = .clear
    }
    
    fileprivate func contentViewSetup() {
        let width = contentView.bounds.width
        print("The width of the screen is \(width)")
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imgEpisode.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0),
            imgEpisode.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0),
            imgEpisode.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 0),
            imgEpisode.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            btnView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.9),
            btnView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: width * 0.04),
//            btnPlayView.trailingAnchor.constraint(equalTo: btnView.trailingAnchor, constant: -8),
            btnView.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.56),
            
            btnPlay.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.09),
            btnPlay.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.09),
//            btnPlay.widthAnchor.constraint(equalTo: btnPlay.heightAnchor, multiplier: 1),
            
            lblTitle.topAnchor.constraint(equalTo: lblView.topAnchor, constant: 0),
            lblTitle.leadingAnchor.constraint(equalTo: lblView.leadingAnchor, constant: width * 0.015),
            lblTitle.trailingAnchor.constraint(equalTo: lblView.trailingAnchor, constant: -width * 0.013),
            lblTitle.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.75),
            
            lblAuthorName.bottomAnchor.constraint(equalTo: lblView.bottomAnchor, constant: width * 0.01),
            lblAuthorName.trailingAnchor.constraint(equalTo: lblView.trailingAnchor, constant: -width * 0.013),
            lblAuthorName.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lblView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.55),
            lblView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.0)
        ])
    }
    
    func updateUI(_ episode: EpisodeModel){
        self.episode = episode
        lblTitle.text = episode.title.shorted(to: 40)
        lblAuthorName.text = episode.getAuthor().shorted(to: 20)
        let imgItem = episode.imageUrl
        if !imgItem.isEmpty && imgItem.starts(with: "http") {
            imgEpisode.kf.setImage(with: URL(string: imgItem), placeholder:  UIImage(named: ImageRes.img_default))
        }
        else{
            imgEpisode.image = UIImage(named: ImageRes.img_default)
        }
        
        let isSelected = StreamManager.shared.isSelectedTrack(episode.id)
        let isPlaying = StreamManager.shared.isPlaying()
        self.updateSelected(isSelected)
        self.updateState(isSelected && isPlaying)
    }
    
    func updateSelected (_ isSelected: Bool) {
        isSelected ? selectedCell() : deselectedCell()
    }
    
    func updateState(_ isPlay: Bool) {
        isPlay ? selectedCell() : deselectedCell()
    }
    
}
