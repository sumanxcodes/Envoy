import SwiftUI
import UIKit

// MARK: - App Theme (Colors)
struct AppTheme {
    // Backgrounds
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    static let groupedBackground = Color(UIColor.systemGroupedBackground)
    
    // Labels (Text)
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    
    // Tints
    static let tint = Color(UIColor.systemOrange)
    static let destructive = Color(UIColor.systemRed)
    static let success = Color(UIColor.systemGreen)
    
    // Separators
    static let separator = Color(UIColor.separator)
}

// MARK: - App Typography (Fonts)
// Wrappers around Dynamic Type fonts to ensure consistency and scalability
struct AppTypography {
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title1 = Font.title.weight(.bold)
    static let title2 = Font.title.weight(.semibold) // iOS 14+ has title2/3, mapping to title for iOS 13 safety or custom
    static let headline = Font.headline.weight(.semibold)
    static let body = Font.body
    static let callout = Font.callout
    static let subheadline = Font.subheadline
    static let footnote = Font.footnote
    static let caption = Font.caption
    
    // Button Text Styles
    static let primaryButton = Font.headline.weight(.bold)
    static let secondaryButton = Font.body.weight(.medium)
}

// MARK: - Layout Constants
struct AppLayout {
    static let padding: CGFloat = 16.0
    static let smallPadding: CGFloat = 8.0
    static let cornerRadius: CGFloat = 12.0
    static let buttonHeight: CGFloat = 50.0
    static let iconSize: CGFloat = 24.0
}
