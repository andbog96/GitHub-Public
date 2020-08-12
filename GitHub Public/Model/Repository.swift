//
//  Repository.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import Foundation

struct Repository {
    let id: Int
    let login: String
    let photo: String
    let name: String
}

struct Commit {
    let message: String
    let author: String
    let date: String
    let parents: [String]
}
