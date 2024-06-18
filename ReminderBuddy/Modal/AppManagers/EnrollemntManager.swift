//
//  EnrollemntManager.swift
//  ReminderBuddy
//
//  Created by Kushal Chaudhary on 15/06/24.
//

import Foundation
import FirebaseAuth

enum LoginStatus {
    case success
    case failiure(error: LoginError)
    
    enum LoginError {
        case wrongPassword
        case userNotFound
        case unknown
    }
}

enum SignupStatus {
    case success
    case failiure(error: SignupError)
    
    enum SignupError {
        case emailExist
        case unknown
    }
}

final class EnrollemntManager {
    static func postLogin(email: String, password: String, completion: @escaping ((User?, LoginStatus) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let code: AuthErrorCode = .init(_nsError: error)
                switch code.code {
                case .wrongPassword:
                    completion(nil, .failiure(error: .wrongPassword))
                case .userNotFound:
                    completion(nil, .failiure(error: .userNotFound))
                default:
                    completion(nil, .failiure(error: .unknown))
                }
            } else {
                completion(authResult?.user, .success)
            }
        }
    }
    
    static func postSignup(email: String, password: String, firstName: String, lastName: String, completion: @escaping ((User?, SignupStatus) -> Void)) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let code: AuthErrorCode = .init(_nsError: error)
                switch code.code {
                case .emailAlreadyInUse:
                    completion(nil, .failiure(error: .emailExist))
                default:
                    completion(nil, .failiure(error: .unknown))
                }
            } else {
                if let user = authResult?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "\(firstName) \(lastName)"
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Failed to update display name: \(error)")
                            completion(nil, .failiure(error: .unknown))
                        } else {
                            completion(user, .success)
                        }
                    }
                } else {
                    completion(nil, .failiure(error: .unknown))
                }
            }
        }
    }
}
