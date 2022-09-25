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
    var repositories: [RepositoryModel] = []
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetupData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            let detail = segue.destination as? RepositoryDetailView
            detail?.repositoryList = self
        }
    }
}

// MARK: - Search Bar
extension RepositoryListView {
    func searchBarSetupData() {
        guard let searchbar = searchbar else { return }
        searchbar.text = "GitHubのリポジトリを検索できるよー"
        searchbar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIClient().taskCancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        searchBar.resignFirstResponder()
        
        guard let searchWord = searchBar.text else { return }
        APIClient().fetchRepository(searchWord: searchWord) { result in
            switch result {
            case .success(let items):
                self.repositories = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .wrong:
                        let alert = self.wrongError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    case .network:
                        let alert = self.networkError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    case .parse:
                        let alert = self.parseError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        return
    }
}

// MARK: - Table View
extension RepositoryListView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchRepository = repositories[indexPath.row]
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

// MARK: - Alert
extension RepositoryListView {
    private func showAlert(title: String, message: String = "") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        return alert
    }
    
    private func wrongError() -> UIAlertController {
        showAlert(title: "不正なワードの入力", message: "検索ワードの確認を行ってください")
    }
    
    private func networkError() -> UIAlertController {
        showAlert(title: "インターネットの非接続", message: "接続状況の確認を行ってください")
    }
    
    private func parseError() -> UIAlertController {
        showAlert(title: "データの解析に失敗しました")
    }
}
