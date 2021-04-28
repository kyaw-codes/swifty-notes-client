//
//  ViewController.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 27/04/2021.
//

import UIKit

class NotesViewController: UITableViewController {
    
    let dataSource = NoteDataSource()
    
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Swifty Notes"
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add right bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    @objc private func onAddTapped() {
        // navigate to note edit vc
        title = ""
        navigationController?.pushViewController(NoteEditViewController(), animated: true)
    }
    
}

