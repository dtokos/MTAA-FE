import SwiftUI
import Combine

struct AddCommentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var category: Category? = nil
    @State private var content: String = ""
    private var isAddButtonEnabled: Bool {
        return !title.isEmpty && category != nil && !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Komentár")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }.navigationTitle("Pridať komentár")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Pridať") {
//            addPost(course: course, title: title, category: category!, content: content)
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

struct AddCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddCommentView()
        }
    }
}
