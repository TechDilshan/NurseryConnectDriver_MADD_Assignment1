import Foundation

final class MockDataService: DataServiceProtocol {
    func loadChildren() -> [Child] {
        guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
            print("SampleData.json not found in bundle.")
            return fallbackChildren
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Child].self, from: data)
        } catch {
            print("Failed to decode SampleData.json: \(error.localizedDescription)")
            return fallbackChildren
        }
    }

    private var fallbackChildren: [Child] {
        [
            Child(
                id: "1",
                name: "Emma Johnson",
                age: 4,
                schoolName: "Little Stars Preschool",
                pickupLocation: "School Gate A",
                dropoffLocation: "Nursery",
                guardianName: "Sarah Johnson",
                guardianContact: "0771234567",
                status: .pending
            ),
            Child(
                id: "2",
                name: "Liam Smith",
                age: 5,
                schoolName: "Sunshine Kids School",
                pickupLocation: "Main Entrance",
                dropoffLocation: "Nursery",
                guardianName: "John Smith",
                guardianContact: "0719876543",
                status: .pending
            ),
            Child(
                id: "3",
                name: "Olivia Brown",
                age: 3,
                schoolName: "Happy Kids Center",
                pickupLocation: "Side Gate",
                dropoffLocation: "Nursery",
                guardianName: "Emily Brown",
                guardianContact: "0751122334",
                status: .pending
            )
        ]
    }
}
