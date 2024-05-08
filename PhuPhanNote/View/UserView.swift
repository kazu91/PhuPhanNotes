//
//  UserView.swift
//  PhuPhanNote
//
//  Created by Kazu on 7/5/24.
//

import SwiftUI

struct UserView: View {
    @State var username: String = ""
    @State var passphrase: String = ""
    //  @State var rePassphrase: String = ""
    @State var refresh: Bool = false
    @StateObject var userVM = UserViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    //MARK: - Body
    var body: some View {
        if let _ = UserDefaults.standard.object(forKey: Key.UserDefaults.CURRENT_USERNAME) as? String {
            loggedInView
                .background(Color.clear.disabled(refresh))
        } else {
            signInView
                .background(Color.clear.disabled(refresh))
        }
        
    }
    
    //MARK: - Views
    var signInView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Use your username to create notes")
                .font(.headline)
            TextField("Mike, David, ....", text: $username)
                .textFieldStyle(.roundedBorder)
            Text("Enter yout passpharase")
                .font(.headline)
            TextField("", text: $passphrase)
                .textFieldStyle(.roundedBorder)
            Text("If your username not existed, new account will be created.")
            //            TextField("", text: $rePassphrase)
            //                .textFieldStyle(.roundedBorder)
            
            signInButton
                .buttonStyle(.borderedProminent)
            
        }
        .padding()
        .alert("Error", isPresented: $userVM.showingAlert) {
            Button(role: .cancel) {
                userVM.showingAlert = false
                userVM.message = ""
            } label: {
                Text("Okay")
            }
        } message: {
            Text(userVM.message)
        }
    }
    
    var signInButton: some View {
        Button(action: {
            Task {
                await userVM.loginOrRegister(username: username, passphrase: passphrase)
                update()
            }
        }, label: {
            Text("Continue")
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: 38)
        })
    }
    
    var loggedInView: some View {
        VStack {
            Text("Hi, \(UserDefaults.standard.string(forKey: Key.UserDefaults.CURRENT_USERNAME) ?? "")")
                .font(.title)
            
            Button(action: {
                refreshData()
            }, label: {
                Text("Change to another user")
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: 40)
            })
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
    }
    
    //MARK: - Functions
    func update() {
        refresh.toggle()
    }
    
    func refreshData() {
        username = ""
        passphrase = ""
        UserDefaults.standard.removeObject(forKey: Key.UserDefaults.CURRENT_USERNAME)
        UserDefaults.standard.removeObject(forKey: Key.UserDefaults.CURRENT_USERID)
        update()
    }
}

#Preview {
    UserView()
}
