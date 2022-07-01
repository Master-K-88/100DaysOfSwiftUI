//
//  LeaderBoardCollectionViewCell.swift
//  jamit
//
//  Created by Prof K on 12/8/21.
//  Copyright © 2021 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

//protocol LeaderboardDelegate: AnyObject {
//    func followTapped(index: Int)
//}

class LeaderBoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPos: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
//    weak var delegate: LeaderboardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
        
//        // reset the follow button
        self.btnInfo.isUserInteractionEnabled = false
        self.btnInfo.setImage(UIImage(named: ""), for: .normal)
        self.btnInfo.backgroundColor =  .clear/*UIColor.clear*/
        self.btnInfo.borderColor = .clear
        self.btnInfo.borderWidth = CGFloat(0)
        
    }
    
    @IBAction func followTap(_ sender: UIButton) {
    }
    
    func updateUI(_ model: LeaderboardModel, index: Int) {
        
        DispatchQueue.main.async {
            self.imgView.kf.setImage(with: URL(string: model.avatar), placeholder:  UIImage(named: ImageRes.ic_avatar_48dp))
            self.lblPos.text = "\(index)"
            self.lblUsername.text = model.username
            self.btnInfo.tag = index - 1
            if let score = model.score > 1000 ? nil : model.score {
                self.btnInfo.setTitle("\(String(describing: score))", for: .normal)
            }
            let image = model.score > 1000 ? "danger_streak" : " "
            
            self.btnInfo.setImage(UIImage(named: image), for: .normal)
            self.imgView.cornerRadius = self.imgView.frame.size.width / CGFloat(2)
            
        }
        
        
    }
    
    func updateFollow(_ isFollow : Bool) {
        let followBtnText = getString(isFollow ? StringRes.title_unfollow : StringRes.title_follow)
        btnInfo.setTitle("    \(followBtnText)", for: .normal)
        
    }
}
