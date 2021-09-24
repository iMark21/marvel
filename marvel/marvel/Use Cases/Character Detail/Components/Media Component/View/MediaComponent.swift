//
//  MediaComponent.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import UIKit
import RxSwift

class MediaComponent: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Variables
    var dataSource = PublishSubject<[MediaComponentProtocol]>()
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        dataSource = PublishSubject<[MediaComponentProtocol]>()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Setup
    
    func setup(medias: [MediaComponentProtocol]){
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView?.registerCell(
            type: MediaCollectionComponent.self
        )
        
        dataSource.bind(to: collectionView.rx.items) {
            collectionView, index, component in
            guard let cell = collectionView.dequeueCell(
                    withType: MediaCollectionComponent.self,
                    for: IndexPath(index: index)) as? MediaCollectionComponent
            else {
                return UICollectionViewCell()
            }
            
            cell.setup(component: component)
            return cell
            
        }.disposed(by: disposeBag)
        
        dataSource.onNext(medias)
    }
    
}
