import SwiftUI

struct PostGridItemView: View {
    let post: Post
    let category: Category
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Image(uiImage: user.profileImage)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.footnote)
                        .foregroundColor(Color(white: 0.164))
                    Text(post.createdAgo)
                        .font(.caption)
                        .foregroundColor(Color(white: 0.46))
                }
                
                Spacer()
                
                Text(category.title)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color(category.color))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color(white: 0.93))
                .frame(height: 2)
                .padding(.vertical, 16)
            
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.title2)
                    .foregroundColor(Color(white: 0.164))
                    .padding(.bottom, 4)
                    
                Text(post.content)
                    .font(.callout)
                    .foregroundColor(Color(white: 0.46))
                    .padding(.bottom, 4)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(white: 0.93), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct PostGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridItemView(post: Post.example, category: Category.example, user: User.example)
    }
}
