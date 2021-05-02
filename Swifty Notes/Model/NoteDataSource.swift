//
//  NoteDataSource.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 27/04/2021.
//

import UIKit

class NoteDataSource: NSObject, UITableViewDataSource {

    var notes = [Note]()
    
    var dataChange: (() -> Void)?
    
    static let shared = NoteDataSource()
    private let urlString = "http://localhost:8080/api/v0/note"
    
    private override init() {
        super.init()
        
        reloadAllNotes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else {
            fatalError("Failed to cast cell into NoteCell")
        }
        cell.note = notes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = notes[indexPath.row].id
            NoteService.shared.delete(id: id) { [weak self] isSuccessful in
                if isSuccessful {
                    self?.notes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    private func reloadAllNotes() {
        NoteService.shared.fetchNotes { [weak self] result in
            guard let self = self else { return }
            do {
                self.notes = try result.get()
                self.notes = NoteService.sortNoteByDate(self.notes)
                self.dataChange?()
            } catch {
                debugPrint(error)
            }
        }
    }

}

extension NoteDataSource : UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased()
        if searchText != "" {
            notes = notes.filter { $0.note.lowercased().contains(searchText ?? "") }
        } else {
            reloadAllNotes()
        }
        dataChange?()
    }
}
