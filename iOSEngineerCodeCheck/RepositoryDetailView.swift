//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailView: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var stargazers: UILabel!
    @IBOutlet weak var wachers: UILabel!
    @IBOutlet weak var forks: UILabel!
    @IBOutlet weak var issues: UILabel!

    var repositoryList: RepositoryListView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = repositoryList.repository[repositoryList.index]

        language.text = "Written in \(repository["language"] as? String ?? "")"
        stargazers.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        wachers.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forks.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issues.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }

    func getImage() {
        let repository = repositoryList.repository[repositoryList.index]

        repositoryName.text = repository["full_name"] as? String

        if let owner = repository["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { data, _, _ in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                }.resume()
            }
        }
    }
}
