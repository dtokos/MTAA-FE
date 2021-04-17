import SwiftUI

struct CoursePostsView: View {
    let course: Course
    let user = User(id: 1, name: "Eugen Ártvy", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date())
    let posts = [
        Post(id: 1, userId: 1, courseId: 1, categoryId: 0, title: "Lorem ipsum", content: "Lorem ipsum dolor sit amet...", createdAt: Date(), updatedAt: Date()),
        Post(id: 2, userId: 1, courseId: 1, categoryId: 1, title: "In semper", content: "In semper ultricies risus...", createdAt: Date(), updatedAt: Date()),
        Post(id: 3, userId: 1, courseId: 1, categoryId: 2, title: "Curabitur suscipit", content: "Curabitur suscipit dui id mi...", createdAt: Date(), updatedAt: Date()),
        Post(id: 4, userId: 1, courseId: 1, categoryId: 3, title: "Proin euismod", content: "Proin euismod ex quis egestas...", createdAt: Date(), updatedAt: Date()),
        Post(id: 5, userId: 1, courseId: 1, categoryId: 4, title: "Morbi porta", content: "Morbi porta dapibus mauris...", createdAt: Date(), updatedAt: Date()),
        Post(id: 6, userId: 1, courseId: 1, categoryId: 4, title: "Morbi porta", content: "Morbi porta dapibus mauris...", createdAt: Date(), updatedAt: Date()),
        Post(id: 7, userId: 1, courseId: 1, categoryId: 4, title: "Morbi porta", content: "Morbi porta dapibus mauris...", createdAt: Date(), updatedAt: Date()),
    ]
    let categories = [
        Category(id: 0, title: "Prednášky", color: .systemPink, createdAt: Date(), updatedAt: Date()),
        Category(id: 1, title: "Cvičenia", color: .systemGreen, createdAt: Date(), updatedAt: Date()),
        Category(id: 2, title: "Zadania", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        Category(id: 3, title: "Skúšky", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        Category(id: 4, title: "Iné", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
    ]
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(posts) { post in
                    NavigationLink(
                        destination: PostDetailView(post: post, user: user),
                        label: {
                            PostGridItemView(post: post, category: categories[post.categoryId], user: user)
                        }).buttonStyle(PlainButtonStyle())
                }
            }).padding()
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination: AddPostView()) {
            Image(systemName: "plus")
        })
    }
}

struct CoursePosts_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoursePostsView(course: .example)
        }
    }
}
