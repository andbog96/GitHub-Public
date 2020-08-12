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
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.view.backgroundColor = .white
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                       constant: 50).isActive = true
        
        tableView.isHidden = true
        tableView.prefetchDataSource = self

        model.delegate = self
        model.load()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                     for: indexPath) as? TableViewCell,
            let repository = model.repositories?[indexPath.row] else {
            return TableViewCell()
        }
        
        cell.setup(repository: repository)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? DetailsViewController else { return }
        
        detailsViewController
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
        tableView.isHidden = false
        activityIndicatorView.removeFromSuperview()
    }
    
}
