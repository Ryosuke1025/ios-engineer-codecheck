//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryListView: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var searchbar: UISearchBar?
    private var task: URLSessionTask?
    var repository: [Repository] = []
    var index: Int?

    // MARK: - Life Cycle
    deinit {
        print("RepositoryListView deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let searchbar = searchbar else { return }
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
        
        guard let searchWord = searchBar.text else { return }
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else { return }
        
        // selfをweak selfに変更
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
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
            guard let data = data else { return }
            guard let items = try? JSONDecoder().decode(Repositories.self, from: data) else { return }
            self.repository = items.items
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
        cell.textLabel?.text = searchRepository.fullName
        cell.detailTextLabel?.text = searchRepository.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
