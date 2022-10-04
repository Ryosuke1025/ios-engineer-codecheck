//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryListView: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var searchbar: UISearchBar?
    var repositories: [RepositoryModel] = []
    var index: Int?
    
    deinit {
        print("RepositoryListView deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetupData()
    }
}

// MARK: - Search Bar
extension RepositoryListView: UISearchBarDelegate {
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
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
        let storyboard = UIStoryboard(name: String(describing: RepositoryDetailView.self), bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController { coder in
            RepositoryDetailView(coder: coder, repository: self.repositories[indexPath.row])
        }
        guard let safenextVC = nextVC else { return }
        self.navigationController?.pushViewController(safenextVC, animated: true)
    }
}
