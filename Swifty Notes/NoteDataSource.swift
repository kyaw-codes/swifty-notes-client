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
    var date: String? = nil
}

class NoteDataSource: NSObject, UITableViewDataSource {
    
    var notes = [Note]()
    
    static let shared = NoteDataSource()
    
    private override init() {
        super.init()
        
        fetchNotes { [weak self] (result) in
            DispatchQueue.global().async {
                do {
                    self?.notes = try result.get()
                } catch {
                    debugPrint(error)
                }
            }
        }
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
    
    private func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        let urlString = "http://localhost:8080/api/v0/note"
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (note, response, error) in
            // Check basic error
            if error != nil || note == nil {
                completion(.failure(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(error!))
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                debugPrint("Wrong MIME type")
                return
            }
            
            // Actual json decoding
            do {
                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
                let notes = try decoder.decode([Note].self, from: note!)
                completion(.success(notes))
            } catch {
                debugPrint(error)
            }
        }
        
        dataTask.resume()
    }
    
}
