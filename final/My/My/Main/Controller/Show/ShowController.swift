//
//  GenreController.swift
//  Created by YPY Global on 4/11/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import Sheeeeeeeeet

class ShowController: BaseCollectionController{
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var filterHeader: UIView!
    @IBOutlet weak var btnFilterCoutry: UIView!
    @IBOutlet weak var btnFilterLan: UIView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    
    var titleScreen: String?
    var slugCat: String?
    
    var country = IJamitConstants.TAG_ALL
    var language = IJamitConstants.TAG_ALL
    
    var dismissDelegate: DismissDelegate?
    
    override func setUpUI() {
        self.lblTitle.text = self.titleScreen
        self.filterHeader.isHidden = self.typeVC != IJamitConstants.TYPE_VC_SHOWS_OF_CATEGORY
        self.lblCountry.text = getString(StringRes.title_select_country).uppercased()
        self.lblLanguage.text = getString(StringRes.title_select_language).uppercased()
        super.setUpUI()
    }

    override func getUIType() -> UIType {
        return .FlatGrid
    }
    
    @IBAction func countryTap(_ sender: Any) {
        self.startGetCountries(isGetOnline: true)
    }
    
    @IBAction func lanTap(_ sender: Any) {
        self.startGetLanguages(isGetOnline: true)
    }
    
    private func startGetLanguages(isGetOnline: Bool){
        let jamItLocale = TotalDataManager.shared.jamItLocale
        if jamItLocale != nil && !jamItLocale!.isEmptyLan() {
            self.showDropDown(pivotView: self.btnFilterLan, titleId: StringRes.title_select_language,
                              lists: jamItLocale!.languages!) { (selectedItem) in
                self.lblLanguage.text = selectedItem.getFullName().uppercased()
                self.language = selectedItem.code
                self.isStartLoadData = false
                self.startLoadData()
            }
            return
        }
        if isGetOnline {
            self.startGetJamItLocale {
                self.startGetLanguages(isGetOnline: false)
            }
        }
        
    }
    
    private func startGetCountries(isGetOnline: Bool){
        let jamItLocale = TotalDataManager.shared.jamItLocale
        if jamItLocale != nil && !jamItLocale!.isEmptyLan() {
            self.showDropDown(pivotView: self.btnFilterCoutry, titleId: StringRes.title_select_country,
                              lists: jamItLocale!.countries!) { (selectedItem) in
                self.lblCountry.text = selectedItem.getFullName().uppercased()
                self.country = selectedItem.code
                self.isStartLoadData = false
                self.startLoadData()
            }
            return
        }
        if isGetOnline {
            self.startGetJamItLocale {
                self.startGetCountries(isGetOnline: false)
            }
        }
        
    }
    
    private func startGetJamItLocale(_ completion: @escaping () -> Void) {
        if !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        JamItPodCastApi.getJamItLocales { (responce) in
            self.dismissProgress()
            if responce == nil {
                self.showToast(withResId: StringRes.info_server_error)
                return
            }
            if let local = responce {
                if !local.isEmptyLan() || !local.isEmptyCountry() {
                    TotalDataManager.shared.jamItLocale = local
                    completion()
                }
            }
        }
        
    }

    
    private func showDropDown(pivotView: UIView, titleId: String, lists: [LocaleModel], _ completion: @escaping (LocaleModel) -> Void){
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
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
       if ApplicationUtils.isOnline() {
            if self.typeVC == IJamitConstants.TYPE_VC_FEATURED_PODCASTS {
                JamItPodCastApi.getFeaturedPodcast { (list) in
                    completion(self.convertListModelToResult(list))
                }
            }
            else if self.typeVC == IJamitConstants.TYPE_VC_FEATURED_AUDIO_BOOK {
                JamItPodCastApi.getFeaturedAudioBooks{ (list) in
                    completion(self.convertListModelToResult(list))
                }
            }
            else if self.typeVC == IJamitConstants.TYPE_VC_SHOWS_OF_CATEGORY && self.slugCat != nil && !self.slugCat!.isEmpty {
                JamItPodCastApi.getShowOfCategory(self.slugCat!, country,language) { (list) in
                    completion(self.convertListModelToResult(list))
                }
            }
            return
        }
        completion(nil)
        
    }

    override func getIDCellOfCollectionView() -> String {
        return String(describing: ShowCardGridCell.self)
    }
    
    override func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        let item = model as! ShowModel
        let cell = cell as! ShowCardGridCell
        cell.updateUI(item)
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
            self.dismissDelegate?.dismiss(controller: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func getStringNoDataID() -> String {
        return StringRes.title_no_show
    }
}
