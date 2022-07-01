//
//  DialogConfirmController.swift
//  jamit
//
//  Created by Do Trung Bao on 17/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit

protocol ConfirmDelegate {
    func onCancel()
    func onConfirm()
    func onTopAction()
}

struct ConfirmResource {
    var title = ""
    var msg = ""
    var artwork: String?
    var posBgColorId: String?
    var posTextColor: UIColor?
    var isTopAction = false
    var topActionResImg: String?
    var posStrId: String?
    var negStrId: String?
    var strokeColor: UIColor?
}

class DialogConfirmController : JamitRootViewController{
    
    @IBOutlet weak var btnTopAction: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnConfirm: AutoFillButton!
    @IBOutlet weak var btnCancel: AutoFillButton!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblSubInfo: UILabel!
    
    @IBOutlet weak var tapOutSideView: UIView!
    private var tapOutSide : UITapGestureRecognizer?
    
    var delegate: ConfirmDelegate?
    var resource: ConfirmResource?
    
    override func setUpUI() {
        super.setUpUI()
        self.lblTitle.text = resource?.title ?? getString(StringRes.title_confirm)
        self.lblSubInfo.text = resource?.msg ?? ""
        
        let strNegative = getString(resource?.negStrId ?? StringRes.title_cancel)
        self.btnCancel.setTitle(strNegative, for: .normal)
        
        let posStrId = resource?.posStrId ?? ""
        self.btnConfirm.isHidden = posStrId.isEmpty
        if !posStrId.isEmpty {
            self.btnConfirm.setTitle(getString(posStrId), for: .normal)
            self.btnConfirm.backgroundColor = getColor(hex: resource?.posBgColorId ?? ColorRes.color_join)
            self.btnConfirm.setTitleColor(resource?.posTextColor ?? .white, for: .normal)
            if let strokeColor = resource?.strokeColor {
                self.btnConfirm.borderWidth = CGFloat(1)
                self.btnConfirm.borderColor = strokeColor
            }
        }
    
        let imgTopAction = UIImage(named: resource?.topActionResImg ?? ImageRes.ic_close_white_36dp)
        self.btnTopAction.setImage(imgTopAction, for: .normal)
        self.btnTopAction.isHidden = !(resource?.isTopAction ?? false)
    
        if let artwork = resource?.artwork, artwork.starts(with: "http") {
            self.imgView.kf.setImage(with: URL(string: artwork), placeholder:  UIImage(named: ImageRes.ic_circle_avatar_default))
        }
        else {
            self.imgView.image = UIImage(named: ImageRes.ic_circle_avatar_default)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imgView.cornerRadius = self.imgView.frame.width / 2
        self.imgView.layoutIfNeeded()
        self.tapOutSideView.addGestureRecognizer(UITapGestureRecognizer())
        self.registerTapOutSideRecognizer()
    }
    
    
    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: false, completion: {
        })
    }
    
    @IBAction func topActionTap(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.delegate?.onTopAction()
        })
    }
    
    @IBAction func confirmTap(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.delegate?.onConfirm()
        })
    }
    
    //register/add tap outside
     override func registerTapOutSideRecognizer() {
         if self.tapOutSide == nil {
             self.tapOutSide = UITapGestureRecognizer(target: self, action: #selector(cancelTap))
             self.view.addGestureRecognizer(tapOutSide!)
         }
       
     }
     
     //Unregister/remove tap gesture recognition
     override func unregisterTapOutSideRecognizer(){
         if let gesture = self.tapOutSide {
             self.view.removeGestureRecognizer(gesture)
         }
         self.view.endEditing(true)
         self.tapOutSide = nil
     }

}

