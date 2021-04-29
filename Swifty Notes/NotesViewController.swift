//
//  ViewController.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 27/04/2021.
//

import UIKit

class NotesViewController: UITableViewController {
    
    let dataSource = NoteDataSource.shared
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = dataSource.notes[indexPath.row]
        let noteEditVC = NoteEditViewController()
        noteEditVC.note = note
        navigateToNoteEditVC(vc: noteEditVC)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc private func onAddTapped() {
        navigateToNoteEditVC(vc: NoteEditViewController())
    }
    
    private func navigateToNoteEditVC(vc: NoteEditViewController, animated: Bool = true) {
        title = ""
        navigationController?.pushViewController(vc, animated: animated)
    }
    
}

