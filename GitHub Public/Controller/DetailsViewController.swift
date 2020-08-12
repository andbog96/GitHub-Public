//
//  DetailsViewController.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 12.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var login: UILabel!
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var service: ServiceProtocol = GitHubService()
    var repository: Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = repository.name
        login.text = repository.login
        if let url = URL(string: repository.photo) {
            photo?.kf.setImage(with: url)
        }
        
        disposeView()
        
        service.getLastCommit(repository: repository, setupCommit)
    }
    
    private func disposeView() {
        message.text = nil
        author.text = nil
        dateLabel.text = nil
        message.text = nil
    }
    
    private func setupCommit(_ commit: Commit?) {
        guard let commit = commit else {
            let alertController = UIAlertController(title: "Some server error",
                                                    message: "Try connect later",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.service.getLastCommit(repository: self.repository, self.setupCommit)
            }
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
            
            return
        }
        
        message.text = commit.message
        author.text = commit.author
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = inputDateFormatter.date(from: commit.date) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd.MM.yyyy"
            dateLabel.text = outputDateFormatter.string(from: date)
        }
        
        if !commit.parents.isEmpty {
            let ending = commit.parents.count == 1 ? "" : "s"
            message.text += "\n\nParent\(ending):\n"
                + commit.parents.reduce("", { (result, sha) -> String in
                result + sha + "\n"
            })
        }
        
        activityIndicator.stopAnimating()
    }
    
}
