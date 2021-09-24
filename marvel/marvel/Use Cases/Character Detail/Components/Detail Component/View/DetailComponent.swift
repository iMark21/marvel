//
//  DetailComponent.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import UIKit

class DetailComponent: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        headerImageView.image = nil
    }
    
    func setup(component: DetailComponentProtocol) {
        self.titleLabel.text = component.output.name
        self.descriptionLabel.text = component.output.description
        guard let url = component.output.imageUrl else {
            headerImageView.image = nil
            return
        }
        self.headerImageView.load(url: url)
    }
    
}
