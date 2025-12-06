import SwiftUI

struct ChatOverlayView: View {
    @StateObject private var viewModel = ChatViewModel()
    // @FocusState is iOS 15+. We need to remove it or use a workaround.
    // For now, removing focus state management to fix build.
    // @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle / Drag Indicator
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
            
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .padding(10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Area
            HStack(spacing: 10) {
                TextField("Ask Envoy...", text: $viewModel.inputText, onCommit: {
                    Task { await viewModel.sendMessage() }
                })
                    .padding(10)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                
                Button(action: {
                    Task { await viewModel.sendMessage() }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
            }
            .padding()
            .background(Color.white.opacity(0.9)) // Replaced ultraThinMaterial
        }
        .background(Color.white.opacity(0.9)) // Replaced ultraThinMaterial
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 10)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var isUser: Bool {
        message.role == "user"
    }
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(message.content)
                .padding(12)
                .background(isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isUser ? .white : .primary)
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: isUser ? .trailing : .leading)
            
            if !isUser { Spacer() }
        }
    }
}

// Extension for partial corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        VStack {
            Spacer()
            ChatOverlayView()
                .frame(height: 400)
        }
    }
}
