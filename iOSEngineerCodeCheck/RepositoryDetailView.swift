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
    var repositoryList: RepositoryListView?

    // MARK: - Life Cycle
    deinit {
        print("RepositoryDetailView deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpuData()
        getImage()
    }
    
    private func setpuData() {
        guard let repositoryList = repositoryList, let index = repositoryList.index else { return }
        let repository = repositoryList.repository[index]
        language.text = "Written in \(repository.language)"
        stargazers.text = "\(repository.stargazersCount) stars"
        wachers.text = "\(repository.watchersCount) watchers"
        forks.text = "\(repository.forksCount) forks"
        issues.text = "\(repository.openIssuesCount) open issues"
    }
    
    private func getImage() {
        guard let repositoryList = repositoryList, let index = repositoryList.index else { return }
        let repository = repositoryList.repository[index]
        
        repositoryName.text = repository.fullName
        
        let owner = repository.owner
        let avatarURLstring = owner.avatarUrl
        guard let avatarURL = URL(string: avatarURLstring) else { return }
        URLSession.shared.dataTask(with: avatarURL) { [weak self] (data, response, error) in
            // Failed access
            if let error = error {
                print("APIアクセス時にエラーが発生しました。: error={\(error)}")
                return
            }
            // Successful access
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard let self = self else { return }
            guard let data = data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }.resume()
    }
}
