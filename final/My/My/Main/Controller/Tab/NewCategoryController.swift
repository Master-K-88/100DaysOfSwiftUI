//
//  NewCategoryController.swift
//  jamit
//
//  Created by Prof K on 3/15/22.
//  Copyright © 2022 Jamit Technologies, Inc. All rights reserved.
//

import UIKit

class NewCategoryController: JamitRootViewController {

    @IBOutlet weak var lblNodata : UILabel!
    @IBOutlet var progressBar: UIActivityIndicatorView!
    @IBOutlet weak var catView: UIView!
    
    var viewModel: CatergoryViewModel!
    
    let scrollContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .fill
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var typeVC: Int = 0
    var isAllowRefresh = true
    var itemDelegate: AppItemDelegate?
    var parentVC: MainController?
    var isTab = false
    var isAllowReadCache = false
    var isReadCacheWhenNoData = false
    var isCatShow: Bool = true
    
    let scrollView: UIScrollView = {
       let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIStackView = {
       let view = UIStackView()
        view.spacing = 20
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.contentMode = .scaleToFill
        view.alignment = .fill
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "episodes or podcasts"
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
    
    //MARK: - Button stack view for changing the category
    
    let btnContainerView: UIStackView = {
       let view = UIStackView()
        view.spacing = 10
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnCat: UIButton = {
       let button = UIButton()
        button.setTitle("Category", for: .normal)
        button.tintColor = getColor(hex: "#FFFFFF")
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let btnTopics: UIButton = {
       let button = UIButton()
        button.setTitle("Topics", for: .normal)
        button.tintColor = getColor(hex: "#FFFFFF")
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Category container
    
    let categoryContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.alignment = .fill
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Trending view
    let btnTrendingBG: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // Trending view button with image icon
    let btnTrending: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "img_trending"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // Trending view topic title
    let trendingTitle: UILabel = {
       let label = UILabel()
        label.text = "Top 10"
        label.textColor = .white
//        label.font =  
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Trending view topic subbtitle
    let trendingSubTitle: UILabel = {
       let label = UILabel()
        label.text = "Podcast this week"
        label.textColor = .white
//        label.font =
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Topic view
    let topicsView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 15
        view.contentMode = .scaleToFill
        view.alignment = .fill
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trendingTopicBG: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let btnTrendingCat: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "img_trend"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let trendingCatTitle: UILabel = {
       let label = UILabel()
        label.text = "Trending"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trendingEditorPickBG: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let btnEditorPick: UIButton = {
       let button = UIButton()
        button.contentMode = .top
        button.backgroundColor = .clear
        button.backgroundImage(for: .normal)
        button.setImage(UIImage(named: "img_editor_pick"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let lblEditorPick: UILabel = {
       let label = UILabel()
        label.text = "Editor Picks"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    @IBOutlet var bottomHeight: NSLayoutConstraint!
    
    private var categoryCollectionView: UICollectionView?
    private var topicCollectionView: UICollectionView?
    
    let fontTitle = UIFont(name: IJamitConstants.FONT_BOLD, size: DimenRes.text_size_title) ?? UIFont.systemFont(ofSize: DimenRes.text_size_body)
    let fontBody = UIFont(name: IJamitConstants.FONT_LIGHT, size: DimenRes.text_size_body) ?? UIFont.systemFont(ofSize: DimenRes.text_size_body)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNodata.isHidden = true
        progressBar.isHidden = true

        trendingTitle.font = fontTitle
        trendingSubTitle.font = fontBody
        
        setupView()
        setupConstraints()
        viewModel.catButtonSelected()
        categorySelected()
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refetchData), for: .valueChanged)
        
        searchTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        btnTopics.addTarget(self, action: #selector(btnTopicSelected), for: .touchUpInside)
        btnCat.addTarget(self, action: #selector(btnCatSelected), for: .touchUpInside)
        btnTrending.addTarget(self, action: #selector(topTenSelected), for: .touchUpInside)
        btnSearch.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        topicSelected()
        
        categorySelected()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollContainer.backgroundColor = .black
    }
    
    @objc func refetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func btnCatSelected() {
        viewModel.catButtonSelected()
    }
    
    @objc func btnTopicSelected() {
        viewModel.topicButtonSelected()
    }
    
    @objc private func searchTapped() {
        searchContent()
    }
    
    @objc func topTenSelected() {
        guard let episodeVC = self.parentVC?.createStoryVC(IJamitConstants.TYPE_VC_TOP_TEN_PODCASTS) else {
            return
        }
//        episodeVC.topic = model as? TopicModel
        self.parentVC?.addControllerOnContainer(controller: episodeVC)
    }
    
    private func searchContent() {
        if !(searchTextField.text?.isEmpty)!{
            let temp = searchTextField.text!
            self.searchTextField.text = ""
            self.hideVirtualKeyboard()
            self.parentVC?.goToSearch(temp)
        }
        else {
            self.hideVirtualKeyboard()
        }
    }
    
    fileprivate func categorySelected() {
        viewModel.isCatSelected = { [weak self] in
            
            let categoryLayout = UICollectionViewFlowLayout()
            categoryLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            categoryLayout.minimumInteritemSpacing = 12.0
            categoryLayout.minimumLineSpacing = 16.0
            categoryLayout.scrollDirection = .vertical
            
            self?.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
            
            guard let categoryCollectionView = self?.categoryCollectionView,
                  let collectionContainerView = self?.collectionContainerView else {
                      return
                  }
            collectionContainerView.addSubview(categoryCollectionView)
            
            categoryCollectionView.frame = collectionContainerView.bounds
            DispatchQueue.main.async {
                self?.categoryContainer.isHidden = false
                self?.btnCat.backgroundColor = getColor(hex: "#FFAE29")
                self?.btnCat.setTitleColor(.black, for: .normal)
                self?.btnTopics.backgroundColor = getColor(hex: "#171715")
                self?.btnTopics.setTitleColor(.white, for: .normal)
                self?.isCatShow = true
                categoryCollectionView.backgroundColor = getColor(hex: "#000000")
                
                categoryCollectionView.register(NewCategoryCell.self, forCellWithReuseIdentifier: NewCategoryCell.identifier)
                
                categoryCollectionView.dataSource = self
                categoryCollectionView.delegate = self
                
                self?.topicCollectionView?.isHidden = true
                categoryCollectionView.isHidden = false
                categoryCollectionView.reloadData()
                self?.topicCollectionView?.reloadData()
            }
            
        }
    }
    
    fileprivate func topicSelected() {
        viewModel.isTopicSelected = { [weak self] in
            let topicLayout = UICollectionViewFlowLayout()
            topicLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            topicLayout.minimumInteritemSpacing = 15.0
            topicLayout.minimumLineSpacing = 15.0
            topicLayout.scrollDirection = .vertical
            self?.topicCollectionView = UICollectionView(frame: .zero, collectionViewLayout: topicLayout)
            
            guard let topicCollectionView = self?.topicCollectionView,
                  let collectionContainerView = self?.collectionContainerView else {
                      return
                  }
            
            collectionContainerView.addSubview(topicCollectionView)
            topicCollectionView.frame = collectionContainerView.bounds
            
            DispatchQueue.main.async {
                self?.categoryContainer.isHidden = true
                self?.btnTopics.backgroundColor = getColor(hex: "#FFAE29")
                self?.btnTopics.setTitleColor(.black, for: .normal)
                self?.btnCat.backgroundColor = getColor(hex: "#171715")
                self?.btnCat.setTitleColor(.white, for: .normal)
                
                self?.isCatShow = false
                
                topicCollectionView.register(NewTopicCell.self, forCellWithReuseIdentifier: NewTopicCell.identifier)
                
                topicCollectionView.dataSource = self
                topicCollectionView.delegate = self
                
                topicCollectionView.backgroundColor = getColor(hex: "#000000")
                self?.topicCollectionView?.isHidden = false
                self?.topicCollectionView?.reloadData()
                self?.categoryCollectionView?.reloadData()
            }
        }
    }
    
    func setupView() {
        
        // Scroll view added as a subbview
        catView.addSubview(scrollView)
        scrollView.pin(to: catView)
        
        // Scroll view container added as a subview
        scrollView.addSubview(scrollContainer)
        scrollContainer.pin(to: scrollView)
        
        // Bacground views added to the scrollview container
        scrollContainer.addArrangedSubview(containerBGView)
        containerBGView.pin(to: scrollContainer)
        
        // background view of the scroll view container
        containerBGView.addSubview(containerView)
        containerView.pin(to: containerBGView, top: 10, left: 20, bottom: 0, right: -20)
        btnTopics.cornerRadius = 5
        btnCat.cornerRadius = 5
        // search view added as a subview
        // button container view added as btnContainerView
        // category container view added as categoryContainer
        // collection container view added as collectionContainerView
        containerView.addArrangedSubview(searchView)
        containerView.addArrangedSubview(btnContainerView)
        containerView.addArrangedSubview(categoryContainer)
        containerView.addArrangedSubview(collectionContainerView)
        
        categoryContainer.addArrangedSubview(btnTrendingBG)
        btnTrendingBG.addSubview(btnTrending)
        btnTrending.pin(to: btnTrendingBG)
        btnTrending.addSubview(trendingTitle)
        btnTrending.addSubview(trendingSubTitle)
        
        categoryContainer.addArrangedSubview(topicsView)
        topicsView.addArrangedSubview(trendingTopicBG)
        trendingTopicBG.addSubview(btnTrendingCat)
        btnTrendingCat.pin(to: trendingTopicBG)
        trendingTopicBG.addSubview(trendingCatTitle)
        topicsView.addArrangedSubview(trendingEditorPickBG)
        trendingEditorPickBG.addSubview(btnEditorPick)
        btnEditorPick.pin(to: trendingEditorPickBG)
        trendingEditorPickBG.addSubview(lblEditorPick)
        
        searchView.addSubview(btnSearch)
        searchView.addSubview(searchTextField)
        
        
        btnContainerView.addArrangedSubview(btnCat)
        btnContainerView.addArrangedSubview(btnTopics)
    }
    
    func setupConstraints() {
        let width = catView.frame.size.width
        let height = catView.frame.size.height
        print("The device height is \(height) and width \(width)")
        NSLayoutConstraint.activate([
            //To enable scrolling
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            //setting the item to fit to middle with padding of 20 left and right
            containerView.widthAnchor.constraint(equalToConstant: width - 40),
            
            searchView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.15),
            btnSearch.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: width * 0.05),
           
            btnSearch.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            btnSearch.heightAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.8),
            btnSearch.widthAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.8),
            
            searchTextField.leadingAnchor.constraint(equalTo: btnSearch.trailingAnchor, constant: width * 0.02),
            searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor),
            
            btnContainerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.15),
            
            btnCat.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.13),
            btnTopics.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.13),
            
            categoryContainer.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.58),
            collectionContainerView.heightAnchor.constraint(equalToConstant: height),
            
            trendingSubTitle.bottomAnchor.constraint(equalTo: btnTrendingBG.bottomAnchor, constant: -15),
            trendingSubTitle.leadingAnchor.constraint(equalTo: btnTrendingBG.leadingAnchor, constant: 16),
            
            trendingTitle.bottomAnchor.constraint(equalTo: trendingSubTitle.topAnchor, constant: -4),
            trendingTitle.leadingAnchor.constraint(equalTo: trendingSubTitle.leadingAnchor),
            
            trendingCatTitle.bottomAnchor.constraint(equalTo: trendingTopicBG.bottomAnchor, constant: -11),
            trendingCatTitle.leadingAnchor.constraint(equalTo: trendingTopicBG.leadingAnchor, constant: 12),
            
            lblEditorPick.bottomAnchor.constraint(equalTo: trendingEditorPickBG.bottomAnchor, constant: -11),
            lblEditorPick.leadingAnchor.constraint(equalTo: trendingEditorPickBG.leadingAnchor, constant: 12),
            
        ])
    }

}

extension NewCategoryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch collectionView {
        case categoryCollectionView:
            let pos: Int = indexPath.row
            guard let listModels = viewModel.listCategory else {
                return
            }
            let item = listModels[pos]
            self.itemDelegate?.clickItem(list: listModels, model: item, position: pos)
            
        case topicCollectionView:
            let pos: Int = indexPath.row
            guard let listModels = viewModel.listPopularTopics else {
                return
            }
            let item = listModels[pos]
            self.itemDelegate?.clickItem(list: listModels, model: item, position: pos)
            
        default:
            print("Nothing here")
        }
    }
}

extension NewCategoryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch isCatShow {
    case true:
        return viewModel.listCategory?.count ?? 0
    case false:
        return viewModel.listPopularTopics?.count ?? 0
    }
//        switch collectionView {
//        case categoryCollectionView:
//            return viewModel.listCategory?.count ?? 0
//        case topicCollectionView:
//            return viewModel.listPopularTopics?.count ?? 0
//        default:
//            return 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch isCatShow {
        case true:
            guard let cell = categoryCollectionView?.dequeueReusableCell(withReuseIdentifier: NewCategoryCell.identifier, for: indexPath) as? NewCategoryCell,
                  let model = viewModel.listCategory?[indexPath.row] else {
                return UICollectionViewCell()
            }
            cell.updateUI(model, indexPath.row)
            return cell
        case false:
            guard let cell = topicCollectionView?.dequeueReusableCell(withReuseIdentifier: NewTopicCell.identifier, for: indexPath) as? NewTopicCell,
                  let model = viewModel.listPopularTopics?[indexPath.row] else {
                print("This is other collection printed for now")
                return UICollectionViewCell()
            }
            let pos = indexPath.row
            print("The index is \(pos)")
            cell.updateUI(model, fontTitle, pos)
            return cell
            
        }
        
    }
}

extension NewCategoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.layer.frame.size.width - 52
        switch collectionView {
        case categoryCollectionView:
            return CGSize(width: width * 0.5, height: width * 0.23)
        case topicCollectionView:
            return CGSize(width: width * 1.0, height: width * 0.15)
        default:
            return CGSize(width: width * 0.4, height: width * 0.25)
        }
    }
    
}

extension NewCategoryController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchContent()
        return true
    }
}
