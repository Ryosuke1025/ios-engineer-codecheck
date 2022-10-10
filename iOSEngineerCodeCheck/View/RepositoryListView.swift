//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryListView: UIViewController {
    
    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {

            indicator.color = UIColor(red: 44 / 255, green: 169 / 255, blue: 225 / 255, alpha: 1)
        }
    }
    @IBOutlet private weak var searchbar: UISearchBar?
    // passiveviewなのでinputのみ
    private var presenter: RepositoryListPresenterInput!
    
    private func inject(presenter: RepositoryListPresenterInput) {
        self.presenter = presenter
    }
    
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    deinit {
        print("RepositoryListView deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = APIClient()
        let presenter = RepositoryListPresenter(view: self, model: model)
        self.inject(presenter: presenter)
        searchBarSetupData()
        indicator.isHidden = true
    }
}

extension RepositoryListView: UISearchBarDelegate {
    private func searchBarSetupData() {
        guard let searchbar = searchbar else { return }
        searchbar.text = "GitHubのリポジトリを検索できるよー"
        searchbar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarBecameEmpty()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true), let searchWord = searchBar.text else { return }
        searchBar.resignFirstResponder()
        presenter.search(searchWord: searchWord)
    }
}

extension RepositoryListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchRepository = presenter.repositories[indexPath.row]
        cell.textLabel?.text = searchRepository.fullName
        cell.detailTextLabel?.text = searchRepository.language
        cell.tag = indexPath.row
        return cell
    }
}

extension RepositoryListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: String(describing: RepositoryDetailView.self), bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController { [self] coder in
            RepositoryDetailView(coder: coder, repository: presenter.repositories[indexPath.row])
        }
        guard let safenextVC = nextVC else { return }
        self.navigationController?.pushViewController(safenextVC, animated: true)
    }
}

extension RepositoryListView: RepositoryListPresenterOutput {
    func updateTableView(repositories: [RepositoryModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func upData(load: Bool) {
        DispatchQueue.main.async {
            self.indicator.isHidden = !load
        }
    }
    func getError(err: String) {
        switch err {
        case "wrong":
            let alert = ErrorAlert().wrongError()
            self.present(alert, animated: true, completion: nil)
            
        case "network":
            let alert = ErrorAlert().networkError()
            self.present(alert, animated: true, completion: nil)
            
        case "parse":
            let alert = ErrorAlert().parseError()
            self.present(alert, animated: true, completion: nil)
        
        default:
            break
        }
    }
}
