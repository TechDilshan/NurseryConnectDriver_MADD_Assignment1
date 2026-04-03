import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Spacer()

            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding()
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    PrimaryButton(title: "Start Route", systemImage: "play.fill")
        .padding()
}
