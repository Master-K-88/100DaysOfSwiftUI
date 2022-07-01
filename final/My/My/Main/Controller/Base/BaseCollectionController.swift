//
//  BaseCollectionController.swift
//  Created by YPY Global on 4/11/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit

protocol AppItemDelegate{
    func clickItem(list:[JsonModel], model : JsonModel, position: Int)
    
    func gotoEpisodeDetail(_ model: JsonModel)
}

class BaseCollectionController: JamitRootViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNodata : UILabel!
    @IBOutlet var progressBar: UIActivityIndicatorView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var lblMore: UILabel!
    @IBOutlet var indicatorMore: UIActivityIndicatorView!
    @IBOutlet var bottomHeight: NSLayoutConstraint!
    
    var listModels: [JsonModel]?
    var itemsPerRow = 2
    var sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let refreshControl = UIRefreshControl()
    
    var itemDelegate: AppItemDelegate?
    
    var typeVC: Int = 0
    var isAllowRefresh = true
    var isAllowLoadMore = false
    var isOfflineData = false
    var isShowHeader = false
    
    var isTab = false
    var isFirstTab = false
    var isAllowReadCache = false
    var isReadCacheWhenNoData = false
    var isAllowAddObserver = false
    
    var maxPage: Int = IJamitConstants.MAX_PAGE
    var numberItemPerPage: Int = IJamitConstants.NUMBER_ITEM_PER_PAGE
    var isStartLoadData = false
    
    private var isStartAddingPage = false
    private var currentPage: Int = 0
    private var idCell : String = ""
    private var isAllowAddPage = false
    private var isAddObserver = false
    
    var uiType : UIType = .FlatList
    
    var totalDataMng = TotalDataManager.shared
    var widthItemGrid : CGFloat = 0.0
    
    override func setUpUI() {
        super.setUpUI()
        
        self.uiType = getUIType()
        self.setUpCollectionView()
        self.setUpRefresh()
        
        self.lblNodata.text = getString(getStringNoDataID())
        self.lblNodata.isHidden =  true
        
        self.hideFooterView()
        
        addObserverForData()
        setUpCustomizeUI()
        
        if self.isFirstTab || !isTab {
            self.startLoadData()
        }
    }
    
    func setUpCustomizeUI(){
        
    }
    
    
    func startLoadData() {
        if !isStartLoadData {
            isStartLoadData = true
            onLoadData(false,true)
        }
    }
    
    func onRefreshData(_ isNeedHide: Bool){
        if !self.progressBar.isHidden {
            hideRefreshUI()
            return
        }
        if isAllowLoadMore && isStartAddingPage {
            hideRefreshUI()
            return
        }
        onLoadData(true,isNeedHide);
    }
    
    func onLoadData(_ isNeedRefresh: Bool,_ isNeedHideCollectView: Bool) {
        if isNeedRefresh {
            onResetDataCollection()
        }
        if isNeedHideCollectView {
            showLoading(true)
        }
        DispatchQueue.global().async {
            var listModels : [JsonModel]?
            var isNeedCheckOnline: Bool = false
            if self.isOfflineData || (!isNeedRefresh && self.isAllowReadCache && self.typeVC > 0 && !ApplicationUtils.isOnline()){
                listModels = self.getDataFromCache()
            }
            if !self.isOfflineData && (listModels == nil || isNeedRefresh) {
                isNeedCheckOnline = true
                self.getListModelFromServer({resultModel in
                    var isGetNew = false
                    if resultModel != nil && resultModel!.isResultOk() {
                        if self.isAllowReadCache && self.typeVC > 0 {
                            self.totalDataMng.setListCacheData(self.typeVC, resultModel!.listModel!)
                            listModels = self.totalDataMng.getListData(self.typeVC)
                        }
                        if listModels == nil || listModels!.count == 0 {
                            listModels = resultModel!.listModel
                        }
                        isGetNew = true
                    }
                    else{
                        if self.isReadCacheWhenNoData {
                            listModels = self.getDataFromCache()
                        }
                    }
                    self.doOnNextWithListModel(&listModels,0,isGetNew)
                    DispatchQueue.main.async {
                        self.checkResultModel(resultModel, isNeedCheckOnline, listModels)
                    }
                })
                return
            }
            self.doOnNextWithListModel(&listModels,0,false)
            DispatchQueue.main.async {
                self.checkResultModel(nil, isNeedCheckOnline, listModels)
            }
            
        }
    }
    
    func doOnNextWithListModel(_ listModels: inout [JsonModel]?, _ offset: Int, _ isGetNew: Bool) {
        
    }

    func getListModelFromServer(_ completion: @escaping (ResultModel?)->Void){}

    private func onLoadNextModel() {
        showFooterView()
        if !ApplicationUtils.isOnline() || self.listModels == nil || self.listModels?.count == 0 {
            self.isStartAddingPage = false
            hideFooterView()
            hideRefreshUI()
            return
        }
        DispatchQueue.global().async {
            let originalSize: Int  = self.listModels!.count
            let offset = self.currentPage * self.numberItemPerPage
            self.getListModelFromServer(offset, self.numberItemPerPage, {resultModel in
                var listLoadMores = resultModel != nil && resultModel!.isResultOk() ? resultModel!.listModel : nil
                let sizeLoaded = listLoadMores != nil ? listLoadMores!.count :0
                let isLoadOkNumberItem = sizeLoaded >= self.numberItemPerPage
                self.doOnNextWithListModel(&listLoadMores,originalSize,true)
                
                DispatchQueue.main.async {
                    self.hideFooterView()
                    self.hideRefreshUI()
                    self.isAllowAddPage =  isLoadOkNumberItem && self.currentPage < self.maxPage
                    if self.isAllowAddPage {
                        self.currentPage += 1
                    }
                    if sizeLoaded > 0 {
                        for model in listLoadMores! {
                            self.listModels!.append(model)
                        }
                        self.collectionView.reloadData()
                    }
                    self.isStartAddingPage = false
                }
                
            })
        }
        
    }
    
    
    func getListModelFromServer(_ offset: Int, _ limit: Int, _ completion: @escaping (ResultModel?)->Void){
        
    }
    
    private func checkResultModel(_ resultModel: ResultModel?, _ isNeedCheckOnline: Bool, _ listModel:[JsonModel]?){
        showLoading(false)
        hideRefreshUI()
        if isNeedCheckOnline && (resultModel == nil || !resultModel!.isResultOk()){
            if isReadCacheWhenNoData {
                self.setUpInfo(listModel)
                return
            }
            let msg = resultModel != nil && ApplicationUtils.isOnline() ? resultModel!.msg : getString(getStringNoDataID())
            if(!msg.isEmpty){
                self.showResult(msg)
                return
            }
            let msgId = !ApplicationUtils.isOnline() ? StringRes.info_error_connect : getStringNoDataID()
            self.showResult(withResId: msgId)
            return
        }
        setUpInfo(listModel)
        
        
    }
    
    func getUIType() -> UIType {
        return .FlatList
    }
      
    func setUpRefresh(){
        if(isAllowRefresh){
            self.refreshControl.tintColor = getColor(hex: ColorRes.color_pull_to_refresh)
            self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            self.collectionView.refreshControl = refreshControl
        }
    }
    
    @objc private func pullToRefresh() {
        onRefreshData(false)
    }

    
    private func onResetDataCollection(){
        isAllowAddPage = false
        isStartAddingPage = false
        currentPage = 0
    }
    
    private func hideFooterView () {
        if self.footerView != nil && !self.footerView.isHidden {
            self.indicatorMore.stopAnimating()
            self.bottomHeight.constant = 0
            self.footerView.isHidden = true
            self.footerView.layoutIfNeeded()
        }
        
    }
    private func showFooterView () {
        if self.footerView != nil && self.footerView.isHidden {
            self.bottomHeight.constant = 54
            self.footerView.isHidden = false
            self.footerView.layoutIfNeeded()
            self.indicatorMore.startAnimating()
        }
    }
    
    private func checkAllowLoadMore(_ sizeLoaded: Int) -> Bool {
        let page: Int = Int(CGFloat(sizeLoaded) / CGFloat(numberItemPerPage))
        if page < maxPage && sizeLoaded >= numberItemPerPage {
            return true
        }
        return false
    }
    
    func setUpInfo(_ listModel: [JsonModel]?){
        let size = listModel?.count ?? 0
        self.listModels?.removeAll()
        self.listModels = listModel
        self.collectionView.isHidden = false
        if size > 0 {
            self.collectionView.reloadData()
            if isAllowLoadMore {
                self.currentPage = self.currentPage + 1
                self.isAllowAddPage = checkAllowLoadMore(listModel!.count)
            }
        }
        else {
            self.collectionView.reloadData()
        }
        if !self.isShowHeader {
            self.updateInfo()
        }
    }
    
    func updateInfo() {
        let size = self.listModels?.count ?? 0
        self.lblNodata.isHidden = size > 0
        if size == 0 {
            self.lblNodata.text = getString(getStringNoDataID())
        }
    }
    
    func hideRefreshUI() {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
 
    @objc func onBroadcastDataChanged(notification:Notification) -> Void {
        guard let typeVC: Int = notification.userInfo![IJamitConstants.KEY_VC_TYPE] as? Int else {
            self.notifyWhenDataChanged()
            return
        }
        if self.typeVC == typeVC {
            notifyWhenDataChanged()
            return
        }
        self.updateFavorite(notification: notification)
    }
    
    func updateFavorite(notification:Notification){
        guard let id: String = notification.userInfo![IJamitConstants.KEY_ID] as? String else {
            notifyWhenDataChanged()
            return
        }
        guard let likesDatas : [String] = notification.userInfo![IJamitConstants.KEY_LIKE_DATA] as? [String] else {
            notifyWhenDataChanged()
            return
        }
        DispatchQueue.global().async {
            if self.listModels != nil && self.listModels!.count > 0 {
                guard let indexItem: Int = self.listModels!.firstIndex(where: {
                    let episode: EpisodeModel = ($0 as? EpisodeModel)!
                    return episode.id.elementsEqual(id)
                }) else{
                    return
                }
                DispatchQueue.main.async {
                    let episode = self.listModels![indexItem] as? EpisodeModel
                    episode!.likes = likesDatas
                    self.notifyWhenDataChanged()
                }
            }
        }
    }
   
    
    func getIDCellOfCollectionView () -> String {
        return ""
    }
    
    func notifyWhenDataChanged () {
        self.collectionView.reloadData()
    }
    
    func setUpCollectionView(){
        let idCell: String = getIDCellOfCollectionView()
        if(!idCell.isEmpty){
            guard idCell != "NewEpisodeFlatListCell" else {
                collectionView.register(NewEpisodeFlatListCell.self, forCellWithReuseIdentifier: NewEpisodeFlatListCell.identifier)
                self.idCell = idCell
                self.setUpUIType()
                return
            }
            collectionView.register(UINib(nibName: idCell, bundle: nil), forCellWithReuseIdentifier: idCell)
           
            
        }
        self.idCell = idCell
        self.setUpUIType()
    }
    
    private func setUpUIType(){
        if uiType == .FlatList{
            sectionInsets.left = 0.0
            sectionInsets.right = 0.0
            sectionInsets.top = 0.0
            sectionInsets.bottom = 0.0
        }
        else if uiType == .FlatGrid || uiType == .CardGrid {
            sectionInsets.left = 10.0
            sectionInsets.right = 10.0
            sectionInsets.top = 10.0
            sectionInsets.bottom = 10.0
            let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            self.widthItemGrid = availableWidth / CGFloat(itemsPerRow)
        }
    }
    
    func renderCell(cell: UICollectionViewCell, model: JsonModel) {
        
    }
    
    func getStringNoDataID() -> String{
        return StringRes.title_no_data
    }
    
    func getDataFromCache () -> [JsonModel]? {
        return getDataFromCache(typeVC)
    }
    
    func getDataFromCache (_ type: Int) -> [JsonModel]? {
        var mListModels = self.totalDataMng.getListData(type)
        if mListModels == nil {
            totalDataMng.readTypeData(type)
            mListModels = self.totalDataMng.getListData(type)
        }
        return mListModels
    }
    
    func showLoading (_ isShow: Bool) {
        self.progressBar.isHidden = !isShow
        if(isShow){
            self.progressBar.startAnimating()
            self.lblNodata.isHidden = true
            self.collectionView.isHidden = true
        }
        else{
            self.progressBar.stopAnimating()
        }
    }
    
    func showResult( withResId: String){
        showResult(getString(withResId))
    }
    
    func showResult(_ msg: String){
        self.lblNodata.text = msg
        let sizeResult = self.listModels?.count ?? 0
        self.lblNodata.isHidden = sizeResult > 0
        if sizeResult > 0  {
            self.showToast(with: msg)
        }
    }
    
    func convertListModelToResult(_ list: [JsonModel]?) -> ResultModel {
        let size = list?.count ?? -1
        let resultModel = ResultModel(size >= 0 ? 200 : -1, size >= 0 ? "success" : getString(getStringNoDataID()))
        resultModel.listModel = list
        return resultModel
    }
   
    private func addObserverForData () {
        if isAllowAddObserver {
            if !isAddObserver {
                isAddObserver = true
                NotificationCenter.default.addObserver(self, selector: #selector(onBroadcastDataChanged(notification:)), name: NSNotification.Name(rawValue: IJamitConstants.BROADCAST_DATA_CHANGE), object: nil)
            }
        }
        
    }
    
    func removeObserverForData() {
        if isAddObserver {
            isAddObserver  = false
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func deleteModel(_ model: JsonModel){
        let size = listModels?.count ?? 0
        if size <= 0 { return }
        guard let indexItem: Int = self.listModels?.firstIndex(where: {
            return $0.equalElement(model)
        }) else{
            return
        }
        self.listModels?.remove(at: indexItem)
        self.notifyWhenDataChanged()
        if !self.isShowHeader {
            self.updateInfo()
        }
    }

}

extension BaseCollectionController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idCell, for: indexPath)
        if self.listModels != nil {
            let item = self.listModels![indexPath.row]
            self.renderCell(cell: cell, model: item)
        }
        return cell
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pos: Int = indexPath.row
        if self.listModels != nil {
            let item = self.listModels![pos]
            self.itemDelegate?.clickItem(list: listModels!, model: item, position: pos)
        }
    }
    
    
}

extension BaseCollectionController: UICollectionViewDelegateFlowLayout{
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch uiType {
        case .FlatList :
            let paddingSpace = sectionInsets.left * CGFloat(2)
            let availableWidth = view.frame.width - paddingSpace
            let sizeHeight = view.frame.width * 0.28
            return CGSize(width: availableWidth, height: CGFloat(sizeHeight))
        case .CardGrid, .FlatGrid:
            return CGSize(width: widthItemGrid, height: widthItemGrid)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if uiType == .FlatList{
            return 0
        }
        else if  uiType == .FlatGrid {
            return DimenRes.flat_grid_row_spacing
        }
        return DimenRes.card_grid_row_spacing
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if uiType == .FlatList{
            return 0
        }
        return DimenRes.grid_column_spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = indexPath.item
        let count = self.listModels?.count ?? -1
        if item == count - 1 && isAllowAddPage {
            if !isStartAddingPage {
                isStartAddingPage = true
                onLoadNextModel()
            }
        }
        
    }
    
   
    
}

