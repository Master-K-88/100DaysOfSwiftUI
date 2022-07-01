//
//  FeaturedShowController.swift
//  jamit
//
//  Created by YPY Global on 4/9/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

protocol HomeHeaderDelegage {
    func goToFeaturedShow(_ show: ShowModel)
    func goToFeatured(_ typeVC: Int)
}

class FeaturedShowController: JamitRootViewController {
    
    @IBOutlet var rootLayout: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    
    var show: ShowModel!
    var index: Int = -1
    var bannerDelegate : HomeHeaderDelegage?
    
    override func setUpUI() {
        super.setUpUI()
//        let imgUrl = show.imgFeatured
        let imgUrl = show.imageUrl
        if(!imgUrl.isEmpty && imgUrl.starts(with: "http")){
            imgBanner.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_banner_default))
        }
        else{
            imgBanner.image = UIImage(named: ImageRes.img_banner_default)
        }
        imgBanner.clipsToBounds = true
    }
    
    @IBAction func featuredTap(_ sender: Any) {
        print("This is to confirm the button exist")
        self.bannerDelegate?.goToFeaturedShow(self.show)
    }
}
