//
//  RepositoriesModel.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation

class RepositoriesModel: RepositoriesModelProtocol {
    
    var delegate: RepositoriesModelDelegate!
    var service: ServiceProtocol = GitHubService()
    
    private(set) var repositories: [Repository]? = nil
    
    private var lastPrefetchedIndex = 0
    
    func load() {
        service.getRepositories(since: 0) { response in
            self.repositories = response
            self.delegate.modelDidLoad()
        }
    }
    
    func prefetch(_ indices: [Int]) {
        guard let repositories = repositories,
            indices.count > 0,
            let maxIndex = indices.max(), lastPrefetchedIndex < maxIndex else {
            return
        }
        
        if maxIndex == repositories.count - 1 {
            lastPrefetchedIndex = maxIndex
            print(indices.max()!)
            
            let last = repositories.last?.id ?? 0
            service.getRepositories(since: last + 1) { response in
                guard let response = response else {
                    return
                }
                
                self.repositories?.append(contentsOf: response)
                self.delegate.modelDidLoad()
            }
        }
    }
}
