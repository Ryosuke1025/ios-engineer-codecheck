//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailView: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var repositoryName: UILabel!
    @IBOutlet private weak var language: UILabel!
    @IBOutlet private weak var stargazers: UILabel!
    @IBOutlet private weak var wachers: UILabel!
    @IBOutlet private weak var forks: UILabel!
    @IBOutlet private weak var issues: UILabel!
    var repository: RepositoryModel
    
    init?(coder: NSCoder, repository: RepositoryModel) {
        self.repository = repository
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("RepositoryDetailView deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpuData()
    }
    
    private func setpuData() {
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
        
        APIClient().fetchImage(avatarURLstring: repository.owner.avatarUrl) { result in
            switch result {
            case .success(let img):
                DispatchQueue.main.async {
                    self.imageView.image = img
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .wrong:
                        let alert = ErrorAlert().wrongError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    case .network:
                        let alert = ErrorAlert().networkError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    case .parse:
                        let alert = ErrorAlert().parseError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
}
