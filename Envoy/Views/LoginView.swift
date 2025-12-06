
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isSignUp = false
    @State private var lastEmail = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Logo / Title
                VStack(spacing: 10) {
                    Image(colorScheme == .dark ? "AppLogoDark" : "AppLogoLight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("ENVOY")
                        .font(.custom("AvenirNext-Bold", size: 32))
                        .tracking(4)
                        .foregroundStyle(.white)
                    
                    Text("Your Intelligent Guide")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 40)
                
                // Form
                LoginFormView(
                    onLogin: { email, password in
                        self.lastEmail = email // Track email for verification
                        Task {
                            if isSignUp {
                                await authViewModel.signUp(email: email, password: password)
                            } else {
                                await authViewModel.signIn(email: email, password: password)
                            }
                        }
                    },
                    isSignUp: isSignUp,
                    isLoading: authViewModel.isLoading,
                    errorMessage: authViewModel.errorMessage
                )
                
                // Toggle between Login and Sign Up
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.05, green: 0.1, blue: 0.2).ignoresSafeArea())
        }
        .sheet(isPresented: $authViewModel.awaitingVerification) {
            VerificationView(
                email: lastEmail,
                onVerify: { token in
                    Task {
                        await authViewModel.verifyOTP(email: lastEmail, token: token)
                    }
                },
                isLoading: authViewModel.isLoading,
                errorMessage: authViewModel.errorMessage
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
