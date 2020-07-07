//
//  NimbleSurveyViewController.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 04/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import UIKit

protocol NimbleSurveyView :class{
    func displaySurvey(pageNumber: Int, list: [Survey])
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func loginError()
    func surveyListError()
}
class NimbleSurveyViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var indexTableView: UITableView!
    @IBOutlet weak var nimbleSurveyCollectionView: UICollectionView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageNumber: UIBarButtonItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var presenter: NimbelSurveyPresenterInterface!
    var initialSwipeIndex: Int = 0
    var cellSize: CGSize = CGSize()
    var surveyList: [Survey]  = [Survey]() {
        didSet {
            nimbleSurveyCollectionView.reloadData()
            indexTableView.reloadData()
        }
    }
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NimbleSurveyConfigurator.sharedInstance.configure(viewController: self)
        self.presenter.getSurvey()
        
        registerNib()
        addTapGesture()
        setUpNavigationBar()
        constructCollectionViewCellLayout()
        indexTableView?.isUserInteractionEnabled = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !surveyList.isEmpty {
            nimbleSurveyCollectionView?.scrollToItem(at: IndexPath(item: initialSwipeIndex, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            cellSize = CGSize(width:UIScreen.main.bounds.size.width , height:UIScreen.main.bounds.size.height - self.view.safeAreaInsets.bottom - 20 - (self.navigationController?.navigationBar.frame.size.height ?? 0))
            
        } else {
            cellSize = CGSize(width:self.view.frame.size.width , height:self.view.frame.size.height  - (self.navigationController?.navigationBar.frame.size.height ?? 0))
        }
    }
    
    // MARK: Private Methods
    private func setUpNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "SURVEYS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func constructCollectionViewCellLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        nimbleSurveyCollectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    private func addTapGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
        swipeUpGesture.direction = UISwipeGestureRecognizer.Direction.up
        self.nimbleSurveyCollectionView?.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown))
        swipeDownGesture.direction = .down
        self.nimbleSurveyCollectionView?.addGestureRecognizer(swipeDownGesture)
    }
    
    private func registerNib() {
        nimbleSurveyCollectionView?.register(UINib(nibName: NimbleSurveyCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: NimbleSurveyCollectionViewCell.identifier)
    }
    
    // MARK: Actions
    @IBAction func refreshButton(_ sender: Any) {
        presenter.fetchNewDataByRefresh()
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension NimbleSurveyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NimbleSurveyCollectionViewCell.identifier, for: indexPath) as? NimbleSurveyCollectionViewCell
        print(indexPath)
        cell?.delegate = self
        cell?.configureCell(survey: surveyList[initialSwipeIndex])
        return cell!
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return cellSize
    }
}

// MARK: UITableViewDelegate and UITableViewDataSource
extension NimbleSurveyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return surveyList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.indexTableViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.tableViewFootterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: Constants.tableViewFootterHeight))
        view.backgroundColor = .clear
        return view
    }
}

// MARK: Survye Display
extension NimbleSurveyViewController: NimbleSurveyView {
    func displaySurvey(pageNumber: Int, list: [Survey]) {
        self.pageNumber.title = "Page \(pageNumber)"
        self.surveyList.removeAll()
        self.surveyList.append(contentsOf: list)
        initialSwipeIndex = list.isEmpty ? (initialSwipeIndex - 1) : 0
        tableViewHeightConstraint.constant = CGFloat(surveyList.count) * (Constants.indexTableViewHeight + Constants.tableViewFootterHeight)
        indexTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        nimbleSurveyCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: true)
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.isHidden = false
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
    
    func loginError() {
        self.showAlertView(title: "Unable to Login", message: "Invalid Credentials")
    }
    
    func surveyListError() {
        self.showAlertView(title: "Something went wrong", message: "")
    }
    
    func showAlertView (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Survey Page Swipe Handle
extension NimbleSurveyViewController {
    @objc func swipeUp() {
        initialSwipeIndex = initialSwipeIndex + 1
        if initialSwipeIndex > surveyList.count - 1 {
            self.presenter.fetchMoreData()
        } else {
        nimbleSurveyCollectionView.scrollToItem(at: IndexPath(item: initialSwipeIndex, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
        indexTableView.selectRow(at: IndexPath(row: 0, section: initialSwipeIndex), animated: true, scrollPosition: .none)
        }
    }

    @objc func swipeDown() {
        initialSwipeIndex = initialSwipeIndex - 1
        if initialSwipeIndex < 0 {
            initialSwipeIndex = 0
            self.presenter.fetchPreviousData()
        } else {
        nimbleSurveyCollectionView.scrollToItem(at: IndexPath(item: initialSwipeIndex, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
        indexTableView.selectRow(at: IndexPath(row: 0, section: initialSwipeIndex), animated: true, scrollPosition: .none)
        }
    }
}

extension NimbleSurveyViewController: OnClickSurveyDelegate {
    func takeASurvey() {
        if let navigationController = self.navigationController {
            self.presenter.presentTakeASurveyPage(navigationController: navigationController)
        }
    }
}
