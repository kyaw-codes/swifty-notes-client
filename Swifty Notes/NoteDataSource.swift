//
//  NoteDataSource.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 27/04/2021.
//

import UIKit

struct Note: Codable {
    var id: Int = 1
    var note: String
    var date: Date? = nil
}

class NoteDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else {
            fatalError("Failed to cast cell into NoteCell")
        }
        return cell
    }
    
}
