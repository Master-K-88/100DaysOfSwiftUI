//
//  LibraryHeader.swift
//  jamit
//  Created by YPY Global on 4/13/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

protocol LibraryDelegate {
    func goToMyDownload()
    func goToMyFavorite()
}
class LibraryHeader: UICollectionReusableView {
    
    @IBOutlet weak var lblMyFavorite: UILabel!
    @IBOutlet weak var lblNumEpisode: UILabel!
    @IBOutlet weak var lblDownload: UILabel!
    @IBOutlet weak var lblMySubscription: UILabel!
    
    var delegate: LibraryDelegate?
    
    override func awakeFromNib() {
        self.lblDownload.text = getString(StringRes.title_downloads)
        self.lblMyFavorite.text = getString(StringRes.title_favorite)
        self.lblMySubscription.text =  getString(SettingManager.isLoginOK() ? StringRes.title_my_subscriptions : StringRes.info_login_get_subscriptions)
    }
    
    func updateInfoDownload(){
        let listFav = TotalDataManager.shared.getListData(IJamitConstants.TYPE_VC_DOWNLOAD)
        let size = listFav?.count ?? 0
        self.lblNumEpisode.text = StringUtils.formatNumberSocial(StringRes.format_episode, StringRes.format_episodes, Int64(size))
    }
    
    @IBAction func downloadTap(_ sender: Any) {
        self.delegate?.goToMyDownload()
    }
    
    @IBAction func favoriteTap(_ sender: Any) {
        self.delegate?.goToMyFavorite()
    }
}
