//
//  SignUpController.swift
//  iLandMusic
//  Created by iLandMusic on 8/14/19.
//  Copyright © 2019 iLandMusic. All rights reserved.
//

import Foundation
import UIKit

class SignUpController: JamitRootViewController {
    
    private let placeHolderColor = getColor(hex: ColorRes.main_second_text_color)
    private let borderColor = getColor(hex: ColorRes.color_accent)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var constraintLogoWidth: NSLayoutConstraint!
    
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    
    private var isShowingKeyboard = false
    var parentVC: LoginController?
    
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnTos: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    @IBOutlet weak var tfUsername: UITextField!{
        didSet {
            self.tfUsername.setIcon(UIImage(named: ImageRes.ic_user_white_24dp)!)
            self.tfUsername.placeholderColor(color: placeHolderColor)
            self.tfUsername.delegate = self
        }
    }
    
    @IBOutlet weak var tfEmail: UITextField!{
        didSet {
            self.tfEmail.setIcon(UIImage(named: ImageRes.ic_email_login_white_24dp)!)
            self.tfEmail.placeholderColor(color: placeHolderColor)
            self.tfEmail.delegate = self
        }
    }
    @IBOutlet weak var tfPassword: UITextField!{
        didSet {
            self.tfPassword.setIcon(UIImage(named: ImageRes.ic_lock_white_24dp)!)
            self.tfPassword.placeholderColor(color: placeHolderColor)
            self.tfPassword.delegate = self
        }
    }
    
    @IBOutlet weak var tfConfirmPass: UITextField! {
        didSet{
            self.tfConfirmPass.setIcon(UIImage(named: ImageRes.ic_lock_white_24dp)!)
            self.tfConfirmPass.placeholderColor(color: placeHolderColor)
            self.tfConfirmPass.delegate = self
        }
    }
    override func setUpUI() {
        super.setUpUI()
        self.registerTapOutSideRecognizer()
        self.registerKeyboardObserver()
        
        if isCheapDevice() {
            guard let constraintLogoWidth = constraintLogoWidth else {
                return
            }
            constraintLogoWidth.constant =  80.0
            
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpBolder()
        if isCheapDevice() {
            self.setUpBolder()
            self.imgLogo.layoutIfNeeded()
        }
    }
    
    func setUpBolder(){
        self.tfUsername.setBottomBorder(withColor: borderColor)
        self.tfEmail.setBottomBorder(withColor: borderColor)
        self.tfConfirmPass.setBottomBorder(withColor: borderColor)
        self.tfPassword.setBottomBorder(withColor: borderColor)
    }
    
    @IBAction func privacyTap(_ sender: Any) {
        ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_PRIVACY_POLICY)
    }
    
    @IBAction func tosTap(_ sender: Any) {
        ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_TERM_OF_USE)
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.backToHome()
    }
    
    func backToHome() {
        if self.isShowingKeyboard {
            self.hideVirtualKeyboard()
            return
        }
        self.unregisterKeyboardObserver()
        self.unregisterTapOutSideRecognizer()
        self.dismissDetail()
    }
    
    @IBAction func createAccountTap(_ sender: Any) {
        self.hideVirtualKeyboard()
        if !ApplicationUtils.isOnline() {
            showToast(withResId:  StringRes.info_lose_internet)
            return
        }
        let userName  = self.tfUsername.text!
        let email = self.tfEmail.text!
        let password = self.tfPassword.text!
        let confirmPass = self.tfConfirmPass.text!
        
        let emptyFormat  = getString(StringRes.format_empty_field)
        if userName.isEmpty {
            showToast(with: String(format: emptyFormat, getString(StringRes.title_user_name)))
            return
        }
        if StringUtils.isHasSpecialCharacter(userName){
            showToast(with: String(format: getString(StringRes.format_special_field), getString(StringRes.title_user_name)))
            return
        }
        if email.isEmpty {
            showToast(with: String(format: emptyFormat, getString(StringRes.title_email)))
            return
        }
        if password.isEmpty {
            showToast(with: String(format: emptyFormat, getString(StringRes.title_password)))
            return
        }
        if confirmPass.isEmpty {
            showToast(with: String(format: emptyFormat, getString(StringRes.title_confirm_pass)))
            return
        }
        if !email.isValidEmail() {
            showToast(with: getString(StringRes.info_email_invalid))
            return
        }
        if !password.elementsEqual(confirmPass){
            showToast(with: getString(StringRes.info_password_not_match))
            return
        }
        if(confirmPass.count < IJamitConstants.MIN_PASSWORD_LENGHT) {
            showToast(with: getString(StringRes.info_password_short))
            return
        }
        self.showProgress(getString(StringRes.info_process_loading))
        JamItPodCastApi.signIn(userName, email, password) { (result) in
            self.dismissProgress()
            if let userModel = result?.model as? UserModel {
                if userModel.isActive {
                    SettingManager.saveUser(userModel)
                    MemberShipManager.shared.saveInfoMemberFromUserModel(userModel)
                    
                    let main = MainController.create() as! MainController
                    main.msgId = StringRes.info_login_success
                    self.presentDetail(main)
                }
                else{
                    let msg = result?.message ?? getString(StringRes.info_sign_in_successfully)
                    self.parentVC?.msgFirstTime = msg
                    self.backToHome()
                }
          
            }
            else{
                let msg = result?.error ?? getString(StringRes.info_server_error)
                self.showToast(with: msg)
            }
        }
    }

    
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
        self.tfPassword.resignFirstResponder()
        self.tfConfirmPass.resignFirstResponder()
        self.tfEmail.resignFirstResponder()
        self.tfUsername.resignFirstResponder()
    }
   
}

//extension for text field
extension SignUpController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == tfUsername){
            tfEmail.becomeFirstResponder()
        }
        else if(textField == tfEmail){
            tfPassword.becomeFirstResponder()
        }
        else if(textField == tfPassword){
            self.tfConfirmPass.becomeFirstResponder()
            if !isCheapDevice() && self.lastOffset == nil {
                lastOffset = scrollView.contentOffset
            }
        }
        else if(textField == tfConfirmPass){
            textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    
}

// MARK: Keyboard Handling
extension SignUpController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.isShowingKeyboard = true
        
        let cheapDevice = isCheapDevice()
        if keyboardHeight != nil  {
            return
        }
        if !self.tfConfirmPass.isFirstResponder && self.lastOffset == nil && !cheapDevice {
            return
        }
        if self.tfConfirmPass.isFirstResponder && self.lastOffset == nil && !cheapDevice {
            self.lastOffset = self.scrollView.contentOffset
        }
        if self.lastOffset == nil && cheapDevice {
            self.lastOffset = self.scrollView.contentOffset
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            var collapseSpace:CGFloat = 0.0
            if !isCheapDevice(){
                collapseSpace = self.tfConfirmPass.frame.size.height
            }
            else{
                collapseSpace = (self.tfEmail.frame.size.height + 10)*3
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isShowingKeyboard = false
        if self.lastOffset != nil  && self.keyboardHeight != nil {
            UIView.animate(withDuration: 0.3) {
                self.constraintContentHeight.constant -= self.keyboardHeight
                self.scrollView.contentOffset = self.lastOffset
            }
            self.keyboardHeight = nil
            self.lastOffset = nil
        }
        
    }
}
