//
//  NewTabRecordingController.swift
//  jamit
//
//  Created by Prof K on 3/20/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation
import Foundation

class NewTabRecordingController: JamitRootViewController {
    
    var parentVC: MainController?
    //    var mic = MicrophoneMonitor(numberOfSamples: 75)
    var mic = MicrophoneMonitor()
    
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        //            view.spacing = 10
        view.distribution = .equalCentering
        view.alignment = .fill
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Upper view for holding the form request and the recording view
    private let upperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: This holds the form view
    private let formContainer: UIStackView = {
        let view = UIStackView()
        view.spacing = 30
        view.axis = .vertical
        view.contentMode = .top
        view.distribution = .fillProportionally
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblTitile: UILabel = {
        let label = UILabel()
        label.text = "Tell Your Story"
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tfTitle: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.placeholder = "Title Of Your Story"
        textfield.cornerRadius = 10
        textfield.textColor = .white
        textfield.placeholderColor(color: getColor(hex: "#ECF0FD"))
        textfield.backgroundColor = getColor(hex: "#1B1C1F")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let seriesBGView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var btnSeries: UIButton = {
        let button = UIButton()
        //        button.tintColor = .white
        //        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        //        button.contentMode = .center
        //        button.imageView?.contentScaleFactor = 1
        //        button.imageView?.heightAnchor.constraint(equalToConstant: 5).isActive = true
        //        button.contentScaleFactor = 1
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imgSeriesPick: UIButton = {
        let imageView = UIButton()
        
        imageView.contentMode = .center
        imageView.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        imageView.tintColor = .white
        //        imageView.image =
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tfSeriesTitle: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.isEnabled = true
        textfield.placeholder = "Series Title"
        textfield.cornerRadius = 10
        textfield.textColor = .white
        textfield.placeholderColor(color: getColor(hex: "#ECF0FD"))
        textfield.backgroundColor = getColor(hex: "#1B1C1F")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    private let topicCatBGView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var btnTopic: UIButton = {
        let button = UIButton()
        //        button.tintColor = .white
        
        //        button.imageView?.contentScaleFactor = 1
        //        button.contentScaleFactor = 1
        //        button.imageView?.heightAnchor.constraint(equalToConstant: 5).isActive = true
        //        button.imageView?.contentMode = .center
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imgTopicPick: UIButton = {
        let imageView = UIButton()
        
        imageView.contentMode = .center
        imageView.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        imageView.tintColor = .white
        //        imageView.image =
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tfTopic: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.placeholder = "Topic Category"
        textfield.cornerRadius = 10
        textfield.isEnabled = true
        textfield.textColor = .white
        textfield.placeholderColor(color: getColor(hex: "#ECF0FD"))
        textfield.backgroundColor = getColor(hex: "#1B1C1F")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let langBGView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var btnLang: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        //        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.contentMode = .center
        button.imageView?.contentScaleFactor = 1
        button.imageView?.heightAnchor.constraint(equalToConstant: 5).isActive = true
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imgLanPick: UIButton = {
        let imageView = UIButton()
        
        imageView.contentMode = .center
        imageView.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        imageView.tintColor = .white
        //        imageView.image =
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tfLang: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.placeholder = "English"
        textfield.cornerRadius = 10
        textfield.isEnabled = true
        textfield.placeholderColor(color: getColor(hex: "#ECF0FD"))
        textfield.textColor = .white
        textfield.backgroundColor = getColor(hex: "#1B1C1F")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let tfTags: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.cornerRadius = 10
        textfield.placeholder = "Tags"
        textfield.textColor = .white
        textfield.placeholderColor(color: getColor(hex: "#ECF0FD"))
        textfield.backgroundColor = getColor(hex: "#1B1C1F")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let explicitBGView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let switchExplicit: UISwitch = {
        let button = UISwitch()
        button.thumbTintColor = getColor(hex: "#FFAE29")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lblExplicit: UILabel = {
        let label = UILabel()
        label.text = "Explicit Content"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: End of the form view
    
    //MARK: Begining of the recording view
    
    private let recordingContainer: UIStackView = {
        let view = UIStackView()
        view.spacing = 30
        view.axis = .vertical
        view.contentMode = .top
        view.distribution = .fillProportionally
        //        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let audioView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.borderColor = .lightGray
        view.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let audioDetail: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: "#111111")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblTimer: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont(name: "Poppins-Bold", size: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lblRecording: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 15)
        label.textColor = .lightGray
        label.text = "New Recording"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var btnPlay: UIButton = {
        let button = UIButton()
        button.cornerRadius = 35
        button.tintColor = .black
        button.setImage(UIImage(named: ImageRes.ic_play_white_36dp), for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    //MARK: - Lower view for holding the buttons
    
    private let lowerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnSubmitView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // getColor(hex: "#111111")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let uploadButtonStack: UIStackView = {
        let view = UIStackView()
        view.spacing = 25
        view.axis = .horizontal
        view.distribution = .fillEqually
        //        view.contentMode = .top
        view.alignment = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let uploadView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear //getColor(hex: "#111111")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recordButtonStack: UIStackView = {
        let view = UIStackView()
        view.spacing = 15
        view.distribution = .fillProportionally
        view.contentMode = .scaleAspectFit
        view.axis = .vertical
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let btnStartView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var btnStart: UIButton = {
        let button = UIButton()
        button.cornerRadius = 12
        button.tintColor = .white
        button.setTitle("Start Recording", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 18)
        button.backgroundColor = getColor(hex: "#FD2F00")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var btnRestart: UIButton = {
        let button = UIButton()
        button.cornerRadius = 12
        button.tintColor = .white
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 18)
        button.backgroundColor = getColor(hex: "#FD2F00")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var btnUpload: UIButton = {
        let button = UIButton()
        button.cornerRadius = 12
        button.tintColor = .white
        button.setTitle("Upload", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 18)
        button.backgroundColor = getColor(hex: "#19B600")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    private var timer: Timer?
    
    var seriesID = ""
    var lanCode = ""
    var topicId = ""
    
    var currentSample: Int = 0
    let numberOfSamples: Int = 75
    
    private let placeHolderColor = getColor(hex: ColorRes.main_second_text_color)
    private let borderColor = getColor(hex: ColorRes.color_accent)
    
    let settingRecord = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: IJamitConstants.SAMPLING_RATE,
        AVEncoderBitRateKey: IJamitConstants.BITRATE,
        AVNumberOfChannelsKey: IJamitConstants.NUMBER_CHANNELS,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.pin(to: view)
        //        view.backgroundColor = .black
        recordingContainer.backgroundColor = getColor(hex: "#111111")
        view.addSubview(backButton)
        backButton.pin(to: view, top: 54, left: 24, bottom: nil, right: nil)
        scrollView.addSubview(scrollContentView)
        scrollContentView.pin(to: scrollView)
        
        scrollContentView.addArrangedSubview(upperView)
        scrollContentView.addArrangedSubview(lowerView)
        
        upperView.addSubview(formContainer)
        upperView.addSubview(recordingContainer)
        
        
        //        scrollContentView.addArrangedSubview(scrollContainer)
        // Form view
        formContainer.pin(to: upperView, top: 80, left: 24, bottom: 0, right: -24)
        
        
        
        // Recording View
        recordingContainer.pin(to: upperView, top: 80, left: 0, bottom: 0, right: 0)
        recordingContainer.addArrangedSubview(audioView)
        recordingContainer.addArrangedSubview(audioDetail)
        audioDetail.addSubview(lblTimer)
        audioDetail.addSubview(lblRecording)
        audioDetail.addSubview(btnPlay)
        
        //        scrollContainer.pin(to: upperView)
        formContainer.addArrangedSubview(titleView)
        
        titleView.addSubview(lblTitile)
        lblTitile.pin(to: titleView, top: 0, left: 0, bottom: nil, right: 0)
        formContainer.backgroundColor = .clear
        formContainer.addArrangedSubview(tfTitle)
        formContainer.addArrangedSubview(seriesBGView)
        seriesBGView.addSubview(tfSeriesTitle)
        tfSeriesTitle.pin(to: seriesBGView)
        seriesBGView.addSubview(imgSeriesPick)
        imgSeriesPick.pin(to: seriesBGView, top: 23, left: nil, bottom: -23, right: -20)
        seriesBGView.addSubview(btnSeries)
        btnSeries.pin(to: seriesBGView, top: 0, left: nil, bottom: 0, right: -20)
        
        
        formContainer.addArrangedSubview(topicCatBGView)
        topicCatBGView.addSubview(tfTopic)
        tfTopic.pin(to: topicCatBGView)
        topicCatBGView.addSubview(imgTopicPick)
        imgTopicPick.pin(to: topicCatBGView, top: 23, left: nil, bottom: -23, right: -20)
        topicCatBGView.addSubview(btnTopic)
        btnTopic.pin(to: topicCatBGView, top: 0, left: nil, bottom: 0, right: -20)
        
        formContainer.addArrangedSubview(langBGView)
        langBGView.addSubview(tfLang)
        tfLang.pin(to: langBGView)
        langBGView.addSubview(imgLanPick)
        imgLanPick.pin(to: langBGView, top: 23, left: nil, bottom: -23, right: -20)
        langBGView.addSubview(btnLang)
        btnLang.pin(to: langBGView, top: 0, left: nil, bottom: 0, right: -20)
        
        formContainer.addArrangedSubview(tfTags)
        formContainer.addArrangedSubview(explicitBGView)
        
        explicitBGView.addSubview(switchExplicit)
        switchExplicit.pin(to: explicitBGView, top: 0, left: 0, bottom: nil, right: nil)
        explicitBGView.addSubview(lblExplicit)
        //        scrollContentView.addArrangedSubview(btnSubmitView)
        
        // Button View
        scrollContentView.addArrangedSubview(lowerView)
        //        lowerView.pin(to: scrollContentView, top: nil, left: 24, bottom: -200, right: -24)
        //        btnSubmitView.addSubview(btnStart)
        lowerView.addSubview(btnSubmitView)
        upperView.backgroundColor = .clear //getColor(hex: "#111111")
        lowerView.backgroundColor = .clear//getColor(hex: "#111111")
        btnSubmitView.pin(to: lowerView, top: 5, left: 24, bottom: -50, right: -24)
        btnSubmitView.addSubview(recordButtonStack)
        recordButtonStack.pin(to: btnSubmitView)
        recordButtonStack.addArrangedSubview(btnStartView)
        btnStartView.addSubview(btnStart)
        btnStart.pin(to: btnStartView)
        recordButtonStack.addArrangedSubview(uploadView)
        uploadView.addSubview(uploadButtonStack)
        uploadButtonStack.pin(to: uploadView)
        //        recordButtonStack.addArrangedSubview(uploadButtonStack)
        //        uploadView
        uploadButtonStack.addArrangedSubview(btnRestart)
        uploadButtonStack.addArrangedSubview(btnUpload)
        btnStart.isHidden = false
        uploadButtonStack.backgroundColor = getColor(hex: "#111111")
        setupConstraints()
        setupUI()
        btnLang.addTarget(self, action: #selector(lanTap), for: .touchUpInside)
        btnTopic.addTarget(self, action: #selector(topicTap), for: .touchUpInside)
        btnSeries.addTarget(self, action: #selector(seriesTap), for: .touchUpInside)
        btnStart.addTarget(self, action: #selector(goToRecord), for: .touchUpInside)
        btnPlay.addTarget(self, action: #selector(playTap), for: .touchUpInside)
        btnRestart.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        btnUpload.addTarget(self, action: #selector(uploadTap), for: .touchUpInside)
        
//        uploadButtonStack.isHidden = true
        view.backgroundColor = .black
        
        recordingInitialSetup()
    }
    
    fileprivate func recordingInitialSetup() {
        recordingContainer.isHidden = false
        formContainer.isHidden = true
        btnPlay.isHidden = true
        uploadButtonStack.isHidden = true
        btnStart.isHidden = false
        
        lowerView.backgroundColor = .clear
        upperView.backgroundColor = .clear
        view.backgroundColor = getColor(hex: "#111111")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupRecorder()
        view.backgroundColor = .black
        
        recordingInitialSetup()
    }
    
    //    func setUpConstraints(_ contentView: UIHostingController) {
    //
    //    }
    
    func setupUI() {
        self.tfTitle.delegate = self
        self.tfSeriesTitle.delegate = self
        self.tfTags.delegate = self
        self.registerTapOutSideRecognizer()
        
        //        self.lblRecord.text = getString(StringRes.title_start_recording)
        //        self.lblMaxInfo.text = String(format: getString(StringRes.format_maximum_minute), String(IJamitConstants.MAX_TIME_RECORD))
        //        self.lblUploadStory.text = getString(StringRes.title_upload_story)
        //
        //        self.layoutRecord.isHidden = true
        
    }
    
    func setupConstraints() {
        backButton.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        recordingContainer.isHidden = true
        let width = view.frame.size.width
        let height = view.frame.size.height
        NSLayoutConstraint.activate([
            scrollContentView.widthAnchor.constraint(equalToConstant: width),
            formContainer.widthAnchor.constraint(equalToConstant: width - 48),
            scrollContentView.heightAnchor.constraint(equalToConstant: height),
            upperView.heightAnchor.constraint(equalToConstant: height * 0.72),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            titleView.heightAnchor.constraint(equalToConstant: 90),
            lblTitile.heightAnchor.constraint(equalToConstant: 35),
            
            tfTitle.heightAnchor.constraint(equalToConstant: 54),
            seriesBGView.heightAnchor.constraint(equalToConstant: 54),
            topicCatBGView.heightAnchor.constraint(equalToConstant: 54),
            langBGView.heightAnchor.constraint(equalToConstant: 54),
            tfTags.heightAnchor.constraint(equalToConstant: 54),
            
            btnSeries.widthAnchor.constraint(equalToConstant: 12),
            imgLanPick.widthAnchor.constraint(equalToConstant: 12),
            imgTopicPick.widthAnchor.constraint(equalToConstant: 12),
            imgSeriesPick.widthAnchor.constraint(equalToConstant: 12),
            
            //            btnSeries.heightAnchor.constraint(equalToConstant: 7),
            
            btnTopic.widthAnchor.constraint(equalToConstant: 12),
            //            btnCat.heightAnchor.constraint(equalToConstant: 7),
            
            btnLang.widthAnchor.constraint(equalToConstant: 12),
            //            btnLang.heightAnchor.constraint(equalToConstant: 7),
            explicitBGView.heightAnchor.constraint(equalToConstant: 54),
            
            lblExplicit.topAnchor.constraint(equalTo: switchExplicit.topAnchor),
            lblExplicit.centerXAnchor.constraint(equalTo: explicitBGView.centerXAnchor),
            
            btnSubmitView.heightAnchor.constraint(equalToConstant: 170),
            
            btnStart.heightAnchor.constraint(equalToConstant: 52),
            btnRestart.heightAnchor.constraint(equalToConstant: 52),
            btnUpload.heightAnchor.constraint(equalToConstant: 52),
            //            uploadView.heightAnchor.constraint(equalToConstant: 52),
            //            uploadView
            audioView.heightAnchor.constraint(equalTo: upperView.heightAnchor, multiplier: 0.5),
            audioView.widthAnchor.constraint(equalTo: upperView.widthAnchor, multiplier: 1.2),
            audioView.centerXAnchor.constraint(equalTo: upperView.centerXAnchor),
            audioDetail.heightAnchor.constraint(equalTo: upperView.heightAnchor, multiplier: 0.38),
            lblTimer.centerXAnchor.constraint(equalTo: audioDetail.centerXAnchor),
            lblTimer.topAnchor.constraint(equalTo: audioDetail.topAnchor, constant: 30),
            lblRecording.topAnchor.constraint(equalTo: lblTimer.bottomAnchor, constant: 10),
            lblRecording.centerXAnchor.constraint(equalTo: audioDetail.centerXAnchor),
            btnPlay.topAnchor.constraint(equalTo: lblRecording.bottomAnchor, constant: 25),
            btnPlay.centerXAnchor.constraint(equalTo: audioDetail.centerXAnchor),
            btnPlay.heightAnchor.constraint(equalToConstant: 70),
            btnPlay.widthAnchor.constraint(equalToConstant: 70),
            
        ])
    }
    
    
    func setUpBorder() {
        self.tfTitle.setBottomBorder(withColor: borderColor)
        self.tfSeriesTitle.setBottomBorder(withColor: borderColor)
        self.tfTags.setBottomBorder(withColor: borderColor)
        self.tfLang.setBottomBorder(withColor: borderColor)
        self.tfTopic.setBottomBorder(withColor: borderColor)
    }
    @objc private func goToRecord() {
        
        let sView = ContentView()
        let contentView = UIHostingController(rootView: sView.environmentObject(mic))
        
        addChild(contentView)
        audioView.addSubview(contentView.view)
        contentView.view.backgroundColor = .black
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: audioView.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: audioView.bottomAnchor),
            contentView.view.leftAnchor.constraint(equalTo: audioView.leftAnchor),
            contentView.view.rightAnchor.constraint(equalTo: audioView.rightAnchor)
        ])
        
        formContainer.isHidden = true
        view.backgroundColor = getColor(hex: "#111111")
        
        recordingContainer.isHidden = false
        btnStart.setTitle("Finish Recording", for: .normal)
        btnStart.backgroundColor = .green
        
        onRecord()
    }
    @objc func backTap(_ sender: Any) {
        if recordingContainer.isHidden == true {
            recordingContainer.isHidden = false
            formContainer.isHidden = true
            uploadButtonStack.isHidden = false
            view.backgroundColor = getColor(hex: "#111111")
            uploadView.backgroundColor = getColor(hex: "#111111")
            return
        }
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
    
    
    
    @objc func recordTap(_ sender: Any) {
        self.onRecord()
    }
    
    func onRecord() {
        if !self.isStartRecording {
            if !self.pathFile.isEmpty {
                
                return
            }
            self.startRecord()
            btnStart.isHidden = false
            uploadButtonStack.isHidden = true
        }
        else{
            stopRecord()
            btnStart.isHidden = true
            uploadButtonStack.isHidden = false
        }
    }
    
    @objc private func restartTapped() {
        
        restartRecording()
    }
    
    func restartRecording() {
        let msg = getString(StringRes.info_recording_again)
        let titleCancel = getString(StringRes.title_cancel)
        let titleYes = getString(StringRes.title_record_again)
        self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleYes, negative: titleCancel, completion: {
            self.deleteOldFile()
            self.mic.soundSamples = [Float](repeating: .zero, count: 75)
            self.startRecord()
            self.recordingInitialSetup()
        })
    }
    
    func startRecord() {
        //        self.layoutRecord.isHidden = false
        self.isPrepared = false
        self.stopPlaying()
        self.lblTimer.text = "00 : 00"
        self.lblTimer.isHidden = false
        //        self.lblMaxInfo.isHidden = false
        self.timeRecord = 0
        self.btnPlay.isHidden = true
        //        self.btnUpload.isHidden = true
//        uploadButtonStack.isHidden = false
        
        self.btnStart.backgroundColor = getColor(hex: ColorRes.color_recording)
        //        self.lblRecord.textColor = .white
        //        self.imgRecord.tintColor = .white
        
        if let recordFile = self.createFileRecord() {
            
            JamitLog.logE("====>recordFile=\(recordFile)")
            do {
                self.isStartRecording = true
                self.audioRecorder = try AVAudioRecorder(url: recordFile, settings: settingRecord)
                self.audioRecorder?.delegate = self
                self.audioRecorder?.record()
                self.startCountTime()
                btnStart.setTitle(getString(StringRes.title_stop_recording), for: .normal)
                startMonitoring()
                //                                self.lblRecord.text =
                //                self.imgRecord.image = UIImage(named: ImageRes.ic_stop_36dp)
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
    
    func startMonitoring() {
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            // 7
            self.audioRecorder?.updateMeters()
            self.mic.soundSamples[self.currentSample] = self.audioRecorder?.averagePower(forChannel: 0) ?? 0.0
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            
            //            print("This is the sound samples \(self.soundSamples)")
        })
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        audioRecorder?.stop()
    }
    
    func stopRecord() {
        self.stopTimerRecord()
        self.releaseRecorder()
        //        self.lblMaxInfo.isHidden = true
        self.isStartRecording = false
        self.btnPlay.isHidden = false
        self.updateStatePlay(false)
        timer?.invalidate()
        //        stopMonitoring()
        //        self.lblRecord.text = getString(StringRes.title_record_again)
        //        self.imgRecord.image = UIImage(named: ImageRes.ic_stories_36dp)
        //        self.btnUpload.isHidden = false
        
        let colorRecord = getColor(hex: ColorRes.color_recording)
        //        self.btnRecord.backgroundColor = .white
        //        self.lblRecord.textColor = colorRecord
        //        self.imgRecord.tintColor = colorRecord
    }
    //
    @objc func uploadTap(_ sender: Any) {
        if formContainer.isHidden {
            formContainer.isHidden = false
            recordingContainer.isHidden = true
            backButton.isHidden = false
            view.backgroundColor = .black
            uploadButtonStack.backgroundColor = .black
            return
        }
        self.startUpload()
    }
    
    @objc func playTap(_ sender: Any) {
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
                //                timer.position(x: 0, y: 0)
                return
            }
            
        }
        catch {
            self.backToHome(StringRes.info_permission_unknow_error)
        }
    }
    
    
    func resetData() {
        self.tfTitle.text = ""
        self.tfSeriesTitle.text = ""
        self.tfTags.text = ""
        self.seriesID = ""
        self.lanCode = ""
        self.topicId = ""
        self.lblTimer.text = getString(StringRes.title_start_recording)
        self.uploadView.isHidden = true
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
                self.lblTimer.text = "00 : 00"
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
        self.lblTimer.text = "00 : 00"
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
        self.lblTimer.text = convertToStringTime(time: TimeInterval(self.timeRecord))
    }
    
    
    func startUpdateTime() {
        self.stopTimerPlay()
        self.playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerPlayRunning), userInfo: nil, repeats: true)
    }
    
    @objc func timerPlayRunning() {
        let currentTime = self.audioPlayer?.currentTime ?? TimeInterval(0)
        self.lblTimer.text = convertToStringTime(time: currentTime)
    }
    
    @objc func lanTap(_ sender: UIButton) {
        self.startGetLanguages()
    }
    
    @objc func topicTap(_ sender: Any) {
        self.startGetTopics()
    }
    
    @objc func seriesTap(_ sender: Any) {
        //        self.startGetSeries()
        self.showSeriesHistory()
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
                    JamitLog.logE("Error When deleting record file: \(error.domain)")
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
        btnPlay.setImage(UIImage(named: isPlay ? ImageRes.ic_pause_white_36dp : ImageRes.ic_play_white_36dp), for: .normal)
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
        
        let titleStory = self.tfTitle.text ?? ""
        let titleSeries = self.tfSeriesTitle.text ?? ""
        if titleStory.isEmpty {
            showToast(with: String(format: getString(StringRes.format_empty_field), getString(StringRes.title_story_title)))
            return
        }
        let tags = self.tfTags.text ?? ""
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
    
    
    func startGetLanguages() {
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
            self.tfLang.becomeFirstResponder()
        }
    }
    
    private func setUpLanPickerView() {
        self.btnLang.isHidden = false
        self.tfLang.delegate = self
        self.lanPickerView = UIPickerView()
        self.lanPickerView.delegate = self
        self.lanPickerView.dataSource = self
        //self.lanPickerView.showsSelectionIndicator = true
        self.lanPickerView.backgroundColor = getColor(hex: ColorRes.color_background)
        self.tfLang.inputView = self.lanPickerView
        
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
        self.tfLang.inputAccessoryView = toolBar
    }
    
    func showSeriesHistory() {
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
    
    func startGetSeries() {
        if !ApplicationUtils.isOnline() { return }
        self.showProgress()
        JamItPodCastApi.getSeriesName{ (list) in
            self.dismissProgress()
            let isEmpty = list?.isEmpty ?? true
            //            self.btnHistorySeries.isHidden = isEmpty
            if !isEmpty {
                self.listSeries = list
                self.setUpSeriesPickerView()
            }
        }
    }
    
    func startGetTopics() {
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
    
    
    private func setUpSeriesPickerView() {
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
    
    
    
    private func setUpTopicPickerView() {
        //        self.btnTopic.isHidden = true
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
    
    override func hideVirtualKeyboard() {
        super.hideVirtualKeyboard()
        self.doneHistoryClick()
        self.tfTitle.resignFirstResponder()
        self.tfSeriesTitle.resignFirstResponder()
        self.tfTags.resignFirstResponder()
        self.tfLang.resignFirstResponder()
        self.tfTopic.resignFirstResponder()
    }
}


  

    

    
//
//    @objc private func backbuttonTapped() {
//        if !self.pathFile.isEmpty {
//            let msg = getString(StringRes.info_record_back)
//            let titleCancel = getString(StringRes.title_cancel)
//            let titleYes = getString(StringRes.title_yes)
//            self.showAlertWith(title: getString(StringRes.title_confirm), message: msg, positive: titleYes, negative: titleCancel, completion: {
//                self.backToHome()
//            })
//            return
//        }
//        self.backToHome()
//        print("Back button tapped")
//    }
//
//    func backToHome(_ msgId: String? = nil){
//        self.listTopics?.removeAll()
//        self.listLanguages?.removeAll()
//        self.listSeries?.removeAll()
//
//        self.listTopics = nil
//        self.listLanguages = nil
//        self.listSeries = nil
//
////        self.stopTimerRecord()
////        self.stopTimerPlay()
////        self.unregisterTapOutSideRecognizer()
////        self.releaseRecorder()
////        self.releasePlayer()
////        self.deleteOldFile()
//        self.dismiss(animated: true) {
//            if msgId != nil {
//                self.parentVC?.showToast(withResId: msgId!)
//            }
//        }
//    }
    
//}


extension NewTabRecordingController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
            self.tfLang.text = model?.getFullName() ?? ""
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
        self.tfLang.resignFirstResponder()
    }
    
    //click done event when show picker view
    @objc func doneHistoryClick() {
        self.tfSeriesTitle.resignFirstResponder()
        self.tfSeriesTitle.inputView = nil
        self.tfSeriesTitle.inputAccessoryView = nil
        
    }
    
}


extension NewTabRecordingController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {

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
        self.lblTimer.text = convertToStringTime(time: duration)

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


extension NewTabRecordingController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.tfTitle){
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
        if textField == self.tfLang || textField == self.tfTopic {
            return false
        }
        return true
    }

}
