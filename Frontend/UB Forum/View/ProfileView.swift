import SwiftUI
import Combine

struct ProfileView: View {
    @EnvironmentObject private var authVM: AuthVM
    @ObservedObject private var vm = EditUserVM()
    
    @Binding var isActive: Bool
    @State private var isImagePickerActive: Bool = false
    
    private let fallbackImage = UIImage(named: "userPlaceholder")!
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Spacer()
                Image(uiImage: vm.profileImage ?? fallbackImage)
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                Spacer()
            }
            .onTapGesture {self.isImagePickerActive = true}
            TextField("Meno", text: $vm.name)
            TextField("Email", text: $vm.email)
            SecureField("Heslo (min. 6)", text: $vm.password)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Uložiť") {
                    editUser()
                }.disabled(!vm.isEditButtonEnabled)
            }
        }
        .sheet(isPresented: $isImagePickerActive) {
            ImagePicker(image: $vm.profileImage)
        }
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Nepodarilo sa editovať profil"), message: Text(editErrorMessage()), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if let user = authVM.user {
                vm.setUser(user: user)
            }
        }
    }
    
    func editUser() {
        vm.editUser {res in
            if self.authVM.user != nil && res.users[self.authVM.user!.id] != nil {
                self.authVM.user = res.users[self.authVM.user!.id]
            }
            self.isActive = false
        }
    }
    
    func editErrorMessage() -> String {
        switch vm.error {
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

class EditUserVM: ObservableObject {
    //private let api: UsersApi = MemoryUsersApi()
    private let api: UsersApi = WebUsersApi()
    private var cancelBag = Set<AnyCancellable>()
    
    private var user: User? = nil
    
    @Published var profileImage: UIImage? = nil
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var error: UsersApiError? = nil
    @Published var showError = false
    var isEditButtonEnabled: Bool {
        return user != nil && !name.isEmpty && !email.isEmpty && (password.isEmpty || password.count >= 6)
    }
    
    public func setUser(user: User) {
        self.user = user
        self.profileImage = user.profileImage
        self.name = user.name
        self.email = user.email
        self.password = ""
    }
    
    public func editUser(callback: @escaping (UsersApiResponse) -> Void) {
        error = nil
        
        user?.name = name
        user?.email = email
        let pass = password.isEmpty ? nil : password
        
        api.edit(user: user!, password: pass, profileImage: profileImage)
            .sink(receiveCompletion: {status in
                switch status {
                    case .failure(let error):
                        self.error = error
                        self.showError = true
                    default: break
                }
            }, receiveValue: {res in callback(res)})
            .store(in: &cancelBag)
    }
}

