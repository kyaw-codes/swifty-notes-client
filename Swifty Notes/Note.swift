//
//  Note.swift
//  Swifty Notes
//
//  Created by Ko Kyaw on 02/05/2021.
//

import Foundation

struct Note: Codable {
    var id: Int = 1
    var note: String
    var date: String? = nil
}
