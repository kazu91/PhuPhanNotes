//
//  NoteViewModel.swift
//  PhuPhanNote
//
//  Created by Kazu on 7/5/24.
//

import Foundation
import Combine

class NoteViewModel: ObservableObject, Identifiable {
    
    private let noteRepository = NoteRepository()
    var userRepository = UserRepository()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var note: Note
    
    @Published var username: String?
    
    var noteId = ""
    
    init(_ note: Note) {
        self.note = note
        
        $note
            .compactMap { $0.id }
            .assign(to: \.noteId, on: self)
            .store(in: &cancellables)
        
        $note
            .sink { note in
            Task {
                if !note.userId.isEmpty {
                    self.username = await self.getUsernameById(note.userId)
                }
            }
        }
        .store(in: &cancellables)
       
      
    }
    
    func add() {
        noteRepository.add(note)
    }
    
    func update() {
        noteRepository.update(note)
    }

    func delete() {
        noteRepository.remove(note)
    }
    
    func getUsernameById(_ id: String) async -> String {
        if id.isEmpty { return "" }
        let user = await userRepository.getUserById(id)
        
        return user?.name ?? ""
    }
    
}
