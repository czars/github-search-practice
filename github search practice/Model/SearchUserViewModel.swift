//
//  SearchUserViewModel.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/11.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import Foundation

protocol SearchUserViewModelType {
    var keyword: String { get set }
    var nextPageNumber: Int? { get set }
    var delegate: SearchUserDelegate? { get set }
    func searchUser(_ keyword: String, page: Int?)
    func getNextPage()
    func numberOfUser() -> Int
    func userAtIndex(_ index: Int) -> User?
    func clearSearchKeyword()
}

protocol SearchUserDelegate {
    func viewModelUpdateSearchResult(_ viewModel: SearchUserViewModelType)
    func viewModel(_ viewModel: SearchUserViewModelType, showAlert text: String)
}

class SearchUserViewModel {
    var keyword: String = ""
    var nextPageNumber: Int? = 1
    var apiEngine: SearchUser!
    var delegate: SearchUserDelegate?
    private(set) var users: [User] = [] {
        didSet {
            let behavior = oldValue.diff(from: users)
            DispatchQueue.main.async {
                if behavior {
                    self.delegate?.viewModelUpdateSearchResult(self)
                }
            }
        }
    }
}

extension SearchUserViewModel: SearchUserViewModelType {
    func clearSearchKeyword() {
        keyword = ""
        users = []
        nextPageNumber = 1
    }
    
    func getNextPage() {
        searchUser(keyword, page: nextPageNumber)
    }
    
    func searchUser(_ keyword: String, page: Int?) {
        if self.keyword != keyword {
            self.keyword = keyword
            users = []
            nextPageNumber = 1
        }
        if keyword.isEmpty {
            return
        }
        apiEngine.users(userName: keyword, page: page) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let (users, nextPage)):
                self.users.append(contentsOf: users)
                self.nextPageNumber = nextPage
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.viewModel(self, showAlert: error.localizedDescription)
                }
            }
        }
    }
    
    func numberOfUser() -> Int {
        return users.count
    }
    
    func userAtIndex(_ index: Int) -> User? {
        if !users.indices.contains(index) {
            return nil
        }
        return users[index]
    }
}



extension Array where Element: Hashable {
    func diff(from other: [Element]) -> Bool {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet)).count > 0
    }
}
