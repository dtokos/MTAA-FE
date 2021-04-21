import SwiftUI
import Combine

struct AddPostView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    
    @State private var title: String = ""
    @State private var categoryId: Int? = nil
    @State private var content: String = ""
    private var isAddEnabled: Bool {
        return !title.isEmpty && categoryId != nil && !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Názov")) {
                TextField("Lorem ipsum", text: $title)
            }
            
            Section(header: Text("Kategória")) {
                Picker("Kategória", selection: $categoryId) {
                    ForEach(state.categoriesByName) { category in
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
        .navigationTitle("Pridať príspevok")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Pridať") {
                    addPost()
                }
                .disabled(!isAddEnabled)
            }
        }
        .alert(item: $state.postsAddError) {error in
            Alert(
                title: Text("Nepodarilo sa pridať príspevok"),
                message: Text(addErrorMessage(error: error)),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear{loadCategories()}
    }
    
    func loadCategories() {
        interactors.categories.load()
    }
    
    func addPost() {
        guard let course = state.coursesSelected,
              let categoryId = categoryId,
              let category = state.categories[categoryId] else {return}
        
        interactors.posts.add(course: course, title: title, category: category, content: content) {
            self.isActive = false
        }
    }
    
    func addErrorMessage(error: PostsApiError) -> String {
        switch error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddPostView(isActive: .constant(true))
        }
    }
}
