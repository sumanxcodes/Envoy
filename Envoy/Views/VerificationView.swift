import SwiftUI

struct VerificationView: View {
    let email: String
    let onVerify: (String) -> Void
    let isLoading: Bool
    let errorMessage: String?
    
    @State private var otp = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Verify Email")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Enter the code sent to \(email)")
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            TextField("000000", text: $otp)
                .keyboardType(.numberPad)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundStyle(.white)
                .frame(maxWidth: 200)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Button(action: {
                onVerify(otp)
            }) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("VERIFY")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(otp.count < 6 || isLoading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackground").ignoresSafeArea())
    }
}

#Preview {
    VerificationView(
        email: "test@example.com",
        onVerify: { _ in },
        isLoading: false,
        errorMessage: nil
    )
    .background(Color.black)
}
