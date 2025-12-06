import SwiftUI

struct LoginFormView: View {
    let onLogin: (String, String) -> Void
    let isSignUp: Bool
    let isLoading: Bool
    let errorMessage: String?
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundStyle(.white)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundStyle(.white)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Button(action: {
                onLogin(email, password)
            }) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(isSignUp ? "SIGN UP" : "LOG IN")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isLoading)
        }
        .padding(.horizontal)
    }
}
