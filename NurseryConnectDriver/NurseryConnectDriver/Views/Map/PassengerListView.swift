import SwiftUI

struct PassengerListView: View {
    let passengers: [Passenger]

    var body: some View {
        NavigationStack {
            List(passengers) { passenger in
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 36, height: 36)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(passenger.name)
                            .font(.headline)

                        Text("Age: \(passenger.age)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Passengers On Board")
        }
    }
}

#Preview {
    PassengerListView(
        passengers: [
            Passenger(name: "Emma Johnson", age: 4),
            Passenger(name: "Liam Smith", age: 5)
        ]
    )
}
