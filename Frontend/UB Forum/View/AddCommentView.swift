import SwiftUI
import Combine

struct AddCommentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var vm = AddCommentVM()
    
    let post: Post
    
    @State private var content: String = ""
    private var isAddButtonEnabled: Bool {
        return !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Komentár")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }.navigationTitle("Pridať komentár")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Pridať") {
                    addComment(post: post, content: content)
                }.disabled(!isAddButtonEnabled)
            }
        }
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Nepodarilo sa pridať komentár"), message: Text(addErrorMessage()), dismissButton: .default(Text("OK")))
        }
    }
    
    func addComment(post: Post, content: String) {
        vm.addComment(post: post, content: content) {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func addErrorMessage() -> String {
        switch vm.error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct AddCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddCommentView(post: .example)
        }
    }
}

class AddCommentVM: ObservableObject {
    //private let api: CommentsApi = MemoryCommentsApi()
    private let api: CommentsApi = WebCommentsApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var error: CommentsApiError? = nil
    @Published var showError = false
    
    public func addComment(post: Post, content: String, callback: @escaping () -> Void) {
        error = nil
        
        api.add(post: post, content: content)
            .sink(receiveCompletion: {status in
                switch status {
                    case .failure(let error):
                        self.error = error
                        self.showError = true
                    default: break
                }
            }, receiveValue: {_ in callback()})
            .store(in: &cancelBag)
    }
}

