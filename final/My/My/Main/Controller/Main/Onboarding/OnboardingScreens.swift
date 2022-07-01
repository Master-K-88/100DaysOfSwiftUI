//
//  OnboardingScreens.swift
//  jamit
//
//  Created by Prof K on 5/30/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class OnboardingScreens: UIViewController {
    
    var myController = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstVC = GenderViewController()
        firstVC.view.backgroundColor = .gray
        myController.append(firstVC)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    func presentPageVC() {
        guard let first = myController.first else {
            return
        }
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        pageVC.delegate = self
        pageVC.dataSource = self
        
        pageVC.setViewControllers([first],
                                  direction: .forward,
                                  animated: true,
                                  completion: nil)
        present(pageVC, animated: true)
    }
}

extension OnboardingScreens: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = myController.firstIndex(of: viewController), pageIndex > myController.count - 1 else {
            return nil
        }
        let after = pageIndex + 1
        return myController[after]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = myController.firstIndex(of: viewController), pageIndex > 0 else {
            return nil
        }
        let before = pageIndex - 1
        return myController[before]
    }
}

extension OnboardingScreens: UIPageViewControllerDelegate {
    
}
