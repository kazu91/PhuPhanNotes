//
//  NoteRepository.swift
//  PhuPhanNote
//
//  Created by Kazu on 6/5/24.
//

import FirebaseFirestore
import Combine

class NoteRepository: ObservableObject {
    private let path: String = Key.FirestorePath.notes
    private let store = Firestore.firestore()
    
    @Published var notes: [Note] = []
    
    var userId = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getAll() {
        store.collection(path)
            .order(by: "lastUpdateDate", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting notes: \(error.localizedDescription)")
                    return
                }
                self.notes = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Note.self)
                } ?? []
            }
    }
    
    func getUserNotes() {
        store.collection(path)
            .whereField("userId", isEqualTo: UserDefaults.standard.string(forKey: Key.UserDefaults.CURRENT_USERID) ?? "")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting notes: \(error.localizedDescription)")
                    return
                }
                self.notes = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Note.self)
                } ?? []
            }
    }
    
    func add(_ note: Note) {
        do {
            var newNote = note
            newNote.userId = UserDefaults.standard.string(forKey: Key.UserDefaults.CURRENT_USERID) ?? ""
            _ = try store.collection(path).addDocument(from: newNote)
        } catch {
            fatalError("Unable to add note: \(error.localizedDescription).")
        }
    }
    
    func update(_ note: Note) {
        guard let noteId = note.id else { return }
        
        do {
            try store.collection(path).document(noteId).setData(from: note)
        } catch {
            fatalError("Unable to update note: \(error.localizedDescription).")
        }
    }
    
    func remove(_ note: Note) {
        guard let noteId = note.id else { return }
        
        store.collection(path).document(noteId)
            .delete { error in
                if let error = error {
                    print("Unable to remove note: \(error.localizedDescription)")
                }
            }
    }
    
}
