//
//  SignInView.swift
//  SampleFit
//
//  Created by Zihan Qi on 2/11/21.
//

import SwiftUI

import SwiftUI
import AuthenticationServices
import Combine

struct SignInView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var signInAuthenticationState: AuthenticationState
    @Environment(\.colorScheme) var colorScheme
    @State private var currentColorScheme: ColorScheme = .light
    
    var body: some View {
        VStack {
            
            // Custom sign in
            VStack(spacing: 16) {
                // username field
                UsernameTextField($signInAuthenticationState.username, inputStatus: signInAuthenticationState.usernameInputStatus, colorType: \.signInColor)
                
                // password field
                PasswordTextField(.password, text: $signInAuthenticationState.password, inputStatus: signInAuthenticationState.passwordInputStatus, colorType: \.signInColor)
                    .padding(.bottom, 24)
                
                if userData.signInReturnsError {
                    Text("Incorrect username or password.")
                        .foregroundColor(.red)
                }
                
                // sign in button
                Button(action: userData.signInUsingDefaultMethod) {
                    Group {
                        if userData.signInStatus != .validating {
                            Text("Sign In")
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.vertical)
                        }
                    }
                        .font(.headline)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 7.5)
                                .fill(signInAuthenticationState.allowsAuthentication ? signInAuthenticationState.passwordInputStatus.signInColor : Color.secondary)
                        )
                }
                .disabled(!signInAuthenticationState.allowsAuthentication || userData.signInStatus == .validating)
            }
            .padding(.top, 60)

            
            Divider()
                .padding(.vertical, 8)
            
            
            // Sign up with Apple
            SignInWithAppleButton(.signIn, onRequest: { (request: ASAuthorizationAppleIDRequest) in
                request.requestedScopes = [.fullName]
            }, onCompletion: { (result: Result<ASAuthorization, Error>) in
                userData.signInwithAppleDidComplete(with: result)
            })
            .signInWithAppleButtonStyle(currentColorScheme == .dark ? .white : .black)
            .frame(height: 44)
            .id(currentColorScheme.hashValue)
            .disabled(userData.signInStatus == .validating)

            Spacer()
        }
        // detects color scheme change and re-render
        .onReceive(CurrentValueSubject<ColorScheme, Never>(colorScheme), perform: { newValue in
            self.currentColorScheme = newValue
        })
        .padding(.horizontal, 24)
        .navigationBarTitle("Sign In")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var userData = UserData()

    static var previews: some View {
        MultiplePreview(embedInNavigationView: true) {
            SignInView(signInAuthenticationState: userData.signInAuthenticationState)

        }
        .environmentObject(userData)
    }
}
