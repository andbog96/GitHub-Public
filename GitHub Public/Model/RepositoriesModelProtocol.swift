//
//  RepositoriesModelProtocol.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation

protocol RepositoriesModelProtocol {
    
    var delegate: RepositoriesModelDelegate! { get set }
    
    var service: ServiceProtocol { get set }
    
    var repositories: [Repository]? { get }
    
    func load()
    
    func prefetch(_ indices: [Int])
    
}
