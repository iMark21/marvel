//
//  MediaCollectionComponent.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import UIKit

class MediaCollectionComponent: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private var mediaImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet weak var backgroundTitleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mediaImageView.image = nil
    }

    func setup(component: MediaComponentProtocol) {
        /// Label
        self.titleLabel.text = component.output?.title
        self.titleLabel.textColor = .white
        self.backgroundTitleView
            .backgroundColor = .black
            .withAlphaComponent(0.5)
        
        /// Image
        guard let url = component.output?.imageUrl else {
            mediaImageView.image = nil
            return
        }
        self.mediaImageView.load(url: url)
    }
}
