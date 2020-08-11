//
//  TableViewCell.swift
//  GitHub Public
//
//  Created by Andrey Bogdanov on 11.08.2020.
//  Copyright © 2020 Andbog. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //dispose()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //dispose()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dispose()
    }
    
    private func dispose() {
        imageView?.image = nil
    }

}
