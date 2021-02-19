//
//  UserData.swift
//  SampleFit
//
//  Created by Zihan Qi on 2/10/21.
//

import Foundation
import Combine
import SwiftUI
import AuthenticationServices

/// Stores relavant information about the user.
class UserData: ObservableObject {
    
    // MARK: - Instance properties
    
    /// Notifies SwiftUI to re-render UI because of a data change.
    var objectWillChange = ObservableObjectPublisher()
    
    var createAccountInformation = CreateAccountInformation()
    var signInInformation = SignInInformation()
    var credential = Credential()
    var socialInformation = SocialInformation()
    
    
    var signInStatus = SignInStatus.never {
        willSet {
            objectWillChange.send()
        }
    }
    var networkQueryController = NetworkQueryController()
    
    // MARK: - Navigation
    var shouldPresentAuthenticationView: Bool {
        get { return signInStatus != .signedIn }
        set {}
    }
    
    // MARK: - Asynchronous tasks
    
    func signInwithAppleDidComplete(with result: Result<ASAuthorization, Error>) {
        switch result {
        case let .success(authorization):
            
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                storeCredentialAndManageSignInStatusAfterSignInSuccess(identifier: appleIDCredential.user, fullName: appleIDCredential.fullName)

            case let passwordCredential as ASPasswordCredential:
                storeCredentialAndManageSignInStatusAfterSignInSuccess(identifier: passwordCredential.user)
                
            default:
                break
            }
            
        case let .failure(error):
            
            // TODO: Do something about the error
            print("Sign in with Apple Error: \(error)")
            manageSignInStatusAfterSignIn(false)
            
        }
    }
    
    /// Runs when the user chooses to sign up using default method.
    func createAccountUsingDefaultMethod() {
        print("creating account using default method...")
        signInStatus = .validatingFirstTime
        
        networkQueryController.createAccount(using: createAccountInformation) { [unowned self] (success) in 
            if success {
                storeCredentialAndManageSignInStatusAfterSignInSuccess(identifier: createAccountInformation.username)
            } else {
                print("Create account failed")
            }
        }
    }
    
    /// Runs when the user chooses to sign in using default method.
    func signInUsingDefaultMethod() {
        print("signing in using default method...")
        signInStatus = .validating
        
        networkQueryController.signIn(using: signInInformation) { [unowned self] (success) in
            if success {
                storeCredentialAndManageSignInStatusAfterSignInSuccess(identifier: signInInformation.username)
            } else {
                print("Sign in failed")
            }
        }
    }
    
    /// Runs when the user chooses to sign out.
    func signOut() {
        print("signing out.")
        
        signInStatus = .signedOut
    }
    
    private func storeCredentialAndManageSignInStatusAfterSignInSuccess(identifier: String, fullName: PersonNameComponents? = nil) {
        // store the credentials
        storeCredential(identifier: identifier, fullName: fullName)
        // change sign in status
        manageSignInStatusAfterSignIn(true)
        // fetch social information
        fetchSocialInformation(usingCredential: credential)
    }
    
    private func storeCredential(identifier: String, fullName: PersonNameComponents? = nil) {
        credential = Credential(identifier: identifier, fullName: fullName)
    }
    
    /// Manages sign in status after the user chooses to sign in.
    private func manageSignInStatusAfterSignIn(_ success: Bool) {
        if success {
            signInStatus = .signedIn
        } else {
            switch signInStatus {
            case .never:
                break
            default:
                signInStatus = .signedOut
            }
        }
    }
    
    private func fetchSocialInformation(usingCredential credential: Credential) {
        // fetch social information
        networkQueryController.exerciseFeedsForUser(withCredential: credential) { (result) in
            switch result {
            case let .success(exercises):
                DispatchQueue.main.async {
                    self.socialInformation.exerciseFeeds = exercises
                }
            case let .failure(error):
                print("error fetching exercise feeds: \(error)")
                
            }
        }
    }
    
    static var signedInUserData: UserData {
        let userData = UserData()
        userData.storeCredentialAndManageSignInStatusAfterSignInSuccess(identifier: "signedInUser")
        return userData
    }
}
