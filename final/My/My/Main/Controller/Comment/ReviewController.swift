//
//  ReviewController.swift
//  jamit
//
//  Created by Do Trung Bao on 8/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit

class ReviewController: BaseReviewController {
    
    var parentVC : MainController?
    var show: ShowModel?
    
    override func setUpUI() {
        super.setUpUI()
        self.reviewDelegate = self
        self.tfChat.placeholder = getString(self.isLogin ? StringRes.info_hint_review : StringRes.info_login_to_add_review)
        self.btnLogin.setTitle(getString(StringRes.info_login_to_add_review), for: .normal)
    }
    
    override func setUpCustomizeUI() {
        super.setUpCustomizeUI()
        let title = self.show?.title ?? ""
        self.lblTitle.text = String(format: getString(StringRes.format_title_community), title)
    }
  
    override func getListModelFromServer(_ completion: @escaping (ResultModel?) -> Void) {
        let slug = show?.slug ?? ""
        if ApplicationUtils.isOnline() && !slug.isEmpty {
            JamItPodCastApi.getDetailShow(slug) { (result) in
                if let newShow = result  {
                    completion(self.convertListModelToResult(newShow.reviews))
                    return
                }
                completion(self.convertListModelToResult(self.show?.reviews))
            }
            return
        }
        completion(self.convertListModelToResult(self.show?.reviews))
    }
 
    override func onPostReview(){
        let review = self.tfChat.text ?? ""
        let audioID = self.show?.id ?? ""
        if review.isEmpty || audioID.isEmpty { return }
        self.showProgress()
        JamItPodCastApi.addReview(review, audioID) { (result) in
            self.dismissProgress()
            self.tfChat.text = ""
            if let newShow = result  {
                if !newShow.isResultOk() {
                    self.showToast(withResId: StringRes.info_request_login_again)
                    self.tfChat.isEnabled = false
                    self.tfChat.placeholder = getString(StringRes.info_login_to_add_review)
                    SettingManager.logOut()
                    return
                }
                let reviews = newShow.reviews ?? []
                self.setUpInfo(reviews)
            }
        }
    }
    
    override func loginTap(_ sender: Any) {
        self.dismiss(animated: true) {
            NavigationManager.shared.goToLogin(currentVC: self.parentVC,msg: getString(StringRes.info_login_to_add_review))
        }
    }
    
}
extension ReviewController : ReviewDelegate {
    
    func deleteReview(_ review: ReviewModel) {
        let msg = getString(StringRes.info_delete_review)
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
        JamItPodCastApi.deleteReview(review.id, self.show?.id ?? "") { (result) in
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
