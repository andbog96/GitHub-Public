//
//  TableViewCell.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TableViewCell"
    
    private lazy var placeholderImage: UIImage = {
        let size = CGSize(width: frame.height, height: frame.height)
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            UIColor.white.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }()
    
    func setup(repository: Repository) {
        textLabel?.text = repository.name
        detailTextLabel?.text = repository.login
        
        imageView?.contentMode = .scaleAspectFit
        imageView?.kf.indicatorType = .activity
        if let url = URL(string: repository.photo) {
            imageView?.kf.setImage(with: url, placeholder: placeholderImage)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.kf.cancelDownloadTask()
        imageView?.image = nil
    }
    
}
