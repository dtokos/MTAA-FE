import SwiftUI
import Combine

struct EditPostView: View {
    @ObservedObject private var vm: EditPostVM
    @Binding var post: Post
    @Binding var category: Category
    @Binding var isActive: Bool
    
    init(post: Binding<Post>, category: Binding<Category>, isActive: Binding<Bool>) {
        vm = EditPostVM(post: post.wrappedValue, category: category.wrappedValue)
        self._post = post
        self._category = category
        self._isActive = isActive
    }
    
    var body: some View {
        Form {
            Section(header: Text("Názov")) {
                TextField("Lorem ipsum", text: $vm.title)
            }
            
            Section(header: Text("Kategória")) {
                Picker("Kategória", selection: $vm.categoryId) {
                    ForEach(vm.categories, id: \.self) { category in
                        Text(category.title)
                            .tag(category.id)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Obsah")) {
                TextEditor(text: $vm.content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }
        .navigationTitle("Upraviť príspevok")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Uložiť") {
                    editPost()
                }.disabled(!vm.isEditButtonEnabled)
            }
        }
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Nepodarilo sa upraviť príspevok"), message: Text(editErrorMessage()), dismissButton: .default(Text("OK")))
        }
        .onAppear{loadCategories()}
    }
    
    func loadCategories() {
        vm.loadCategories()
    }
    
    func editPost() {
        vm.editPost {res in
            if let post = res.posts[post.id] {self.post = post}
            if let category = res.categories[post.categoryId] {self.category = category}
            self.isActive = false
        }
    }
    
    func editErrorMessage() -> String {
        switch vm.error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte vyplnené údaje a pripojenie na internet"
        }
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPostView(post: .constant(.example), category: .constant(.example), isActive: .constant(true))
        }
    }
}

class EditPostVM: ObservableObject {
    //private let postsApi: PostsApi = MemoryPostsApi()
    private let postsApi: PostsApi = WebPostsApi()
    //private let categoriesApi: CategoriesApi = MemoryCategoriesApi()
    private let categoriesApi: CategoriesApi = WebCategoriesApi()
    private var cancelBag = Set<AnyCancellable>()
    
    private var post: Post
    
    @Published var title: String
    @Published var categoryId: Int
    @Published var content: String
    
    @Published var categories: [Category]
    
    @Published var error: PostsApiError? = nil
    @Published var showError = false
    var isEditButtonEnabled: Bool {
        return !title.isEmpty && !content.isEmpty
    }
    
    init(post: Post, category: Category) {
        self.post = post
        
        title = post.title
        categoryId = post.categoryId
        content = post.content
        categories = [category]
    }
    
    public func loadCategories() {
        categoriesApi.load()
            .sink(receiveCompletion: {_ in}, receiveValue: {res in
                self.categories = res.categories.values.sorted {$0.title < $1.title}
            })
            .store(in: &cancelBag)
    }
    
    public func editPost(callback: @escaping (PostsApiResponse) -> Void) {
        error = nil
        post.title = title
        post.categoryId = categoryId
        post.content = content
        
        postsApi.edit(post: post)
            .sink(receiveCompletion: {status in
                switch status {
                    case .failure(let error):
                        self.error = error
                        self.showError = true
                    default: break
                }
            }, receiveValue: {res in callback(res)})
            .store(in: &cancelBag)
    }
}
