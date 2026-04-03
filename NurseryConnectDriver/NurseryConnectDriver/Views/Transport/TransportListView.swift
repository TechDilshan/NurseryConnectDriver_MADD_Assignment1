import SwiftUI

struct TransportListView: View {
    @EnvironmentObject var transportViewModel: TransportViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                if transportViewModel.children.isEmpty {
                    EmptyStateView(
                        title: "No Children Found",
                        message: "There are no transport records available for today.",
                        systemImage: "person.crop.circle.badge.exclamationmark"
                    )
                } else {
                    List {
                        ForEach(transportViewModel.filteredChildren) { child in
                            NavigationLink {
                                ChildDetailView(childID: child.id)
                            } label: {
                                ChildRowView(child: child)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $transportViewModel.searchText, prompt: "Search by child or school")
                }
            }
            .navigationTitle("Today's Manifest")
        }
    }
}

#Preview {
    TransportListView()
        .environmentObject(TransportViewModel())
}
