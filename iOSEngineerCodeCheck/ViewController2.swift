//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var stargazers: UILabel!
    @IBOutlet weak var wachers: UILabel!
    @IBOutlet weak var forks: UILabel!
    @IBOutlet weak var issues: UILabel!
    
    var vc1: ViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = vc1.repository[vc1.index]
        
        language.text = "Written in \(repo["language"] as? String ?? "")"
        stargazers.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        wachers.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forks.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issues.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }
    
    func getImage() {
        let repo = vc1.repository[vc1.index]
        
        repositoryName.text = repo["full_name"] as? String
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                }.resume()
            }
        }
    }
}
