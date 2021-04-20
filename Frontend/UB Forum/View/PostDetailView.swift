import SwiftUI
import Combine

struct PostDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthVM
    @ObservedObject var vm: ShowPostVM = ShowPostVM()
    @State var showEdit: Bool = false
    @State var showDeletePost: Bool = false
    @State var showDeleteComment: Bool = false
    
    @State var post: Post
    @State var category: Category
    @State var deletingComment: Comment? = nil
    var user: User
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NavigationLink(destination: EditPostView(post: $post, category: $category, isActive: $showEdit), isActive: $showEdit) {}
                NavigationLink(destination: EditCommentView(post: post).environmentObject(vm), isActive: $vm.showEditComment) {}
                
                PostGridItemView(post: post, category: category, user: user)
                Spacer(minLength: 20)
                Text("Komentáre")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: columns, content: {
                    ForEach(vm.comments) {comment in
                        ZStack(alignment: .topTrailing) {
                            CommentGridItemView(comment: comment, user: vm.users[comment.userId]!)
                            if comment.userId == authVM.user?.id {
                                HStack {
                                    Spacer()
                                    Button {
                                        self.vm.editingCommentContent = comment.content
                                        self.vm.editingComment = comment
                                        self.vm.showEditComment = true
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                    }
                                    Button {
                                        self.deletingComment = comment
                                        self.showDeleteComment = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                                .offset(x: -5, y: 5)
                            }
                        }
                    }
                })
                .padding()
                .animation(.default)
                
                NavigationLink(
                    destination: AddCommentView(post: post),
                    label: {
                        Text("Pridať komentár")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
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
                        self.showDeletePost = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .actionSheet(isPresented: $showDeletePost) { () -> ActionSheet in
            ActionSheet(title: Text("Naozaj chcete vymazať príspevok"), message: nil, buttons: [
                .destructive(Text("Vymazať")) {deletePost()},
                .cancel()
            ])
        }
        .actionSheet(isPresented: $showDeleteComment) { () -> ActionSheet in
            ActionSheet(title: Text("Naozaj chcete vymazať komentár"), message: nil, buttons: [
                .destructive(Text("Vymazať")) {deleteComment()},
                .cancel()
            ])
        }
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Nepodarilo sa pridať príspevok"), message: Text("Skontrolujte svoje pripojenie na internet a skúste znova"), dismissButton: .default(Text("OK")))
        }
        .onAppear {loadComments()}
    }
    
    func loadComments() {
        vm.loadComments(post: post)
    }
    
    func deleteComment() {
        guard let comment = deletingComment else {return}
        vm.deleteComment(post: post, comment: comment)
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
    //private let commentsApi: CommentsApi = MemoryCommentsApi()
    private let commentsApi: CommentsApi = WebCommentsApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var comments = [Comment]()
    @Published var users = [Int:User]()
    @Published var error: PostsApiError? = nil
    @Published var showError = false
    
    @Published var commentError: CommentsApiError? = nil
    @Published var showCommentError = false
    
    @Published var editingComment: Comment? = nil
    @Published var editingCommentContent: String = ""
    @Published var editCommentError: CommentsApiError? = nil
    @Published var showEditCommentError: Bool = false
    @Published var showEditComment: Bool = false
    var isEditCommentButtonEnabled: Bool {
        return editingComment != nil && !editingCommentContent.isEmpty
    }
    
    public func loadComments(post: Post) {
        commentsApi.load(post: post)
            .sink(receiveCompletion: {_ in}) {res in
                self.comments = res.comments.values.sorted {$0.createdAt < $1.createdAt}
                self.users = res.users
            }
            .store(in: &cancelBag)
    }
    
    public func editComment(post: Post) {
        guard var comment = editingComment else {return}
        comment.content = editingCommentContent
        commentsApi.edit(post: post, comment: comment)
            .sink(receiveCompletion: {status in
                switch status {
                    case .failure(let error):
                        self.commentError = error
                        self.showCommentError = true
                    default: break
                }
            }, receiveValue: {_ in self.showEditComment = false})
            .store(in: &cancelBag)
    }
    
    public func deleteComment(post: Post, comment: Comment) {
        commentsApi.delete(post: post, comment: comment)
            .sink(receiveCompletion: {status in
                switch status {
                    case .failure(let error):
                        self.commentError = error
                        self.showCommentError = true
                    default: break
                }
            }, receiveValue: {res in
                let keys = res.comments.keys
                self.comments = self.comments.filter{!keys.contains($0.id)}
            })
            .store(in: &cancelBag)
    }
    
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
