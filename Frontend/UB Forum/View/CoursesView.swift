import SwiftUI

struct CoursesView: View {
    let courses = [
        Course(id: 1, title: "OOP", color: .systemGreen, createdAt: Date(), updatedAt: Date()),
        Course(id: 2, title: "AJ", color: .systemPink, createdAt: Date(), updatedAt: Date()),
        Course(id: 3, title: "ADM", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        Course(id: 4, title: "MA", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        Course(id: 5, title: "MIP", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        Course(id: 6, title: "PPI", color: .systemPink, createdAt: Date(), updatedAt: Date()),
        Course(id: 7, title: "PRPR", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        Course(id: 8, title: "ZOOP", color: .systemOrange, createdAt: Date(), updatedAt: Date()),
        Course(id: 9, title: "PAM", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        Course(id: 10, title: "FYZ", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        Course(id: 11, title: "TZIV", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        Course(id: 12, title: "ELN", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        Course(id: 13, title: "ML1", color: .systemIndigo, createdAt: Date(), updatedAt: Date()),
        Course(id: 14, title: "SPRO", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
        Course(id: 15, title: "SPAASM", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        Course(id: 16, title: "MSOFT", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        Course(id: 17, title: "PARALPR", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
        Course(id: 18, title: "APC", color: .systemOrange, createdAt: Date(), updatedAt: Date()),
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(courses, id: \.id) { course in
                        NavigationLink(destination: CoursePosts(course: course)) {
                            CourseGridItem(course: course)
                        }
                    }
                }.padding(.horizontal)
            }.navigationTitle("Predmety")
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
