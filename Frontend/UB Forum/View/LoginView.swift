import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var authVM: AuthVM
    
    @State private var email = "eugen.artvy@example.com" // TODO: Remove after testing
    @State private var password = "12345678" // TODO: Remove after testing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Prihlásenie")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            SecureField("Heslo", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: logIn) {
                Text("Prihlásiť")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .alert(isPresented: $authVM.showError) {
            Alert(title: Text("Nepodarilo sa prihlásiť"), message: Text(loginErrorMessage()), dismissButton: .default(Text("OK")))
        }
    }
    
    func logIn() {
        authVM.logIn(email: email, password: password)
    }
    
    func loginErrorMessage() -> String {
        switch authVM.error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            case .wrongCredentials: return "Zlé prihlasovacie údaje"
            default: return "Skontrolujte prihlasovacie údaje a pripojenie na internet"
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authVM: AuthVM())
    }
}
