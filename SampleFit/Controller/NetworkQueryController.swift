//
//  NetworkQueryController.swift
//  SampleFit
//
//  Created by Zihan Qi on 2/17/21.
//

import Foundation
import SwiftUI
import Combine

struct MessagedError: Error {
    let message: String
}

/// Handles asynchronous networking tasks.
class NetworkQueryController {
    
    /// Returns a publisher that publishes true value if success and false values if an error occured.
    func validateUsername(_ username: String) -> AnyPublisher<Bool, Never> {
        // FIXME: validate username over network
        // faking validation logic now
        // faking networking delay of 2 seconds
        return Future<Bool, Error> { promise in
            if username.count <= 3 {
                promise(.failure(MessagedError(message: "Too short")))
            } else {
                promise(.success(true))
            }
        }
        .replaceError(with: false)
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    /// Returns a publisher that publishes true value if success and false values if an error occured.
    func validatePassword(_ password: String) -> AnyPublisher<Bool, Never> {
        // FIXME: validate password over network
        // faking validation logic now
        // faking networking delay of 2 seconds
        return Future<Bool, Error> { promise in
            if password.count < 5 {
                promise(.failure(MessagedError(message: "Too short")))
            } else {
                promise(.success(true))
            }
        }
        .replaceError(with: false)
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    
    /// Returns a publisher that publishes true values if success and false values if an eror occured.
    func createAccount(using: AuthenticationState) -> AnyPublisher<Bool, Never> {
        // FIXME: Create account over network
        // assuming success now
        // faking networking delay of 2 seconds
        return Future<Bool, Error> { promise in
            promise(.success(true))
//            promise(.failure(MessagedError(message: "Sign Up Error")))
        }
        .replaceError(with: false)
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    /// Returns a publisher that publishes true values if success and false values if an eror occured.
    func signIn(using: AuthenticationState) -> AnyPublisher<Bool, Never> {
        // FIXME: Sign in over network
        // assuming success now
        // faking networking delay of 2 seconds
        return Future<Bool, Error> { promise in
            promise(.success(true))
        }
        .replaceError(with: false)
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    /// Queries the network and returns the exercise feeds or a the default example exercise array on failure.
    func exerciseFeedsForUser(withProfile profile: PublicProfile) -> AnyPublisher<[Exercise], Never> {
        // FIXME: Search for exercise feeds for user over network
        // assuming success now
        // faking networking delay of 2 seconds
        return Future<[Exercise], Error> { promise in
            promise(.success(Exercise.exampleExercisesFull))
        }
        .replaceError(with: Exercise.exampleExercisesSmall)
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    /// Queries the network for exercise results and returns a publisher that emits either relevant exercises on success or an error on failure.
    func searchExerciseResults(searchText: String, category: Exercise.Category?) -> AnyPublisher<[Exercise], Error> {
        // FIXME: Search for exercise results for user over network
        // assuming success now
        // faking networking delay of 2 seconds
        return Future { promise in
            promise(.success(Exercise.exampleExercisesFull.filter {
                if let category = category {
                    return $0.category == category && $0.shouldAppearOnSearchText(searchText)
                } else {
                    return $0.shouldAppearOnSearchText(searchText)
                }
            }))
        }
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    /// Quries the network for user results and returns a publisher that emits either relevant user credentials on success or an error on failure.
    func searchUserResults(searchText: String) -> AnyPublisher<[PublicProfile], Error> {
        // FIXME: Search for user results for user over network
        // assuming success now
        // faking networking delay of 2 seconds
        return Future { promise in
            promise(.success(PublicProfile.exampleProfiles.filter { $0.shouldAppearOnSearchText(searchText) }))
        }
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    /// Returns a publisher that publishes image values if success and nil values if an eror occured.
    func loadImage(fromURL url: URL) -> AnyPublisher<Image?, Never> {
        // FIXME: Load image over network
        // assuming success now
        // faking networking delay of 2 seconds
        return Future<Image?, Error> { promise in
            promise(.success(Image(systemName: "network")))
        }
        .replaceError(with: nil)
        .delay(for: .seconds(2), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    static let shared = NetworkQueryController()
}
