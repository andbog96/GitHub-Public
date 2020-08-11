//
//  RepositoriesTableViewController.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import UIKit
import SDWebImage

class RepositoriesTableViewController: UITableViewController {
    
    var model: RepositoriesModelProtocol = RepositoriesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self

        model.delegate = self
        model.load()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
        guard let repository = model.repositories?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = repository.name
        cell.detailTextLabel?.text = repository.login
        
        cell.imageView?.contentMode = .scaleAspectFit
        //cell.imageView?.sd_cancelCurrentImageLoad()
        if let url = URL(string: repository.photo) {
            cell.imageView?.sd_setImage(with: url)
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension RepositoriesTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        model.prefetch(indexPaths.map(\.row))
    }
    
}

extension RepositoriesTableViewController: RepositoriesModelDelegate {
    
    func modelDidLoad() {
        tableView.reloadData()
    }
    
}
