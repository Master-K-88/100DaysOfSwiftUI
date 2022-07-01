//
//  ViewController.swift
//  My
//
//  Created by Prof K on 6/27/22.
//

import UIKit
import Toast
import AppTrackingTransparency

class SplashController: JamitRootViewController {

    let TIME_OUT_NETWORK = 3.0
    let TIME_OUT_PROCESS = 2.0
    
    var mTotalDataMng = TotalDataManager.shared
    var mAppConfigure: ConfigModel?
    
    @IBOutlet weak var lblInfo: UILabel!
    var tokenViewModel: GetTokenViewModel?
    
    var isValidCookie = -1
    
    override func viewDidLoad() {
        self.initFontToast()
        super.viewDidLoad()
        tokenViewModel = GetTokenViewModel()
        tokenViewModel?.getCSRFToken()
        view.backgroundColor = UIColor(named: "Background_color")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestIDFA()
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    self.onInitData()
                // Now that we are authorized we can get the IDFA
                //                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    let isShowIntro  = SettingManager.getBoolean(SettingManager.KEY_SHOW_INTRO)
                    if !isShowIntro {
                        self.onInitData()
                        DispatchQueue.main.async {
                            self.showAlertWith(title: "App Tracking", message: "User have dsiabled app tracking this can be enable in the settings screen")
                        }
                    } else {
                        self.onInitData()
                    }
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    self.onInitData()
                case .restricted:
                    self.onInitData()
                @unknown default:
                    self.onInitData()
                }
            }
        } else {
            self.onInitData()
        }
    }
    
    func onInitData() {
        self.getSettingFromServer { list in
            self.checkUserInfo {
                self.loadData(list)
            }
        }
    }
    
    private func checkUserInfo(completion: @escaping ()->Void ) {
        if ApplicationUtils.isOnline() && SettingManager.isLoginOK() {
            JamItPodCastApi.checkUser { (result) in
                if let checkToken = result  {
                    if checkToken.activeToken {
                        MemberShipManager.shared.checkIAP(completion)
                        return
                    }
                    SettingManager.logOut()
                    self.isValidCookie = 0
                }
                completion()
            }
            return
        }
        completion()
    }
    
    func getSettingFromServer(completion: @escaping ([SettingModel]?)->Void ) {
        if ApplicationUtils.isOnline() {
            JamItPodCastApi.getRemoteSettings { (result) in
                if let setting = result{
                    let list = [setting]
                    completion(list)
                }
            }
            return
        }
        completion(nil)
    }
    
    func loadData(_ list: [SettingModel]?) {
        DispatchQueue.global().async {
            if list != nil {
                self.mTotalDataMng.setListCacheData(IJamitConstants.TYPE_SETTING, list!)
            }
            self.mTotalDataMng.readCacheAndData({
                DispatchQueue.main.asyncAfter(deadline: .now() + self.TIME_OUT_PROCESS, execute: {
                    self.showLoading(false)
                    self.goToMainController()
                })
            })
        }
        
    }
    
    func goToMainController(){
        if isValidCookie == 0 {
            let main = LoginController.create(IJamitConstants.STORYBOARD_USER)
            self.presentDetail(main)
        }
        else{
            
            let main = LoginController.create(IJamitConstants.STORYBOARD_USER)
            self.presentDetail(main)
            
        
        }
    }
    
    private func initFontToast(){
//        var toastStyle = ToastStyle()
//        toastStyle.titleFont = UIFont(name: IJamitConstants.FONT_SEMI_BOLD, size: DimenRes.toast_font_size) ?? UIFont.systemFont(ofSize: DimenRes.toast_font_size)
//        toastStyle.messageFont = UIFont(name: IJamitConstants.FONT_NORMAL, size: DimenRes.toast_font_size) ?? UIFont.systemFont(ofSize: DimenRes.toast_font_size)
//        ToastManager.shared.style = toastStyle
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        self.showLoading(false)
        
        self.lblInfo.text = getString(StringRes.title_copyright)
        if IJamitConstants.RESET_TIMER {
            SettingManager.setSleepMode(0)
        }
        self.mAppConfigure = mTotalDataMng.appConfigure

    }


    private func showLoading(_ isShow: Bool) {
        if isShow {
//            self.indicatorView.isHidden = false
//            self.indicatorView.startAnimating()
        }
        else{
//            self.indicatorView.stopAnimating()
//            self.indicatorView.isHidden = true
        }
    }

    
}

