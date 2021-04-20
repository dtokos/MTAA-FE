import SwiftUI

struct CommentGridItemView: View {
    let comment: Comment
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Text(user.name)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Text(comment.createdAgo)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            Text(comment.content)
                .font(.body)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .topLeading)
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

struct CommentGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        CommentGridItemView(comment: .example, user: .example)
    }
}
