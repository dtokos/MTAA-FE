import SwiftUI
import Combine

struct ProfileView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    @State private var isImagePickerActive: Bool = false
    
    private let fallbackImage = UIImage(named: "userPlaceholder")!
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var profileImage: UIImage? = nil
    var isEditEnabled: Bool {
        return state.authUser != nil && !name.isEmpty && !email.isEmpty && (password.isEmpty || password.count >= 6)
    }
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Spacer()
                Image(uiImage: profileImage ?? fallbackImage)
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                Spacer()
            }
            .onTapGesture {self.isImagePickerActive = true}
            
            TextField("Meno", text: $name)
            TextField("Email", text: $email)
            SecureField("Heslo (min. 6)", text: $password)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Uložiť") {
                    editUser()
                }
                .disabled(!isEditEnabled)
            }
        }
        .sheet(isPresented: $isImagePickerActive) {
            ImagePicker(image: $profileImage)
        }
        .alert(item: $state.usersEditError) {error in
            Alert(
                title: Text("Nepodarilo sa editovať profil"),
                message: Text(editErrorMessage(error: error)),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            guard let user = state.authUser else {return}
            name = user.name
            email = user.email
            profileImage = user.profileImage
        }
    }
    
    func editUser() {
        guard var user = state.authUser else {return}
        user.name = name
        user.email = email
        
        interactors.users.edit(user: user, password: password, profileImage: profileImage) {
            self.isActive = false
        }
    }
    
    func editErrorMessage(error: UsersApiError) -> String {
        switch error {
            case .validationError: return "Prosím, vyplňte správne všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct ProvileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isActive: .constant(true))
        }
    }
}
