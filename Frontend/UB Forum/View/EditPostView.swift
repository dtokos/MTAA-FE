import SwiftUI
import Combine

struct EditPostView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    
    @State private var title: String = ""
    @State private var categoryId: Int? = nil
    @State private var content: String = ""
    var isEditEnabled: Bool {
        return !title.isEmpty && categoryId != nil && !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Názov")) {
                TextField("Lorem ipsum", text: $title)
            }
            
            Section(header: Text("Kategória")) {
                Picker("Kategória", selection: $categoryId) {
                    ForEach(state.categoriesByName) {category in
                        Text(category.title)
                            .tag(category.id as Int?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Obsah")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }
        .navigationTitle("Upraviť príspevok")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Uložiť") {
                    editPost()
                }
                .disabled(!isEditEnabled)
            }
        }
        .alert(item: $state.postsEditError) {error in
            Alert(
                title: Text("Nepodarilo sa upraviť príspevok"),
                message: Text(editErrorMessage(error: error)),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            loadCategories()
            guard let post = state.postsSeleted else {return}
            title = post.title
            categoryId = post.categoryId
            content = post.content
        }
    }
    
    func loadCategories() {
        interactors.categories.load()
    }
    
    func editPost() {
        guard let categoryId = categoryId,
            var post = state.postsSeleted else {return}
        post.title = title
        post.categoryId = categoryId
        post.content = content
        
        interactors.posts.edit(post: post) {
            self.isActive = false
        }
    }
    
    func editErrorMessage(error: PostsApiError) -> String {
        switch error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPostView(isActive: .constant(true))
        }
    }
}
