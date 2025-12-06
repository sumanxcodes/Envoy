import SwiftUI

struct TripsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "map.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                Text("Your Trips")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Upcoming and past trips will appear here.")
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Trips")
        }
    }
}

#Preview {
    TripsView()
}
