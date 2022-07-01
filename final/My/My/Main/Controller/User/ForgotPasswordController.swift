//
//  ForgotPasswordController.swift
//  JamIt
//  Created by JamIt on 8/15/19.
//  Copyright © 2019 JamIt. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordController: JamitRootViewController {
    
    let placeHolderColor = getColor(hex: ColorRes.main_second_text_color)
    let borderColor = getColor(hex: ColorRes.color_accent)
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var constraintLogoWidth: NSLayoutConstraint!
        
    @IBOutlet weak var btnResetPass: UIButton!
    
    @IBOutlet weak var btnBottomBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnTos: UIButton!
    
    @IBOutlet weak var btnPrivacy: UIButton!
    
    @IBOutlet weak var tfEmail: UITextField!{
        didSet {
            self.tfEmail.setIcon(UIImage(named: ImageRes.ic_email_login_white_24dp)!)
            self.tfEmail.placeholderColor(color: placeHolderColor)
            self.tfEmail.delegate = self
        }
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.registerTapOutSideRecognizer()
        if isCheapDevice() {
            guard let constraintLogoWidth = constraintLogoWidth else {
                return
            }
            constraintLogoWidth.constant = 120.0
        }
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
        self.tfEmail.setBottomBorder(withColor: borderColor)
    }
    
    @IBAction func privacyTap(_ sender: Any) {
        ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_PRIVACY_POLICY)
    }
    
    @IBAction func tosTap(_ sender: Any) {
        ShareActionUtils.goToURL(linkUrl: IJamitConstants.URL_TERM_OF_USE)
    }
    
    @IBAction func backTap(_ sender: Any) {
        if self.tfEmail.isFirstResponder {
            self.hideVirtualKeyboard()
            return
        }
        self.unregisterTapOutSideRecognizer()
        self.dismissDetail()
    }
    
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
        self.tfEmail.resignFirstResponder()
    }
    
    @IBAction func resetPassTap(_ sender: Any) {
        self.hideVirtualKeyboard()
        if !ApplicationUtils.isOnline() {
            showToast(withResId:  StringRes.info_lose_internet)
            return
        }
        let email = self.tfEmail.text!
        let emptyFormat  = getString(StringRes.format_empty_field)
        if email.isEmpty {
            showToast(with: String(format: emptyFormat, getString(StringRes.title_email)))
            return
        }
        if !email.isValidEmail() {
            showToast(with: getString(StringRes.info_email_invalid))
            return
        }
        self.showProgress(getString(StringRes.info_process_loading))
        JamItPodCastApi.resetPassword(email) { (result) in
            self.dismissProgress()
            if (result?.message) != nil {
                let msg = !result!.message.isEmpty ? result!.message : getString(StringRes.info_reset_pass_success)
                self.showToast(with: msg)
            }
            else{
                let msg = result?.error ?? getString(StringRes.info_server_error)
                self.showToast(with: msg)
            }
        }
    }
    
    @IBAction func bottomBackTap(_ sender: Any) {
        self.hideVirtualKeyboard()
        self.dismissDetail()
    }
}

//delegate for email text field
extension ForgotPasswordController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
  
}
