//
//  NoteView.swift
//  PhuPhanNote
//
//  Created by Kazu on 6/5/24.
//

import SwiftUI

struct NoteView: View {
    let dateFormat = "dd-MM-YYYY hh:mm:ss"

    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var noteVM: NoteViewModel
    
    @State var viewOnly: Bool = true
    @State var title = ""
    @State var content = ""
    @State var showAlert: Bool = false
    
    //MARK: - Body
    var body: some View {
       
        NavigationStack {
            VStack(alignment: .leading) {
                noteFromUserView
                noteTitleView
                VStack(alignment: .leading, spacing: 10) {
                    Text("Note")
                        .foregroundColor(.gray)
                    TextEditor(text: $content)
                        .border(Color.gray.opacity(0.5), width: 0.5)
                        .disabled(viewOnly)
                }
                submitButtonView
                Spacer()
            }
            .navigationTitle(noteVM.note.id == nil ? "Add Note" : "Update Note")
            .navigationBarTitleDisplayMode(.inline)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .onAppear {
                title = noteVM.note.title
                content = noteVM.note.content
                if noteVM.note.id != nil {
                    viewOnly = noteVM.note.userId != UserDefaults.standard.string(forKey: Key.UserDefaults.CURRENT_USERID)
                }
            }
            .toolbar(content: {
                // hide when creating new note or not user's note
                !viewOnly ?
                ToolbarItem(placement: .primaryAction) {
                     Button(action: {
                        showAlert = true
                    }, label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                    })
                }
                : nil
            })
            .confirmationDialog(
                Text("Delete your note?"),
                isPresented: $showAlert,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    noteVM.delete()
                    dismiss()
                }
            }
        }
    }
    
    //MARK: - Views
    var noteFromUserView: some View {
        viewOnly ?
        Text("Note from \(noteVM.username ?? "")")
            .fontWeight(.medium)
            .padding(.bottom, 5)
        : nil
    }
    var noteTitleView: some View {
        return VStack(alignment: .leading, spacing: 5) {
            Text("Note Title")
                .foregroundColor(.gray)
            TextField("Enter note's title", text: $title)
                .frame(height: 48)
                .textFieldStyle(.roundedBorder)
                .disabled(viewOnly)
        }
    }
    
    var submitButtonView: some View {
        Button(action: {
            noteVM.note.id == nil ? addNote() : updateNote()
        }, label: {
            Text(noteVM.note.id == nil ? "Add Note" : "Update")
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: 38)
        })
        .buttonStyle(.borderedProminent)
        .disabled(viewOnly)
    }
    
    //MARK: - Functions
    
    func addNote() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        noteVM.note.title = title
        noteVM.note.content = content
        noteVM.note.lastUpdateDate = dateFormatter.string(from: Date())
        noteVM.note.userId = UserDefaults.standard.object(forKey: Key.UserDefaults.CURRENT_USERID) as? String ?? ""
        
        noteVM.add()
        
        noteVM.username = UserDefaults.standard.string(forKey: Key.UserDefaults.CURRENT_USERNAME)
        
        dismiss()
    }
    
    func updateNote() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        noteVM.note.title = title
        noteVM.note.content = content
        noteVM.note.lastUpdateDate = dateFormatter.string(from: Date())
        
        noteVM.update()
        
        dismiss()
    }
    
}

#Preview {
    NoteView(noteVM: NoteViewModel(Note(title: "", content: "", lastUpdateDate: "", userId: "")))
}
