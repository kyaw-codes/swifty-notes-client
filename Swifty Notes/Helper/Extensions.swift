//
//  Extensions.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 02/05/2021.
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

extension UITextView {
    
    convenience init(font: UIFont, isNoteTextField: Bool = true) {
        self.init(frame: .zero)
        
        self.font = font
        if isNoteTextField {
            self.autocorrectionType = .no
            self.autocapitalizationType = .none
        }
    }
}

extension Date {
    func toNoteDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' hh:mm a"
        return formatter.string(from: self)
    }
}

extension String {
    
    func toNoteTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy 'at' hh:mm a"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date!)
    }
    
    func toNoteDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' hh:mm a"
        guard let date = formatter.date(from: self) else {
            fatalError("Failed to convert \(self) into Date object.")
        }
        return date
    }
}
