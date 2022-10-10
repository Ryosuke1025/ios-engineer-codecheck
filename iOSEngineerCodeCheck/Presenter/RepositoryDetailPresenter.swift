//
//  RepositoryDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 須崎良祐 on 2022/10/11.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

protocol RepositoryDetailPresenterInput {
    var repository: RepositoryModel { get }
    func fetchData(repository: RepositoryModel)
}

protocol RepositoryDetailPresenterOutput {
    func setupImage(image: UIImage)
    func setupTextData(repository: RepositoryModel)
    /*func getError(err: String)*/
}

final class RepositoryDetailPresenter: RepositoryDetailPresenterInput {
    
    private(set) var repository: RepositoryModel

    private var view: RepositoryDetailPresenterOutput!
    private var model: APIClientModel

    init(repository: RepositoryModel, view: RepositoryDetailPresenterOutput, model: APIClientModel) {
        self.repository = repository
        self.view = view
        self.model = model
    }
    
    func fetchData(repository: RepositoryModel) {
        view.setupTextData(repository: repository)
        model.fetchImage(avatarURLstring: repository.owner.avatarUrl) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.view.setupImage(image: image)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .wrong:
                        self.view.getError(err: "wrong")
                        return
                    case .network:
                        self.view.getError(err: "network")
                        return
                    case .parse:
                        self.view.getError(err: "parse")
                        return
                    }
                }
            }
        }
    }
    
}
