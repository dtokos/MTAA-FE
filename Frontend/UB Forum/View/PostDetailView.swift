import SwiftUI
import Combine

struct PostDetailView: View {
    enum ActiveSheet: Identifiable {
        case deletePost
        case deleteComment(comment: Comment)
        
        var id: Int {
            switch self {
                case .deletePost: return 0
                case .deleteComment: return 1
            }
        }
    }
    
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    
    @State var showEdit: Bool = false
    @State var showAddComment: Bool = false
    @State var showEditComment: Bool = false
    @State var activeSheet: ActiveSheet? = nil
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: EditPostView(isActive: $showEdit), isActive: $showEdit) {EmptyView()}
            NavigationLink(destination: AddCommentView(isActive: $showAddComment), isActive: $showAddComment) {EmptyView()}
            NavigationLink(destination: EditCommentView(isActive: $showEditComment), isActive: $showEditComment) {EmptyView()}
            
            VStack(alignment: .leading) {
                PostGridItemView(
                    post: state.postsSeleted!,
                    category: state.categories[state.postsSeleted!.categoryId]!,
                    user: state.users[state.postsSeleted!.userId]!
                )
                
                Text("Komentáre")
                    .font(.title3)
                    .foregroundColor(Color(white: 0.164))
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                
                LazyVGrid(columns: columns) {
                    ForEach(state.commentsByDate) {comment in
                        ZStack(alignment: .topTrailing) {
                            CommentGridItemView(comment: comment, user: state.users[comment.userId]!)
                            if comment.userId == state.authUser?.id {
                                HStack {
                                    Spacer()
                                    Button {
                                        self.state.commentsSelected = comment
                                        self.showEditComment = true
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                    }
                                    Button {
                                        self.activeSheet = .deleteComment(comment: comment)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                                .offset(x: -16, y: 22)
                            }
                        }
                    }
                    
                    Spacer(minLength: 24)
                    
                    Button(action: {self.showAddComment = true}) {
                        Text("Pridať komentár")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .animation(.default)
            }
            .padding()
            
            Text("")
                .hidden()
                .alert(item: $state.postsDeleteError) {_ in
                    Alert(
                        title: Text("Nepodarilo sa vymazať príspevok"),
                        message: Text("Skontrolujte svoje pripojenie na internet a skúste znova"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            
            Text("")
                .hidden()
                .alert(item: $state.commentsDeleteError) {_ in
                    Alert(
                        title: Text("Nepodarilo sa vymazať komentár"),
                        message: Text("Skontrolujte svoje pripojenie na internet a skúste znova"),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
        .navigationTitle("Detail príspevku")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if state.authUser?.id == state.postsSeleted?.userId {
                    Button(action: {self.showEdit = true}) {
                        Image(systemName: "square.and.pencil")
                    }
                    Button(action: {self.activeSheet = .deletePost}) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .actionSheet(item: $activeSheet) {sheet in
            if case .deleteComment(let comment) = sheet {
                return ActionSheet(title: Text("Naozaj chcete vymazať komentár"), message: nil, buttons: [
                    .destructive(Text("Vymazať")) {deleteComment(comment: comment)},
                    .cancel()
                ])
            } else {
                return ActionSheet(title: Text("Naozaj chcete vymazať príspevok"), message: nil, buttons: [
                    .destructive(Text("Vymazať")) {deletePost()},
                    .cancel()
                ])
            }
        }
        .onAppear {loadComments()}
    }
    
    func loadComments() {
        guard let post = state.postsSeleted else {return}
        interactors.comments.load(post: post)
    }
    
    func deleteComment(comment: Comment) {
        guard let post = state.postsSeleted else {return}
        interactors.comments.delete(post: post, comment: comment)
    }
    
    func deletePost() {
        interactors.posts.delete(post: state.postsSeleted!) {
            self.isActive = false
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostDetailView(isActive: .constant(true))
        }
    }
}
