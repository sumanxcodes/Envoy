import SwiftUI

struct SuggestionChipsView: View {
    let suggestions: [String]
    let onTap: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: {
                        onTap(suggestion)
                    }) {
                        Text(suggestion)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.tint)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(AppTheme.tint.opacity(0.1))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppTheme.tint.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, AppLayout.padding)
        }
    }
}

// Suggestion templates
struct ChatSuggestions {
    static let general = [
        "Scout coffee shops",
        "Find events tonight",
        "Weekend plans",
        "Nearby restaurants"
    ]
    
    static let location = [
        "What's around me?",
        "Best rated nearby",
        "Open now",
        "Popular spots"
    ]
    
    static let planning = [
        "Plan a trip",
        "Date night ideas",
        "Family activities",
        "Hidden gems"
    ]
    
    // Get context-aware suggestions
    static func getSuggestions(hasMessages: Bool) -> [String] {
        if hasMessages {
            return location
        } else {
            return general
        }
    }
}

#Preview {
    VStack {
        Spacer()
        SuggestionChipsView(suggestions: ChatSuggestions.general) { suggestion in
            print("Tapped: \(suggestion)")
        }
        .padding(.vertical)
    }
}
