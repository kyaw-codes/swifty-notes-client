//
//  NoteCell.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 27/04/2021.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = nil, color: UIColor? = nil, noOfLines: Int = 1) {
        self.init(frame: .zero)
        
        self.text = text
        self.font = font
        self.textColor = color
        self.numberOfLines = noOfLines
    }
}

class NoteCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    var note: Note? {
        didSet {
            guard let data = note else { return }
            noteLabel.text = data.note
            dateLabel.text = data.date ?? ""
        }
    }
    
    private let noteLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 22))
    private let dateLabel = UILabel(text: "", color: .systemGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(noteLabel)
        addSubview(dateLabel)
        
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        noteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        noteLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: noteLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: noteLabel.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 4).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
