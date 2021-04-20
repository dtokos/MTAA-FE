import SwiftUI
import Combine

struct EditCommentView: View {
    @EnvironmentObject private var vm: ShowPostVM
    let post: Post
    
    var body: some View {
        Form {
            Section(header: Text("Komentár")) {
                TextEditor(text: $vm.editingCommentContent)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }.navigationTitle("Upraviť komentár")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Uložiť") {
                    vm.editComment(post: post)
                }.disabled(!vm.isEditCommentButtonEnabled)
            }
        }
        .alert(isPresented: $vm.showEditCommentError) {
            Alert(title: Text("Nepodarilo sa upraviť komentár"), message: Text(editErrorMessage()), dismissButton: .default(Text("OK")))
        }
    }
    
    func editErrorMessage() -> String {
        switch vm.editCommentError {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct EditCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditCommentView(post: .example)
        }
    }
}
