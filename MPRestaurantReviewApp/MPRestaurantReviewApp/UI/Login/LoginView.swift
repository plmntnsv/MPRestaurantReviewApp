//
//  LoginView.swift
//  MPRestaurantReviewApp
//
//  Created by Plamen Atanasov on 28.05.25.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            ScreenTitle(title: "Login")
            
            Spacer()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                print("Logging in with \(username) / \(password)")
            }) {
                Text("Login")
                    .bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Text("Don't have an account? Sign up.")
                .font(.caption)
                .foregroundColor(.secondary)
                .underline()
                .onTapGesture {
                    print("register")
                }
            
            Spacer()
        }
        .padding(50)
    }
}

#Preview {
    LoginView()
}
