//
//  UserRepository.swift
//  PhuPhanNote
//
//  Created by Kazu on 6/5/24.
//

import FirebaseFirestore
import Combine

class UserRepository: ObservableObject {
    private let path: String = Key.FirestorePath.users
    private let store = Firestore.firestore()
    
    @Published var users: [User] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    func get() {
        store.collection(path)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting users: \(error.localizedDescription)")
                    return
                }
                self.users = snapshot?.documents.compactMap { document in
                    try? document.data(as: User.self)
                } ?? []
            }
    }
    
    func getUserByUsername(_ username: String) async ->  User? {
        do {
            let querSnappshot = try await store.collection(path)
                .whereField("name", isEqualTo: username)
                .getDocuments()
            return try querSnappshot.documents.first?.data(as: User.self)
        } catch {
            fatalError("Unable to get user: \(error.localizedDescription).")
        }
    }
    
    func getUserById(_ userId: String) async ->  User? {
        do {
            let querSnappshot = try await store.collection(path)
                .whereField(FieldPath.documentID(), isEqualTo: userId)
                .getDocuments()
            return try querSnappshot.documents.first?.data(as: User.self)
        } catch {
            fatalError("Unable to get user: \(error.localizedDescription).")
        }
    }
    
    func add(_ user: User) {
        do {
            _ = try store.collection(path).addDocument(from: user)
        } catch {
            fatalError("Unable to add user: \(error.localizedDescription).")
        }
    }
}
