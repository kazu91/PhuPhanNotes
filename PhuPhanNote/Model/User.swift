//
//  User.swift
//  PhuPhanNote
//
//  Created by Kazu on 6/5/24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String?
    var passphrase: String?
}
