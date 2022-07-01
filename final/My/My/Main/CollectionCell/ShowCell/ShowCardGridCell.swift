//
//  GenreCardGridCell.swift
//  Created by Do Trung Bao on 1/28/19.
//  Copyright © 2019 YPY Global. All rights reserved.
//

import UIKit

class ShowCardGridCell: UICollectionViewCell {
    
    @IBOutlet var rootLayout: UIView!
    @IBOutlet var img: UIImageView!
    
    var show: ShowModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(_ show: ShowModel) {
        self.show = show
        let imgUrl: String = show.imageUrl
        if imgUrl.starts(with: "http") {
            img.kf.setImage(with: URL(string: imgUrl), placeholder:  UIImage(named: ImageRes.img_default))
        }
        else {
            img.image = UIImage(named: ImageRes.img_default)
        }
    }

    
}
