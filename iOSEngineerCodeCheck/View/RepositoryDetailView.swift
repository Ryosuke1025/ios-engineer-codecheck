//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailView: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var repositoryName: UILabel!
    @IBOutlet private weak var language: UILabel!
    @IBOutlet private weak var stargazers: UILabel!
    @IBOutlet private weak var wachers: UILabel!
    @IBOutlet private weak var forks: UILabel!
    @IBOutlet private weak var issues: UILabel!
    var repository: RepositoryModel
    private var presenter: RepositoryDetailPresenterInput!
    
    init?(coder: NSCoder, repository: RepositoryModel) {
        self.repository = repository
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func inject(presenter: RepositoryDetailPresenterInput) {
        self.presenter = presenter
    }
    deinit {
        print("RepositoryDetailView deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = APIClient()
        let presenter = RepositoryDetailPresenter(repository: repository, view: self, model: model)
        self.inject(presenter: presenter)
        presenter.fetchData(repository: repository)
    }
}

extension RepositoryDetailView: RepositoryDetailPresenterOutput {
    func setupTextData(repository: RepositoryModel) {
        if let safeLanguage = repository.language {
            language.text = "Written in \(safeLanguage)"
        } else {
            language.text = "Written in ---"
        }
        stargazers.text = "\(repository.stargazersCount) stars"
        wachers.text = "\(repository.watchersCount) watchers"
        forks.text = "\(repository.forksCount) forks"
        issues.text = "\(repository.openIssuesCount) open issues"
        repositoryName.text = repository.fullName
    }
        
    func setupImage(image: UIImage) {
        imageView.image = image
    }
    
    func getError(err: String) {
        switch err {
        case "wrong":
            let alert = ErrorAlert().wrongError()
            self.present(alert, animated: true, completion: nil)
            
        case "network":
            let alert = ErrorAlert().networkError()
            self.present(alert, animated: true, completion: nil)
            
        case "parse":
            let alert = ErrorAlert().parseError()
            self.present(alert, animated: true, completion: nil)
        
        default:
            break
        }
    }
}
