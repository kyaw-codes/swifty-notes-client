//
//  NoteEditViewController.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 27/04/2021.
//

import UIKit

class NoteEditViewController: UIViewController {
    
    var note: Note? {
        didSet {
            guard let note = note else { return }
            textView.text = note.note
            title = note.date!.toNoteTitle()
        }
    }
    
    private var dataSource = NoteDataSource.shared
    
    private let textView = UITextView(font: .systemFont(ofSize: 18))
    private let scrollView = UIScrollView()
    private var scrollViewBottomAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenKeyboardNotification()
        
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTapped)))
        
        setupNavigationBar()
        
        textView.delegate = self
        setupScrollView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func listenKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let self = self else { return }
            guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardHeight = value.cgRectValue.height
            self.scrollViewBottomAnchor!.constant = -keyboardHeight + self.view.safeAreaInsets.bottom
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let self = self else { return }
            self.scrollViewBottomAnchor!.constant = 0
        }
    }
    
    fileprivate func setupTextView() {
        scrollView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        let heightConstraint = textView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }
    
    fileprivate func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        scrollViewBottomAnchor?.isActive = true
        
        setupTextView()
    }
    
    private func setupNavigationBar() {
        if note == nil {
            title = "New Note"
        }
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    @objc private func onViewTapped() {
        textView.becomeFirstResponder()
    }
    
    @objc private func onSaveTapped() {
        textView.resignFirstResponder()
        
        if note == nil {
            saveNote()
        } else {
            updateNote()
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func saveNote() {
        NoteService.shared.add(note: textView.text) { [weak self] (result) in
            guard let self = self else { return }
            do {
                let note = try result.get()
                self.dataSource.notes.append(note)
                self.dataSource.notes = NoteService.sortNoteByDate(self.dataSource.notes)
                self.dataSource.dataChange?()
            } catch {
                fatalError("Adding note failed: \(error)")
            }
        }
    }
    
    private func updateNote() {
        let index = dataSource.notes.firstIndex { $0.note.elementsEqual(self.note!.note) }!
        let noteToUpdate = Note(id: note!.id, note: textView.text, date: nil)
        
        NoteService.shared.update(note: noteToUpdate) { [weak self] (result) in
            guard let self = self else { return }
            do {
                let updatedNote = try result.get()
                self.dataSource.notes[index] = updatedNote
                self.dataSource.notes = NoteService.sortNoteByDate(self.dataSource.notes)
                self.dataSource.dataChange?()
            } catch {
                fatalError("Updating note failed: \(error)")
            }
        }
    }
    
}

extension NoteEditViewController : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(onSaveTapped)), animated: true)
        return true
    }
}
