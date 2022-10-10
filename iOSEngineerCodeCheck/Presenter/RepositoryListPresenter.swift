//
//  GithubPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 須崎良祐 on 2022/10/10.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryListPresenterInput {
    var repositories: [RepositoryModel] { get }
    func search(searchWord: String)
    func searchBarBecameEmpty()
}

protocol RepositoryListPresenterOutput {
    func updateTableView(repositories: [RepositoryModel])
    func getError(err: String)
}

final class RepositoryListPresenter: RepositoryListPresenterInput {
    private(set) var repositories: [RepositoryModel] = []
        
    private var view: RepositoryListPresenterOutput!
    private var model: APIClientModel
    
    init(view: RepositoryListPresenterOutput, model: APIClientModel) {
        self.view = view
        self.model = model
    }
    
    func search(searchWord: String) {
        model.fetchRepositories(searchWord: searchWord) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                DispatchQueue.main.async {
                    self?.view.updateTableView(repositories: repositories)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .wrong:
                        self?.view.getError(err: "wrong")
                        return
                    case .network:
                        self?.view.getError(err: "network")
                        return
                    case .parse:
                        self?.view.getError(err: "parse")
                        return
                    }
                }
            }
        }
    }
    
    func searchBarBecameEmpty() {
        model.taskCancel()
        repositories.removeAll()
        view.updateTableView(repositories: repositories)
    }
}
