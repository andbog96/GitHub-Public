//
//  RepositoriesTableViewController.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {
    
    var model: RepositoriesModelProtocol = RepositoriesModel()
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? DetailsViewController,
            let repositories = model.repositories,
            let index = tableView.indexPathForSelectedRow?.row else { return }
        
        detailsViewController.repository = repositories[index]
    }
    
}

extension RepositoriesTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        model.prefetch(indexPaths.map(\.row))
    }
    
}

extension RepositoriesTableViewController: RepositoriesModelDelegate {
    
    func modelDidLoad() {
        guard model.repositories != nil else {
            let alertController = UIAlertController(title: "Some server error",
                                                    message: "Try connect later",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.model.load()
            }
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
            
            return
        }
        
        tableView.reloadData()
        tableView.isHidden = false
        activityIndicatorView.removeFromSuperview()
    }
    
}
