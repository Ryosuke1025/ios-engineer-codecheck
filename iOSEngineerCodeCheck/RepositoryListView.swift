//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryListView: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchbar: UISearchBar!

    var repository: [[String: Any]] = []
    var task: URLSessionTask?
    var word: String!
    var url: String!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.text = "GitHubのリポジトリを検索できるよー"
        searchbar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let detail = segue.destination as! RepositoryDetailView
            detail.repositoryList = self
        }
    }
}

extension RepositoryListView {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        word = searchBar.text!
        if word.isEmpty {
            print("ワードが入力されてない")
        } else {
            url = "https://api.github.com/search/repositories?q=\(word!)"
            task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = obj["items"] as? [[String: Any]] {
                        self.repository = items
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            task?.resume()
        }
    }
}

extension RepositoryListView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchRepository = repository[indexPath.row]
        cell.textLabel?.text = searchRepository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = searchRepository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}