import Foundation

struct RepositoriesModel: Codable {
    let items: [RepositoryModel]
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct RepositoryModel: Codable, Identifiable {
    let id: Int
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let repositoryURL: String
    let owner: Owner
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "full_name"
        case language = "language"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case repositoryURL = "html_url"
        case owner
    }
}

struct Owner: Codable {
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
