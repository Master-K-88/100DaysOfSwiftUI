//
//  MultiRadioController.swift
//  Created by YPY Global on 4/10/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import FRadioPlayer
import Kingfisher
import MediaPlayer
import MarqueeLabel
//import GoogleMobileAds
import NVActivityIndicatorView
import AFNetworking
import Sheeeeeeeeet
import Toast


class MainController: ParentViewController {
    
    @IBOutlet weak var mainHeaderView: UIView!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var controlPlayer: UIStackView!
    @IBOutlet weak var indicatorSmall: NVActivityIndicatorView!
    @IBOutlet weak var btnSmallForward: UIButton!
    @IBOutlet weak var btnSmallRewind: UIButton!
    @IBOutlet weak var btnSmallPlay: UIButton!
    @IBOutlet weak var lblSmallInfo: MarqueeLabel!
    @IBOutlet weak var lblSmallName: UILabel!
    @IBOutlet weak var imgSmall: UIImageView!
    @IBOutlet weak var bottomPlayerView: UIView!
    @IBOutlet weak var miniButton: UIButton!
    @IBOutlet weak var userProfileImg: UIImageView!
    
//    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var segment: Segmentio!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var leaderboardBtn: UIButton!
//    @IBOutlet weak var btnClear: UIButton!
//    @IBOutlet weak var btnSearch: UIButton!
    
//    @IBOutlet weak var tfSearch: UITextField!
//    @IBOutlet weak var btnStartSearch: UIButton!
//    @IBOutlet weak var imgActionBar: UIImageView!
    @IBOutlet weak var bgTab: UIView!
    @IBOutlet weak var btnNoti: UIButton!
    
//    @IBOutlet weak var lblGreeting: UILabel!
    
    @IBOutlet weak var constraintPlayerBottom: NSLayoutConstraint!
    
    var episodeCellViewModel: EpisodeViewModel = EpisodeViewModel()
    
    var viewModel: HomeViewModel = HomeViewModel()
    var categoryViewModel: CatergoryViewModel = CatergoryViewModel()
//    let trendingUsersViewModel = TrendingUsersViewModel()
    
//    viewModel = HomeViewModel()
//    episodeCellViewModel = EpisodeViewModel()
//    categoryViewModel = CatergoryViewModel()
    
    var isShowReview = false
    
    //Controller variable
    var playingVC : PlayingControler!
    
    var selectIndex: Int = 0
    
    //Variable
    var currentSleepTime: Int = 0
    var countDownTimer = Timer()
    
    var currentEpisode : EpisodeModel!
    var listEpisode : [EpisodeModel]!
    
    var isAllCheckNetWorkOff: Bool = false
    
    var libraryVC: TabLibraryController?
    var profileVC : NewTabProfileController?
    var detailShowVC : PodcastDetailController?
    var myStoryVC : StoryController?
    var myDownloadVC : MyDownloadController?
    var friendVC: NewUserProfileController?
    var invitationVC: InvitationEventController?
    
    lazy var viewControllers: [UIViewController] = []
    var countVC = 0
    
    var deeplinkMng: DeepLinkManager?
    var eventDelegate: EventTotalDelegate?
    var menuDelegate: MenuDelegate?
    var dolbySdkManager: DolbySdkManager?
    
    var countingEvent = 0
    var pivotEvent: EventModel?
    var isGoToEvent = false
    
    fileprivate func prepareControllers() -> [UIViewController]  {
        
        var listController = [UIViewController]()
        
//        self.settingsBtn.isHidden = true
        //setup delegate
        let featuredVC = TabHomeController.create(IJamitConstants.STORYBOARD_TAB) as! TabHomeController
        featuredVC.typeVC = IJamitConstants.TYPE_VC_TAB_HOME
        featuredVC.itemDelegate = self
        featuredVC.parentVC = self
        featuredVC.isTab = true
        featuredVC.viewModel = viewModel
        featuredVC.episodeCellViewModel = episodeCellViewModel
//        featuredVC.trendingUsersViewModel = trendingUsersViewModel
        featuredVC.menuDelegate = self.menuDelegate
        featuredVC.isFirstTab = true
        featuredVC.isAllowAddObserver = true
        featuredVC.isShowHeader = true
        featuredVC.isAllowRefresh = true
        featuredVC.isAllowReadCache = true
        featuredVC.isReadCacheWhenNoData = true
        listController.append(featuredVC)
        
        let catVC = NewCategoryController.create(IJamitConstants.STORYBOARD_TAB) as! NewCategoryController
        catVC.typeVC = IJamitConstants.TYPE_VC_TAB_CATEGORIES
        catVC.itemDelegate = self
        catVC.viewModel = categoryViewModel
        catVC.isTab = true
        catVC.parentVC = self
        catVC.isAllowRefresh = true
        catVC.isAllowReadCache = true
        catVC.isReadCacheWhenNoData = true
        listController.append(catVC)
        
        libraryVC = TabLibraryController.create(IJamitConstants.STORYBOARD_TAB) as? TabLibraryController
        libraryVC?.typeVC = IJamitConstants.TYPE_VC_TAB_LIBRARY
        libraryVC?.itemDelegate = self
        libraryVC?.isTab = true
        libraryVC?.parentVC = self
        libraryVC?.isAllowRefresh = true
        libraryVC?.isShowHeader = true
//        libraryVC?.isAllowAddObserver = true
        listController.append(self.libraryVC!)
        
        invitationVC = InvitationEventController.create(IJamitConstants.STORYBOARD_EVENT) as! InvitationEventController
        invitationVC?.eventDelegate = self.eventDelegate
        invitationVC?.dismissDelegate = self
        invitationVC?.isAllowRefresh = true
        invitationVC?.parentVC = self
        
        listController.append(invitationVC!)
        
        return listController
    }
    
    private func segmentioContent() -> [SegmentioItem] {
        var list = [SegmentioItem]()
        // Setting the home controller icon
        list.append(SegmentioItem(title: getString(StringRes.title_tab_discover).uppercased(), image: UIImage(named: ImageRes.ic_tab_home_24dp)))
        // Setting the category controller icon
        list.append(SegmentioItem(title: getString(StringRes.title_tab_categories).uppercased(), image: UIImage(named: ImageRes.ic_tab_category_24dp)))
        // Setting the record controller icon
        list.append(SegmentioItem(title: getString(StringRes.title_tab_records).uppercased(), image: UIImage(named: ImageRes.ic_stories_36dp)))
        // Setting the library controller icon
        list.append(SegmentioItem(title: getString(StringRes.title_tab_library).uppercased(), image: UIImage(named: ImageRes.ic_tab_library_24dp)))
        // Setting the profile controller icon
        list.append(SegmentioItem(title: getString(StringRes.title_tab_profile).uppercased(), image: UIImage(named: ImageRes.ic_notify)))
        return list
    }
    
    
    override func setUpData() {
        super.setUpData()
        greetUser()
//        tfSearch.delegate = self
//        tfSearch.placeholderColor(color: getColor(hex: ColorRes.text_search_hint_color))
        
        //apply customization menu for ActionSheet
        ActionSheet.applyAppearance(SheetMenuAppearance())
        
        StreamManager.shared.delegate = self
        
        //PlayingController
        playingVC = PlayingControler.create(IJamitConstants.STORYBOARD_PLAYING) as? PlayingControler
        playingVC.modalPresentationStyle = .overFullScreen
        playingVC.sleepDelegate = self
        playingVC?.parentVC = self
        
        //init menu delegate
        menuDelegate = MenuDelegate(currentVC: self)
        
        currentSleepTime = SettingManager.getSleepMode()
        viewControllers = self.prepareControllers()
        
//        ToastManager.shared.style.backgroundColor = getColor(hex: ColorRes.toast_bg_color)
//        ToastManager.shared.style.messageColor = getColor(hex: ColorRes.toast_text_color)
        
        //init event delegate
        eventDelegate = EventTotalDelegate(currentVC: self)
        
        //start get detail notification
        startGetNotification()
        
        if StreamManager.shared.isHavingList() {
            showBottomPlayer(true)
            updateInfoOfPlayingTrack(StreamManager.shared.currentModel)
            showPlayerIndicator(StreamManager.shared.isLoading())
            onUpdatePlaybackState(StreamManager.shared.playbackState)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpTab()
        registerDeeplinkObserver()
        onReceiveDeepLink()
        
        //check show review app
        if !self.isShowReview {
            isShowReview = true
            AppStoreReviewManager.requestReviewIfAppropriate(IJamitConstants.FREQ_REVIEW_APP, SettingManager.KEY_COUNT_REVIEW)
        }
        profileVC?.shortTapped()
        initDolbySdk()
        updateUserProfile()
    }
    
    func updateUserProfile() {
        
        let avatar = NewSettingManager.getSetting(NewSettingManager.KEY_USER_AVATAR)
        if avatar.starts(with: "https") {
            self.userProfileImg.kf.setImage(with: URL(string: avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
        }
        else {
            self.userProfileImg.image = UIImage(named: ImageRes.ic_avatar_48dp)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dolbySdkManager?.onDestroy()
        dolbySdkManager = nil
    }
    
    @IBAction func profileButtonTapped() {
        profileVC = NewTabProfileController.create(IJamitConstants.STORYBOARD_TAB) as? NewTabProfileController
        profileVC?.typeVC = IJamitConstants.TYPE_VC_TAB_PROFILE
        profileVC?.parentVC = self
        profileVC?.itemDelegate = self
        profileVC?.menuDelegate = self.menuDelegate
        profileVC?.episodeCellViewModel = episodeCellViewModel
        profileVC?.isTab = true
        profileVC?.isAllowRefresh = true
        profileVC?.isAllowAddObserver = true
        navigationController?.pushViewController(profileVC!, animated: true)
//        self.addControllerOnContainer(controller: profileVC!)
    }
    
    func initDolbySdk() {
        if dolbySdkManager == nil {
            JamitLog.logE("======>initDolbySDK")
            let dolbySdkManager = DolbySdkManager(currentVC: self)
            if dolbySdkManager.isInitiatedDolby {
                dolbySdkManager.loginToDolby()
                dolbySdkManager.registerInvitedEvent(self)
            }
            self.dolbySdkManager = dolbySdkManager
        }
    }
    
     func setUpTab(){
        setupScrollView()
        TabBuilder.buildSegmentioView(
            content: segmentioContent(),
            segmentioView: segment,
            segmentioStyle: SegmentioStyle.onlyImage,
            tabBgColor: UIColor(named: ColorRes.backgroun_color) ?? .black
        )
        segment.selectedSegmentioIndex = selectedSegmentioIndex()
        segment.valueDidChange = { [weak self] _, segmentIndex in
            if segmentIndex == 2 {
                self?.menuDelegate?.showMenuRecord()
                return
            }
            if segmentIndex >= 0 && segmentIndex < 4 {
                self?.settingsBtn.isHidden = true
                self?.leaderboardBtn.isHidden = false
            } else {
                self?.settingsBtn.isHidden = false
            }
            let index = segmentIndex >= 3 ? (segmentIndex - 1) : segmentIndex
            if index >= 0 && index < (self?.viewControllers.count)! {
                self?.selectIndex = index
                if let scrollViewWidth = self?.scrollView.frame.width {
                    let contentOffsetX = scrollViewWidth * CGFloat(index)
                    self?.scrollView.setContentOffset(
                        CGPoint(x: contentOffsetX, y: 0),
                        animated: false
                    )
                }
                if let currentVC = self?.viewControllers[index] as? BaseCollectionController {
                    currentVC.startLoadData()
                }
                
            }
            if segmentIndex == 0 {
//                self?.lblGreeting.isHidden = false
            } else {
//                self?.lblGreeting.isHidden = true
            }
            if segmentIndex == 1 {
                self?.categoryViewModel.catButtonSelected()
            }
        }
        
        segment.isHidden = countVC > 0
        refreshContainerBottom()
    }
    
    fileprivate func greetUser() {
        if SettingManager.isLoginOK() && ApplicationUtils.isOnline() {
            let userName = SettingManager.getSetting(SettingManager.KEY_USER_NAME)
            DispatchQueue.main.async {
//                self.lblGreeting.text = "Hi, \(userName.capitalized)"
            }
        } else {
//            lblGreeting.text = "Hi, Anonymous"
        }
    }

    
    fileprivate func setupScrollView() {
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = false
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: containerView.frame.height
        )
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChild(viewController)
            scrollView.addSubview(viewController.view, options: .useAutoresize)
            viewController.didMove(toParent: self)
        }
    }
    
    
    override func onDoWhenNetworkOn() {
        super.onDoWhenNetworkOn()
        self.isAllCheckNetWorkOff = false
    }
    
    override func onDoWhenNetworkOff() {
        super.onDoWhenNetworkOff()
        let isHavingStream = StreamManager.shared.isHavingList()
        if isHavingStream && !isAllCheckNetWorkOff {
            isAllCheckNetWorkOff = true
            startMusicAction(PlayerAction.LostConnect)
            
            self.showToast(withResId: StringRes.info_connect_to_play)
            self.showPlayerIndicator(false)
            
            if self.playingVC.isViewLoaded && self.playingVC.isVisible {
                self.playingVC.dismiss(animated: true, completion: {
                    self.playingVC.isVisible = false
                    self.showBottomPlayer(false)
                })
                return
            }
            self.showBottomPlayer(false)
            
        }
    }
    
    func showPlayerIndicator (_ isShow: Bool){
        self.controlPlayer.isHidden = isShow
        self.indicatorSmall.isHidden = !isShow
        if(isShow){
            self.indicatorSmall.startAnimating()
        }
        else{
            self.indicatorSmall.stopAnimating()
        }
        self.playingVC.showLoading(isShow)
        
    }
    // Notification button
    private func startGetNotification() {
        let isLogin = SettingManager.isLoginOK()
        if ApplicationUtils.isOnline() &&  isLogin {
            JamItEventApi.getUserNotification { noti in
                JamitLog.logE("====>number noti=\(String(describing: noti?.results))")
                let isResultOk = noti?.isResultOk() ?? false
                self.btnNoti.isHidden = !isResultOk
                let isHasNoti = noti?.isHasNoti ?? false
                let imgRes = isHasNoti ? ImageRes.ic_menu_noti_active_24dp : ImageRes.ic_menu_noti_24dp
                self.btnNoti.setImage(UIImage(named: imgRes), for: .normal)
            }
        }
    }
    
    @IBAction func notiTap(_ sender: Any) {
//        self.goToInvitation()
    }
    // start search button
//    @IBAction func startSearchTapped(_ sender: Any) {
//        if !(tfSearch.text?.isEmpty)!{
//            self.goToSearch(tfSearch.text!)
//            self.hideVirtualKeyboard()
//        }
//    }
    // clear search btn tapped
//    @IBAction func clearTextTapped(_ sender: Any) {
//        if !(tfSearch.text?.isEmpty)!{
//            tfSearch.text = ""
//        }
//        else{
//            self.hideVirtualKeyboard()
//        }
//    }
    // search btn tapped
//    @IBAction func searchTapped(_ sender: Any) {
//        self.imgActionBar.isHidden = true
//        self.searchView.isHidden = false
//        self.btnSearch.isHidden = true
//        self.tfSearch.becomeFirstResponder()
//        self.registerTapOutSideRecognizer()
//    }
    
    // Leaderboard button handler
    @IBAction func leaderboardTapped(_ sender: Any) {
        self.gotoLeaderboard()
    }
    
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
//        self.tfSearch.text = ""
//        self.searchView.isHidden = true
//        self.btnSearch.isHidden = false
//        self.imgActionBar.isHidden = false
        self.unregisterTapOutSideRecognizer()
    }
    
    @IBAction func settinBtnTapped(_ sender: Any) {
        let controller = SettingsControllerViewController.create(IJamitConstants.STORYBOARD_TAB) as! SettingsControllerViewController
        controller.parentVC = self
        self.addControllerOnContainer(controller: controller)
    }
    
    @IBAction func rewindTapped(_ sender: Any) {
        if isAllCheckNetWorkOff && !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_connect_to_play)
            return
        }
        startMusicAction(PlayerAction.Rewind)
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if isAllCheckNetWorkOff && !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_connect_to_play)
            return
        }
        startMusicAction(PlayerAction.TogglePlay)
        episodeCellViewModel.reloadCells?()
        episodeCellViewModel.reloadHomeCells?()
    }
    
    @IBAction func forwardTapped(_ sender: Any) {
        if isAllCheckNetWorkOff && !ApplicationUtils.isOnline() {
            showToast(withResId: StringRes.info_connect_to_play)
            return
        }
        startMusicAction(PlayerAction.Forward)
    }
    
    @IBAction func miniTapped(_ sender: Any) {
        self.present(self.playingVC, animated: true, completion: {
            self.playingVC.isVisible = true
        })
    }
    
    func addControllerOnContainer(controller : UIViewController){
        controller.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
        self.segment.isHidden = true
        self.bgTab.isHidden = true
        self.refreshContainerBottom()
    }
    
    func addProfileControllerOnContainer(controller : UIViewController){
        let width = containerView.bounds.width
        let height = containerView.bounds.height

//        self.view.addProfileBlurEffect()
        controller.view.frame = CGRect(x: 0, y: height * 0.5, width: width, height: height * 0.7)
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
        self.segment.isHidden = true
        self.bgTab.isHidden = true
        self.refreshContainerBottom()
    }
    
    func addBottomSheet(startHP: CGFloat, startVP: CGFloat, width: CGFloat, height: CGFloat, controller : UIViewController){
//        let width = containerView.bounds.width
//        let height = containerView.bounds.height

//        self.view.addProfileBlurEffect()
        controller.view.frame = CGRect(x: startHP, y: startVP, width: width, height: height)
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        self.countVC += 1
        self.segment.isHidden = true
        self.bgTab.isHidden = true
        self.refreshContainerBottom()
    }
    
    func refreshContainerBottom()   {
        let isShowBtPlayer = !self.bottomPlayerView.isHidden
        let isTabHidden = self.segment.isHidden
        let tabHeight = self.segment.frame.height
        var height: CGFloat
        if isTabHidden {
            height = isShowBtPlayer ? DimenRes.bottom_play_height : 0
        }
        else{
            height = tabHeight + (isShowBtPlayer ? DimenRes.bottom_play_height : 0)
        }
        self.containerBottom.constant = height
        self.containerView.layoutIfNeeded()
        
        if isShowBtPlayer {
            self.constraintPlayerBottom.constant = isTabHidden ? 0 : -tabHeight
            self.bottomPlayerView.layoutIfNeeded()
        }
        
    }
    
    func playListEpisodeWithCheckAds(list: [EpisodeModel], episode: EpisodeModel, isDeepLink: Bool = false) {
        let downloadUrl = TotalDataManager.shared.getFileDownloaded(episode)
        if !ApplicationUtils.isOnline() && (downloadUrl == nil || downloadUrl!.isEmpty) {
            showToast(withResId: StringRes.info_connect_to_play)
            return
        }
        let currentEpisode = StreamManager.shared.currentModel
        if(currentEpisode != nil  && currentEpisode != nil && currentEpisode!.id == episode.id){
            return
        }
        if IJamitConstants.FREQ_AUDIO_ADS > 0 && !isDeepLink{
            self.counting = self.counting + 1
            if self.counting%IJamitConstants.FREQ_AUDIO_ADS == 0 && checkShowPopup()  {
                self.startMusicAction(PlayerAction.Pause)
                self.currentEpisode = episode
                self.listEpisode = list
                return
            }
        }
        playListEpisodeWithoutAds(list: list,episode: episode)
        
    }
    
    private func playListEpisodeWithoutAds (list: [EpisodeModel], episode: EpisodeModel){
        let size = list.count
        if size > 0  {
            if StreamManager.shared.isPlayerStopped() {
                let currentSleepTime = SettingManager.getSleepMode()
                startTimer(timer: currentSleepTime)
            }
            self.showBottomPlayer(true)
            updateInfoOfPlayingTrack(episode)
            StreamManager.shared.setListModel(list)
            playEpisode(model: episode)
        }
    }
    
    func playEpisode(model: EpisodeModel!){
        self.btnSmallPlay.setImage(UIImage(named: ImageRes.ic_play_white_36dp), for: .normal)
        let b: Bool = StreamManager.shared.setCurrentModel(model)
        if (b) {
            startMusicAction(PlayerAction.Play)
            updateInfoForIOSMusicWidget()
            self.episodeCellViewModel.reloadCells?()
            episodeCellViewModel.reloadHomeCells?()
        }
    }
    
    func showBottomPlayer (_ isShow: Bool) {
        self.bottomPlayerView.isHidden = !isShow
        self.refreshContainerBottom()
    }
    
    func updateInfoOfPlayingTrack (_ model: EpisodeModel?) {
        if model != nil {
            self.lblSmallName.text = model!.title
            self.lblSmallInfo.text = !model!.getAuthor().isEmpty ? model!.getAuthor() : getString(StringRes.app_name)
            if self.playingVC.isViewLoaded {
                self.playingVC.updateInfo(model, true)
            }
            let imgItem = model!.imageUrl
            if !imgItem.isEmpty && imgItem.starts(with: "http") {
                self.imgSmall.kf.setImage(with: URL(string: imgItem), placeholder:  UIImage(named: ImageRes.img_default))
            }
            else{
                self.imgSmall.image = UIImage(named: ImageRes.img_default)
            }
        }
    }
    
    override func onInterstitialAdClose() {
        super.onInterstitialAdClose()
        if self.isGoToEvent {
            self.isGoToEvent = false
            NavigationManager.shared.goToLive(currentVC: self, event: self.pivotEvent)
            return
        }
        if(self.currentEpisode != nil  && self.listEpisode != nil){
            playListEpisodeWithoutAds(list: self.listEpisode, episode: self.currentEpisode)
        }
    }
    
    override func showToast(with msg: String){
//        self.view.makeToast(msg, duration: 2.0, position: .center)
    }
    
    func goToListShowOfCat(_ model: CategoryModel){
        let showVC = ShowController.create(IJamitConstants.STORYBOARD_SHOW) as! ShowController
        showVC.itemDelegate = self
        showVC.dismissDelegate = self
        showVC.isAllowRefresh = true
        showVC.slugCat = model.slug
        showVC.titleScreen = model.name
        showVC.typeVC = IJamitConstants.TYPE_VC_SHOWS_OF_CATEGORY
        self.addControllerOnContainer(controller: showVC)
    }
    
    override func onReceiveDeepLink() {
        if self.deeplinkMng == nil {
            self.deeplinkMng = DeepLinkManager(currentVC: self)
            self.eventDelegate?.deepLinkMng = self.deeplinkMng
        }
        if let deepLink = TotalDataManager.shared.deepLink {
            self.deeplinkMng?.processDeepLink(deepLink)
            //must reset deep link
            TotalDataManager.shared.deepLink = nil
        }
    }
    
}

extension MainController : SleepDelegate {
    func timeSleep(value: Int, controller: UIViewController) {
        SettingManager.setSleepMode(value)
        
        controller.dismiss(animated: false, completion: nil)
        if value > 0 {
            if StreamManager.shared.isHavingList(){
                startTimer(timer: value)
            }
        }
        else{
            if (self.countDownTimer.isValid) {
                self.countDownTimer.invalidate()
            }
            self.playingVC.resetSleepTimer()
        }
        
    }
    
    func startTimer (timer: Int) {
        self.currentSleepTime = timer * 60 //second
        //reset timer
        if (self.countDownTimer.isValid) {
            self.countDownTimer.invalidate()
        }
        if (self.currentSleepTime > 0) {
            // Start timer
            self.playingVC.updateSleepTime(time: TimeInterval(self.currentSleepTime))
            self.countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerRunning() {
        self.currentSleepTime -= 1
        if (self.currentSleepTime == 0) {
            if (self.countDownTimer.isValid) {
                self.countDownTimer.invalidate()
            }
            startMusicAction(PlayerAction.Stop)
        }
        self.playingVC.updateSleepTime(time: TimeInterval(self.currentSleepTime))
    }
}



//extension MainController : UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        if !(searchTextField.text?.isEmpty)!{
//            let temp = searchTextField.text!
//            self.searchTextField.text = ""
//            self.hideVirtualKeyboard()
//            self.goToSearch(temp)
//        }
//        else {
//            self.hideVirtualKeyboard()
//        }
//        return true
//    }
//}

extension MainController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        segment.selectedSegmentioIndex = Int(currentPage)
    }
    
    fileprivate func selectedSegmentioIndex() -> Int {
        return (self.selectIndex < 2) ? self.selectIndex : (self.selectIndex + 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
    
    fileprivate func goToControllerAtIndex(_ index: Int) {
        segment.selectedSegmentioIndex = index
    }
}

extension MainController: StreamDelegate {
    func onUpdatePlayerState(_ playerState: FRadioPlayerState) {
        switch playerState {
        case .loading:
            showBottomPlayer(true)
            showPlayerIndicator(ApplicationUtils.isOnline())
            updateInfoOfPlayingTrack(StreamManager.shared.currentModel)
            updateInfoForIOSMusicWidget()
            self.sendBroadcastUpdateEpisodeCell()
            break
        case .loadingFinished:
            showPlayerIndicator(false)
            self.playingVC.updateStatusPlayer()
            self.sendBroadcastUpdateEpisodeCell()
            self.episodeCellViewModel.itemSelected?()
            self.episodeCellViewModel.reloadCells?()
            self.episodeCellViewModel.reloadHomeCells?()
            break
        case .error:
            self.showPlayerIndicator(false)
            startMusicAction(PlayerAction.Stop)
            self.onClosePlayer()
            
            let isOnline = ApplicationUtils.isOnline()
            let msgId = isOnline ? StringRes.info_play_error : StringRes.info_error_connect
            showToast(withResId: msgId)
            
            break
        default:
            break
        }
    }
    
    func onUpdatePlaybackState(_ playbackState: FRadioPlaybackState) {
        switch playbackState {
        case .playing:
            self.btnSmallPlay.setImage(UIImage(named: ImageRes.ic_pause_white_36dp), for: .normal)
//            self.episodeCellViewModel.itemSelected?()
            self.episodeCellViewModel.reloadCells?()
            episodeCellViewModel.reloadHomeCells?()
            //check if loading is show , hide it
            if !self.indicatorSmall.isHidden {
                self.showPlayerIndicator(false)
            }
            break
        case .stopped:
            self.btnSmallPlay.setImage(UIImage(named: ImageRes.ic_play_white_36dp), for: .normal)
            self.episodeCellViewModel.itemDeselected?()
            self.episodeCellViewModel.reloadCells?()
            episodeCellViewModel.reloadHomeCells?()
            //if empty list playing , let remove it
            if !StreamManager.shared.isHavingList() {
                self.onClosePlayer()
            }
            break
        default:
            self.btnSmallPlay.setImage(UIImage(named: ImageRes.ic_play_white_36dp), for: .normal)
            break
        }
        self.sendBroadcastUpdateEpisodeCell()
        self.playingVC.updateStatusPlayer()
    }
    
    func onClosePlayer(){
        if !self.bottomPlayerView.isHidden {
            self.showBottomPlayer(false)
        }
        if self.countDownTimer.isValid {
            self.countDownTimer.invalidate()
        }
        self.playingVC.resetSleepTimer()
        self.collapsePlayer()
    }
    
    func collapsePlayer(){
        if self.playingVC.isViewLoaded && self.playingVC.isVisible {
            self.playingVC.dismiss(animated: true) {
                self.playingVC.isVisible = false
            }
        }
    }
    
    func onUpdatePosition(_ current: Float, _ duration: Float) {
        self.playingVC.onUpdatePosition(current, duration)
    }
    
    func sendBroadcastUpdateEpisodeCell(){
        //notify to data
        let episode = StreamManager.shared.currentModel
        if episode != nil {
            let userInfo  = [IJamitConstants.KEY_ID:episode!.id]
            NotificationCenter.default.post(name: Notification.Name(IJamitConstants.BROADCAST_DATA_CHANGE), object: nil, userInfo: userInfo)
        }
        
    }
    
}

extension MainController : AppItemDelegate {
    
    func clickItem(list: [JsonModel], model: JsonModel, position: Int) {
        if model is ShowModel {
            goToDetailShow(model as! ShowModel)
        }
        else if model is UserModel {
            let user = model as! UserModel
            if user.isYourStory() {
                NavigationManager.shared.goToRecording(currentVC: self)
                return
            }
            goToUserStories(user)
        }
        else if model is TopicModel {
            let episodeVC = self.createStoryVC(IJamitConstants.TYPE_VC_DETAIL_TOPIC)
            episodeVC.topic = model as? TopicModel
            self.addControllerOnContainer(controller: episodeVC)
        }
        else if model is CategoryModel {
            self.goToListShowOfCat(model as! CategoryModel)
        }
        else if model is EpisodeModel {
            let episode: EpisodeModel = model as! EpisodeModel
            if episode.isPremium && !MemberShipManager.shared.isPremiumMember() {
                NavigationManager.shared.goToUpgradeMember(currentVC: self)
            }
            else{
                let listEpisode: [EpisodeModel] = list as! [EpisodeModel]
                playListEpisodeWithCheckAds(list: listEpisode, episode:  episode)
            }
        }
    }
    
    func gotoEpisodeDetail(_ model: JsonModel) {
        let episode: EpisodeModel = model as! EpisodeModel
        gotoEpisodeDetailShow(episode)
    }
    
//    func goToInvitation(){
//        let invitationVC = InvitationEventController.create(IJamitConstants.STORYBOARD_EVENT) as! InvitationEventController
//        invitationVC.eventDelegate = self.eventDelegate
//        invitationVC.dismissDelegate = self
//        invitationVC.isAllowRefresh = true
//        invitationVC.parentVC = self
//        self.addControllerOnContainer(controller: invitationVC)
//    }
    
    // Goto leaderboard screen
    func gotoLeaderboard() {
        let leaderbboardVC = LeaderboardController.create(IJamitConstants.STORYBOARD_TAB) as! LeaderboardController
        leaderbboardVC.dismissDelegate = self
        leaderbboardVC.isAllowRefresh = true
        leaderbboardVC.parentVC = self
        self.addControllerOnContainer(controller: leaderbboardVC)
    }
    
    func gotoEpisodeDetailShow(_ model: EpisodeModel) {
        let episodeVC = NewEpisodeDetailController()
        episodeVC.episodeModel = model
        self.addControllerOnContainer(controller: episodeVC)
    }
    
    func goToDetailShow(_ model: ShowModel){
        self.detailShowVC = PodcastDetailController.create(IJamitConstants.STORYBOARD_SHOW) as? PodcastDetailController
        self.detailShowVC?.itemDelegate = self
        self.detailShowVC?.menuDelegate = self.menuDelegate
        self.detailShowVC?.dismissDelegate = self
        self.detailShowVC?.parentVC = self
        self.detailShowVC?.isAllowRefresh = true
        self.detailShowVC?.isAllowAddObserver = true
        self.detailShowVC?.showModel = model
        self.detailShowVC?.typeVC = IJamitConstants.TYPE_VC_DETAIL_SHOW
        self.addControllerOnContainer(controller: self.detailShowVC!)
    }
    
    func goToSearch(_ keyword: String, _ isTag: Bool = false){
        let episodeVC = self.createStoryVC(IJamitConstants.TYPE_VC_SEARCH)
        episodeVC.keyword = keyword
        episodeVC.isTagSearch = isTag
        self.addControllerOnContainer(controller: episodeVC)
    }
    
    func createStoryVC (_ typeVC: Int) -> StoryController {
        let episodeVC = StoryController.create(IJamitConstants.STORYBOARD_STORY) as! StoryController
        episodeVC.itemDelegate = self
        episodeVC.menuDelegate = self.menuDelegate
        episodeVC.isAllowAddObserver = true
        episodeVC.dismissDelegate = self
        episodeVC.isAllowRefresh = true
        episodeVC.typeVC = typeVC
        episodeVC.parentVC = self
        return episodeVC
    }
    
    func goToSocialPage(_ user: UserModel, _ type: Int) {
        let socialInfo = SocialInfoController.create(IJamitConstants.STORYBOARD_USER) as! SocialInfoController
        socialInfo.user = user
        socialInfo.selectIndex = type
        socialInfo.dismissDelegate = self
        socialInfo.itemDelegate = self
        socialInfo.mainCont = self
        self.addControllerOnContainer(controller: socialInfo)
    }
    
    func goToUserStories(_ user: UserModel) {
        if user.userID.isEmpty { return }
        let isMyUser = user.isMyUserId(SettingManager.getUserId())
        if isMyUser {
            self.myStoryVC = self.createStoryVC(IJamitConstants.TYPE_VC_MY_STORIES)
            self.addControllerOnContainer(controller: myStoryVC!)
            return
        }
        self.friendVC = NewUserProfileController.create(IJamitConstants.STORYBOARD_STORY) as? NewUserProfileController
        self.friendVC?.typeVC = IJamitConstants.TYPE_VC_USER_STORIES
        self.friendVC?.itemDelegate = self
//        self.friendVC?.menuDelegate = self.menuDelegate
        self.friendVC?.parentVC = self
        self.friendVC?.userModel = user
//        self.friendVC?.isAllowRefresh = true
//        self.friendVC?.isShowHeader = true
        self.friendVC?.dismissDelegate = self
//        self.friendVC?.isAllowAddObserver = true
        self.addControllerOnContainer(controller: self.friendVC!)
    }
}

extension MainController: DismissDelegate {
    func dismiss(controller: UIViewController) {
        self.countVC -= 1
        if self.countVC <= 0 {
            self.countVC = 0
            self.segment.isHidden = false
            self.bgTab.isHidden = false
            self.refreshContainerBottom()
        }
        self.refreshContainerBottom()
    }
}
extension MainController: DolbyUserInvitedDelegate {
    
    func onUserInvited(_ confId: String, _ event: EventModel) {
        event.roomId = confId
        self.goToLive(event)
    }
    
    func onUserDeclined(_ confId: String, _ event: EventModel) {
        self.showToast(withResId: StringRes.info_declined_event)
    }
    
    func onInvitedError(_ error: NSError?) {
        JamitLog.logE("=======>MainController onInvitedError=\(String(describing: error))")
    }
    
    func goToLive( _ event: EventModel?, _ isShowAds: Bool = true){
        
        // Show advert if necessary
        if IJamitConstants.FREQ_EVENT_ADS > 0 && isShowAds {
            self.countingEvent += 1
            if self.countingEvent % IJamitConstants.FREQ_EVENT_ADS == 0 && checkShowPopup()  {
                self.pivotEvent = event
                self.isGoToEvent = true
                return
            }
        }
        NavigationManager.shared.goToLive(currentVC: self, event: event)
    }
    
}
