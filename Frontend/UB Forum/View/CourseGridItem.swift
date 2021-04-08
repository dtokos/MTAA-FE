import SwiftUI

struct CourseGridItem: View {
    let course: Course
    
    var body: some View {
        Text(course.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .background(Color(course.color))
            .cornerRadius(8)
    }
}

struct CourseGridItem_Previews: PreviewProvider {
    static var previews: some View {
        CourseGridItem(course: .example)
    }
}
