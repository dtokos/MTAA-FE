import SwiftUI
import Combine

struct EditCommentView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    
    @State private var content: String = ""
    var isEditEnabled: Bool {
        return !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Komentár")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }
        .navigationTitle("Upraviť komentár")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Uložiť") {
                    editComment()
                }
                .disabled(!isEditEnabled)
            }
        }
        .alert(item: $state.commentsEditError) {error in
            Alert(
                title: Text("Nepodarilo sa upraviť komentár"),
                message: Text(editErrorMessage(error: error)),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            guard let comment = state.commentsSelected else {return}
            content = comment.content
        }
    }
    
    func editComment() {
        guard let post = state.postsSeleted,
              var comment = state.commentsSelected else {return}
        comment.content = content
        
        interactors.comments.edit(post: post, comment: comment) {
            self.isActive = false
        }
    }
    
    func editErrorMessage(error: CommentsApiError) -> String {
        switch error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct EditCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditCommentView(isActive: .constant(true))
        }
    }
}
