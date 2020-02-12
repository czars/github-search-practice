//
//  ViewController.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/10.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {

    var searchUserViewModel: SearchUserViewModelType!
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var searchBar = UISearchBar()
    
    init(with searchUserViewModel: SearchUserViewModelType) {
        self.searchUserViewModel = searchUserViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.backgroundColor = .white
        searchUserViewModel.delegate = self
    }
    
    private func setupUI() {
        edgesForExtendedLayout = []
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 160, height: 160)
        collectionViewLayout.minimumInteritemSpacing = 18
        collectionViewLayout.minimumLineSpacing = 18
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(safeArea)-[searchBar(48)]-[collectionView]|", options: [.alignAllLeading, .alignAllTrailing], metrics: ["safeArea": view.safeAreaInsets.top], views: ["collectionView": collectionView, "searchBar": searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: ["collectionView": collectionView, "searchBar": searchBar]))
    }
}

extension SearchUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchUserViewModel.numberOfUser()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        let user = self.searchUserViewModel.userAtIndex(indexPath.row)
        if let _user = user {
            cell.setContent(with: _user)
        }
        return cell
    }
    
    
}

extension SearchUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.searchUserViewModel.numberOfUser() - 10 {
            searchUserViewModel.getNextPage()
        }
    }
}

extension SearchUserViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchUserViewModel.clearSearchKeyword()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchUserViewModel.clearSearchKeyword()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        guard let keyword = searchBar.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) else { return }
        self.searchUserViewModel.searchUser(keyword, page: nil)
    }
}

extension SearchUserViewController: SearchUserDelegate {
    func viewModelUpdateSearchResult(_ viewModel: SearchUserViewModelType) {
        self.collectionView.reloadData()
    }
    
    func viewModel(_ viewModel: SearchUserViewModelType, showAlert text: String) {
        let alert = UIAlertController(title: "Prompt", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

