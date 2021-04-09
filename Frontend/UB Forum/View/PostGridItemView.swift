import SwiftUI

struct PostGridItemView: View {
    let post: Post
    let category: Category
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack {
                    Image(uiImage: user.profileImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(user.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.title)
                    HStack(spacing: 5) {
                        Text(category.title)
                            .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                            .font(.caption)
                            .foregroundColor(.white)
                            .background(Color(category.color))
                            .cornerRadius(8)
                        Text(post.createdAgo)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }.padding(.bottom, 10)
            
            Text(post.content)
                .font(.body)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .topLeading)
        .padding()
        .background(Color(.white))
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(.gray),
            alignment: .bottom
        )
        .clipped()
        .shadow(color: Color.black.opacity(0.15), radius: 5)
    }
}

struct PostGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridItemView(post: Post.example, category: Category.example, user: User.example)
    }
}
