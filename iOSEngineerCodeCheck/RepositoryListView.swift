//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryListView: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchbar: UISearchBar!
    var repository: [[String: Any]] = []
    var task: URLSessionTask?
    var index: Int!

    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.text = "GitHubのリポジトリを検索できるよー"
        searchbar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let detail = segue.destination as? RepositoryDetailView
            detail?.repositoryList = self
        }
    }
}

extension RepositoryListView {
    
    // MARK: - Method
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Optional Bindingでアンラップ
        guard let word = searchBar.text else { return }
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(word)") else { return }
        task = URLSession.shared.dataTask(with: url) { data, urlResponse, _ in
            guard let urlResponse = urlResponse as? HTTPURLResponse else { return }
            print(urlResponse.statusCode)
            
            guard let data = data else { return }
            guard let obj = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let items = obj["items"] as? [[String: Any]] else { return }
            self.repository = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task?.resume()
    }
}

extension RepositoryListView {
    
    // MARK: - Method
    
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
