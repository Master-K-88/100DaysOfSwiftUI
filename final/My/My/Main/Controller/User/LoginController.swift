//
//  LoginController.swift
//  JamIT
//
//  Created by JamIT on 8/14/19.
//  Copyright © 2019 JamIT. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class LoginController: JamitRootViewController {
    
    private let placeHolderColor = getColor(hex: ColorRes.label_color)
    private let borderColor = getColor(hex: ColorRes.color_accent)
    
    var msgFirstTime: String?
    var parentVC: JamitRootViewController?
    
    @IBOutlet weak var btnTos: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnForgetPass: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    let viewModel = SignInViewModel()
    
    @IBOutlet weak var tfEmail: UITextField!{
        didSet {
            self.tfEmail.setIcon(UIImage(named: ImageRes.ic_email_login_white_24dp)!)
            self.tfEmail.placeholderColor(color: placeHolderColor)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginSuccess()
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.tfEmail.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.unregisterTapOutSideRecognizer()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerTapOutSideRecognizer()
        self.setUpBorder()
        if msgFirstTime != nil && !self.msgFirstTime!.isEmpty {
            self.showToast(with: msgFirstTime!)
            self.msgFirstTime = nil
        }
    }
    
    fileprivate func loginSuccess() {
        viewModel.goToOTP = { [weak self] in
            self?.dismissProgress()
            self?.goToOTP()
        }
    }
    
    func setUpBorder() {
        self.tfEmail.setBottomBorder(withColor: borderColor)
//        self.tfPassword.setBottomBorder(withColor: borderColor)
    }
    
    @IBAction func loginTap(_ sender: Any) {
        self.hideVirtualKeyboard()
        if !ApplicationUtils.isOnline() {
            showToast(withResId:  StringRes.info_lose_internet)
            return
        }
        
        let email = self.tfEmail.text!
//        let password = self.tfPassword.text!
        let emptyFormat  = getString(StringRes.format_empty_field)
        guard !email.isEmpty else {
            showAlertWith(title: "Email Required", message: "Email cannot be blank, please enter a valid email")
            return
        }
        
        
//        if email.isEmpty {
//            showToast(with: String(format: emptyFormat, getString(StringRes.title_email)))
//            return
//        }
//        if password.isEmpty {
//            showToast(with: String(format: emptyFormat, getString(StringRes.title_password)))
//            return
//        }
        if !email.isValidEmail() {
            showAlertWith(title: "Invalid Email", message: getString(StringRes.info_email_invalid))
//            showToast(with: getString(StringRes.info_email_invalid))
            return
        }
        NewSettingManager.saveSetting(NewSettingManager.KEY_USER_EMAIL, email)
        self.showProgress(getString(StringRes.info_process_loading))
        viewModel.loginToJamit()
        
        
        
//        JamItPodCastApi.login(email, "password") { (result) in
//
//            if let userModel = result?.model as? UserModel {
//                if !userModel.isActive {
//                    self.showToast(withResId: StringRes.info_not_activated_account)
//                    return
//                }
//                SettingManager.saveUser(userModel)
//                MemberShipManager.shared.saveInfoMemberFromUserModel(userModel)
//                //reset parent to go to new one
//                self.parentVC = nil
//                self.goToMain(true)
//            }
//            else{
//                let msg = result?.error ?? getString(StringRes.info_wrong_user_pass)
//                self.showToast(with: msg)
//            }
//        }
        
    }
    
    @IBAction func skipTap(_ sender: Any) {
        self.goToMain(false)
    }

    
    @IBAction func forgetTap(_ sender: Any) {
        self.hideVirtualKeyboard()
//        self.tfPassword.text = ""
        self.tfEmail.text = ""
        let forgotPassVC = ForgotPasswordController.create(IJamitConstants.STORYBOARD_USER) as! ForgotPasswordController
        self.presentDetail(forgotPassVC)
    }
    
    
    @IBAction func signUpTap(_ sender: Any) {
        self.hideVirtualKeyboard()
//        self.tfPassword.text = ""
        self.tfEmail.text = ""
        let signUp = SignUpController.create(IJamitConstants.STORYBOARD_USER) as! SignUpController
        signUp.parentVC = self
        self.presentDetail(signUp)
    }
    
    @IBAction func privacyTap(_ sender: Any) {
        ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_PRIVACY_POLICY)
    }
    @IBAction func tosTap(_ sender: Any) {
        ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_TERM_OF_USE)
    }
    
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
//        self.tfPassword.resignFirstResponder()
        self.tfEmail.resignFirstResponder()
    }
    
    private func goToMain(_ isSuccess: Bool = false){
        self.dismissProgress()
        if self.parentVC != nil {
            if self.parentVC is MainController {
                (self.parentVC as! MainController).msgId = isSuccess ? StringRes.info_login_success : nil
            }
            self.dismissDetail()
        }
        else{
            let main = MainController.create() as! MainController
            main.msgId = StringRes.info_login_success
            self.presentDetail(main)
        }
       
    }
    
    private func goToOTP() {
        let otpVC = OTPController()
        otpVC.viewModel = viewModel
        self.presentDetail(otpVC)
    }

}

// text field delegate to capture event keyboard
extension LoginController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if(textField == self.tfPassword){
//            textField.resignFirstResponder()
//            self.view.endEditing(true)
//        }
//        else if(textField == self.tfEmail){
////            self.tfPassword.becomeFirstResponder()
//        }
        return true
    }
   
}
