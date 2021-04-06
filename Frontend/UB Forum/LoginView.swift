import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Prihlásenie")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Heslo", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Prihlásiť") {
                
            }.frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
        }.padding(.horizontal)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
