//
//  RadioFlatListCell.swift
//  Created by YPY Global on 12/21/18.
//  Copyright © 2018 YPY Global. All rights reserved.
//

import UIKit
import MarqueeLabel

//protocol MenuEpisodeDelegate {
//    func showEpisodeMenu(_ view: UIView,_ model: EpisodeModel, _ typeVC: Int, _ isFromMyStories : Bool)
//    func onTogglePlay(_ model: EpisodeModel)
//    func onFollowTap(_ model: EpisodeModel)
//}
//
//protocol GoToShowDelegate {
//    func goToShowOf(_ model: EpisodeModel)
//}

class EpisodeFlatListCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: MarqueeLabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblCreatedData: UILabel!
    
    @IBOutlet weak var imgDuration: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var rootLayout: UIView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var imgPremium: UILabel!
    
    private var colorSelected = getColor(hex: ColorRes.color_accent)
    private var colorTextHeader = getColor(hex: ColorRes.list_view_color_main_text)
    private var colorTextAuthor = getColor(hex: ColorRes.list_view_color_author_text)
    private var colorTextSecond = getColor(hex: ColorRes.list_view_color_second_text)
    
    var episode: EpisodeModel!
    var menuDelegate: MenuEpisodeDelegate?
    var listModels: [EpisodeModel]?
    var itemDelegate: AppItemDelegate?
    var showDelegage: GoToShowDelegate?
    var typeVC : Int  = 0
    
    var isUserStories = false
    var isMyStories = false
    
    override func awakeFromNib() {
        self.imgMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuTap)))
        self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePlayTap)))
        self.img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToShow)))
    }
    
    @objc func togglePlayTap(){
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
    
    @objc func menuTap(){
        JamitLog.logE("====>clgt=\(String(describing: menuDelegate))")
        self.menuDelegate?.showEpisodeMenu(self.imgMenu, self.episode,self.typeVC,self.isMyStories)
    }
    
    @objc func goToShow(){
        self.showDelegage?.goToShowOf(self.episode)
    }
    
    func updateUI(_ episode: EpisodeModel){
        self.episode = episode
        let imgItem = episode.imageUrl
        if !imgItem.isEmpty && imgItem.starts(with: "http") {
            img.kf.setImage(with: URL(string: imgItem), placeholder:  UIImage(named: ImageRes.img_default))
        }
        else{
            img.image = UIImage(named: ImageRes.img_default)
        }
        lblName.text = episode.title
        lblAuthor.text = episode.getAuthor()
        self.imgPremium.isHidden = !episode.isPremium
        
        let timeAgo = episode.getStrTimeAgo()
        self.lblCreatedData.text = timeAgo
        self.lblCreatedData.isHidden = timeAgo.isEmpty
        
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
        self.lblName.textColor = isSelected ? colorSelected : colorTextHeader
        self.lblAuthor.textColor = isSelected ? colorSelected : colorTextAuthor
        self.lblDuration.textColor = isSelected ? colorSelected : colorTextSecond
        self.lblCreatedData.textColor = isSelected ? colorSelected : colorTextSecond
        self.imgMenu.tintColor = isSelected ? colorSelected : colorTextSecond
        self.imgDuration.tintColor = isSelected ? colorSelected : colorTextSecond
        self.imgPlay.tintColor = isSelected ? colorSelected : colorTextAuthor
    }
    
    func updateState(_ isPlay: Bool) {
        self.imgPlay.image = UIImage(named: isPlay ? ImageRes.ic_pause_outline_48dp : ImageRes.ic_play_outline_48dp)
    }
}

