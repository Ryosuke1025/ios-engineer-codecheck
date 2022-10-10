//
//  Mock.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 須崎良祐 on 2022/10/11.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
import Foundation
@testable import iOSEngineerCodeCheck

extension RepositoryModel {
    static func mock() -> RepositoryModel {
        let repository = RepositoryModel (
                                    id: 1,
                                    fullName: "apple/swift",
                                    language: "C++",
                                    stargazersCount: 1,
                                    watchersCount: 1,
                                    forksCount: 1,
                                    openIssuesCount: 1,
                                    owner: .init(avatarUrl:  "https://avatars.githubusercontent.com/u/10639145?v=4")
        )
        return repository
    }
}
