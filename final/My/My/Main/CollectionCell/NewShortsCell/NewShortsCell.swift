//
//  NewShortsCell.swift
//  jamit
//
//  Created by Prof K on 3/28/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewShortsCell: UICollectionViewCell {
    static let identifier = "NewShortsCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: ColorRes.card_color_past)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblShortInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblDuration: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let btnView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnPlay: UIButton = {
        let button = UIButton()
        button.backgroundColor = getColor(hex: "#FFAE29")
        button.tintColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnMenu: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = getColor(hex: "#FFFFFF")
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var episode: EpisodeModel?
    var listModels: [EpisodeModel]?
    var menuDelegate: MenuEpisodeDelegate?
    var itemDelegate: AppItemDelegate?
    var isMyStories = true
    var typeVC : Int  = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        btnPlay.addTarget(self, action: #selector(btnPlayTapped), for: .touchUpInside)
        btnMenu.addTarget(self, action: #selector(btnMenuTapped), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblShortInfo.text = ""
        lblDuration.text = ""
        deselectedCell()
    }
    private func setUpView() {
        contentView.cornerRadius = 20
        contentView.addSubview(containerView)
        containerView.pin(to: contentView)
//        containerView.cornerRadius = 10
        
        containerView.addSubview(lblShortInfo)
        containerView.addSubview(lblDuration)
        
        contentView.addSubview(btnView)
        btnView.pin(to: contentView, top: 0, left: nil, bottom: 0, right: 0)
        
        btnView.addSubview(btnStackView)
        btnStackView.pin(to: btnView, top: 20, left: nil, bottom: -20, right: -16)
        
        btnStackView.addArrangedSubview(btnPlay)
        btnPlay.cornerRadius = contentView.frame.width * 0.1 * 0.5
        btnStackView.addArrangedSubview(btnMenu)
        btnPlay.layoutIfNeeded()
        setupConstraints()
        deselectedCell()
//        containerView.backgroundColor = getColor(hex: "#1B1C1F")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lblShortInfo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            lblShortInfo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            lblShortInfo.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.75),
            
            lblDuration.topAnchor.constraint(equalTo: lblShortInfo.bottomAnchor, constant: 5),
            lblDuration.leadingAnchor.constraint(equalTo: lblShortInfo.leadingAnchor),
            lblDuration.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            btnPlay.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            btnPlay.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            
            btnMenu.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            btnMenu.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.05),
        ])
    }
    
    @objc func btnPlayTapped(sender: UIButton) {
        print("There is an initial print out")
//        guard let episode = episode else {
//            print("There is a fault here")
//            return
//        }
//
//        print("There is no fault here")
//        let isSelected = StreamManager.shared.isSelectedTrack(episode.id)
//        let isReadyPlay = StreamManager.shared.isMusicReadyPlay()
//        if isSelected && isReadyPlay {
//            print("There is a play here")
//            self.menuDelegate?.onTogglePlay(episode)
//        }
//        else {
//            print("There is no fault here")
//            if self.listModels != nil {
//                self.itemDelegate?.clickItem(list: self.listModels!, model: episode, position: 0)
//            }
//        }
        
    }
    
    @objc func btnMenuTapped(sender: UIButton) {
        guard let episode = episode else {
            return
        }
        self.menuDelegate?.showEpisodeMenu(self.btnMenu, episode, self.typeVC, self.isMyStories)
    }
    
//    func configureView(with model: EpisodeModel) {
//        lblShortInfo.text = model.audioTitle
////        lblDuration.text = model.duration
//        let duration = model.duration
//        if !duration.isEmpty && duration.isNumber() {
//            let intDuration = Int64(duration)!
//            if intDuration < 60 {
//                 self.lblDuration.text = StringUtils.formatNumberSocial(StringRes.format_sec, StringRes.format_secs, intDuration)
//            }
//            else{
//                self.lblDuration.text = StringUtils.formatNumberSocial(StringRes.format_min, StringRes.format_min, intDuration/60)
//            }
//        }
//        else {
//            self.lblDuration.text = duration
//        }
//    }
    
    func selectedCell() {
        contentView.backgroundColor = getColor(hex: ColorRes.color_accent)
        btnPlay.isHidden = true
        lblDuration.textColor = .white
    }
    
    fileprivate func deselectedCell() {
        contentView.backgroundColor = getColor(hex: ColorRes.card_color_past)
        btnPlay.isHidden = false
        lblShortInfo.textColor = UIColor.white
        lblDuration.textColor = .white
    }
    
    func updateUI(_ episode: EpisodeModel){
        self.episode = episode
        lblShortInfo.text = episode.title.shorted(to: 35)
        let duration = episode.duration
        if !duration.isEmpty && duration.isNumber() {
            let intDuration = Int64(duration)!
            if intDuration < 60 {
                 self.lblDuration.text = StringUtils.formatNumberSocial(StringRes.format_sec, StringRes.format_secs, intDuration)
            }
            else{
                self.lblDuration.text = StringUtils.formatNumberSocial(StringRes.format_min, StringRes.format_min, intDuration/60)
            }
        }
        else {
            self.lblDuration.text = duration
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
