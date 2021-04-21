import SwiftUI
import Combine

struct AddCommentView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    
    @State private var content: String = ""
    private var isAddEnabled: Bool {
        return !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Komentár")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }
        .navigationTitle("Pridať komentár")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Pridať") {
                    addComment()
                }
                .disabled(!isAddEnabled)
            }
        }
        .alert(item: $state.commentsAddError) {error in
            Alert(
                title: Text("Nepodarilo sa pridať komentár"),
                message: Text(addErrorMessage(error: error)),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func addComment() {
        guard let post = state.postsSeleted else {return}
        
        interactors.comments.add(post: post, content: content) {
            self.isActive = false
        }
    }
    
    func addErrorMessage(error: CommentsApiError) -> String {
        switch error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct AddCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddCommentView(isActive: .constant(true))
        }
    }
}
