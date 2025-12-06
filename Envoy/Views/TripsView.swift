import SwiftUI

struct TripsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Image(systemName: "map.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppTheme.secondaryLabel)
                Text("Your Trips")
                    .font(AppTypography.title1)
                Text("Upcoming and past trips will appear here.")
                    .font(AppTypography.body)
                    .foregroundColor(AppTheme.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationBarTitle("Trips")
        }
    }
}

#Preview {
    TripsView()
}
