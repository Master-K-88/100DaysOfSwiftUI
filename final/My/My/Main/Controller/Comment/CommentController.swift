//
//  CommentController.swift
//  jamit
//
//  Created by YPY Global on 8/8/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class CommentController: BaseReviewController {
    
    var parentVC : PlayingControler?
    var episode: EpisodeModel?
    
    override func setUpUI() {
        super.setUpUI()
        self.reviewDelegate = self
        self.tfChat.placeholder = getString(self.isLogin ? StringRes.info_hint_comment : StringRes.info_login_to_add_comment)
        self.btnLogin.setTitle(getString(StringRes.info_login_to_add_comment), for: .normal)
    }
   
    override func setUpCustomizeUI() {
        super.setUpCustomizeUI()
        let title = self.episode?.title ?? ""
        self.lblTitle.text = String(format: getString(StringRes.format_title_comment), title)
    }
    
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        let episodeId = self.episode?.id ?? ""
        if ApplicationUtils.isOnline() && !episodeId.isEmpty {
            JamItPodCastApi.getListComments(episodeId) { (list) in
                if let comments = list {
                    completion(self.convertListModelToResult(comments))
                    return
                }
                completion(self.convertListModelToResult([]))
            }
            return
        }
        completion(self.convertListModelToResult([]))
    }
    
    override func onPostReview() {
        let comment = self.tfChat.text ?? ""
        let episodeID = self.episode?.id ?? ""
        let audioID = self.episode?.audioId ?? ""
        if comment.isEmpty || audioID.isEmpty || episodeID.isEmpty { return }
        self.showProgress()
        JamItPodCastApi.addComment(comment, audioID, episodeID) { (result) in
            self.dismissProgress()
            self.tfChat.text = ""
            if let newShow = result  {
                if !newShow.isResultOk() {
                    self.showToast(withResId: StringRes.info_request_login_again)
                    self.tfChat.isEnabled = false
                    self.tfChat.placeholder = getString(StringRes.info_login_to_add_comment)
                    SettingManager.logOut()
                    return
                }
                self.onRefreshData(false)
            }
        }
      
    }
    override func loginTap(_ sender: Any) {
        self.dismiss(animated: true) {
            NavigationManager.shared.goToLogin(currentVC: self.parentVC,msg: getString(StringRes.info_login_to_add_comment))
        }
    }
    
}
extension CommentController : ReviewDelegate {
    
    func deleteReview(_ review: ReviewModel) {
        let msg = getString(StringRes.info_delete_comment)
        let titleCancel = getString(StringRes.title_cancel)
        let titleDelete = getString(StringRes.title_delete)
        self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleDelete, negative: titleCancel, completion: { self.onDelete(review)})
    }
    
    func clickUser(_ review: ReviewModel) {
        self.dismiss(animated: true, completion: {
            self.parentVC?.goToUserStories(review.author)
        })
    }
    
    private func onDelete(_ review: ReviewModel){
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        let commentId = review.id
        JamItPodCastApi.deleteComment(commentId) { (result) in
            self.dismissProgress()
            if let newReview = result {
                if newReview.isResultOk() {
                    self.deleteModel(review)
                    return
                }
                let msg = !newReview.message.isEmpty ? newReview.message : getString(StringRes.info_server_error)
                self.showToast(with: msg)
                return
            }
            self.showToast(withResId: StringRes.info_server_error)
        }
        
    }
}
