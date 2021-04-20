import SwiftUI

struct CommentGridItemView: View {
//    let user: User
    let content = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Text("username")
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Text("pred 10 min")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            Text(content)
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
        CommentGridItemView()
    }
}
