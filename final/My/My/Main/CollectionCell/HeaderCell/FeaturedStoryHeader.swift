//
//  DiscoverHeader.swift
//  jamit
//
//  Created by Do Trung Bao on 4/9/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class FeaturedStoryHeader: UICollectionReusableView {
    
    @IBOutlet weak var lblExploreStories: UILabel!
    @IBOutlet weak var lblPopularTopic: PaddingUILabel!
    
    @IBOutlet weak var collectionTopic: UICollectionView!
    @IBOutlet weak var collectionTrendingUser: UICollectionView!
    @IBOutlet weak var layoutTrending: UIStackView!
    @IBOutlet weak var lblTrending: PaddingUILabel!
    
    private var listPopularTopics : [TopicModel]?
    private var listTrendingUsers : [UserModel]?
    
    //fake font to calculate width of tag in the header
    private let fakeLabel = UILabel()
    
    private let tagFont = UIFont.init(name: IJamitConstants.FONT_MEDIUM, size: DimenRes.size_text_tag_view) ?? UIFont.systemFont(ofSize: DimenRes.size_text_tag_view)
    
    private var paddingInset = UIEdgeInsets(top: 0, left: DimenRes.medium_padding, bottom: 0, right: DimenRes.medium_padding)
    
    var appItemDelegate: AppItemDelegate?
    
    private var cellWidth: CGFloat = 0.0
    private var cellHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        self.lblExploreStories.text = getString(StringRes.title_explore_stories)
        self.lblTrending.text = getString(StringRes.title_trending_users)
        self.lblPopularTopic.text = getString(StringRes.title_popular_topics)
        
        self.fakeLabel.font = tagFont
        
        self.collectionTrendingUser.register(UINib(nibName: String(describing: TrendingUserCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TrendingUserCell.self))
        
        self.collectionTopic.register(UINib(nibName: String(describing: TopicCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: TopicCell.self))
        
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 4 *  DimenRes.height_tag_view, height: DimenRes.height_tag_view)
        self.collectionTopic.collectionViewLayout = layout
    }
 
    func setListTrendingUsers(_ listUser: [UserModel]?, _ screenWidth: CGFloat) {
        self.listTrendingUsers?.removeAll()
        self.listTrendingUsers = nil
        
        self.cellHeight = IJamitConstants.RATE_TRENDING_USER * screenWidth
        self.cellWidth = (screenWidth - 2*DimenRes.medium_padding) / 5.5
 
        self.listTrendingUsers = listUser
        self.collectionTrendingUser.reloadData()
    }
    
    func setListPopularTopics(_ listTopics: [TopicModel]?) {
        self.listPopularTopics?.removeAll()
        self.listPopularTopics = nil
        self.listPopularTopics = listTopics
        self.collectionTopic.reloadData()
    }

}


extension FeaturedStoryHeader : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionTopic {
            return self.listPopularTopics?.count ?? 0
        }
        return self.listTrendingUsers?.count ?? 0
    }
    
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionTopic {
            let model = self.listPopularTopics![indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TopicCell.self), for: indexPath) as! TopicCell
            cell.updateUI(model,tagFont)
            return cell
        }
        let model = self.listTrendingUsers![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TrendingUserCell.self), for: indexPath) as! TrendingUserCell
        cell.updateUI(model,self.cellWidth)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionTopic {
            if let model = self.listPopularTopics?[indexPath.row] {
                self.appItemDelegate?.clickItem(list: self.listPopularTopics!, model: model, position: indexPath.row)
            }
            return
        }
        if let model = self.listTrendingUsers?[indexPath.row] {
            self.appItemDelegate?.clickItem(list: self.listTrendingUsers!, model: model, position: indexPath.row)
        }
       
    }
    
}

extension FeaturedStoryHeader: UICollectionViewDelegateFlowLayout{
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionTopic {
            let model = self.listPopularTopics![indexPath.row]
            let realTextWidth = fakeLabel.caculateWidth(DimenRes.height_tag_view, "#" + model.name)
            let realWidth = realTextWidth + 3 * DimenRes.small_padding + DimenRes.size_tag_image
            JamitLog.logE("====>realTextWidth=\(realTextWidth)==>realWidth=\(realWidth)")
            return CGSize(width: realWidth, height: DimenRes.height_tag_view)
        }
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }

    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.paddingInset
    }
 
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DimenRes.medium_padding
    }
}
