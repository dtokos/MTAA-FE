import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @State private var email = ""
    @State private var password = ""
    
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
        .alert(item: $state.authLoginError) {error in
            Alert(
                title: Text("Nepodarilo sa prihlásiť"),
                message: Text(loginErrorMessage(error: error)),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func logIn() {
        interactors.auth.logIn(email: email, password: password)
    }
    
    func loginErrorMessage(error: AuthApiError) -> String {
        switch error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            case .wrongCredentials: return "Zlé prihlasovacie údaje"
            default: return "Skontrolujte prihlasovacie údaje a pripojenie na internet"
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
