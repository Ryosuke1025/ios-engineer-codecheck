//
//  APIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by 須崎良祐 on 2022/09/24.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit
import Foundation

protocol APIClientModel {
    var task: URLSessionTask? { get }
    func fetchRepositories(searchWord: String, completionHandler: @escaping (Result<[RepositoryModel], FetchError>) -> Void)
    func taskCancel()
    func fetchImage(avatarURLstring: String, completionHandler: @escaping (Result<UIImage, FetchError>) -> Void)
}

enum FetchError: Error {
        case wrong
        case network
        case parse
}

final class APIClient: APIClientModel {
    var task: URLSessionTask?
    
    func fetchRepositories(searchWord: String, completionHandler: @escaping (Result<[RepositoryModel], FetchError>) -> Void) {
        if !searchWord.isEmpty {
            guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else {
                completionHandler(.failure(FetchError.wrong))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                
                if error != nil {
                    completionHandler(.failure(FetchError.network))
                    return
                }
                guard let safedata = data else { return }
                do {
                    let decodedData = try JSONDecoder().decode(RepositoriesModel.self, from: safedata)
                    completionHandler(.success(decodedData.items))
                } catch {
                    completionHandler(.failure(FetchError.parse))
                }
            }
            task.resume()
        }
    }
    
    func taskCancel() {
        task?.cancel()
    }
    
    func fetchImage(avatarURLstring: String, completionHandler: @escaping (Result<UIImage, FetchError>) -> Void) {
        guard let avatarURL = URL(string: avatarURLstring) else {
            completionHandler(.failure(FetchError.wrong))
            return
        }
        URLSession.shared.dataTask(with: avatarURL) { data, _, error in
            if error != nil {
                completionHandler(.failure(FetchError.network))
                return
            }
            
            guard let safedata = data else { return }
            guard let image = UIImage(data: safedata) else {
                completionHandler(.failure(FetchError.parse))
                return
            }
            completionHandler(.success(image))
        }.resume()
    }
}
