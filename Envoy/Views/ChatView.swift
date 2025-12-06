import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
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
                                    .background(AppTheme.secondaryBackground)
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
                    .background(AppTheme.secondaryBackground)
                    .cornerRadius(20)
                
                Button(action: {
                    Task { await viewModel.sendMessage() }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(AppTheme.tint)
                        .clipShape(Circle())
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
            }
            .padding()
            .background(AppTheme.background)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
        }
        .background(AppTheme.background)
    }
}
