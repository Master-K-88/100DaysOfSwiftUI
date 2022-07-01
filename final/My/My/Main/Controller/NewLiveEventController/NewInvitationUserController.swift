//
//  NewInvitationUserController.swift
//  jamit
//
//  Created by Prof K on 5/4/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewInvitationUserController: JamitRootViewController {
    
    var parentVC: LiveEventController?
    var event: EventModel?
    var dismissDelegate: LiveEventController?
    var isAllowRefresh: Bool = false
    
    var mainView = UIView()
    var bgView = UIView()
    
    private let inviteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Invite someone into the room"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        return label
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: "#979797")
        view.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Find People and Clubs"
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
    
    let usersView: UIView = {
        let view = UIView()
        view.backgroundColor = getColor(hex: "#161616")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnContainerView: UIStackView = {
       let view = UIStackView()
        view.spacing = 15
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnInvite: UIButton = {
       let button = UIButton()
//        button.setTitle("Category", for: .normal)
        button.setImage(UIImage(named: ImageRes.ic_share), for: .normal)
        button.tintColor = .white
        button.backgroundColor = getColor(hex: "#3b3b3b")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnMessage: UIButton = {
       let button = UIButton()
//        button.setTitle("Topics", for: .normal)
        button.setImage(UIImage(named: ImageRes.ic_copy), for: .normal)
        button.tintColor = .white
        button.backgroundColor = getColor(hex: "#3b3b3b")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnMore: UIButton = {
       let button = UIButton()
//        button.setTitle("Topics", for: .normal)
        button.setImage(UIImage(named: ImageRes.ic_more), for: .normal)
        button.tintColor = .white
        button.backgroundColor = getColor(hex: "#3b3b3b")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var usersCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
//        view.layer.cornerRadius = 20
        setupView()
        
//        LiveEventController().view.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let userLayout = UICollectionViewFlowLayout()
        userLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        userLayout.minimumInteritemSpacing = 15.0
        userLayout.minimumLineSpacing = 15.0
        userLayout.scrollDirection = .vertical
        self.usersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: userLayout)
        
        guard let usersCollectionView = self.usersCollectionView else {
                  return
              }
        
        usersView.addSubview(usersCollectionView)
        usersCollectionView.frame = usersView.bounds
        
        DispatchQueue.main.async {
            
            usersCollectionView.register(NewLiveUserCell.self, forCellWithReuseIdentifier: NewLiveUserCell.identifier)
            
            usersCollectionView.dataSource = self
            usersCollectionView.delegate = self
            
            usersCollectionView.backgroundColor = getColor(hex: "#161616")
        }
    }
    
    @objc func removeInviteScreen() {
//        removeView()
        print("Tapped inside the view")
    }
    
    func removeView() {
        self.hideVirtualKeyboard()
        self.unregisterTapOutSideRecognizer()
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            self.dismissDelegate?.dismiss(controller: self)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.mainView) else { return }
        if !view.frame.contains(location) {
            removeView()
        } else {
            print("Tapped inside the view")
        }
    }
    
    func setupView() {
        view.addSubview(bgView)
        view.addSubview(mainView)
        mainView.addSubview(inviteLabel)
        
        bgView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        bgView.backgroundColor = .black
        bgView.alpha = 0.7
        
        btnMore.cornerRadius = 24
        btnMessage.cornerRadius = 24
        btnInvite.cornerRadius = 24
        
        mainView.frame = CGRect(x: 20, y: view.bounds.height/4, width: view.bounds.width - 40, height: view.bounds.height/2.5)
        mainView.backgroundColor = getColor(hex: "#161616")
        mainView.alpha = 1.0
        
        
        mainView.layer.cornerRadius = 20
//        mainView.center = view.center
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(removeInviteScreen))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        self.mainView.addGestureRecognizer(gestureRecognizer)
        
        mainView.addSubview(searchView)
        mainView.addSubview(usersView)
        mainView.addSubview(btnContainerView)
        
        searchView.addSubview(btnSearch)
        searchView.addSubview(searchTextField)
        
        
        btnContainerView.addArrangedSubview(btnInvite)
        btnContainerView.addArrangedSubview(btnMessage)
        btnContainerView.addArrangedSubview(btnMore)
        
        NSLayoutConstraint.activate([
            inviteLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            inviteLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            searchView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            searchView.topAnchor.constraint(equalTo: inviteLabel.bottomAnchor, constant: 17),
            searchView.heightAnchor.constraint(equalToConstant: 40),
            btnSearch.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 8),
           
            btnSearch.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            btnSearch.heightAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.8),
            btnSearch.widthAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.8),
            
            searchTextField.leadingAnchor.constraint(equalTo: btnSearch.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor),
            
            usersView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 30),
            usersView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            usersView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            usersView.bottomAnchor.constraint(equalTo: btnContainerView.topAnchor, constant: -5),
            
            btnContainerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            btnContainerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            btnContainerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20),
            btnContainerView.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.15),
            
            btnMore.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.13),
            btnMessage.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.13),
            btnInvite.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.13),
            
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewInvitationUserController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

extension NewInvitationUserController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch collectionView {
        case usersCollectionView:
            let pos: Int = indexPath.row
//            guard let listModels = viewModel.listCategory else {
//                return
//            }
//            let item = listModels[pos]
//            self.itemDelegate?.clickItem(list: listModels, model: item, position: pos)
            
//        case topicCollectionView:
//            let pos: Int = indexPath.row
//            guard let listModels = viewModel.listPopularTopics else {
//                return
//            }
//            let item = listModels[pos]
//            self.itemDelegate?.clickItem(list: listModels, model: item, position: pos)
            
        default:
            print("Nothing here")
        }
    }
}

extension NewInvitationUserController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let cell = usersCollectionView?.dequeueReusableCell(withReuseIdentifier: NewLiveUserCell.identifier, for: indexPath) as? NewLiveUserCell else {
                return UICollectionViewCell()
            }
//            cell.updateUI(model, indexPath.row)
            return cell
            
        
    }
}

extension NewInvitationUserController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width - 52
        switch collectionView {
        case usersCollectionView:
            return CGSize(width: width * 0.18, height: width * 0.15)
        default:
            return CGSize(width: width * 0.4, height: width * 0.25)
        }
    }
    
}

extension NewInvitationUserController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        searchContent()
        return true
    }
}
