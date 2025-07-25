import SwiftUI

struct AboutView: View {
    @StateObject private var viewModel = AboutViewModel()
    @State private var editName = ""
    @State private var editEmail = ""
    @State private var editBio = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                
                Image(viewModel.profileImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                
                VStack(spacing: 16) {
                    Text(viewModel.fullName)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.email)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.bio)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                    
                    Button("Edit Profile") {
                        editName = viewModel.fullName
                        editEmail = viewModel.email
                        editBio = viewModel.bio
                        viewModel.startEditingProfile()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Spacer(minLength: 40)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: .constant(viewModel.isEditingProfile), onDismiss: {
            viewModel.cancelEditing()
        }) {
            EditProfileView(
                name: $editName,
                email: $editEmail,
                bio: $editBio,
                onSave: {
                    viewModel.saveProfile(name: editName, email: editEmail, bio: editBio)
                },
                onCancel: {
                    viewModel.cancelEditing()
                }
            )
        }
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

struct EditProfileView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var bio: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Information")) {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Title/Bio", text: $bio, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }
}
