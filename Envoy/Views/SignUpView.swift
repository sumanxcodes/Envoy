import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.1, blue: 0.2) // Deep Navy approximation
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                Image(colorScheme == .dark ? "AppLogoDark" : "AppLogoLight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                // Header
                Text("Create Account")
                    .font(.custom("AvenirNext-Bold", size: 28))
                    .foregroundStyle(.white)
                    .padding(.bottom, 20)
                
                // Form
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    Task {
                        await authViewModel.signUp(email: email, password: password)
                    }
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("SIGN UP")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .disabled(authViewModel.isLoading)
                
                Button("Already have an account? Log In") {
                    dismiss()
                }
                .foregroundStyle(.gray)
                .padding(.top)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
