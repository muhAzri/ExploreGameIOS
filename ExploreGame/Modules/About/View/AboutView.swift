import SwiftUI

struct AboutView<Presenter: AboutPresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                
                Image(presenter.profileImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                
                VStack(spacing: 16) {
                    Text(presenter.fullName)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text(presenter.bio)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(title: "iOS Technologies", value: "Swift, SwiftUI, UIKit, Combine, Core Data")
                    InfoRow(title: "Android Technologies", value: "Kotlin, Java, Jetpack Compose, Room")
                    InfoRow(title: "Cross-Platform", value: "Flutter, Dart, Provider, Bloc")
                    InfoRow(title: "Architecture", value: "VIPER, MVVM, Clean Architecture, MVI")
                    InfoRow(title: "Tools", value: "Xcode, Android Studio, Git, Firebase")
                    InfoRow(title: "Specialties", value: "Native & Cross-Platform Mobile Apps")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}