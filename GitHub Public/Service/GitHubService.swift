//
//  GitHubService.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation
import Alamofire

struct GitHubService: ServiceProtocol {
 
    private func getRepositoriesURLString(_ id: Int) -> String {
        "https://api.github.com/repositories?since=\(id)"
    }
    
    private func getLastCommitsURLString(login: String, name: String) -> String {
        "https://api.github.com/repos/\(login)/\(name)/commits"
    }
    
    func getRepositories(since id: Int, _ callback: @escaping ([Repository]?) -> Void) {
        AF.request(getRepositoriesURLString(id)).responseJSON { response in
            switch response.result {
            case .failure(_):
                callback(nil)
            case .success:
                if let json = try? JSONDecoder().decode([RepositoryResponse].self, from: response.data!) {
                    callback(json.map {
                        Repository(id: $0.id, login: $0.owner.login, photo: $0.owner.avatar_url, name: $0.name)
                    })
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    func getLastCommit(repository: Repository, _ callback: @escaping (Commit?) -> Void) {
        AF.request(getLastCommitsURLString(login: repository.login, name: repository.name))
            .responseJSON { response in
            switch response.result {
            case .failure(_):
                callback(nil)
            case .success:
                if let json = try? JSONDecoder().decode([CommitResponse].self, from: response.data!),
                    let last = json.first {
                    callback(Commit(message: last.commit.message, author: last.commit.author.name, date: last.commit.author.date, parents: last.parents.map(\.sha)))
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    private struct RepositoryResponse: Codable {
        let id: Int
        let name: String
        let owner: Owner
        
        struct Owner: Codable {
            let login: String
            let avatar_url: String
        }
    }
    
    private struct CommitResponse: Codable {
        let commit: Commit
        let parents: [Parent]
        
        struct Commit: Codable {
            let author: Author
            let message: String
            
            struct Author: Codable {
                let name: String
                let date: String
            }
        }
        
        struct Parent: Codable {
            let sha: String
        }
    }
    
}
