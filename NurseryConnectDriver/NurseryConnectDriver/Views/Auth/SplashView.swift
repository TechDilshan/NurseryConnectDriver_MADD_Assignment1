import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.85), Color.cyan.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "car.side.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.white)

                Text("NurseryConnect Driver")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text("Safe nursery transport management")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))

                ProgressView()
                    .tint(.white)
                    .padding(.top, 12)
            }
            .padding()
        }
    }
}

#Preview {
    SplashView()
}
