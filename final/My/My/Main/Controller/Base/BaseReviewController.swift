//
//  BaseReviewController.swift
//  jamit
//
//  Created by Do Trung Bao on 8/8/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class BaseReviewController: BaseCollectionController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var bottomAction: UIView!
    
    //bottom action constraint for showing or hide keyboard
    @IBOutlet weak var bottomEdConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfChat: UITextField!
    @IBOutlet weak var rootEdChat: UIView!
    @IBOutlet weak var btnSend: UIView!
    
    //fake font to calculate height of description in the header
    let fakeLabel = UILabel()
    
    private var keyboardHeight: CGFloat!
    private var isShowingKeyboard = false
    
    var reviewDelegate: ReviewDelegate?
    
    var isLogin = false
    
    override func setUpUI() {
        self.fakeLabel.font = UIFont.init(name: IJamitConstants.FONT_NORMAL, size: DimenRes.text_size_body) ?? UIFont.systemFont(ofSize: DimenRes.text_size_body)
        super.setUpUI()
        
        self.tfChat.placeholderColor(color: getColor(hex: ColorRes.text_hint_chat_color))
        self.tfChat.textColor = getColor(hex: ColorRes.text_chat_color)
        self.tfChat.backgroundColor = UIColor.clear
        self.tfChat.delegate = self
        
        self.isLogin = SettingManager.isLoginOK()
        
        self.btnLogin.isHidden = isLogin
        self.rootEdChat.isHidden = !isLogin
        self.btnSend.isHidden = !isLogin
        
        self.registerTapOutSideRecognizer()
        self.registerKeyboardObserver()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnSend.cornerRadius = self.btnSend.frame.size.width / CGFloat(2)
    }
    
    func registerKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func getUIType() -> UIType {
        return .FlatList
    }
    
    override func getIDCellOfCollectionView() -> String {
        return String(describing: ReviewFlatListCell.self)
    }
    
//    override func doOnNextWithListModel(_ listModels: inout [JsonModel]?, _ offset: Int, _ isGetNew: Bool) {
//        let size = listModels?.count ?? 0
//        if size > 0 {
//            let reviews = listModels as! [ReviewModel]
//            let availableWidth = self.view.frame.width
//            for item in reviews {
//                let height = fakeLabel.caculateHeight(availableWidth, item.text,false)
//                item.heightText = height
//            }
//        }
//    }
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let cell = cell as! ReviewFlatListCell
        let review = model as! ReviewModel
        cell.delegate = self.reviewDelegate
        cell.updateUI(review)
    }
    
    //override function to calculate height of native ads
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.listModels?[indexPath.row] as? ReviewModel {
            let availableWidth = self.view.frame.width
            let padding = item.heightText > DimenRes.pivot_review_height ? DimenRes.medium_padding : 0
            let realHeight = DimenRes.row_height_review + (item.heightText - DimenRes.pivot_review_height) + padding
            return CGSize(width: availableWidth, height: realHeight)
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    @IBAction func backTap(_ sender: Any) {
        if self.isShowingKeyboard {
            self.hideVirtualKeyboard()
            return
        }
        self.unregisterTapOutSideRecognizer()
        self.unregisterKeyboardObserver()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
        self.tfChat.resignFirstResponder()
    }
    
    @IBAction func sendTap(_ sender: Any) {
        self.hideVirtualKeyboard()
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.onPostReview()
    }
    
    func onPostReview(){
        
    }
    
    override func getStringNoDataID() -> String {
        return StringRes.info_no_favorite
    }
    
    @IBAction func loginTap(_ sender: Any) {
        
    }
    
}

// text field delegate to capture event keyboard
extension BaseReviewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
   
}

// MARK: Keyboard Handling
extension BaseReviewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let kbFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if !self.isShowingKeyboard && self.keyboardHeight == nil {
                self.isShowingKeyboard = true
                
                let bottomSafeArea: CGFloat
                if #available(iOS 11.0, *) {
                    bottomSafeArea = view.safeAreaInsets.bottom
                } else {
                    bottomSafeArea = bottomLayoutGuide.length
                }
                self.keyboardHeight = kbFrame.height - bottomSafeArea
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomEdConstraint.constant = -self.keyboardHeight
                })
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.isShowingKeyboard && self.keyboardHeight != nil {
            self.isShowingKeyboard = false
            UIView.animate(withDuration: 0.3) {
                self.bottomEdConstraint.constant = 0
            }
            self.keyboardHeight = nil
        }
    }
}
