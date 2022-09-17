//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailView: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var stargazers: UILabel!
    @IBOutlet weak var wachers: UILabel!
    @IBOutlet weak var forks: UILabel!
    @IBOutlet weak var issues: UILabel!
    var repositoryList: RepositoryListView?

    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let repositoryList = repositoryList, let index = repositoryList.index else { return }
        let repository = repositoryList.repository[index]
        language.text = "Written in \(repository["language"] as? String ?? "")"
        stargazers.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        wachers.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forks.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issues.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }

    func getImage() {
        guard let repositoryList = repositoryList, let index = repositoryList.index else { return }
        let repository = repositoryList.repository[index]
        
        repositoryName.text = repository["full_name"] as? String
        
        guard
            let owner = repository["owner"] as? [String: Any],
            let avatarURLstring = owner["avatar_url"] as? String,
            let avatarURL = URL(string: avatarURLstring)
        else { return }
        URLSession.shared.dataTask(with: avatarURL) { data, response, error in
            
            // Failed access
            if let error = error {
                print("APIアクセス時にエラーが発生しました。: error={\(error)}")
                return
            }
            // Successful access
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard let data = data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }.resume()
    }
}
