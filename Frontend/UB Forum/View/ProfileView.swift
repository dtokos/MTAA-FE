import SwiftUI

struct ProfileView: View {
    @State private var profileImage: UIImage
    @State private var name: String
    @State private var email: String
    @State private var password: String
    
    init(user: User?) {
        self._profileImage = State(initialValue: user?.profileImage ?? UIImage(named: "userPlaceholder")!)
        self._name = State(initialValue: user?.name ?? "")
        self._email = State(initialValue: user?.email ?? "")
        self._password = State(initialValue: "")
    }
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Spacer()
                Image(uiImage: profileImage)
                    .clipShape(Circle())
                Spacer()
            }
            TextField("Meno", text: $name)
            TextField("Email", text: $email)
            SecureField("Heslo", text: $password)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Uložiť") {
            print("Update profile")
        })
    }
}

struct ProvileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(user: nil)
        }
    }
}
