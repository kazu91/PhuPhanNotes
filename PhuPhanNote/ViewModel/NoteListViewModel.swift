//
//  NoteListViewModel.swift
//  PhuPhanNote
//
//  Created by Kazu on 7/5/24.
//

import Foundation
import Combine

class NoteListViewModel: ObservableObject {
    @Published var showUserNotes = false
    @Published var noteViewModels: [NoteViewModel] = []
    @Published var noteRepository = NoteRepository()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        // TODO: check for redundant later
        getNoteList()
    }
    
    func add(_ note: Note) {
        noteRepository.add(note)
    }
    
    func getNoteList() {
        // Show only user
        if showUserNotes {
            noteRepository.getUserNotes()
        } else { // show all
            noteRepository.getAll()
        }
        noteRepository.$notes.map { notes in
            notes.map { note in
                NoteViewModel(note)
            }
        }
        .assign(to: \.noteViewModels, on: self)
        .store(in: &cancellables)
    }
    
}
