import SwiftUI
import Combine

struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var vm = AddPostVM()
    let course: Course
    
    @State private var title: String = ""
    @State private var category: Category? = nil
    @State private var content: String = ""
    private var isAddButtonEnabled: Bool {
        return !title.isEmpty && category != nil && !content.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Názov")) {
                TextField("Lorem ipsum", text: $title)
            }
            
            Section(header: Text("Kategória")) {
                Picker("Kategória", selection: $category) {
                    ForEach(vm.categories, id: \.self) { category in
                        Text(category.title)
                            .tag(category as UB_Forum.Category?)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Obsah")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }.navigationTitle("Pridať príspevok")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Pridať") {
            addPost(course: course, title: title, category: category!, content: content)
        }.disabled(!isAddButtonEnabled))
        .onAppear{loadCategories()}
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Nepodarilo sa pridať príspevok"), message: Text(addErrorMessage()), dismissButton: .default(Text("OK")))
        }
    }
    
    func loadCategories() {
        vm.loadCategories()
    }
    
    func addPost(course: Course, title: String, category: Category, content: String) {
        vm.addPost(course: course, title: title, category: category, content: content, callback: {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    func addErrorMessage() -> String {
        switch vm.error {
            case .validationError: return "Prosím, vyplňte všetky polia"
            default: return "Skontrolujte prihlasovacie údaje a pripojenie na internet"
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddPostView(course: Course.example)
        }
    }
}

class AddPostVM: ObservableObject {
    //private let postsApi: PostsApi = MemoryPostsApi()
    private let postsApi: PostsApi = WebPostsApi()
    //private let categoriesApi: CategoriesApi = MemoryCategoriesApi()
    private let categoriesApi: CategoriesApi = WebCategoriesApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var categories = [Category]()
    @Published var error: PostsApiError? = nil
    @Published var showError = false
    
    public func loadCategories() {
        categoriesApi.load()
            .sink(receiveCompletion: {_ in}, receiveValue: {res in
                self.categories = res.categories.values.sorted {$0.title < $1.title}
            })
            .store(in: &cancelBag)
    }
    
    public func addPost(course: Course, title: String, category: Category, content: String, callback: @escaping () -> Void) {
        error = nil
        
        postsApi.add(course: course, title: title, category: category, content: content)
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
