import SwiftUI

struct PostDetailView: View {
    var post: Post
    var user: User
    
    let category = Category(id: 0, title: "Prednášky", color: .systemPink, createdAt: Date(), updatedAt: Date())
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                PostGridItemView(post: post, category: category, user: user)
                Spacer(minLength: 20)
                Text("Komentáre")
                    .font(.headline)
            }.padding()
        }
        .navigationTitle("Detail príspevku")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination: EditPostView()) {
            Text("Upraviť")
        })
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostDetailView(post: .example, user: .example)
        }
    }
}
