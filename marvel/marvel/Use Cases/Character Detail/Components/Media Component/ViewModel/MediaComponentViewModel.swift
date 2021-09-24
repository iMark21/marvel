//
//  MediaComponentViewModel.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import Foundation

// MARK: - Protocol
protocol MediaComponentProtocol {
    var input: MediaComponentViewModel.Input {get}
    var output: MediaComponentViewModel.Output? {get}
}
// MARK: - I/O
extension MediaComponentViewModel {
    struct Input {
        let media: Any
    }
    struct Output {
        let imageUrl: URL?
        let title: String?
    }
}

// MARK: - Class
class MediaComponentViewModel: MediaComponentProtocol {
    
    /// Protocol variables I/O
    var input: Input
    var output: Output?
    
    init(media: Any) {
        
        self.input = Input.init(media: media)
        
        if let comic = media as? Comic {
            self.output = Output.init(
                imageUrl: comic.thumbnail?.getImageUrl(),
                title: comic.title ?? ""
            )
        } else if let serie = media as? Serie {
            self.output = Output.init(
                imageUrl: serie.thumbnail?.getImageUrl(),
                title: serie.title ?? ""
            )
        }
        
    }
}
