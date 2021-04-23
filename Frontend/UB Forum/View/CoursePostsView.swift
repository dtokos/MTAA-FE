import SwiftUI
import Combine

struct CoursePostsView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @Binding var isActive: Bool
    @State private var showAdd: Bool = false
    @State private var showDetail: Bool = false
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: AddPostView(isActive: $showAdd), isActive: $showAdd) {EmptyView()}
            NavigationLink(destination: PostDetailView(isActive: $showDetail), isActive: $showDetail) {EmptyView()}
            
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(state.postsByDate) {post in
                    PostGridItemView(
                        post: post,
                        category: state.categories[post.categoryId]!,
                        user: state.users[post.userId]!
                    )
                    .onTapGesture {
                        self.state.postsSeleted = post
                        self.showDetail = true
                    }
                }
            }
            .padding()
            .animation(.default)
        }
        .navigationTitle(state.coursesSelected?.title ?? "Predmet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {self.showAdd = true}) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {loadPosts()}
    }
    
    func loadPosts() {
        guard let course = state.coursesSelected else {return}
        interactors.posts.load(course: course)
    }
}

struct CoursePosts_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoursePostsView(isActive: .constant(true))
        }
    }
}
