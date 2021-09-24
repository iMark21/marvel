//
//  CharacterDetailDataSource.swift
//  marvel
//
//  Created by Michel Marques on 24/9/21.
//

import Foundation
import RxDataSources

// MARK: RX - Data Sources

enum MultipleSectionModel {
    case HeaderSection(title: String, items: [SectionItem])
    case MediaSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case HeaderSectionItem(component: DetailComponentProtocol)
    case MediaSectionItem(components: [MediaComponentProtocol])
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch  self {
        case .HeaderSection(title: _, items: let items):
            return items.map { $0 }
        case .MediaSection(title: _, items: let items):
            return items.map { $0 }

        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .HeaderSection(title: title, items: _):
            self = .HeaderSection(title: title, items: items)
        case let .MediaSection(title: title, items: _):
            self = .MediaSection(title: title, items: items)
        }
    }
}

extension MultipleSectionModel {
    var title: String {
        switch self {
        case .HeaderSection(title: let title, items: _):
            return title
        case .MediaSection(title: let title, items: _):
            return title
        }
    }
}
