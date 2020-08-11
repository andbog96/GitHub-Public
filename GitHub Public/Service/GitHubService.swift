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
 
    private let repositoriesURLString = "https://api.github.com/repositories"
    
    private func getRepositoriesURLString(_ id: Int) -> String {
        repositoriesURLString + "?since=\(id)"
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
                    debugPrint(response.data!)
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
    
}
