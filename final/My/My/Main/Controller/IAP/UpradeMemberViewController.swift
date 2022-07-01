//
//  UpradeMemberViewController.swift
//  Radio PL
//  Created by YPY Global on 9/20/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit
import StoreKit

class UpradeMemberViewController: JamitRootViewController {
    
    private let mainColor = getColor(hex: ColorRes.main_second_text_color)
    private let mainSecondColor = getColor(hex: ColorRes.main_second_text_color)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var paddingInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    private var listModels: [PremiumModel] = []
    private var listSKProducts: Set<SKProduct>?
    
    @IBOutlet weak var lblEulaInfo: UILabel!
   
    override func setUpUI() {
        super.setUpUI()
   
        self.setUpCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseSuccess(notification:)), name: NSNotification.Name(rawValue: MemberShipManager.BROADCAST_PURCHASE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseFailed(notification:)), name: NSNotification.Name(rawValue: MemberShipManager.BROADCAST_PURCHASE_FAIL), object: nil)
        
        //load product information
        self.loadProductInfo()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpTermAndPolicy()
    }
    
    func setUpTermAndPolicy(){
        let colorAccent = getColor(hex: ColorRes.buy_color)

        let colorNormal = getColor(hex: ColorRes.main_second_text_color)

        let termOfUse = getString(StringRes.title_term_of_use)
        let privacyPolicy = getString(StringRes.title_privacy_policy)

        //set up info term of use and privacy policy
        let infoText = String.init(format: getString(StringRes.format_eula),termOfUse,privacyPolicy)

        let boldFont = UIFont(name: IJamitConstants.FONT_SEMI_BOLD, size: DimenRes.text_size_subhead) ?? UIFont.systemFont(ofSize: DimenRes.text_size_subhead)
        let boldColor = colorAccent

        let normalFont = UIFont(name: IJamitConstants.FONT_NORMAL, size: DimenRes.text_size_body) ?? UIFont.systemFont(ofSize: DimenRes.text_size_body)

        let infoHtmlString = String.format(strings: [termOfUse,privacyPolicy], boldFont: boldFont, boldColor: boldColor, inString: infoText, font: normalFont, color: colorNormal)

        self.lblEulaInfo.attributedText = infoHtmlString
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        self.lblEulaInfo.addGestureRecognizer(tap)
        self.lblEulaInfo.isUserInteractionEnabled = true
        
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let termOfUse = getString(StringRes.title_term_of_use) + "      "
        let privacyPolicy = getString(StringRes.title_privacy_policy)
        
        let termString = String.init(format: getString(StringRes.format_eula),termOfUse,privacyPolicy) as NSString

        let termRange = termString.range(of: termOfUse)
        let policyRange = termString.range(of: privacyPolicy)
        
        let tapLocation = gesture.location(in: self.lblEulaInfo)
        let index = self.lblEulaInfo.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if checkRange(termRange, contain: index){
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_TERM_OF_USE)
            return
        }
        if checkRange(policyRange, contain: index) {
            ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_PRIVACY_POLICY)
            return
        }
    }
     
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    
    private func setUpCollectionView(){
         let idCell: String = String(describing: IAPListCell.self)
         self.collectionView.register(UINib(nibName: idCell, bundle: nil), forCellWithReuseIdentifier: idCell)
    }
    
    private func loadProductInfo(){
        self.collectionView.isHidden = true
        self.showProgress()
        let count = StringRes.array_product_ids.count
        var productIds: Set<String> = []
        for i in 0..<count {
            let productId = getString(StringRes.array_product_ids[i])
            JamitLog.logE("====>productId="+productId)
            productIds.insert(productId)
        }
        JamitLog.logE("====>productIds=\(productIds)")
        SwiftyStoreKit.retrieveProductsInfo(productIds, completion: { result in
            DispatchQueue.main.async {
                self.dismissProgress()
                guard result.retrievedProducts.count > 0 else {
                    self.initIAPModel()
                    return
                }
                self.listSKProducts = result.retrievedProducts
                self.initIAPModel()
            }
        })
    }
    
    
    private func initIAPModel() {
        let count = MemberShipManager.TYPE_MEMBERS.count
        let memberId = MemberShipManager.shared.getIdMember()
        let isPremimum = MemberShipManager.shared.isPremiumMember()
        for i in 0..<count {
            let productId = getString(StringRes.array_product_ids[i])
            
            let id = MemberShipManager.TYPE_MEMBERS[i]
            let member = getString(StringRes.array_members[i])
            let img = ImageRes.img_members[i]
            
            let price = getString(StringRes.array_prices[i])
            let time = getString(StringRes.array_date_times[i])
            let model = PremiumModel(id,member,img,productId)
            
            model.labelBtnBuy = getString(StringRes.title_buy_now)
            model.price = price
            model.duration = time
            
            let skuDetails = getSkuDetails(productId)
            if skuDetails != nil{
                if skuDetails!.localizedPrice != nil && !skuDetails!.localizedPrice!.isEmpty {
                    model.price = skuDetails!.localizedPrice!
                }
            }
            if isPremimum {
                self.updateInfoMemberId(model, memberId)
            }
            self.listModels.append(model)
        }
        self.collectionView.isHidden = false
        self.collectionView.reloadData()
    }
  
    func getSkuDetails(_ productId: String) -> SKProduct?{
        if self.listSKProducts != nil {
            for product in self.listSKProducts! {
                if product.productIdentifier.elementsEqual(productId){
                    return product
                }
            }
        }
        return nil
    }
  
    
    func updateInfoMemberId(_ model: PremiumModel, _ memberId: Int) {
        let currentMember = Int(model.id)
        if currentMember < memberId {
            model.labelBtnBuy = getString(StringRes.title_skip)
            model.statusBtn = PremiumModel.STATUS_BTN_SKIP
        }
        else if currentMember > memberId {
            model.labelBtnBuy = getString(StringRes.title_buy_now)
            model.statusBtn = PremiumModel.STATUS_BTN_BUY
        }
        else {
            model.labelBtnBuy = ""
            model.statusBtn = PremiumModel.STATUS_BTN_PURCHASED
        }
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.backToHome()
    }
    
    private func backToHome() {
        self.dismissDetail()
        NotificationCenter.default.removeObserver(self)
    }
        
    @IBAction func restoreTap(_ sender: Any) {
        self.restorePurchase()
    }
    
    private func restorePurchase(){
        self.collectionView.isHidden = true
        self.showProgress()
        
        //check receipt info before doing another
        StoreKitManager.shared.checkReceiptInfo(sharedSecret: IJamitConstants.IAP_SHARE_SECRET
            , completion: { (receiptInfo) in
                self.dismissProgress()
                self.checkRestoreModel(receiptInfo)
        }, error: {(msg) in
            self.dismissProgress()
            self.showAlertWith(title: getString(StringRes.title_information), message: msg, positive: getString(StringRes.title_cancel), completion: {
                //back the main screen
                self.backToHome()
            })
        })
    }
    
    private func checkRestoreModel(_ receiptInfo: ReceiptInfo){
        if self.listModels.count > 0 {
            let memberId = MemberShipManager.shared.getIdMember()
            var purchaseMemberId = MemberShipManager.TYPE_BEGINNER_MEMBER
            var receiptDict: [String:Any]?
            for model in self.listModels {
                let productId = model.productId
                let purchaseItem = StoreKitManager.shared.verifySubscription(productId: productId, receipt: receiptInfo)
                if purchaseItem != nil {
                    purchaseMemberId = Int(model.id)
                    model.labelBtnBuy = ""
                    model.statusBtn = PremiumModel.STATUS_BTN_PURCHASED
                    receiptDict = MemberShipManager.shared.getDictReceiptItem(receipt: purchaseItem!)
                }
                self.updateInfoMemberId(model, memberId)
            }
            
            if receiptDict != nil {
                MemberShipManager.shared.saveInfoMember(receipt: receiptDict!)
            }
            
            //update UI collection when restoreing
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            
            if receiptDict != nil {
                self.sendInfoPurchaseToServer(memberId: purchaseMemberId, receipt: receiptDict!)
            }
            
        
        }
    }
    
    @objc func purchaseSuccess(notification:Notification) -> Void {
        self.dismissProgress()
        
        if let receipt = notification.userInfo as? [String:Any]{
            let productId = receipt[MemberShipManager.KEY_PRODUCT_ID] as! String
            for model in self.listModels {
                if model.productId.elementsEqual(productId){
                    MemberShipManager.shared.saveInfoMember(receipt: receipt)
                    self.showToast(withResId: StringRes.info_thanks_purchasing)
                    model.statusBtn = PremiumModel.STATUS_BTN_PURCHASED
                    model.labelBtnBuy = ""
                    self.collectionView.reloadData()
                    
                    self.sendInfoPurchaseToServer(memberId: model.id, receipt: receipt)
                    break
                }
            }
            let memberId = MemberShipManager.shared.getIdMember()
            for model in self.listModels {
                self.updateInfoMemberId(model, memberId)
            }
            //update status other model
            self.collectionView.reloadData()
            
        }
    }
    
    @objc func purchaseFailed(notification:Notification) -> Void {
        self.dismissProgress()
        if let msg = notification.userInfo![MemberShipManager.KEY_MESSAGE] as? String {
            self.showAlertWith(title: getString(StringRes.title_information), message: msg, positive: getString(StringRes.title_cancel), completion: {
                //back the main screen
                //self.backToHome()
            })
        }
    }
    
    func sendInfoPurchaseToServer(memberId: Int, receipt: [String: Any]) {
        SettingManager.setBoolean(SettingManager.KEY_NEED_UPDATE_PURCHASE, true)
        //check online to update
        if(ApplicationUtils.isOnline()){
            JamitLog.logE("=========>sendInfoPurchaseToServer = \(memberId)")
            let productId = receipt[MemberShipManager.KEY_PRODUCT_ID] as! String
            let indexMember = MemberShipManager.shared.getMemberIndexFromProductId(productId)
            if indexMember >= 0 {
                let startDate = String(receipt[MemberShipManager.KEY_PURCHASE_TIME] as! Double)
                let endDate = String(receipt[MemberShipManager.KEY_EXPIRED_TIME] as! Double)

                let token = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
                let memberType = MemberShipManager.STR_MEMBERS[indexMember]
                let transId = receipt[MemberShipManager.KEY_SV_TRANSACTION_ID] as! String
                let params = ["token":token,"subscription_type": memberType,
                              "premium_id": ("ios_" + transId), "is_activated": true,
                              "is_premium_member": true,"premium_start_date": startDate,
                              "premium_end_date": endDate,"premium_referral_platform":"ios"] as [String : Any]

                self.showProgress()
                JamItPodCastApi.updatePremium(params) { (result) in
                    self.dismissProgress()
                    if (result?.model as? UserModel) != nil {
                        SettingManager.setBoolean(SettingManager.KEY_NEED_UPDATE_PURCHASE, false)
                        let main = MainController.create() as! MainController
                        self.presentDetail(main)
                    }
                    else{
                        let msg = result?.error ?? getString(StringRes.info_server_error)
                        self.showToast(with: msg)
                    }

                }
            }
        }
    }
    
}

extension UpradeMemberViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IAPListCell.self), for: indexPath)
        let item = self.listModels[indexPath.row]
        let iapCell = cell as! IAPListCell
        iapCell.updateUI(item)
        iapCell.itemCellDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }

}

extension UpradeMemberViewController: UICollectionViewDelegateFlowLayout{
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - paddingInset.left - paddingInset.right
        return CGSize(width: availableWidth, height: DimenRes.row_height_large)
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return paddingInset
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
}
//follow delegate
extension UpradeMemberViewController : IAPItemClickDelegate {
    
    func onViewDetail(_ premiumModel: PremiumModel) {
        let status = premiumModel.statusBtn
        if status == PremiumModel.STATUS_BTN_SKIP || status == PremiumModel.STATUS_BTN_PURCHASED {
           return
        }
        if !ApplicationUtils.isOnline(){
            self.showToast(withResId: StringRes.info_error_connect)
            return
        }
        self.showProgress()
        StoreKitManager.shared.purchaseProduct(productId: premiumModel.productId, sharedSecret: IJamitConstants.IAP_SHARE_SECRET)
    }
}

