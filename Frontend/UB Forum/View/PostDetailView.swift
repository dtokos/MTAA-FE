import SwiftUI
import Combine

struct PostDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthVM
    @ObservedObject var vm: ShowPostVM = ShowPostVM()
    @State var showEdit: Bool = false
    @State var showDelete: Bool = false
    
    @State var post: Post
    @State var category: Category
    var user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NavigationLink(destination: EditPostView(post: $post, category: $category, isActive: $showEdit), isActive: $showEdit) {}
                
                PostGridItemView(post: post, category: category, user: user)
                Spacer(minLength: 20)
                Text("Komentáre")
                    .font(.headline)
            }.padding()
        }
        .navigationTitle("Detail príspevku")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if authVM.user?.id == user.id {
                    Button {
                        self.showEdit = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    Button {
                        self.showDelete = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .actionSheet(isPresented: $showDelete) { () -> ActionSheet in
            ActionSheet(title: Text("Naozaj chcete vymazať príspevok"), message: nil, buttons: [
                .destructive(Text("Vymyzať")) {deletePost()},
                .cancel()
            ])
        }
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Nepodarilo sa pridať príspevok"), message: Text("Skontrolujte svoje pripojenie na internet a skúste znova"), dismissButton: .default(Text("OK")))
        }
    }
    
    func deletePost() {
        vm.deletePost(post: post) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostDetailView(post: .example, category: .example, user: .example)
        }
    }
}

class ShowPostVM: ObservableObject {
    //private let postsApi: PostsApi = MemoryPostsApi()
    private let postsApi: PostsApi = WebPostsApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var error: PostsApiError? = nil
    @Published var showError = false
    
    public func deletePost(post: Post, callback: @escaping () -> Void) {
        error = nil
        
        postsApi.delete(post: post)
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
