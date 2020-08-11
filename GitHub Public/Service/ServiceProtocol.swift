//
//  ServiceProtocol.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    
    func getRepositories(since id: Int, _ callback: @escaping ([Repository]?) -> Void)
    
}
