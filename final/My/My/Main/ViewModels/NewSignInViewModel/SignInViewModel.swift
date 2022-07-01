//
//  SignInViewModel.swift
//  My
//
//  Created by Prof K on 6/28/22.
//

import Foundation

class SignInViewModel {
    var activateButton:((String, Bool)->Void)?
    var updateCountDown: ((String) -> Void)?
    var goToOTP: ( () -> Void)?
    var goToOnboarding: (() -> Void)?
    var goToHome: (() -> Void)?
    
    var timer: Timer?
    var totalTime = 600
    var token = ""
    
    let api: JamitAPIProtocol = JamitAPI()
    let endpont = NewJamitApiEndpoint.METHOD_LOGIN
    
    func loginToJamit() {
        let endpont = NewJamitApiEndpoint.METHOD_LOGIN
        api.signin(endpoint: endpont, param: ["email": NewSettingManager.getSetting(NewSettingManager.KEY_USER_EMAIL)]) { [weak self] result in
            switch result {
            case .success(let data):
                print("I am testing the response from the server \(data)")
                if data.loginUser {
                    NewSettingManager.setBoolean(NewSettingManager.KEY_REGISTER_USER, data.register)
                    self?.goToOTP?()
                }
            case .failure(_):
                debugPrint("I am getting an error")
            }
        }
    }
    
    func verifyLoginToJamit(param: [String: Any]) {
        let endpont = NewJamitApiEndpoint.METHOD_CONFIRM_LOGIN
        api.verifySignin(endpoint: endpont, param: param) { [weak self] result in
            print("Something is here")
            switch result {
                
            case .success(let data):
                
                debugPrint("The data is \(data)")
                print("I am testing the response from the server \(data.newUser)")
                let cookies = HTTPCookieStorage.shared.cookies
                for cooky in cookies ?? [] {
                    if cooky.name == "token" {
                        self?.token = cooky.value
                        print("This is the token from cookies \(self?.token)")
                    }
                }
                print(HTTPCookieStorage.shared.cookies!)
                if data.newUser {
                    self?.goToOnboarding?()
                } else {
                    NewSettingManager.saveSetting(NewSettingManager.KEY_USER_ID, data.user?.userID)
                    NewSettingManager.saveSetting(NewSettingManager.KEY_USER_AVATAR, data.user?.avatar)
                    NewSettingManager.saveSetting(NewSettingManager.KEY_USER_TOKEN, self?.token)
                    NewSettingManager.saveSetting(NewSettingManager.KEY_USER_NAME, data.user?.username)
                    NewSettingManager.saveSetting(NewSettingManager.KEY_USER_TYPE, data.user?.userRole?.joined(separator: "&"))
                    self?.goToHome?()
                }
            case .failure(_):
                debugPrint("I am getting an error")
            }
        }
    }
    
    func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        let timer = timeFormatted(totalTime)
        updateCountDown?(timer)
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func willActivteButton(text: String) {
        if text.count >= 4 {
            print("The number of character is \(text.count) in \(text) color: green")
            activateButton?("green", true)
        } else {
            print("The number of character is \(text.count) in \(text) color: gray")
            activateButton?("gray", false)
        }
    }
}
