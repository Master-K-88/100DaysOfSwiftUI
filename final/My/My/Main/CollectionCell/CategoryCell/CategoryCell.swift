//
//  CategoryCell.swift
//  jamit
//
//  Created by YPY Global on 8/5/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var imgVector: UIImageView!
    @IBOutlet weak var rootLayout: UIView!
    
    private let chatArraysColors = ColorRes.array_categories_colors
    private var sizeArray: Int = 0
    var catModel: CategoryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sizeArray = chatArraysColors.count
    }
    
    func updateUI(_ model: CategoryModel, _ pos: Int) {
        self.catModel = model
        self.lblGenre.text = model.name
        self.rootLayout.backgroundColor = getColor(hex: chatArraysColors[pos%self.sizeArray])
    }
    
}
