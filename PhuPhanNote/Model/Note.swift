//
//  Note.swift
//  PhuPhanNote
//
//  Created by Kazu on 6/5/24.
//

import Foundation
import FirebaseFirestore

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var lastUpdateDate: String
    var userId: String
}
