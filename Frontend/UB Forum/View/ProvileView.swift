import SwiftUI

struct ProvileView: View {
    let profileImage = UIImage(named: "userPlaceholder")!
    @State private var name = "Eugen Ártvy"
    @State private var email = "eugen.artvy@example.com"
    @State private var password = ""
    
    var body: some View {
        Form {
            HStack(alignment: .center) {
                Spacer()
                Image(uiImage: profileImage)
                Spacer()
            }
            TextField("Meno", text: $name)
            TextField("Email", text: $email)
            SecureField("Heslo", text: $password)
        }.navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Uložiť") {
            print("Update profile")
        })
    }
}

struct ProvileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProvileView()
        }
    }
}
