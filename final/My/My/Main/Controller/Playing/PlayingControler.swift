//
//  Created by YPYGlobal on 1/9/19.
//  Copyright © 2019 YPYGlobal. All rights reserved.
//

import MediaPlayer
import UIKit
import FRadioPlayer
import MarqueeLabel
import NVActivityIndicatorView

class PlayingControler : ParentViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    @IBOutlet weak var controlPlayer: UIView!
    @IBOutlet weak var indicatorPlayer: NVActivityIndicatorView!
    
    @IBOutlet weak var seekBar: UISlider!
    
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblDuration: UILabel!

    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var btnPlay: UIView!
    
    @IBOutlet weak var lblDragDropTile: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lblSong: UILabel!
    @IBOutlet weak var lblArtist: MarqueeLabel!
    
    @IBOutlet var visualEffect: UIVisualEffectView!
    
    @IBOutlet weak var btnGetPremium: UIButton!
    @IBOutlet weak var layoutPageContainer: UIView!
    
    @IBOutlet weak var btnTweet: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var layoutSeekBar: UIStackView!
    @IBOutlet var lblSleepTimer: UILabel!
    
    var sleepDelegate : SleepDelegate?
    var playingHomeVC : PlayingHomeController?
    var playingInfoVC: PlayingInfoController?
    var parentVC: MainController?
    var download: BackgroundDownload?
    
    let volumeView = MPVolumeView()
    
    // check playing control visible or not
    var isVisible : Bool = false
    var tempValue: Float = 0.0
    
    private var pageViewController: UIPageViewController!
    
    private var currentIndex: Int = 0
    private var pendingIndex: Int = 0
    
    fileprivate lazy var viewControllers: [JamitRootViewController] = {
        var listControllers:[JamitRootViewController] = []
        
        self.playingHomeVC = PlayingHomeController.create(IJamitConstants.STORYBOARD_PLAYING) as? PlayingHomeController
        listControllers.append(self.playingHomeVC!)
        
        self.playingInfoVC = PlayingInfoController.create(IJamitConstants.STORYBOARD_PLAYING) as? PlayingInfoController
        self.playingInfoVC?.parentVC = self
        listControllers.append(self.playingInfoVC!)
        
        return listControllers
    }()
    
    override func setUpUI() {
        super.setUpUI()
        setUpColorForUI()
        
        //update player
        updateInfo(true)
        
        self.btnGetPremium.isHidden = MemberShipManager.shared.isPremiumMember()
        self.showLoading(StreamManager.shared.isLoading())
        self.updateStatusPlayer()
        self.initPageController()
        
        let currentSleepTime = SettingManager.getSleepMode()
        if currentSleepTime > 0 {
            self.lblSleepTimer.isHidden = false
            updateSleepTime(time: TimeInterval(currentSleepTime*60))
        }
    }
    
    private func initPageController () {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.view.frame = self.layoutPageContainer.bounds
        
        self.pageViewController.setViewControllers([self.viewControllers[self.currentIndex]], direction: .forward, animated: true, completion: nil)
        self.addViewControllerToRootView(controller: self.pageViewController, rootLayout: self.layoutPageContainer)
       
    }
    
    func showLoading (_ isShow: Bool){
        if !self.isViewLoaded { return }
        self.controlPlayer.isHidden = isShow
        self.layoutSeekBar.isHidden = isShow
        self.indicatorPlayer.isHidden = !isShow
        if isShow {
            self.indicatorPlayer.startAnimating()
            self.lblCurrentTime.text = "00:00"
            self.lblDuration.text = "00:00"
        }
        else{
            self.indicatorPlayer.stopAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //update animation and volume
        self.registerObserverBackForeGround()
        self.onMoveToForeground()
        self.isVisible = true
        self.btnGetPremium.isHidden = MemberShipManager.shared.isPremiumMember()
       
        self.download?.completionHandler = { message in
            DispatchQueue.main.async {
                self.showAlertWith(title: StringRes.downloading_in_background, message: message)
                self.showToast(with: message)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.onMoveToBackground()
        self.unregisterObserverBackForeGround()
        
    }
    
    private func setupPlayIcon() {
        NSLayoutConstraint.activate([
            btnPlay.widthAnchor.constraint(equalToConstant: btnPlay.layer.frame.height),
            
        ])
    }

    func setUpColorForUI () {
        self.seekBar.tintColor = getColor(hex: ColorRes.color_volume_slider)
        self.seekBar.thumbTintColor = getColor(hex: ColorRes.color_volume_thumb_slider)
                
        let colorMain = getColor(hex: ColorRes.play_color_text)
        let colorSecondMain = getColor(hex: ColorRes.play_color_secondary_text)
        
        self.lblDragDropTile.textColor = colorMain
        self.lblTags.textColor = colorSecondMain
        
        self.lblSong.textColor = colorMain
        self.lblArtist.textColor = colorSecondMain
        self.indicatorPlayer.color = colorMain
        self.lblSleepTimer.textColor = colorMain
        self.lblSleepTimer.isHidden = true
        self.visualEffect.isHidden = !IJamitConstants.USE_BLUR_EFFECT

    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func updateInfo (_ isNeedUpdateSocial: Bool) {
        if !self.isViewLoaded { return }
        let currentModel = StreamManager.shared.currentModel
        updateInfo(currentModel, isNeedUpdateSocial)
    }
    
    func updateInfo ( _ currentModel: EpisodeModel?, _ isNeedUpdateSocial: Bool) {
        if currentModel != nil {
            self.lblDragDropTile.text = currentModel!.title
            self.lblSong.text = currentModel!.title
            
            let author = !currentModel!.getAuthor().isEmpty ? currentModel!.getAuthor() : getString(StringRes.app_name)
            self.lblTags.text = author
            self.lblArtist.text = author
            
            self.playingHomeVC?.updateImage()
            self.playingInfoVC?.updateInfo()
            self.selectPageVC(self.playingHomeVC)
            
            if isNeedUpdateSocial {
                let isFileDownloaded = TotalDataManager.shared.isFileDownloaded(currentModel!)
                let isAllowShowDownload = !isFileDownloaded
                
                let img = isAllowShowDownload ? ImageRes.ic_download_white_36dp : ImageRes.ic_downloaded_36dp
                let imgDownload = UIImage(named: img)
                DispatchQueue.main.async {
                    self.btnDownload.setImage(imgDownload, for: .normal)
                    self.btnDownload.isHidden = false
                    self.btnDownload.isEnabled = isAllowShowDownload
                    self.updateLikeButton()
                    self.setupPlayIcon()
                    self.btnPlay.layer.cornerRadius = self.btnPlay.layer.frame.height / 2
                }
                
            }
        }
        
    }
    

    func updateStatusPlayer(){
        if !self.isViewLoaded { return }
        let isPlaying  = StreamManager.shared.isPlaying()
        if isPlaying {
            self.imgPlayer.image = UIImage(named: ImageRes.ic_pause_white_36dp)
        }
        else{
            self.imgPlayer.image = UIImage(named: ImageRes.ic_play_white_36dp)
        }
        self.setupPlayIcon()
        self.btnPlay.layer.cornerRadius = btnPlay.layer.frame.height / 2
    }
    
    func onUpdatePosition(_ current: Float, _ duration: Float) {
        if duration >  0 && self.lblCurrentTime != nil {
            self.lblCurrentTime.text = getFormatTimeMusic(current)
            self.lblDuration.text = getFormatTimeMusic(duration)
            let progress = Float(current/duration)
            self.seekBar.value = progress
            if progress >= 1.0 {
                self.seekBar.value = 0.0
            }
        }
    }
    
    private func getFormatTimeMusic(_ second: Float) -> String {
        if let duration = TimeInterval(exactly: second) {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second ]
            formatter.zeroFormattingBehavior = [ .pad ]
            let formattedDuration = formatter.string(from: duration)
            return formattedDuration!
        }
        return "00:00"
        
    }
    
    @IBAction func seekBarValueChange(_ sender: Any) {
        self.tempValue = self.seekBar.value
    }
    
    @IBAction func seekBarTap(_ sender: Any) {
        if self.tempValue > 0 {
            StreamManager.shared.onSeek(percent: self.tempValue)
        }
    }

    @IBAction func premiumTap(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.isVisible = false
            NavigationManager.shared.goToUpgradeMember(currentVC: self.parentVC)
        })
    }
    
    @IBAction func playTapped(_ sender: Any) {
         StreamManager.shared.startMusicAction(action: PlayerAction.TogglePlay)
    }
    
    @IBAction func dropDown(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.isVisible = false
        })
    }
    
    func goToSearchTag(_ tag: String){
        self.dismiss(animated: true, completion: {
            self.isVisible = false
            self.parentVC?.goToSearch(tag, true)
        })
    }
    
    
    @IBAction func prevTap(_ sender: Any) {
        StreamManager.shared.startMusicAction(action: .Previous)
    }
    
    @IBAction func rewindTapped(_ sender: Any) {
        StreamManager.shared.startMusicAction(action: .Rewind)
    }
    
    @IBAction func fastForwardTapped(_ sender: Any) {
        StreamManager.shared.startMusicAction(action: .Forward)
    }
    
    @IBAction func nextTap(_ sender: Any) {
        StreamManager.shared.startMusicAction(action: .Next)
    }
    
    @IBAction func tweetTap(_ sender: Any) {
        if let currentModel = StreamManager.shared.currentModel {
            self.shareWithDeepLink(currentModel, sender as? UIView, {
                self.tweetToTwitter(currentModel)
            })
        }
    }
    
    // Download Tapped
    @IBAction func downloadTapped(_ sender: Any) {
//        self.addBadge(itemvalue: String("1"))
        let currentModel = StreamManager.shared.currentModel
        if let currentModel = currentModel {
            download?.startListenOffline(episode: currentModel)
            self.btnDownload.isEnabled = false
//            NavigationManager.shared.goToListenOffline(currentVC: self, episode: currentModel!)
        }
    }
    
    @IBAction func likeTap(_ sender: Any) {
        let episode = StreamManager.shared.currentModel
        if episode != nil {
            let isFav = !episode!.isFavorite(SettingManager.getUserId())
            self.parentVC?.menuDelegate?.updateFavorite(episode!, IJamitConstants.TYPE_PLAYING, isFav)
        }
    }
    
    func updateLikeButton()  {
        if !self.isViewLoaded { return }
        let episode = StreamManager.shared.currentModel
        if episode != nil {
            let isLike = episode!.isFavorite(SettingManager.getUserId())
            self.btnLike.setImage(UIImage(named: isLike ? ImageRes.ic_heart_pink_36dp: ImageRes.ic_heart_outline_white_36dp), for: .normal)
        }
    }
    
    //this function from list of episode comments
    func goToUserStories(_ user: UserModel) {
        self.dismiss(animated: false, completion: {
            self.isVisible = false
            self.parentVC?.goToUserStories(user)
        })
    }
    
    //this function from list of episode comments
    func goToLogin(_ msg: String? = nil) {
        self.dismiss(animated: false, completion: {
            self.isVisible = false
            NavigationManager.shared.goToLogin(currentVC: self.parentVC,msg: msg)
        })
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        if let currentModel = StreamManager.shared.currentModel {
            self.shareWithDeepLink(currentModel, sender as? UIView)
        }
    }
    
    @IBAction func sleepTap(_ sender: Any) {
        let control = SleepController.create(IJamitConstants.STORYBOARD_DIALOG) as! SleepController
        control.delegate = self.sleepDelegate
        self.present(control, animated: false, completion: nil)
    }
    
    @IBAction func chatTapped(_ sender: Any) {
        if let currentModel = StreamManager.shared.currentModel {
            let commentVC = CommentController.create(IJamitConstants.STORYBOARD_COMMENT) as! CommentController
            commentVC.episode = currentModel
            commentVC.parentVC = self
            commentVC.modalPresentationStyle = .overFullScreen
            self.present(commentVC, animated: true, completion: nil)
        }
     
    }
        
    func updateSleepTime (time : TimeInterval) {
        if !self.isViewLoaded { return }
        if self.lblSleepTimer.isHidden {
            self.lblSleepTimer.isHidden = false
        }
        self.lblSleepTimer.text = convertToStringTime(time: time)
    }
    
    func resetSleepTimer () {
        if !self.isViewLoaded { return }
        self.lblSleepTimer.isHidden = true
    }
    
    //ui page controller delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! JamitRootViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        }
        return self.viewControllers[previousIndex]
    }
    
    //ui page controller delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! JamitRootViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        if nextIndex >= self.viewControllers.count {
            return nil
        }
        return self.viewControllers[nextIndex]
    }
    
    //ui page controller delegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = self.viewControllers.firstIndex(of: pendingViewControllers.first as! JamitRootViewController)!
    }
    
    //ui page controller delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.selectPage(self.pendingIndex)
        }
    }
    
    func selectPageVC(_ vc: UIViewController?){
        if self.pageViewController != nil && vc != nil {
            guard let viewControllerIndex = self.viewControllers.firstIndex(of: vc as! JamitRootViewController) else {
                return
            }
            self.pageViewController.setViewControllers([vc!], direction: .forward, animated: true, completion: nil)
            self.selectPage(viewControllerIndex)
        }
    }
    
    func selectPage(_ page: Int) {
        self.currentIndex = page
    }
    
    func addViewControllerToRootView(controller : UIViewController, rootLayout: UIView){
        controller.view.frame = CGRect(x: 0, y: 0, width: rootLayout.bounds.width, height: rootLayout.bounds.height)
        self.addChild(controller)
        rootLayout.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
//    func addBadge(itemvalue: String) {
//        print("The item value is: \(itemvalue)")
//          let bagButton = BadgeButton()
//          bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
//        bagButton.tintColor = UIColor.white // UIColor.darkGray
//          bagButton.setImage(UIImage(named: "ic_download_white_36dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
//          bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
//          bagButton.badge = itemvalue
////        self.navigationItem.rightBarButtonItem.append(UIBarButtonItem(customView: bagButton))
//        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: bagButton))
//      }
}

