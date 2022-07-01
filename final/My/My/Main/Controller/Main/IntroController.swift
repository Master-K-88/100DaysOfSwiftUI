//
//  IntroController.swift
//  jamit
//
//  Created by YPY Global on 4/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class IntroController: JamitRootViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate {
  
    private let TIME_PAGE_CHANGE = 8.0
    
    @IBOutlet weak var kernBurnsView: JBKenBurnsView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var firstPageIndicator: UIButton!
    @IBOutlet weak var secondPageIndicator: UIButton!
    @IBOutlet weak var thirdPageIndicator: UIButton!
    @IBOutlet weak var fourthPageIndicator: UIButton!
    @IBOutlet weak var fifthPageIndicator: UIButton!
    private var arrayHelpModels : [HelpModel]!
    private var pageViewController: UIPageViewController!
    
    // Track the current index
    private var currentIndex: Int = 0
    private var pendingIndex: Int = 0
    private var autoChangeTimer = Timer()
    
    fileprivate lazy var viewControllers: [HelpChildController] = {
        var listControllers:[HelpChildController] = []
        let count = self.arrayHelpModels.count
        for i in 1...count {
           listControllers.append(self.createViewControllerAtIndex(index: i-1))
        }
        return listControllers
    }()
    
    override func setUpUI() {
        super.setUpUI()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        self.createHelpModels()
        self.initPageController()
        self.schedulePageChange()
        self.registerObserverBackForeGround()
        clearState()
        firstPageIndicator.backgroundColor = getColor(hex: "#FFAE29")
        firstPageIndicator.setTitleColor(.black, for: .normal)
    }
    
    func changeViewState(index: Int) {
        switch index {
        case 0:
            clearState()
            btnBack.isHidden = true
            firstPageIndicator.backgroundColor = getColor(hex: "#FFAE29")
            firstPageIndicator.setTitleColor(.black, for: .normal)
        case 1:
            clearState()
            btnBack.isHidden = false
            secondPageIndicator.backgroundColor = getColor(hex: "#FFAE29")
            secondPageIndicator.setTitleColor(.black, for: .normal)
        case 2:
            clearState()
            btnBack.isHidden = false
            thirdPageIndicator.backgroundColor = getColor(hex: "#FFAE29")
            thirdPageIndicator.setTitleColor(.black, for: .normal)
        case 3:
            clearState()
            btnBack.isHidden = false
            fourthPageIndicator.backgroundColor = getColor(hex: "#FFAE29")
            fourthPageIndicator.setTitleColor(.black, for: .normal)
        case 4:
            clearState()
            btnBack.isHidden = false
            fifthPageIndicator.backgroundColor = getColor(hex: "#FFAE29")
            fifthPageIndicator.setTitleColor(.black, for: .normal)
        default:
            clearState()
        }
    }
    
    func clearState() {
        firstPageIndicator.backgroundColor = getColor(hex: "#212130")
        firstPageIndicator.setTitleColor(getColor(hex: "#686881"), for: .normal)
        secondPageIndicator.backgroundColor = getColor(hex: "#212130")
        secondPageIndicator.setTitleColor(getColor(hex: "#686881"), for: .normal)
        thirdPageIndicator.backgroundColor = getColor(hex: "#212130")
        thirdPageIndicator.setTitleColor(getColor(hex: "#686881"), for: .normal)
        fourthPageIndicator.backgroundColor = getColor(hex: "#212130")
        fourthPageIndicator.setTitleColor(getColor(hex: "#686881"), for: .normal)
        fifthPageIndicator.backgroundColor = getColor(hex: "#212130")
        fifthPageIndicator.setTitleColor(getColor(hex: "#686881"), for: .normal)
    }
    
    override func onMoveToBackground() {
        self.cancelTask()
    }
    
    override func onMoveToForeground() {
        self.schedulePageChange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let images = [UIImage(named: ImageRes.bg_intro)!]
        SettingManager.setBoolean(SettingManager.KEY_SHOW_INTRO, true)
        kernBurnsView.animateWithImages(images, imageAnimationDuration: 30, initialDelay: 0, shouldLoop: true)
    }
    
    func initPageController () {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.view.frame = self.containerView.bounds
        
        if let firstVC = self.viewControllers.first {
            self.pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        self.addControllerOnRootView(controller: self.pageViewController)
        self.containerView.bringSubviewToFront(self.pageControl)
        self.pageControl.numberOfPages = self.viewControllers.count
        self.pageControl.currentPage = 0
    }
    
    func createHelpModels() {
        self.arrayHelpModels = []
        let count = ImageRes.array_help_intros.count
        for i in 1...count {
            let model = HelpModel(i,getString(StringRes.array_title_helps[i-1]),ImageRes.array_help_intros[i-1])
            model.info = getString(StringRes.array_info_helps[i-1])
            self.arrayHelpModels.append(model)
        }

    }
    
    @IBAction func backTap(_ sender: Any) {
        if !changePageBackward(false) {
            return
        }
    }
    
    @IBAction func nextTap(_ sender: Any) {
        if !changePage(false){
            self.goToMain()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.cancelAnimation()
    }
        
    func goToMain(){
            let main = MainController.create()
            self.presentDetail(main)
    }
 
    func addControllerOnRootView(controller : UIViewController){
        controller.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        self.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! HelpChildController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            return nil
        }
        return self.viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.viewControllers.firstIndex(of: viewController as! HelpChildController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        if nextIndex >= self.viewControllers.count {
            return nil
        }
        return self.viewControllers[nextIndex]
    }
    
    
    func createViewControllerAtIndex(index: Int) -> HelpChildController {
        let helpVC = HelpChildController.create(IJamitConstants.STORYBOARD_CHILD_IN_PAGE) as! HelpChildController
        helpVC.model = self.arrayHelpModels[index]
        helpVC.index = index
        return helpVC
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = self.viewControllers.firstIndex(of: pendingViewControllers.first as! HelpChildController)!
        if pendingIndex == self.viewControllers.count-1 {
            self.btnNext.setTitle(getString(StringRes.title_join_now), for: .normal)
        }
        else{
            self.btnNext.setTitle(getString(StringRes.title_next), for: .normal)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentIndex = pendingIndex
            self.pageControl.currentPage = self.currentIndex
            self.changeViewState(index: self.currentIndex)
            self.schedulePageChange()
        }
    }
    
    
    func cancelAnimation() {
        self.kernBurnsView.stopAnimation()
        self.cancelTask()
    }
    
    func cancelTask(){
        self.autoChangeTimer.invalidate()
    }
    
    func schedulePageChange() {
        self.cancelTask()
//        self.autoChangeTimer = Timer.scheduledTimer(timeInterval: self.TIME_PAGE_CHANGE, target: self, selector: #selector(autoChangePage), userInfo: nil, repeats: false)
    }
    
    @objc func autoChangePage() {
        if self.changePage(true) {
            self.schedulePageChange()
        }
    }
    
    func changePage( _ loop: Bool) -> Bool {
        var currentPage = self.currentIndex + 1
        self.changeViewState(index: self.currentIndex + 1)
        if currentPage >= self.viewControllers.count {
            if loop {
                currentPage = 0
            }
            else{
                return false
            }
        }
        self.pageViewController.setViewControllers([self.viewControllers[currentPage]], direction: .forward, animated: true, completion: { (completed) in
            self.currentIndex = currentPage
            self.pageControl.currentPage = self.currentIndex
            if self.currentIndex == self.viewControllers.count-1 {
                self.btnNext.setTitle(getString(StringRes.title_join_now), for: .normal)
            }
            else{
                self.btnNext.setTitle(getString(StringRes.title_next), for: .normal)
            }
            if !loop {
                self.schedulePageChange()
            }
        })
        
        return true
    }
    
    func changePageBackward( _ loop: Bool) -> Bool {
        var currentPage = self.currentIndex - 1
        self.changeViewState(index: currentPage)
        if currentPage < 0 {
            if loop {
                currentPage = 0
            }
            else{
                return false
            }
        }
        self.pageViewController.setViewControllers([self.viewControllers[currentPage]], direction: .reverse, animated: true, completion: { (completed) in
            self.currentIndex = currentPage
            self.pageControl.currentPage = self.currentIndex
            self.btnNext.setTitle(getString(StringRes.title_next), for: .normal)
            if self.currentIndex == 0 {
                self.btnBack.isHidden = true
            }
            else{
                self.btnBack.isHidden = false
            }
            if !loop {
                self.schedulePageChange()
            }
        })
        
        return true
    }

    
    
}
