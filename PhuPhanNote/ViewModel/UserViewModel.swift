//
//  UserViewModel.swift
//  PhuPhanNote
//
//  Created by Kazu on 7/5/24.
//

import Foundation

import Foundation
import Combine

class UserViewModel: ObservableObject, Identifiable {
    
    private let userRepository = UserRepository()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var currentUser: User?
    @Published var showingAlert: Bool = false
    
    init() {
        Task {
           await currentUser = getUserbyUsername(UserDefaults.standard.object(forKey: Key.UserDefaults.CURRENT_USERNAME) as? String ?? "")
        }
    }
    
    var message = ""
    
    func addNew(_ user: User) {
        userRepository.add(user)
    }
     
    func getUserbyUsername(_ username: String) async -> User? {
        await userRepository.getUserByUsername(username)
    }
    
    func loginOrRegister(username: String, passphrase: String) async {
        if username.contains(" ") || username.isEmpty {
            message = "username cannot have blankspace"
        }
//        if passphrase != rePassphrase {
//            message = "passphrases mismatch \n"
//        } else
        if passphrase.count > 8 || passphrase.count < 4 {
            message = "passphrase must between 4-8 characters"
        }
        
        if !message.isEmpty {
            showingAlert = true
            return
        }
        
        let user = await getUserbyUsername(username)
        
        if let user = user {
            // matches user
            
            //check for passphrase
            if user.passphrase == passphrase {
                // saved current user
                UserDefaults.standard.set(username, forKey: Key.UserDefaults.CURRENT_USERNAME)
                UserDefaults.standard.set(user.id, forKey: Key.UserDefaults.CURRENT_USERID)
                currentUser = user
            } else {
                showingAlert = true
                message = "passphrase mismatch"
            }
            
        } else {
            addNew(User(name: username, passphrase: passphrase))
            
            UserDefaults.standard.set(username, forKey: Key.UserDefaults.CURRENT_USERNAME)
            
            await currentUser = getUserbyUsername(username)
            
            UserDefaults.standard.set(currentUser?.id, forKey: Key.UserDefaults.CURRENT_USERID)
        }
    }
    
}
