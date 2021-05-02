//
//  NoteService.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 30/04/2021.
//

import Foundation

class NoteService {
    
    static let shared = NoteService()
    
    private init() {
    }
    
    private let baseURLString = "http://localhost:8080/api/v0/note"
    
    func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        guard let url = URL(string: baseURLString) else { return }
        
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
                return
            }
            
            // Actual json decoding
            do {
                let notes = try JSONDecoder().decode([Note].self, from: note!)
                DispatchQueue.main.async {
                    completion(.success(notes))
                }
            } catch {
                debugPrint(error)
            }
        }
        
        dataTask.resume()
    }
    
    func add(note: String, completion: @escaping (Result<Note, Error>) -> Void) {
        let note = Note(note: note)
    
        let url = URL(string: baseURLString)!
        var request = URLRequest(url: url)
        
        do {
            let data = try JSONEncoder().encode(note)
            request.httpBody = data
        } catch {
            fatalError("Encoding error: \(error)")
        }

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check basic error
            if error != nil || data == nil {
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
            
            do {
                let createdNote = try JSONDecoder().decode(Note.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(createdNote))
                }
            } catch {
                fatalError("Decoding error: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    func update(note: Note, completion: @escaping (Result<Note, Error>) -> Void) {
        let url = URL(string: "\(baseURLString)/\(note.id)")!
        var request = URLRequest(url: url)
        
        do {
            let data = try JSONEncoder().encode(note)
            request.httpBody = data
        } catch {
            fatalError("Encoding error: \(error)")
        }

        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check basic error
            if error != nil || data == nil {
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
            
            do {
                let updatedNote = try JSONDecoder().decode(Note.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(updatedNote))
                }
            } catch {
                fatalError("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func delete(id: Int, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURLString)/\(id)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
            } else {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
        task.resume()
    }
    
    static func sortNoteByDate(_ notes: [Note]) -> [Note] {
        // Sort note by date
        return notes.sorted { (n1, n2) -> Bool in
            n1.date!.toNoteDate() >= n2.date!.toNoteDate()
        }
    }
}
