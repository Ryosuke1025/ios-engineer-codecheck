//
//  APIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by 須崎良祐 on 2022/09/24.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

class APIClient {
    private var task: URLSessionTask?
    
    enum FetchRepositoryError: Error {
            case wrong
            case network
            case parse
    }
    
    func fetchRepository(searchWord: String, completionHandler: @escaping (Result<[RepositoryModel], FetchRepositoryError>) -> Void) {
        if !searchWord.isEmpty {
            guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else {
                completionHandler(.failure(FetchRepositoryError.wrong))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                
                // Failed access
                if error != nil {
                    completionHandler(.failure(FetchRepositoryError.network))
                    return
                }
                // Successful access
                guard let data = data else { return }
                do {
                    let decodedData = try JSONDecoder().decode(RepositoriesModel.self, from: data)
                    completionHandler(.success(decodedData.items))
                } catch {
                    completionHandler(.failure(FetchRepositoryError.parse))
                }
            }
            task.resume()
        }
    }
    
    func taskCancel() {
        task?.cancel()
    }
}
