import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @Environment(\.colorScheme) var colorScheme
    
    // Callback to let the parent know splash is done
    var onFinished: () -> Void
    
    var body: some View {
        if isActive {
            // This part might not be reached if parent switches view, 
            // but useful if SplashView handles the transition logic itself.
            // However, typically SplashView is just the visual.
            // Let's keep it simple: Just show the logo.
            EmptyView()
        } else {
            ZStack {
                Color(UIColor.systemBackground) // Use system background
                    .ignoresSafeArea()
                
                VStack {
                    Image(colorScheme == .dark ? "AppLogoDark" : "AppLogoLight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    Text("ENVOY")
                        .font(.custom("AvenirNext-Bold", size: 40))
                        .foregroundColor(Color.blue.opacity(0.8))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                        onFinished()
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
