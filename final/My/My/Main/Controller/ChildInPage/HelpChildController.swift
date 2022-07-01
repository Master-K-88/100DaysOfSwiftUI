//
//  HelpChildController.swift
//  jamit
//
//  Created by YPY Global on 4/7/20.
//  Copyright © 2020 YPY Global. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class HelpChildController: JamitRootViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var changeableView: UIView!
    
    var interestingTopics = [InterestingTopics]()
    
    var newTopics = ["Fiction", "Music", "Technology", "True Crime", "Culture", "TV & Film", "Religion", "History", "Comedy", "Education"]
    
    var gender = ""
    
    lazy var topicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 23.0
        layout.minimumLineSpacing = 23.0
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    lazy var podcastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 23.0
        layout.minimumLineSpacing = 23.0
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    lazy var podcasterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 23.0
        layout.minimumLineSpacing = 23.0
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    lazy var firstView: UIView = {
        let view = UIView()
        view.addSubview(firstViewStack)
        firstViewStack.pin(to: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var maleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_male")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var maleLabel: UILabel = {
        let label = UILabel()
        label.text = "Male"
        label.textAlignment = .center
        label.borderColor = getColor(hex: "#B3B3B3")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maleView: UIView = {
        let view = UIView()
        view.addSubview(maleImageView)
        maleImageView.pin(to: view, top: 0, left: 0, bottom: nil, right: 0)
        maleImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        view.addSubview(maleLabel)
        maleLabel.pin(to: view, top: nil, left: 0, bottom: 0, right: 0)
        maleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        view.addSubview(maleButton)
        maleButton.pin(to: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var maleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(maleSelected), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var femaleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(femaleSelected), for: .touchUpInside)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func femaleSelected() {
        print("Female button tapped")
        femaleImageView.borderWidth = 6
        femaleImageView.borderColor = getColor(hex: "#FFAE29")
        maleImageView.borderWidth = 0
        femaleLabel.textColor = getColor(hex: "#FFAE29")
        maleLabel.textColor = getColor(hex: "#B3B3B3")
        gender = "female"
    }
    
    @objc func maleSelected() {
        print("Male button tapped")
        maleImageView.borderWidth = 6
        maleImageView.borderColor = getColor(hex: "#FFAE29")
        femaleImageView.borderWidth = 0
        maleLabel.textColor = getColor(hex: "#FFAE29")
        femaleLabel.textColor = getColor(hex: "#B3B3B3")
        gender = "male"
    }
    
    lazy var femaleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_female")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Female"
        label.textAlignment = .center
        label.borderColor = getColor(hex: "#B3B3B3")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var femaleView: UIView = {
        let view = UIView()
        view.addSubview(femaleImageView)
        femaleImageView.pin(to: view, top: 0, left: 0, bottom: nil, right: 0)
        femaleImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        view.addSubview(femaleLabel)
        femaleLabel.pin(to: view, top: nil, left: 0, bottom: 0, right: 0)
        femaleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        view.addSubview(femaleButton)
        femaleButton.pin(to: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var firstViewStack: UIStackView = {
        let view = UIStackView()
        view.addArrangedSubview(maleView)
        view.addArrangedSubview(femaleView)
        view.spacing = 23
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var secondView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var usernameField: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.textPadding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        textfield.placeholder = "First Name, Last Name"
        textfield.placeholderColor(color: .gray)
        textfield.textColor = .gray
        textfield.cornerRadius = 6
        textfield.backgroundColor = getColor(hex: "#212130")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var thirdView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.textfield_bgcolor)
        view.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "episodes or podcasts"
        textfield.textColor = UIColor(named: ColorRes.search_textcolor)
        textfield.placeholderColor(color: getColor(hex: "#696B7C"))
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let btnSearch: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = getColor(hex: "#696B7C")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fourthView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchPodcasterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.textfield_bgcolor)
        view.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchPodcasterTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Favourite Podcaster"
        textfield.backgroundColor = UIColor(named: ColorRes.textfield_bgcolor)
        textfield.textColor = UIColor(named: ColorRes.search_textcolor)
        textfield.placeholderColor(color: getColor(hex: "#696B7C"))
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let btnSearchPodcaster: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = getColor(hex: "#696B7C")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fifthView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var model: HelpModel!
    var index: Int = -1
    
    override func setUpUI() {
        super.setUpUI()
        lblTitle.textColor = .label
        lblInfo.textColor = .label
        topicCollectionView.showsVerticalScrollIndicator = false
        podcastCollectionView.showsVerticalScrollIndicator = false
        podcasterCollectionView.showsVerticalScrollIndicator = false
        
        [firstView, secondView, thirdView, fourthView, fifthView].forEach { newView in
            changeableView.addSubview(newView)
            newView.pin(to: changeableView)
        }
        newTopics.forEach { topic in
            let newInterestingTopic = InterestingTopics(title: topic, selectedState: false)
            interestingTopics.append(newInterestingTopic)
        }
        thirdView.addSubview(usernameField)
        usernameField.pin(to: thirdView, top: 0, left: 0, bottom: nil, right: 0)
        usernameField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        maleLabel.textColor = getColor(hex: "#B3B3B3")
        femaleLabel.textColor = getColor(hex: "#B3B3B3")
        
        secondView.addSubview(topicCollectionView)
        topicCollectionView.pin(to: secondView)
        fourthView.addSubview(searchView)
        searchView.pin(to: fourthView, top: 0, left: 0, bottom: nil, right: 0)
        fourthView.addSubview(podcastCollectionView)
        podcastCollectionView.pin(to: fourthView, top: nil, left: 0, bottom: 0, right: 0)
        
        searchView.addSubview(btnSearch)
        searchView.addSubview(searchTextField)
        
        
        fifthView.addSubview(searchPodcasterView)
        searchPodcasterView.pin(to: fifthView, top: 0, left: 0, bottom: nil, right: 0)
        fifthView.addSubview(podcasterCollectionView)
        podcasterCollectionView.pin(to: fifthView, top: nil, left: 0, bottom: 0, right: 0)
        
        searchPodcasterView.addSubview(btnSearchPodcaster)
        searchPodcasterView.addSubview(searchPodcasterTextField)
        setupConstraints()
//        topicCollectionView.frame = secondView.bounds
        
        DispatchQueue.main.async {
            
            self.topicCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
            self.topicCollectionView.register(InterestingTopicCell.self, forCellWithReuseIdentifier: InterestingTopicCell.identifier)
            self.topicCollectionView.dataSource = self
            self.topicCollectionView.delegate = self
            
            
            self.podcastCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
            self.podcastCollectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: FavoritePodcastCell.identifier)
            self.podcastCollectionView.dataSource = self
            self.podcastCollectionView.delegate = self
            
            self.podcasterCollectionView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
            self.podcasterCollectionView.register(PodcasterCell.self, forCellWithReuseIdentifier: PodcasterCell.identifier)
            self.podcasterCollectionView.dataSource = self
            self.podcasterCollectionView.delegate = self
        }
        
        self.lblTitle.text = model.name
        self.lblInfo.text = model.info
        switch index {
        case 0:
            hideSubViews()
            firstView.isHidden = false
            firstView.backgroundColor = .clear
        case 1:
            hideSubViews()
            secondView.isHidden = false
            secondView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        case 2:
            hideSubViews()
            thirdView.isHidden = false
            thirdView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        case 3:
            hideSubViews()
            fourthView.isHidden = false
            fourthView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        case 4:
            hideSubViews()
            fifthView.isHidden = false
            fifthView.backgroundColor = UIColor(named: ColorRes.backgroun_color)
        default:
            hideSubViews()
        }
    }
    
    func setupConstraints() {
        let width = changeableView.frame.size.width
        
        NSLayoutConstraint.activate([
            searchView.heightAnchor.constraint(equalTo: fourthView.widthAnchor, multiplier: 0.15),
            btnSearch.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: width * 0.05),
           
            btnSearch.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            btnSearch.heightAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.8),
            btnSearch.widthAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.8),
            
            searchTextField.leadingAnchor.constraint(equalTo: btnSearch.trailingAnchor, constant: width * 0.02),
            searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor),
            
            podcastCollectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor,constant: 5),
            
            
            searchPodcasterView.heightAnchor.constraint(equalTo: fifthView.widthAnchor, multiplier: 0.15),
            btnSearchPodcaster.leadingAnchor.constraint(equalTo: searchPodcasterView.leadingAnchor, constant: width * 0.05),
           
            btnSearchPodcaster.centerYAnchor.constraint(equalTo: searchPodcasterView.centerYAnchor),
            btnSearchPodcaster.heightAnchor.constraint(equalTo: searchPodcasterView.heightAnchor, multiplier: 0.8),
            btnSearchPodcaster.widthAnchor.constraint(equalTo: searchPodcasterView.heightAnchor, multiplier: 0.8),
            
            searchPodcasterTextField.leadingAnchor.constraint(equalTo: btnSearchPodcaster.trailingAnchor, constant: width * 0.02),
            searchPodcasterTextField.trailingAnchor.constraint(equalTo: searchPodcasterView.trailingAnchor),
            searchPodcasterTextField.topAnchor.constraint(equalTo: searchPodcasterView.topAnchor),
            searchPodcasterTextField.bottomAnchor.constraint(equalTo: searchPodcasterView.bottomAnchor),
            
            podcasterCollectionView.topAnchor.constraint(equalTo: searchPodcasterView.bottomAnchor,constant: 5),
        ])
    }
    
    func hideSubViews() {
        firstView.isHidden = true
        secondView.isHidden = true
        thirdView.isHidden = true
        fourthView.isHidden = true
        fifthView.isHidden = true
    }
    
}

struct InterestingTopics {
    let title: String
    var selectedState: Bool
}

extension HelpChildController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case topicCollectionView:
            interestingTopics[indexPath.row].selectedState = !interestingTopics[indexPath.row].selectedState
            DispatchQueue.main.async {
                self.topicCollectionView.reloadData()
            }
        case podcastCollectionView:
            break
        case podcasterCollectionView:
            break
        default:
            break
        }
        
        
    }
}

extension HelpChildController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topicCollectionView:
            return interestingTopics.count
        case podcastCollectionView:
            return 10
        case podcasterCollectionView:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topicCollectionView:
            guard let cell = topicCollectionView.dequeueReusableCell(withReuseIdentifier: InterestingTopicCell.identifier, for: indexPath) as? InterestingTopicCell else {
                print("This is other collection printed for now")
                return UICollectionViewCell()
            }
            let model = interestingTopics[indexPath.row]
            cell.updateUI(model)
            return cell
        case podcastCollectionView:
            guard let cell = podcastCollectionView.dequeueReusableCell(withReuseIdentifier: FavoritePodcastCell.identifier, for: indexPath) as? FavoritePodcastCell else {
                print("This is other collection printed for now")
                return UICollectionViewCell()
            }
            return cell
        case podcasterCollectionView:
            guard let cell = podcasterCollectionView.dequeueReusableCell(withReuseIdentifier: PodcasterCell.identifier, for: indexPath) as? PodcasterCell else {
                print("This is other collection printed for now")
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
}

extension HelpChildController: FollowButtonTapped {
    func btnFollowTapped(_ title: String) {
        print("The user is \(title) the podcaster")
    }
    
    
}

extension HelpChildController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width - 72
        switch collectionView {
        case topicCollectionView:
            return CGSize(width: width * 0.5, height: width * 0.23)
        case podcastCollectionView:
            return CGSize(width: width * 0.29, height: width * 0.29)
        case podcasterCollectionView:
            return CGSize(width: width, height: width * 0.2)
        default:
            return CGSize(width: width * 0, height: width * 0)
        }
        
       
    }
    
}

extension HelpChildController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //        searchContent()
        return true
    }
}
