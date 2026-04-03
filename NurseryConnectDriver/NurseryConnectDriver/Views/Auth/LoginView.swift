import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appGroupedBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 14) {
                            Image(systemName: "car.side.fill")
                                .font(.system(size: 54))
                                .foregroundStyle(.blue)

                            Text("Driver Login")
                                .font(.largeTitle.bold())

                            Text("Use your driver credentials to access the transport system.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)

                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Username")
                                    .font(.subheadline.weight(.semibold))

                                TextField("Enter username", text: $authViewModel.username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.subheadline.weight(.semibold))

                                SecureField("Enter password", text: $authViewModel.password)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button {
                                authViewModel.login()
                            } label: {
                                if authViewModel.isLoading {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .tint(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                } else {
                                    PrimaryButton(title: "Login", systemImage: "lock.fill")
                                }
                            }
                        }
                        .padding()
                        .background(Color.clear)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Demo Credentials")
                                .font(.headline)

                            Text("Username: driver1")
                            Text("Password: Driver@123")
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)

                        Spacer(minLength: 30)
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
