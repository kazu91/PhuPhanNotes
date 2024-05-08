//
//  NoteListView.swift
//  PhuPhanNote
//
//  Created by Kazu on 6/5/24.
//

import SwiftUI

struct NoteListView: View {
    @State private var readyToAddNavigate: Bool = false
    @State private var readyToUpdateNavigate: Bool = false
    @State private var showingUserSheet: Bool = false
    @StateObject var noteListVM = NoteListViewModel()
    
    @State private var showUserNotes = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(noteListVM.noteViewModels, id: \.id) { vm in
                        NavigationLink(destination: NoteView(noteVM: vm)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(vm.note.title + " \(vm.username ?? "")")
                                        .font(.headline)
                                    Text(vm.note.lastUpdateDate)
                                        .font(.system(size: 14))
                                    Text(vm.note.content)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                               Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(.white)
                            .roundedCornerWithBorder(lineWidth: 2, borderColor: .gray.opacity(0.5), radius: 20, corners: [.allCorners] )
                        }
                        .buttonStyle(PlainButtonStyle())

                        
//                        .onTapGesture {
//                            readyToUpdateNavigate = true
//                        }
//                        .navigationDestination(for: NoteViewModel.self) { vm in
//
//                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding()
                
            VStack {
                Spacer()
                Button {
                    readyToAddNavigate = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                        
                    }
                    .navigationDestination(isPresented: $readyToAddNavigate) {
                        NoteView(noteVM: NoteViewModel(Note(title: "", content: "", lastUpdateDate: "", userId: "")))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                .padding()
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(noteListVM.showUserNotes ? "Notes" : "People's Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingUserSheet.toggle()
                    }, label: {
                        Image(systemName: "person.circle")
                    })
                    .sheet(isPresented: $showingUserSheet, content: {
                        UserView()
                    })
                }
                
                ToolbarItem(placement: .navigation) {
                    Toggle(isOn: $noteListVM.showUserNotes) {
                        Text("Your note")
                    }
                    .toggleStyle(.switch)
                }
            })
            .onChange(of: noteListVM.showUserNotes) { _ in
                noteListVM.getNoteList()
            }
            .onAppear {
                noteListVM.showUserNotes = false
            }
        }
    }
}

#Preview {
    NoteListView()
}
