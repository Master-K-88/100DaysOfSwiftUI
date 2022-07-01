//
//  PlayingHomeController.swift
//  iLandMusic
//  Created by JamIt on 10/22/19.
//  Copyright © 2019 JamIt. All rights reserved.
//

import Foundation
import UIKit

class PlayingHomeController: JamitRootViewController{
    
    @IBOutlet weak var layoutImage: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func setUpUI() {
        super.setUpUI()
        self.updateImage()
    }
    
    func updateImage() {
        if let trackModel = StreamManager.shared.currentModel {
            let artWork = trackModel.imageUrl
            if artWork.starts(with: "http") {
                self.imgView.kf.setImage(with: URL(string: artWork), placeholder: UIImage(named: ImageRes.big_rect_img_default))
            }
            else{
                self.imgView.image = UIImage(named: ImageRes.big_rect_img_default)
            }
        }
    }
    
}
