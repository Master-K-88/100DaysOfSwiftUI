//
//  Created by YPYGlobal on 1/9/19.
//  Copyright © 2019 YPYG Global. All rights reserved.
//

import UIKit

protocol SleepDelegate {
    func timeSleep(value : Int, controller : UIViewController)
}

class SleepController : JamitRootViewController{
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var sliderCircular: MSCircularSlider!
    
    var delegate : SleepDelegate?
    var currentTime : Int = 0
    
    override func setUpUI() {
        super.setUpUI()
        
        self.popUpView.backgroundColor = getColor(hex: ColorRes.dialog_bg_color)
        self.sliderCircular.minimumValue = Double(IJamitConstants.MIN_SLEEP_MODE)
        self.sliderCircular.maximumValue = Double(IJamitConstants.MAX_SLEEP_MODE)
        self.sliderCircular.delegate = self
        
        self.popUpView.layer.cornerRadius = 3
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.updateTimerInfo()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentTime = SettingManager.getSleepMode()
        self.sliderCircular.currentValue = Double(self.currentTime)
    }
   
    
    func updateTimerInfo () {
        if currentTime > 0 {
            if currentTime == 1 {
                self.lblMinutes.text =  String.init(format: getString(StringRes.format_minute), currentTime)
            }
            else{
                self.lblMinutes.text =  String.init(format: getString(StringRes.format_minutes), currentTime)
            }
        }
        else{
            self.lblMinutes.text =  getString(StringRes.title_off)
        }
    }
  
    
    @IBAction func doneTapped(_ sender: Any) {
        if delegate != nil{
            delegate?.timeSleep(value: currentTime, controller: self)
        }
    }
}

extension SleepController : MSCircularSliderDelegate{
    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {
        currentTime = Int(value)
        updateTimerInfo()
    }
    
    func circularSlider(_ slider: MSCircularSlider, startedTrackingWith value: Double) {
        
    }
    
    func circularSlider(_ slider: MSCircularSlider, endedTrackingWith value: Double) {
        
    }
}
