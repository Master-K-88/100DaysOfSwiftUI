//
//  RecordingController.swift
//  jamit
//
//  Created by YPY Global on 8/8/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class TabRecordingController: JamitRootViewController {

    private let placeHolderColor = getColor(hex: ColorRes.main_second_text_color)
    private let borderColor = getColor(hex: ColorRes.color_accent)

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRecord: UILabel!
    @IBOutlet weak var layoutRecord: UIStackView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblMaxInfo: UILabel!
    @IBOutlet weak var lblUploadStory: UILabel!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnPlay: UIView!
    @IBOutlet weak var btnUpload: UIView!
    @IBOutlet weak var btnRecord: UIView!

    @IBOutlet weak var switchExplicit: UISwitch!

    @IBOutlet weak var btnTopic: UIButton!
    @IBOutlet weak var btnLan: UIButton!
    @IBOutlet weak var btnHistorySeries: UIView!

    @IBOutlet weak var imgRecord: UIImageView!
    var parentVC: MainController?

    @IBOutlet weak var tfStoryTitle: UITextField! {
        didSet {
            self.tfStoryTitle.placeholderColor(color: placeHolderColor)
        }
    }
    @IBOutlet weak var tfSeriesTitle: UITextField! {
        didSet {
            self.tfSeriesTitle.placeholderColor(color: placeHolderColor)
        }
    }

    @IBOutlet weak var tfTags: UITextField! {
        didSet {
            self.tfTags.placeholderColor(color: placeHolderColor)
        }
    }

    @IBOutlet weak var tfTopic: UITextField! {
        didSet {
            self.tfTopic.placeholderColor(color: placeHolderColor)
        }
    }

    @IBOutlet weak var tfLan: UITextField! {
        didSet {
            self.tfLan.placeholderColor(color: placeHolderColor)
        }
    }

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?

    var pathFile = ""
    var recordFolder: URL?

    var isStartRecording = false
    var isTogglePlay = false
    var isPrepared = false
    var isLoading = false

    var timeRecord: Double = 0
    var position: Double = 0

    var recordTimer: Timer?
    var playTimer: Timer?

    var listTopics : [TopicModel]?
    var listLanguages : [LocaleModel]?
    var listSeries: [SeriesModel]?

    var topicPickerView: UIPickerView!
    var lanPickerView: UIPickerView!
    var seriesPickerView: UIPickerView!
    var seriesToolBar: UIToolbar!

    var seriesID = ""
    var lanCode = ""
    var topicId = ""
    
    

    let settingRecord = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: IJamitConstants.SAMPLING_RATE,
        AVEncoderBitRateKey: IJamitConstants.BITRATE,
        AVNumberOfChannelsKey: IJamitConstants.NUMBER_CHANNELS,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    override func setUpUI() {
        super.setUpUI()
        self.tfStoryTitle.delegate = self
        self.tfSeriesTitle.delegate = self
        self.tfTags.delegate = self
        self.registerTapOutSideRecognizer()

        self.lblRecord.text = getString(StringRes.title_start_recording)
        self.lblMaxInfo.text = String(format: getString(StringRes.format_maximum_minute), String(IJamitConstants.MAX_TIME_RECORD))
        self.lblUploadStory.text = getString(StringRes.title_upload_story)

        self.layoutRecord.isHidden = true
        self.startGetSeries()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpBorder()
        self.setupRecorder()
    }

    func setUpBorder() {
        self.tfStoryTitle.setBottomBorder(withColor: borderColor)
        self.tfSeriesTitle.setBottomBorder(withColor: borderColor)
        self.tfTags.setBottomBorder(withColor: borderColor)
        self.tfLan.setBottomBorder(withColor: borderColor)
        self.tfTopic.setBottomBorder(withColor: borderColor)
    }

    @IBAction func backTap(_ sender: Any) {
        if !self.pathFile.isEmpty {
            let msg = getString(StringRes.info_record_back)
            let titleCancel = getString(StringRes.title_cancel)
            let titleYes = getString(StringRes.title_yes)
            self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleYes, negative: titleCancel, completion: {
                self.backToHome()
            })
            return
        }
        self.backToHome()
    }

    func backToHome(_ msgId: String? = nil){
        self.listTopics?.removeAll()
        self.listLanguages?.removeAll()
        self.listSeries?.removeAll()

        self.listTopics = nil
        self.listLanguages = nil
        self.listSeries = nil

        self.stopTimerRecord()
        self.stopTimerPlay()
        self.unregisterTapOutSideRecognizer()
        self.releaseRecorder()
        self.releasePlayer()
        self.deleteOldFile()
        self.dismiss(animated: true) {
            if msgId != nil {
                self.parentVC?.showToast(withResId: msgId!)
            }
        }
    }



    @IBAction func recordTap(_ sender: Any) {
        self.onRecord()
    }

    func onRecord() {
        if !self.isStartRecording {
            if !self.pathFile.isEmpty {
                let msg = getString(StringRes.info_recording_again)
                let titleCancel = getString(StringRes.title_cancel)
                let titleYes = getString(StringRes.title_record_again)
                self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleYes, negative: titleCancel, completion: {
                    self.deleteOldFile()
                    self.startRecord()
                })
                return
            }
            self.startRecord()
        }
        else{
            stopRecord()
        }
    }

    func startRecord() {
        self.layoutRecord.isHidden = false
        self.isPrepared = false
        self.stopPlaying()
        self.lblDuration.text = "00 : 00"
        self.lblDuration.isHidden = false
        self.lblMaxInfo.isHidden = false
        self.timeRecord = 0
        self.btnPlay.isHidden = true
        self.btnUpload.isHidden = true

        self.btnRecord.backgroundColor = getColor(hex: ColorRes.color_recording)
        self.lblRecord.textColor = .white
        self.imgRecord.tintColor = .white

        if let recordFile = self.createFileRecord() {
            JamitLog.logE("====>recordFile=\(recordFile)")
            do {
                self.isStartRecording = true
                self.audioRecorder = try AVAudioRecorder(url: recordFile, settings: settingRecord)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.record()
                self.startCountTime()
                self.lblRecord.text = getString(StringRes.title_stop_recording)
                self.imgRecord.image = UIImage(named: ImageRes.ic_stop_36dp)
                return
            }
            catch{
                JamitLog.logE("====>error when record")
                self.stopRecord()
            }
            return
        }
        self.backToHome(StringRes.info_recording_error)

    }

    func stopRecord() {
        self.stopTimerRecord()
        self.releaseRecorder()
        self.lblMaxInfo.isHidden = true
        self.isStartRecording = false
        self.btnPlay.isHidden = false
        self.updateStatePlay(false)
        self.lblRecord.text = getString(StringRes.title_record_again)
        self.imgRecord.image = UIImage(named: ImageRes.ic_stories_36dp)
        self.btnUpload.isHidden = false

        let colorRecord = getColor(hex: ColorRes.color_recording)
        self.btnRecord.backgroundColor = .white
        self.lblRecord.textColor = colorRecord
        self.imgRecord.tintColor = colorRecord
    }
//
    @IBAction func uploadTap(_ sender: Any) {
        self.startUpload()
    }

    @IBAction func playTap(_ sender: Any) {
        self.onTogglePlay()
    }

    func setupRecorder() {
        self.recordFolder = TotalDataManager.shared.getRecordDirectory()
        self.recordingSession = AVAudioSession.sharedInstance()
        do {
            try self.recordingSession.setCategory(.playAndRecord, mode: .default)
            try self.recordingSession.setActive(true)
            let resultPermisson = self.recordingSession.recordPermission
            if resultPermisson != AVAudioSession.RecordPermission.granted {
                self.recordingSession.requestRecordPermission({ (granted) in
                    DispatchQueue.main.async {
                        if !granted {
                            self.backToHome(StringRes.info_permission_denied)
                        }
                    }
                })
                return
            }

        }
        catch {
            self.backToHome(StringRes.info_permission_unknow_error)
        }
    }


    func resetData() {
        self.tfStoryTitle.text = ""
        self.tfSeriesTitle.text = ""
        self.tfTags.text = ""
        self.seriesID = ""
        self.lanCode = ""
        self.topicId = ""
        self.lblRecord.text = getString(StringRes.title_start_recording)
        self.layoutRecord.isHidden = true
        self.btnUpload.isHidden = true
        self.deleteOldFile()
        self.releasePlayer()
        self.releaseRecorder()
    }

    func releaseRecorder(){
        self.audioRecorder?.stop()
        self.audioRecorder = nil
    }

    func releasePlayer() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }

    func onTogglePlay() {
        if isLoading { return }
        self.isTogglePlay = !self.isTogglePlay
        if isTogglePlay {
            startPlaying()
        }
        else {
            stopPlaying()
        }
    }

    func startPlaying() {
        if let recordFile = self.getRecordFile() {
            let isPlay = self.audioPlayer?.isPlaying ?? false
            if isPrepared && !isPlay {
                self.audioPlayer?.play()
                self.updateStatePlay(true)
                self.startUpdateTime()
                return
            }
            self.audioPlayer = self.createAudioPlayer(recordFile)
            if self.audioPlayer != nil {
                self.lblDuration.text = "00 : 00"
                self.isLoading = true
                self.audioPlayer?.delegate = self
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.volume = 10.0
                self.isPrepared = true
                self.isLoading = false

                //start play audio
                let currentDuration = self.audioPlayer?.duration ?? 0
                self.timeRecord = currentDuration > 0 ? currentDuration : self.timeRecord

                self.updateStatePlay(true)
                self.startUpdateTime()
                self.audioPlayer?.play()

            }
        }
    }

    func createAudioPlayer(_ recordFile: URL) -> AVAudioPlayer? {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: recordFile)
            return audioPlayer
        }
        catch let error1 as NSError {
            JamitLog.logE("=====>error when creating player=\(error1.description)")
        }
        return nil
    }

    func stopPlaying() {
        self.isTogglePlay = false
        self.stopTimerPlay()
        self.updateStatePlay(false)
        let isPlaying = self.audioPlayer?.isPlaying ?? false
        if self.isPrepared && isPlaying {
            self.audioPlayer?.pause()
            return
        }
        self.isPrepared = false
        self.position = 0
        self.isLoading = false
        self.releasePlayer()
    }

    func startCountTime() {
        self.lblDuration.text = "00 : 00"
        self.stopTimerRecord()
        self.recordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRecordRunning), userInfo: nil, repeats: true)
    }
////
    @objc func timerRecordRunning() {
        if self.timeRecord >= Double(IJamitConstants.MAX_TIME_RECORD) * IJamitConstants.ONE_MINUTE {
            stopRecord()
            return
        }
        self.timeRecord += 1
        self.lblDuration.text = convertToStringTime(time: TimeInterval(self.timeRecord))
    }


    func startUpdateTime() {
        self.stopTimerPlay()
        self.playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerPlayRunning), userInfo: nil, repeats: true)
    }

    @objc func timerPlayRunning() {
        let currentTime = self.audioPlayer?.currentTime ?? TimeInterval(0)
        self.lblDuration.text = convertToStringTime(time: currentTime)
    }

    func stopTimerRecord(){
        if self.recordTimer != nil && self.recordTimer!.isValid {
            self.recordTimer?.invalidate()
        }
        self.recordTimer = nil
    }

    func stopTimerPlay(){
        if self.playTimer != nil && self.playTimer!.isValid {
            self.playTimer?.invalidate()
        }
        self.playTimer = nil
    }

    func deleteOldFile() {
        if self.recordFolder != nil && !pathFile.isEmpty {
            let fileUrl = self.recordFolder!.appendingPathComponent(pathFile)
            let isFileExisted = FileManager.default.fileExists(atPath: fileUrl.path)
            if isFileExisted {
                do {
                    JamitLog.logE("========>start delete record file \(fileUrl)")
                    try FileManager.default.removeItem(at: fileUrl)
                }
                catch let error as NSError {
                    JamitLog.logE("Error When deteting record file: \(error.domain)")
                }
            }
        }
        self.pathFile = ""
    }

    func createFileRecord() -> URL? {
        if self.recordFolder != nil {
            let timeStamp = String(DateTimeUtils.currentTimeMillis()).replacingOccurrences(of: ".", with: "")
            let userID = SettingManager.getUserId()
            let fileName = String(format: IJamitConstants.FORMAT_FILE_NAME, userID,timeStamp)
            JamitLog.logE("========>new record file =\(fileName)")
            self.pathFile = fileName
            return self.recordFolder!.appendingPathComponent(pathFile)
        }
        return nil
    }

    func updateStatePlay(_ isPlay: Bool){
        self.imgPlay.image = UIImage(named: isPlay ? ImageRes.ic_pause_white_36dp : ImageRes.ic_play_white_36dp)
    }

    func getRecordFile() -> URL? {
        if self.recordFolder != nil && !pathFile.isEmpty {
            let fileUrl = self.recordFolder!.appendingPathComponent(pathFile)
            let isFileExisted = FileManager.default.fileExists(atPath: fileUrl.path)
            if isFileExisted {
                return fileUrl
            }
        }
        return nil
    }

    func startUpload() {
        self.hideVirtualKeyboard()
        if self.isStartRecording {
            self.showToast(withResId: StringRes.info_upload_file_when_recording)
            return
        }
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        let recordFile = self.getRecordFile()
        if recordFile == nil {
            self.showToast(withResId: StringRes.info_upload_file_error)
            return
        }
        if lanCode.isEmpty || listLanguages == nil || listLanguages!.isEmpty {
            self.showToast(withResId: StringRes.title_story_language)
            return
        }
        if topicId.isEmpty || listTopics == nil || listTopics!.isEmpty {
            showToast(withResId: StringRes.title_story_category)
            return
        }

        let titleStory = self.tfStoryTitle?.text ?? ""
        let titleSeries = self.tfSeriesTitle?.text ?? ""
        if titleStory.isEmpty {
            showToast(with: String(format: getString(StringRes.format_empty_field), getString(StringRes.title_story_title)))
            return
        }
        let tags = self.tfTags?.text ?? ""
        let explicit = self.switchExplicit.isOn ? "yes" : "no"
        let token = SettingManager.getSetting(SettingManager.KEY_USER_TOKEN)

        let seriesModel = self.listSeries?.first(where: { (model) -> Bool in
            return model.title.lowercased().elementsEqual(titleSeries.lowercased())
        })
        let seriesId = seriesModel?.id ?? ""
        let params = ["token": token,"title" : titleStory , "seriesName": titleSeries,"seriesID": seriesId,
                      "duration": String(Int64(floor(self.timeRecord))), "explicit": explicit,
                      "length": String(recordFile!.fileSize),"tags":tags,
                      "language":lanCode,"topic":topicId]
        JamitLog.logE("=====>upload file params=\(params)")
        self.isPrepared = false
        self.stopPlaying()
        self.showProgress()
        JamItPodCastApi.uploadStory(recordFile!, params: params, self.pathFile) { (episode) in
            self.dismissProgress()
            if episode != nil && episode!.isResultOk() {
                self.showToast(withResId: StringRes.info_upload_file_success)
                self.resetData()

                self.backToHome()
                self.parentVC?.myStoryVC = self.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_MY_STORIES)
                self.parentVC?.addControllerOnContainer(controller: (self.parentVC?.myStoryVC!)!)

                return
            }
            let msg = episode?.message ?? getString(StringRes.info_server_error)
            self.showToast(with: msg)
        }

    }
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
        self.doneHistoryClick()
        self.tfStoryTitle.resignFirstResponder()
        self.tfSeriesTitle.resignFirstResponder()
        self.tfTags.resignFirstResponder()
        self.tfLan.resignFirstResponder()
        self.tfTopic.resignFirstResponder()
    }

    @IBAction func lanTap(_ sender: Any) {
        self.startGetLanguages()
    }

    @IBAction func topicTap(_ sender: Any) {
        self.startGetTopics()
    }

    @IBAction func seriesTap(_ sender: Any) {
        self.showSeriesHistory()
    }

    func showSeriesHistory(){
        self.tfSeriesTitle.resignFirstResponder()
        if self.seriesPickerView == nil || self.seriesToolBar == nil { return }
        self.tfSeriesTitle.inputView = self.seriesPickerView
        let indexSelected = self.listSeries?.firstIndex { (model) -> Bool in
            return model.id.elementsEqual(self.seriesID)
        } ?? 0
        self.seriesPickerView.selectRow(indexSelected, inComponent: 0, animated: true)
        self.tfSeriesTitle.inputAccessoryView = self.seriesToolBar
        self.tfSeriesTitle.becomeFirstResponder()
    }

    func startGetSeries(){
        if !ApplicationUtils.isOnline() { return }
        self.showProgress()
        JamItPodCastApi.getSeriesName{ (list) in
            self.dismissProgress()
            let isEmpty = list?.isEmpty ?? true
            self.btnHistorySeries.isHidden = isEmpty
            if !isEmpty {
                self.listSeries = list
                self.setUpSeriesPickerView()
            }
        }
    }

    func startGetTopics(){
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
            self.tfTopic.becomeFirstResponder()
        }
    }

    func startGetLanguages(){
        if self.lanPickerView != nil { return }
        if !ApplicationUtils.isOnline() {
            self.showToast(withResId: StringRes.info_lose_internet)
            return
        }
        self.showProgress()
        JamItPodCastApi.getAllLocales { (list) in
            self.dismissProgress()
            let isEmpty = list?.isEmpty ?? true
            if isEmpty {
                self.showToast(withResId: StringRes.info_no_story_language)
                return
            }
            self.listLanguages = list
            self.setUpLanPickerView()
            self.tfLan.becomeFirstResponder()
        }
    }

    private func setUpSeriesPickerView(){
        if self.seriesPickerView != nil || self.seriesToolBar != nil  { return }
        self.seriesPickerView = UIPickerView()
        self.seriesPickerView.delegate = self
        self.seriesPickerView.dataSource = self
        //self.seriesPickerView.showsSelectionIndicator = true
        self.seriesPickerView.backgroundColor = getColor(hex: ColorRes.color_background)

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: getString(StringRes.title_done), style: .done, target: self, action: #selector(doneHistoryClick))
        doneButton.tintColor = getColor(hex: ColorRes.dialog_color_accent)

        let titleOption = UIBarButtonItem(title: getString(StringRes.title_story_series), style: .plain, target: nil, action: nil)
        titleOption.tintColor = getColor(hex: ColorRes.dialog_color_main_text)
        let spaceOption = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,  target: nil, action: nil)

        toolBar.setItems([titleOption,spaceOption,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.seriesToolBar = toolBar
    }

    private func setUpLanPickerView(){
        self.btnLan.isHidden = true
        self.tfLan.delegate = self
        self.lanPickerView = UIPickerView()
        self.lanPickerView.delegate = self
        self.lanPickerView.dataSource = self
        //self.lanPickerView.showsSelectionIndicator = true
        self.lanPickerView.backgroundColor = getColor(hex: ColorRes.color_background)
        self.tfLan.inputView = self.lanPickerView

        let indexSelected = self.listLanguages?.firstIndex { (model) -> Bool in
            return model.code.elementsEqual(self.lanCode)
        } ?? 0
        self.lanPickerView.selectRow(indexSelected, inComponent: 0, animated: true)

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: getString(StringRes.title_done), style: .done, target: self, action: #selector(doneClick))
        doneButton.tintColor = getColor(hex: ColorRes.dialog_color_accent)

        let titleOption = UIBarButtonItem(title: getString(StringRes.title_story_language), style: .plain, target: nil, action: nil)
        titleOption.tintColor = getColor(hex: ColorRes.dialog_color_main_text)
        let spaceOption = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,  target: nil, action: nil)

        toolBar.setItems([titleOption,spaceOption,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.tfLan.inputAccessoryView = toolBar
    }

    private func setUpTopicPickerView(){
        self.btnTopic.isHidden = false
        self.tfTopic.delegate = self
        self.topicPickerView = UIPickerView()
        self.topicPickerView.delegate = self
        self.topicPickerView.dataSource = self
        //self.topicPickerView.showsSelectionIndicator = true
        self.topicPickerView.backgroundColor = getColor(hex: ColorRes.color_background)
        self.tfTopic.inputView = self.topicPickerView

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
        self.tfTopic.inputAccessoryView = toolBar
    }
}
// text field delegate to capture event keyboard
extension TabRecordingController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.tfStoryTitle){
            self.tfSeriesTitle.becomeFirstResponder()
        }
        else if(textField == self.tfSeriesTitle){
            self.tfTags.becomeFirstResponder()
        }
        else if(textField == self.tfTags){
            textField.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }

    //prevent textfield can edit when show picker view
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.tfLan || textField == self.tfTopic {
            return false
        }
        return true
    }

}

extension TabRecordingController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        JamitLog.logE("========>finish record =\(flag)")
        if !flag {
            stopRecord()
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        JamitLog.logE("========>Error while recording audio \(error!.localizedDescription)")
        stopRecord()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        JamitLog.logE("========>audio play finished")
        let duration = self.audioPlayer?.duration ?? TimeInterval(self.timeRecord)
        self.lblDuration.text = convertToStringTime(time: duration)

        self.isPrepared = false
        self.stopPlaying()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        JamitLog.logE("=====>Error while playing audio \(error!.localizedDescription)")
        self.isPrepared = false
        self.stopPlaying()
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        JamitLog.logE("=====>audioPlayerBeginInterruption")
        self.stopPlaying()
    }
}

//Extension for pickerview in textfield location
extension TabRecordingController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // number column in pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView  == self.topicPickerView {
            return self.listTopics?.count ?? 0
        }
        else if pickerView  == self.seriesPickerView {
            return self.listSeries?.count ?? 0
        }
        else{
            return self.listLanguages?.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.topicPickerView {
            let model = self.listTopics?[row]
            self.tfTopic.text = model?.name ?? ""
            self.topicId = model?.rootId ?? ""
        }
        else if pickerView == self.seriesPickerView {
            let model = self.listSeries?[row]
            self.tfSeriesTitle.text = model?.title ?? ""
            self.seriesID = model?.id ?? ""
        }
        else{
            let model = self.listLanguages?[row]
            self.tfLan.text = model?.getFullName() ?? ""
            self.lanCode = model?.code ?? ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = ""
        if pickerView == self.topicPickerView {
            let model = self.listTopics?[row]
            title = model?.name ?? ""
        }
        else if pickerView == self.seriesPickerView {
            let model = self.listSeries?[row]
            title = model?.title ?? ""
        }
        else{
            let model = self.listLanguages?[row]
            title = model?.getFullName() ?? ""
        }
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    //click done event when show picker view
    @objc func doneClick() {
        self.tfTopic.resignFirstResponder()
        self.tfLan.resignFirstResponder()
    }
    
    //click done event when show picker view
    @objc func doneHistoryClick() {
        self.tfSeriesTitle.resignFirstResponder()
        self.tfSeriesTitle.inputView = nil
        self.tfSeriesTitle.inputAccessoryView = nil
        
    }
    
}

