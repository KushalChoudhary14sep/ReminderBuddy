//
//  UserManager.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import UIKit
import FirebaseAuth
import LocalAuthentication

class UserManager {

    static let shared = UserManager()
    private init() {}
    
    var currentUser: UserEntity? {
        get {
            return CoreDataManager.shared.fetchCurrentUser()
        }
        set {
            if let newValue = newValue {
                CoreDataManager.shared.saveUser(id: /newValue.id, email: newValue.email, firstName: newValue.firstName, lastName: newValue.lastName)
            } else {
                CoreDataManager.shared.deleteCurrentUser()
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping ((LoginStatus) -> Void)) {
        // Implement your login logic here, assuming EnrollemntManager returns user details
        EnrollemntManager.postLogin(email: email, password: password) {[weak self] user, status in
            guard let self = self else { return }
            switch status {
            case .success:
                setUser(user: user) {
                    self.promptUserToEnableBiometrics { enabled in
                        completion(status)
                    }
                }
            case .failiure:
                completion(status)
            }
        }
    }
    
    func setUser(user: User?, completion: @escaping (() -> Void)) {
        if let unwrappedUser = user {
            if let dbUser = CoreDataManager.shared.fetchUser(byId: unwrappedUser.uid) {
                self.currentUser = dbUser
                completion()
                return
            }
            
            let userEntity = UserEntity(context: CoreDataManager.shared.context)
            userEntity.id = unwrappedUser.uid
            userEntity.email = unwrappedUser.email
            userEntity.firstName = unwrappedUser.displayName?.components(separatedBy: " ").first
            userEntity.lastName = unwrappedUser.displayName?.components(separatedBy: " ").last
            self.currentUser = userEntity
            completion()
        }
    }

    func signupUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping ((SignupStatus) -> Void)) {
        // Implement your signup logic here, assuming EnrollemntManager returns user details
        EnrollemntManager.postSignup(email: email, password: password, firstName: firstName, lastName: lastName) { user, status in
            switch status {
            case .success:
                completion(status)
            case .failiure:
                completion(status)
            }
        }
    }
    
    func removeUser(completion: @escaping (() -> Void)) {
        UserDefaults.standard.set(nil, forKey: "currentUserID")
        UserManager.shared.currentUser = nil
        completion()
    }
    
    func enableBiometricAuthentication(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "biometricAuthenticationEnabled")
    }
    
    func isBiometricAuthenticationEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "biometricAuthenticationEnabled")
    }
    
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID to access your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success, authenticationError)
                }
            }
        } else {
            completion(false, error)
        }
    }
    
    func promptUserToEnableBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Enable Biometric Authentication",
                                              message: "Would you like to enable Face ID/Touch ID to access your account?",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Enable", style: .default, handler: { _ in
                    self.enableBiometricAuthentication(enabled: true)
                    completion(true)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    completion(false)
                }))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        } else {
            completion(false)
        }
    }
}
