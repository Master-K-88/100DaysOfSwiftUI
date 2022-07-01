//
//  CreateEventController.swift
//  jamit
//
//  Created by Do Trung Bao on 17/08/2021.
//  Copyright © 2021 Penthink LLC. All rights reserved.
//

import Foundation
import UIKit
//import MBRadioCheckboxButton

class CreateLoungeController: ParentViewController {
//
    private let placeHolderColor = UIColor(named: ColorRes.textfield_bgcolor)
    //getColor(hex: ColorRes.main_second_text_color)
    private let accentColor = getColor(hex: ColorRes.color_accent)
//
    var parentVC: MainController?
//
    @IBOutlet weak var btnCreateEvent: AutoFillButton!
    @IBOutlet weak var btnTopic: UIButton!
    @IBOutlet weak var lblUpComming: AutoFillLabel!
    @IBOutlet weak var lblLive: AutoFillLabel!
    @IBOutlet weak var tfEventTitle: UITextField! {
        didSet {
            self.tfEventTitle.placeholderColor(color: placeHolderColor ?? .clear)
        }
    }

    @IBOutlet weak var tfEventTopic: UITextField! {
        didSet {
            self.tfEventTopic.placeholderColor(color: placeHolderColor ?? .clear)
        }
    }

    @IBOutlet weak var tfEventTags: UITextField! {
        didSet {
            self.tfEventTags.placeholderColor(color: placeHolderColor ?? .clear)
        }
    }

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var radioBtLive: RadioButton!
    @IBOutlet weak var radioBtUpComming: RadioButton!


    var topicPickerView: UIPickerView!
    var listTopics : [TopicModel]?
    var topicId = ""

    override func setUpUI() {
        super.setUpUI()
        self.tfEventTitle.delegate = self
        self.tfEventTopic.delegate = self
        self.tfEventTags.delegate = self

        self.setUpRadioBtUI()
    }
//
    private func setUpRadioBtUI(){
        let radioBt = RadioButtonColor(active: accentColor, inactive: getColor(hex: ColorRes.main_second_text_color))
        self.radioBtLive.radioButtonColor = radioBt
        self.radioBtUpComming.radioButtonColor = radioBt

        self.selectRadioButton(radioBt: self.radioBtLive)
        self.lblLive.isUserInteractionEnabled = true
        self.lblLive.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lblLiveTap)))

        self.lblUpComming.isUserInteractionEnabled = true
        self.lblUpComming.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lblUpcommingTap)))

        self.radioBtLive.delegate = self
        self.radioBtUpComming.delegate = self
    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpBorder()
        self.setUpDatePicker()
    }
//
    private func setUpDatePicker() {
        let currentDate = Date()
        let minInterval = TimeInterval(IJamitConstants.MIN_SCHEDULE_IN_DAY * IJamitConstants.ONE_DAY_IN_SECONDS)
        let minDate = currentDate.addingTimeInterval(minInterval)

        let maxInterval = TimeInterval(IJamitConstants.MAX_SCHEDULE_IN_DAY * IJamitConstants.ONE_DAY_IN_SECONDS)
        let maxDate = currentDate.addingTimeInterval(maxInterval)

        self.datePicker.minimumDate = minDate
        self.datePicker.maximumDate = maxDate
        self.datePicker.date = minDate
    }
//
    func setUpBorder() {
        self.tfEventTitle.setBottomBorder(withColor: accentColor)
        self.tfEventTags.setBottomBorder(withColor: accentColor)
        self.tfEventTopic.setBottomBorder(withColor: accentColor)
    }
//
    @IBAction func backTap(_ sender: Any) {
        self.backToHome()
    }
//
    @IBAction func topicTap(_ sender: Any) {
        self.startGetTopics()
    }
//
    private func startGetTopics(){
        if self.topicPickerView != nil { return }
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        JamItPodCastApi.getTopics { (list) in
            self.dismissProgress()
            let isEmpty = list?.isEmpty ?? true
            if isEmpty {
                self.showToast(withResId: StringRes.info_no_story_category)
                return
            }
            self.listTopics = list
            self.setUpTopicPickerView()
            self.tfEventTopic.becomeFirstResponder()
        }
    }
//
    private func setUpTopicPickerView(){
        self.btnTopic.isHidden = true
        self.tfEventTopic.delegate = self
        self.topicPickerView = UIPickerView()
        self.topicPickerView.delegate = self
        self.topicPickerView.dataSource = self
        //self.topicPickerView.showsSelectionIndicator = true
        self.topicPickerView.backgroundColor = getColor(hex: ColorRes.color_background)
        self.tfEventTopic.inputView = self.topicPickerView

        let indexSelected = self.listTopics?.firstIndex { (model) -> Bool in
            return model.rootId.elementsEqual(self.topicId)
        } ?? 0
        self.topicPickerView.selectRow(indexSelected, inComponent: 0, animated: true)

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: getString(StringRes.title_done), style: .done, target: self, action: #selector(doneClick))
        doneButton.tintColor = getColor(hex: ColorRes.dialog_color_accent)

        let titleOption = UIBarButtonItem(title: getString(StringRes.title_story_category), style: .plain, target: nil, action: nil)
        titleOption.tintColor = getColor(hex: ColorRes.dialog_color_main_text)
        let spaceOption = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,  target: nil, action: nil)

        toolBar.setItems([titleOption,spaceOption,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.tfEventTopic.inputAccessoryView = toolBar
    }
//
    private func backToHome() {
        self.dismiss(animated: true) {
            self.listTopics?.removeAll()
            self.listTopics = nil
        }
    }
//
    @IBAction func createEventTap(_ sender: Any) {
        self.onCreateEvent()
    }
//
    @objc func lblLiveTap(){
        selectRadioButton(radioBt: self.radioBtLive)
    }

    @objc func lblUpcommingTap(){
        selectRadioButton(radioBt: self.radioBtUpComming)
    }

    func selectRadioButton(radioBt: RadioButton){
        self.radioBtLive.isOn = radioBt == self.radioBtLive
        self.radioBtUpComming.isOn = radioBt == self.radioBtUpComming
        self.datePicker.isHidden = radioBt == self.radioBtLive
    }

    func onCreateEvent() {
        self.hideVirtualKeyboard()
        if !ApplicationUtils.isOnline() {
            self.showToast(with: StringRes.info_lose_internet)
            return
        }
        let titleEvent = self.tfEventTitle?.text ?? ""
        if titleEvent.isEmpty {
            showToast(with: String(format: getString(StringRes.format_empty_field), getString(StringRes.title_event_title)))
            return
        }
        if topicId.isEmpty || listTopics == nil || listTopics!.isEmpty {
            showToast(withResId: StringRes.title_event_category)
            return
        }
        let tags = self.tfEventTags?.text ?? ""
        let fullTime = self.getUpCommingDateTime()
        
        //MARK: - Update this line below soon
        let isCheckedLive = false //self.radioBtLive.isOn
        let schedule = isCheckedLive ? EventModel.STATUS_LIVE : EventModel.STATUS_UPCOMING

        self.showProgress()

        let dateFormatter = DateFormatter()
        let userId = SettingManager.getUserId()
        let token = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)
//        print("The token \(token)")
        let params: [String:Any] = ["userID": userId,
                                    "token": token,
                                    "newEventName" : titleEvent,
                                    "newEventTopic" : topicId,
                                    "newEventTags" : tags,
                                    "newEventSchedule" : schedule,
                                    "newEventStartDate" : fullTime,
                                    "newEventTimeZone" : dateFormatter.timeZone.identifier]

        JamItEventApi.createEvent(params) { event in
            self.dismissProgress()
            JamitLog.logD("======>create event = \(String(describing: event?.eventId))")
            let isResult = event?.isResultOk() ?? false
            if event != nil && isResult {
                self.showToast(withResId: StringRes.info_create_event_successfully)
                self.resetData()
                self.processEvent(event!, isCheckedLive)
                return
            }
            let msg = event?.message ?? getString(StringRes.info_server_error)
            self.showToast(with: msg)
        }

    }
//
    private func resetData() {
        self.tfEventTitle.text = ""
        self.tfEventTags.text = ""
    }
//
    private func processEvent(_ event: EventModel, _ isLive: Bool) {
        if isLive {
            self.dismiss(animated: true) {
                self.parentVC?.goToLive(event, false)
            }
            return
        }
        self.showAlertWithResId(
            titleId: StringRes.title_ok,
            messageId: StringRes.info_share_event_scheduled,
            positiveId: StringRes.title_share,
            negativeId: StringRes.title_back,
            completion: {
                self.shareWithDeepLink(event, self.btnCreateEvent, {
                    self.backToHome()
                })
            })
    }
//
    private func getUpCommingDateTime() -> String {
        let currentDate = self.datePicker.date
        let strDate = DateTimeUtils.getStrDate(IJamitConstants.DATE_FORMAT_EVENT, currentDate)
        return strDate + ":00.000Z"
    }
//
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
        self.tfEventTags.resignFirstResponder()
        self.tfEventTitle.resignFirstResponder()
        self.tfEventTopic.resignFirstResponder()
    }
//
}

// text field delegate to capture event keyboard
extension CreateLoungeController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.tfEventTitle){
            self.tfEventTags.becomeFirstResponder()
        }
        else if(textField == self.tfEventTags){
            textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    
    //prevent textfield can edit when show picker view
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.tfEventTopic {
            return false
        }
        return true
    }
    
}

extension CreateLoungeController: RadioButtonDelegate{

    func radioButtonDidSelect(_ button: RadioButton) {
        selectRadioButton(radioBt: button)
    }

    func radioButtonDidDeselect(_ button: RadioButton) {

    }

}

//Extension for pickerview in textfield location
extension CreateLoungeController: UIPickerViewDataSource, UIPickerViewDelegate {

    // number column in pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listTopics?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let model = self.listTopics?[row]
        self.tfEventTopic.text = model?.name ?? ""
        self.topicId = model?.rootId ?? ""
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let model = self.listTopics?[row]
        let title = model?.name ?? ""
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    //click done event when show picker view
    @objc func doneClick() {
        self.tfEventTopic.resignFirstResponder()
    }

}
