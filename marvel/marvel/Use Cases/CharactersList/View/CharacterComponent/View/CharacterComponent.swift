//
//  CharacterComponent.swift
//  marvel
//
//  Created by Michel Marques on 21/9/21.
//

import UIKit

class CharacterComponent: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viewComponent: UIView!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        imageViewBackground.image = nil
    }
    
    // MARK: - Setup
    
    func setup(component: CharacterComponentProtocol) {
        setupView()
        
        self.titleLabel.text = component.output.name
        guard let url = component.output.imageUrl else {
            return
        }
        self.imageViewBackground?.loadImage(withUrl: url)
    }
    
    // MARK: - Setup View
    
    func setupView() {
        /// Views
        contentView.backgroundColor = .clear
        viewComponent.layer.cornerRadius = Constants.cornerRadius
        viewComponent.clipsToBounds = true
        titleBackgroundView.backgroundColor = .black.withAlphaComponent(Constants.alpha)
        /// Label
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: Constants.fontSize)
    }
    
}

// MARK: - Corner Radius

extension CharacterComponent {
    struct Constants {
        static let fontSize = CGFloat(14)
        static let cornerRadius = CGFloat(10)
        static let alpha = CGFloat(0.5)
    }
}
