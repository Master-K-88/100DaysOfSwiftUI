//
//  IAPListCell.swift
//  iLandMusic
//
//  Created by iLandMusic on 9/21/19.
//  Copyright © 2019 iLandMusic. All rights reserved.
//

import Foundation
import UIKit

protocol IAPItemClickDelegate {
    func onViewDetail(_ model: PremiumModel)
}

class IAPListCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInfo1: UILabel!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var lblInfo2: UILabel!
    
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgChecked: UIImageView!
    
    private let purchasedColor = getColor(hex: ColorRes.purchase_color)
    private let purchasedSecondColor = getColor(hex: ColorRes.purchase_second_color)
    
    private let buyingTextColor = getColor(hex: ColorRes.list_view_color_main_text)
    private let buyingTextSecondColor = getColor(hex: ColorRes.list_view_color_second_text)
    
    private let skipColor = getColor(hex: ColorRes.skip_color)
    private let buyColor = getColor(hex: ColorRes.buy_color)
    
    var itemCellDelegate : IAPItemClickDelegate?
    var model: PremiumModel?

    override func awakeFromNib() {
        self.lblInfo2.text = getString(StringRes.info_listen_premium)
    }
    
    @IBAction func buyNowTap(_ sender: Any) {
        if self.itemCellDelegate != nil {
            self.itemCellDelegate!.onViewDetail(self.model!)
        }
    }
    
    func updateUI(_ premiumModel: PremiumModel) {
        self.model = premiumModel
        let currentMemberId = MemberShipManager.shared.getIdMember()
        if premiumModel.id == currentMemberId && currentMemberId > 0 {
            self.lblTitle.text = String(format: getString(StringRes.format_info_member), premiumModel.name)
            self.lblInfo1!.text = String(format: getString(StringRes.format_removed_ads), premiumModel.duration)
        }
        else{
            self.lblTitle.text = premiumModel.name
            self.lblInfo1!.text = String(format: getString(StringRes.format_remove_ads), premiumModel.duration)
            
        }
        let statusBtn = premiumModel.price + "\nper " + premiumModel.duration
        self.lblPrice.text = statusBtn
        //self.btnBuy.setTitle(premiumModel.labelBtnBuy.uppercased(), for: .normal)
        self.imgView!.image = UIImage(named: premiumModel.img)
        
        let status = premiumModel.statusBtn
        if status == PremiumModel.STATUS_BTN_PURCHASED {
            self.rootView.alpha = 1.0
            self.lblTitle.textColor = self.purchasedColor
            self.lblInfo1.textColor = self.purchasedSecondColor
            self.lblInfo2.textColor = self.purchasedSecondColor
            self.btnBuy.backgroundColor = self.purchasedColor
            self.imgChecked.isHidden = false
            self.lblPrice.isHidden = true
        }
        else if status == PremiumModel.STATUS_BTN_SKIP {
            self.rootView.alpha = 0.6
            self.lblTitle.textColor = self.purchasedColor
            self.lblInfo1.textColor = self.purchasedSecondColor
            self.lblInfo2.textColor = self.purchasedSecondColor
            self.btnBuy.backgroundColor = self.skipColor
            self.imgChecked.isHidden = true
            self.lblPrice.isHidden = true
        }
        else if status == PremiumModel.STATUS_BTN_BUY {
            self.rootView.alpha = 1.0
            self.lblTitle.textColor = self.buyingTextColor
            self.lblInfo1.textColor = self.buyingTextSecondColor
            self.lblInfo2.textColor = self.buyingTextSecondColor
            self.btnBuy.backgroundColor = self.buyColor
            self.imgChecked.isHidden = true
            self.lblPrice.isHidden = false
        }
    }
}
