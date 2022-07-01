//
//  OTPController.swift
//  My
//
//  Created by Prof K on 6/28/22.
//

import UIKit
import Kingfisher

class OTPController: JamitRootViewController {
    
    let generalButton: (String, UIColor) -> UIButton = { (image: String, color: UIColor) -> UIButton in
        let button = UIButton()
        button.cornerRadius = 10
        button.contentMode = .scaleToFill
        button.setImage(UIImage(named: "\(image)"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = color
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    let generalTextfield: () -> UITextField = { () -> UITextField in
        let textfield = UITextField()
        textfield.cornerRadius = 10
        textfield.textColor = .white
        textfield.textAlignment = .center
        textfield.backgroundColor = UIColor(named: ColorRes.textfield_bgcolor)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }
    
    let generalHorizontalStackView = { (space: CGFloat) -> UIStackView in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.spacing = space
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    let imageIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageRes.otp_icon)
        image.tintColor = UIColor(named: ColorRes.tint_color)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleText: UILabel = {
        let label = UILabel()
        label.text = getString(StringRes.otp_title)
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textColor = UIColor(named: ColorRes.label_color)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let otpInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(getString(StringRes.otp_info)) \(NewSettingManager.getSetting(NewSettingManager.KEY_USER_EMAIL))"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let requestOTP: UILabel = {
        let label = UILabel()
        label.text = "\(getString(StringRes.otp_info))"
        label.font = UIFont(name: "Poppins-Regular", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var backButton = generalButton(ImageRes.ic_back_white_24dp,UIColor(named: ColorRes.backgroun_color) ?? .black)
    lazy var otpStackView = generalHorizontalStackView(10)
    
    lazy var firstOTPText = generalTextfield()
    lazy var secondOTPText = generalTextfield()
    lazy var thirdOTPText = generalTextfield()
    lazy var fourthOTPText = generalTextfield()
    
    lazy var verifyButton = generalButton("", UIColor.systemGray3)
    
    var otpCharacter = ""
    weak var viewModel: SignInViewModel?
    var parentVC: JamitRootViewController?
//    String(format: emptyFormat, getString(StringRes.title_email))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verifyButton.addTarget(self, action: #selector(verifyTapped(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.willActivteButton(text: self?.otpCharacter ?? "")
        }
        listener()
        viewModel?.startOtpTimer()
    }
    
    func listener() {
        viewModel?.activateButton = { [weak self] color, btnActivate in
            DispatchQueue.main.async {
                print("I am calling this function in \(color)")
                self?.verifyButton.isUserInteractionEnabled = btnActivate
                self?.verifyButton.backgroundColor = UIColor(named: color) ?? .gray //UIColor(named: color)
            }
        }
        viewModel?.updateCountDown = { [weak self] timer in
            DispatchQueue.main.async {
                self?.requestOTP.text = "\(getString(StringRes.otp_info)): \(timer)"
            }
            
        }
        
        viewModel?.goToOnboarding = { [weak self] in
            self?.dismissProgress()
            self?.gotoOnboarding()
        }
        
        viewModel?.goToHome = {[weak self] in
            self?.dismissProgress()
            self?.goToMain()
        }
    }
    
    func gotoOnboarding() {
//        let isShowIntro  = SettingManager.getBoolean(SettingManager.KEY_SHOW_INTRO)
        let main = IntroController.create()
        self.presentDetail(main)
    }
    
    override func setUpUI() {
        super.setUpUI()
        setupSubviews()
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func verifyTapped(_ sender: UIButton) {
        showProgress()
        let param: [String : Any] = [
            "email": NewSettingManager.getSetting(NewSettingManager.KEY_USER_EMAIL),
            "otp": otpCharacter.uppercased(),
            "registerUser": NewSettingManager.getBoolean(NewSettingManager.KEY_REGISTER_USER)
        ]
        print(param)
        viewModel?.verifyLoginToJamit(param: param)
        //        viewModel?.loginToJamit()
        
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
    
    func setupSubviews() {
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.addSubview(backButton)
        view.addSubview(imageIcon)
        view.addSubview(titleText)
        view.addSubview(otpInfo)
        view.addSubview(otpStackView)
        let otpTexts = [firstOTPText, secondOTPText, thirdOTPText, fourthOTPText]
        for eachOTPText in otpTexts {
            eachOTPText.delegate = self
            eachOTPText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            otpStackView.addArrangedSubview(eachOTPText)
        }
        view.addSubview(verifyButton)
        verifyButton.setTitle(getString(StringRes.verify_otp), for: .normal)
        view.addSubview(requestOTP)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            imageIcon.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            imageIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            titleText.topAnchor.constraint(equalTo: imageIcon.bottomAnchor, constant: 30),
            titleText.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            
            otpInfo.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20),
            otpInfo.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            otpInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            otpStackView.topAnchor.constraint(equalTo: otpInfo.bottomAnchor, constant: 20),
            otpStackView.leadingAnchor.constraint(equalTo: otpInfo.leadingAnchor),
            otpStackView.trailingAnchor.constraint(equalTo: otpInfo.trailingAnchor),
            otpStackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
            verifyButton.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 20),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyButton.heightAnchor.constraint(equalToConstant: 52),
            verifyButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            
            requestOTP.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 10),
            requestOTP.leadingAnchor.constraint(equalTo: verifyButton.leadingAnchor, constant: 20),
//            requestOTP.trailingAnchor.constraint(equalTo: verifyButton.trailingAnchor),
            
        ])
    }
}

extension OTPController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string.uppercased())
        
        return newString.count <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateVerifyButton()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){

        let text = textField.text

        if text?.utf16.count == 1 {
            switch textField {
            case firstOTPText:
                secondOTPText.becomeFirstResponder()
            case secondOTPText:
                thirdOTPText.becomeFirstResponder()
            case thirdOTPText:
                fourthOTPText.becomeFirstResponder()
            case fourthOTPText:
                fourthOTPText.resignFirstResponder()
                updateVerifyButton()
            default:
                break
            }
        }
    }
    
    fileprivate func updateVerifyButton() {
        otpCharacter = "\(firstOTPText.text ?? "")\(secondOTPText.text ?? "")\(thirdOTPText.text ?? "")\(fourthOTPText.text ?? "")"
        viewModel?.willActivteButton(text: otpCharacter)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let text = textField.text
//
//        if text?.utf16.count == 1 {
//            switch textField {
//            case firstOTPText:
//                secondOTPText.becomeFirstResponder()
//            case secondOTPText:
//                thirdOTPText.becomeFirstResponder()
//            case thirdOTPText:
//                fourthOTPText.becomeFirstResponder()
//            case fourthOTPText:
//                fourthOTPText.resignFirstResponder()
//            default:
//                break
//            }
//        }
//
//        return true
//
//    }
    
    
}
