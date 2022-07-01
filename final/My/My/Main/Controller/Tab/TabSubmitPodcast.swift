//
//  TabSubmitPodcast.swift
//  jamit
//
//  Created by Prof K on 11/10/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit
import Sheeeeeeeeet

class TabSubmitPodcast: ParentViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    private let placeHolderColor = getColor(hex: ColorRes.main_second_text_color)
    private var countVC = 0
    
    @IBOutlet weak var podcastRssFeed: UITextField!{
        didSet {
            self.podcastRssFeed.placeholderColor(color: placeHolderColor)
            self.podcastRssFeed.delegate = self
        }
    }
    @IBOutlet weak var filterCountry: UIView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var filterLan: UIView!
    @IBOutlet weak var layoutContent: UIView!
    @IBOutlet weak var layoutBtAction: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    var countries: [LocaleModel]?
    var languages: [LocaleModel]?
    
    @IBOutlet weak var countryTxtfield: UITextField!{
        didSet {
            countryTxtfield.placeholder = getString(StringRes.title_select_country).uppercased()
            countryTxtfield.placeholderColor(color: placeHolderColor)
        }
    }
    @IBOutlet weak var langTxtField: UITextField!{
        didSet {
            self.langTxtField.placeholder = getString(StringRes.title_select_language).uppercased()
            self.langTxtField.placeholderColor(color: placeHolderColor)
        }
    }
    
    var titleScreen: String?
    var slugCat: String?
    
    var country = IJamitConstants.TAG_ALL
    var language = IJamitConstants.TAG_ALL
    
    var dismissDelegate: DismissDelegate?
    
    override func setUpUI() {
        super.setUpUI()
        subjectLbl.text = getString(StringRes.info_submit_label)
    }
    
    @IBAction func countryTapped(_ sender: Any) {
        self.startGetCountries(isGetOnline: true)
    }
    
    @IBAction func languageTapped(_ sender: Any) {
        self.startGetLanguages(isGetOnline: true)
    }
    
    private func startGetLanguages(isGetOnline: Bool) {
        if languages != nil {
            self.showDropDown(pivotView: self.filterLan, titleId: StringRes.title_select_language,
                              lists: self.languages!) { (selectedItem) in
                self.langTxtField.text = selectedItem.getFullName().uppercased()
                self.langTxtField.textColor = self.placeHolderColor
                self.language = selectedItem.code
            }
            return
        }
        if isGetOnline {
            self.startGetLangJamItLocale {
                self.startGetLanguages(isGetOnline: false)
            }
        }
        
    }
    
    private func startGetCountries(isGetOnline: Bool) {
        if countries != nil {
            self.showDropDown(pivotView: self.filterCountry, titleId: StringRes.title_select_country,
                              lists: countries!) { (selectedItem) in
                self.countryTxtfield.text = selectedItem.getFullName().uppercased()
                self.countryTxtfield.textColor = self.placeHolderColor
                self.country = selectedItem.code
            }
            return
        }
        if isGetOnline {
            self.startGetCountryJamItLocale {
                self.startGetCountries(isGetOnline: false)
            }
        }
        
    }
    
    private func startGetLangJamItLocale(_ completion: @escaping () -> Void) {
        if !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        JamItPodCastApi.getAllLocales { (responce) in
            self.dismissProgress()
            if responce == nil {
                self.showToast(withResId: StringRes.info_server_error)
                return
            }
            if let local = responce {
                print("The language \(local[5].nativeName)")
                self.languages = local
                TotalDataManager.shared.jamItLocale?.languages = local
                    completion()
            }
        }
    }
    
    private func startGetCountryJamItLocale(_ completion: @escaping () -> Void) {
        if !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        JamItPodCastApi.getJamItCountryLocales { (responce) in
            self.dismissProgress()
            if responce == nil {
                self.showToast(withResId: StringRes.info_server_error)
                return
            }
            if let local = responce {
                self.countries = local
                TotalDataManager.shared.jamItLocale?.countries = local
                    completion()
            }
        }
    }
    
    private func showDropDown(pivotView: UIView, titleId: String, lists: [LocaleModel], _ completion: @escaping (LocaleModel) -> Void) {
        var items:[MenuItem] = []
        let menuTitle = MenuTitle(title: getString(titleId))
        items.append(menuTitle)
        
        var index = 0
        for item in lists {
            let menuItem = MenuItem(title: item.getFullName(), value: index)
            items.append(menuItem)
            index += 1
        }
        let menu = Menu(items: items)
        let sheet = menu.toActionSheet { (sheet, menuItem) in
            if let index = menuItem.value as? Int {
                completion(lists[index])
            }
        }
        let isPad = Display.pad
        sheet.present(in: self, from: isPad ? pivotView : self.view)
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.view.removeFromSuperview()
        self.dismissDelegate?.dismiss(controller: self)
        if #available(iOS 13.0, *) {
            self.dismiss(animated: true, completion: {
                self.dismissDelegate?.dismiss(controller: self)
            })
        }
        else{
            self.dismiss(animated: true, completion: nil)
            self.dismissDelegate?.dismiss(controller: self)
        }
    }
//    @IBAction func settingBtnTapped(_ sender: Any) {
//        let controller = SettingsControllerViewController.create(IJamitConstants.STORYBOARD_TAB) as! SettingsControllerViewController
//        controller.submitPodcast = self
//        self.addControllerOnContainer(controller: controller)
//    }
    
    private func addControllerOnContainer(controller : UIViewController){
        controller.view.frame = CGRect(x: 0, y: 0, width: layoutContent.bounds.width, height: layoutContent.bounds.height)
        self.addChild(controller)
        self.layoutContent.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
        self.showOrHideLayoutContainer(true)
    }
    
    public func showOrHideLayoutContainer(_ isShow: Bool) {
        self.layoutContent.isHidden = !isShow
        self.layoutBtAction.isHidden = isShow
    }
    
    @IBAction func submitPodcastTap(_ sender: Any) {
        let msgFormat = StringRes.info_input_required
        let inputTitle = String(format: getString(msgFormat))
        
        guard let feedUrl = podcastRssFeed.text else { return }
        if feedUrl == "" {
            let msgFormat = StringRes.info_feed_url_required_msg
            let feedURLMsg = String(format: getString(msgFormat))
            showAlertWith(title: inputTitle, message: feedURLMsg, positive: nil, negative: nil, completion: nil, cancel: .none)
        } else if country == IJamitConstants.TAG_ALL {
            let msgFormat = StringRes.info_country_required_msg
            let countryRequired = String(format: getString(msgFormat))
            showAlertWith(title: inputTitle, message: countryRequired, positive: nil, negative: nil, completion: nil, cancel: .none)
        } else if language == IJamitConstants.TAG_ALL {
            let msgFormat = StringRes.info_language_required_msg
            let langReq = String(format: getString(msgFormat))
            showAlertWith(title: inputTitle, message: langReq, positive: nil, negative: nil, completion: nil, cancel: .none)
        }
        let params = [
            "feed_url": feedUrl,
            "audio_type": "podcast",
            "country": country.lowercased(),
            "language": language
        ]
        JamItPodCastApi.submitPodcast(params) { response in
            guard let duplicate = response?.duplicate else { return }
            if duplicate {
                guard let message = response?.message else { return }
                let msgFormat = StringRes.info_duplicate_podcast_feed
                let submitTitle = String(format: getString(msgFormat))
                self.showAlertWith(title: submitTitle, message: message, positive: nil, negative: nil, completion: nil, cancel: .none)
            } else {
                if let message = response?.message, message != "" {
                    let msgFormat = StringRes.info_submit_podcast
                    let submitTitle = String(format: getString(msgFormat))
                    self.showAlertWith(title: submitTitle, message: message, positive: nil, negative: nil, completion: nil, cancel: .none)
                }
                if let error = response?.error, error != "" {
                    let msgFormat = StringRes.info_submit_podcast
                    let submitTitle = String(format: getString(msgFormat))
                    self.showAlertWith(title: submitTitle, message: error, positive: nil, negative: nil, completion: nil, cancel: .none)
                }
            }
        }
    }
    
}


extension TabSubmitPodcast : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.podcastRssFeed){
            textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    
}
