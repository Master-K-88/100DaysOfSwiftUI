//
//  EditProfileController.swift
//  jamit
//
//  Created by Prof K on 10/15/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class EditProfileController: JamitRootViewController {
    
    private let placeHolderColor = getColor(hex: ColorRes.main_second_text_color)
    @IBOutlet weak var firstNameTxtField: UITextField!{
        didSet {
            self.firstNameTxtField.setIcon(UIImage(named: ImageRes.ic_user_white_24dp)!)
            self.firstNameTxtField.placeholderColor(color: placeHolderColor)
            self.firstNameTxtField.delegate = self
        }
    }
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lastNameTxtField: UITextField!{
        didSet {
            self.lastNameTxtField.setIcon(UIImage(named: ImageRes.ic_user_white_24dp)!)
            self.lastNameTxtField.placeholderColor(color: placeHolderColor)
            self.lastNameTxtField.delegate = self
        }
    }
    @IBOutlet weak var bioTextField: UITextField!{
        didSet {
            self.bioTextField.setIcon(UIImage(named: ImageRes.ic_user_white_24dp)!)
            self.bioTextField.placeholderColor(color: placeHolderColor)
            self.bioTextField.delegate = self
        }
    }
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    var parentVC: MainController?
    var avatarDelegate: AvatarDelegate?
    var dismissDelegate: DismissDelegate?
    var user: UserModel?
    var colorMain: UIColor!
    
    private let myPickerController = UIImagePickerController()
    private var pickedImage: UIImage?
    var maleSelected: Bool!
    var femaleSelected: Bool!
    var birthMonth: String?
    var birthDay: String?
    var birthYear: String?
    var gender: String?
    var strDate: String?
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
        parentVC?.bgTab.isHidden = false
        parentVC?.segment.isHidden = false
//        self.parentVC?.profileVC?.onRefreshData(false)
        self.parentVC?.refreshContainerBottom()
        
        
    }
    
    override func setUpUI() {
        super.setUpUI()
        let avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
        if avatar.starts(with: "https") {
            self.imgAvatar.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else {
            self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
        maleSelected = true
        femaleSelected = false
        self.myPickerController.delegate = self
        self.myPickerController.sourceType = .photoLibrary
        self.myPickerController.mediaTypes = [StringRes.public_image]
        colorMain = getColor(hex: ColorRes.tab_text_focus_color)
        maleBtn.tintColor = colorMain
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        maleSelected = true
        femaleSelected = false
        maleBtn.tintColor = colorMain
        maleBtn.setImage(UIImage(systemName: ImageRes.ic_circle_btn_selected), for: .normal)
        femaleBtn.tintColor = .white
        femaleBtn.setImage(UIImage(systemName: ImageRes.ic_circle_btn_unselected), for: .normal)
    }
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        maleSelected = false
        femaleSelected = true
        maleBtn.tintColor = .white
        maleBtn.setImage(UIImage(systemName: ImageRes.ic_circle_btn_unselected), for: .normal)
        femaleBtn.tintColor = colorMain
        femaleBtn.setImage(UIImage(systemName: ImageRes.ic_circle_btn_selected), for: .normal)
    }
    
    @IBAction func updateImgBtnTapped(_ sender: Any) {
        self.changeAvatar()
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        strDate = dateFormatter.string(from: dateOfBirthPicker.date)
        let arrDate = strDate?.split(separator: ",")
        guard let newArrDate = arrDate?[0] else { return }
        let birthArr = newArrDate.split(separator: "/")
        birthMonth = String(birthArr[0])
        birthDay = String(birthArr[1])
        birthYear = String(birthArr[2])
    }
    func updateAvatar(_ image: UIImage?) {
        self.imgAvatar.image = image
    }
    
    func updateUIHeader(_ user: UserModel?) {
        let isLogin = SettingManager.isLoginOK()
        self.user = user
        if isLogin {
            let avatar = SettingManager.getSetting(SettingManager.KEY_USER_AVATAR)
            if avatar.starts(with: "https") {
                self.imgAvatar.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            }
            else {
                self.imgAvatar.image = UIImage(named: ImageRes.ic_avatar_48dp)
            }
            var displayName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            if displayName.isEmpty || displayName.elementsEqual(getString(StringRes.null_value)) {
                displayName = SettingManager.getSetting(SettingManager.KEY_USER_EMAIL)
            }
        }
    }
    
    private func startUploadImg() {
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: getString(StringRes.info_lose_internet))
            return
        }
        self.showProgress(getString(StringRes.info_process_loading))
        JamItPodCastApi.uploadImage(self.pickedImage!, IJamitConstants.IMG_AVATAR) { (avatar) in
            self.dismissProgress()
            if avatar != nil && avatar!.isResultOk() {
                let img = avatar!.avatarURl
                SettingManager.saveSetting(SettingManager.KEY_USER_AVATAR, img)
                self.updateUIHeader(self.user)
                self.showToast(withResId: StringRes.info_change_avatar_success)
                return
            }
            let msg = avatar != nil && !avatar!.message.isEmpty ? avatar!.message : getString(StringRes.info_change_avatar_error)
            self.showToast(with: msg)
            return
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if maleSelected && !femaleSelected {
            gender = getString(StringRes.gender_male)
        } else if !maleSelected && femaleSelected {
            gender = getString(StringRes.gender_female)
        } else {
            gender = ""
        }
        if SettingManager.isLoginOK() && ApplicationUtils.isOnline() {
            let userName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            let email = SettingManager.getSetting(SettingManager.KEY_USER_EMAIL)
            let token = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
            if let firstName = firstNameTxtField.text, !firstName.isEmpty {
                if let lastName = lastNameTxtField.text,
                   !lastName.isEmpty {
                    if let gender = gender,
                       let bio = bioTextField.text,
                       let birthDay = birthDay,
                       let birthMonth = birthMonth,
                       let birthYear = birthYear {
                        let params = [ "username": userName,
                                       "first_name": firstName,
                                       "last_name": lastName,
                                       "email": email,
                                       "birth_day": birthDay,
                                       "birth_month": birthMonth,
                                       "birth_year": birthYear,
                                       "gender": gender,
                                       "about": bio,
                                       "token": token
                        ]
                        JamItPodCastApi.editProfile(params) { (result) in
                            let msg = result?.message ?? getString(StringRes.info_sign_in_successfully)
                            self.showAlertWith(title: "Update User Info", message: msg,cancel: .none)
                        }
                        
                        JamItPodCastApi.getUser(token) { result in
                            if let user = result?.model as? UserModel {
                                SettingManager.saveUser(user)
                            }
                            
                        }
                        
                    } else {
                        showAlertWith(title: getString(StringRes.info_input_required), message: getString(StringRes.date_of_birth_required), positive: nil, negative: nil, completion: nil, cancel: .none)
                    }
                } else {
                    showAlertWith(title: getString(StringRes.info_input_required), message: getString(StringRes.last_name_required), positive: nil, negative: nil, completion: nil, cancel: .none)
                }
            } else {
                showAlertWith(title: getString(StringRes.info_input_required), message: getString(StringRes.first_name_required), positive: nil, negative: nil, completion: nil, cancel: .none)
            }
        }
    }
    
}


extension EditProfileController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.firstNameTxtField){
            textField.resignFirstResponder()
            self.lastNameTxtField.becomeFirstResponder()
            self.view.endEditing(true)
        } else if(textField == self.lastNameTxtField) {
            self.lastNameTxtField.resignFirstResponder()
            self.bioTextField.becomeFirstResponder()
        } else if(textField == self.bioTextField) {
            self.bioTextField.resignFirstResponder()
        }
        return true
    }
    
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AvatarDelegate {
    
    func changeAvatar() {
        let msg = getString(StringRes.info_change_avatar)
        let titleCancel = getString(StringRes.title_cancel)
        let titleYes = getString(StringRes.title_yes)
        self.parentVC?.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleYes, negative: titleCancel, completion: {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.present(self.myPickerController, animated: true, completion: nil)
            }
            else{
                self.showToast(withResId: StringRes.info_select_image_error)
            }
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.myPickerController.dismiss(animated: true, completion: {
            if pickedImage != nil {
                let reduceImg = pickedImage!.resized(toWidth: IJamitConstants.IMG_SIZE)
                self.updateAvatar(reduceImg)
                self.pickedImage = reduceImg
                self.startUploadImg()
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.myPickerController.dismiss(animated: true, completion: nil)
    }
    
}
