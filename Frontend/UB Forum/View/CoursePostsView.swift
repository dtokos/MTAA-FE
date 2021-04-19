import SwiftUI
import Combine

struct CoursePostsView: View {
    let course: Course
    @ObservedObject private var vm = PostsVM()
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(vm.posts) { post in
                    NavigationLink(
                        destination: PostDetailView(post: post, category: vm.categories[post.categoryId]!, user: vm.users[post.userId]!),
                        label: {
                            PostGridItemView(post: post, category: vm.categories[post.categoryId]!, user: vm.users[post.userId]!)
                        }).buttonStyle(PlainButtonStyle())
                }
            }).padding()
            .animation(.default)
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: AddPostView(course: course)) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {loadPosts()}
    }
    
    func loadPosts() {
        vm.load(course: course)
    }
}

struct CoursePosts_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoursePostsView(course: .example)
        }
    }
}

class PostsVM: ObservableObject {
    //private let api: PostsApi = MemoryPostsApi()
    private let api: PostsApi = WebPostsApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var posts = [Post]()
    @Published var users = [Int:User]()
    @Published var categories = [Int:Category]()
    
    public func load(course: Course) {
        api.load(course: course)
            .sink {_ in} receiveValue: { res in
                self.users = res.users
                self.categories = res.categories
                self.posts = res.posts.values.sorted {$0.createdAt > $1.createdAt}
            }.store(in: &cancelBag)
    }
}
