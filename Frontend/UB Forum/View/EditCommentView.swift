import SwiftUI
import Combine

struct EditCommentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var category: Category? = nil
    @State private var content: String = "motherfucking shit maan, yo get the unga bunga"
    private var isAddButtonEnabled: Bool {
        return !title.isEmpty && category != nil && !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Komentár")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }.navigationTitle("Upraviť komentár")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Uložiť") {
            print("Edit comment")
        }.disabled(!isAddButtonEnabled))
//        .onAppear{loadCategories()}
//        .alert(isPresented: $vm.showError) {
//            Alert(title: Text("Nepodarilo sa pridať príspevok"), message: Text(addErrorMessage()), dismissButton: .default(Text("OK")))
//        }
    }
    
//    func addErrorMessage() -> String {
//        switch vm.error {
//            case .validationError: return "Prosím, vyplňte všetky polia"
//            default: return "Skontrolujte prihlasovacie údaje a pripojenie na internet"
//        }
//    }
}

struct EditCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditCommentView()
        }
    }
}
