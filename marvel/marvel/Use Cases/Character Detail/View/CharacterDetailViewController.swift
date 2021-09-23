//
//  CharacterDetailViewController.swift
//  marvel
//
//  Created by Michel Marques on 23/9/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Public vars
    var viewModel: CharacterDetailViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setup()
    }
    
    // MARK: - Setup View
    
    private func setupView() {

    }
    
    // MARK: - View Model
    
    private func setupViewModel() {
        
    }
    
    private func setup() {
        
    }

}
