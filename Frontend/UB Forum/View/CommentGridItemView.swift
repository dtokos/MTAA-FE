import SwiftUI

struct CommentGridItemView: View {
    let comment: Comment
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Image(uiImage: user.profileImage)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.caption)
                        .foregroundColor(Color(white: 0.164))
                    Text(comment.createdAgo)
                        .font(.caption2)
                        .foregroundColor(Color(white: 0.46))
                }
            }
            .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color(white: 0.93))
                .frame(height: 2)
                .padding(.vertical, 16)
            
            VStack(alignment: .leading) {
                Text(comment.content)
                    .font(.footnote)
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

struct CommentGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentGridItemView(comment: .example, user: .example)
    }
}
