import SwiftUI

struct CoursePosts: View {
    let course: Course
    
    var body: some View {
        Text(course.title)
            .navigationTitle(course.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoursePosts_Previews: PreviewProvider {
    static var previews: some View {
        CoursePosts(course: .example)
    }
}
