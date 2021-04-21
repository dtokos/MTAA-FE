import SwiftUI
import Combine

struct CoursesView: View {
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var interactors: Interactors
    
    @State private var showCourse = false
    @State private var showProfile = false
    @State private var showActions = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: CoursePostsView(isActive: $showCourse), isActive: $showCourse) {}
                NavigationLink(destination: ProfileView(isActive: $showProfile), isActive: $showProfile) {}
                
                LazyVGrid(columns: columns) {
                    ForEach(state.coursesByName) {course in
                        CourseGridItem(course: course)
                            .onTapGesture {
                                self.state.coursesSelected = course
                                self.showCourse = true
                            }
                    }
                }
                .padding(.horizontal)
                .animation(.default)
            }
            .navigationTitle("Predmety")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showActions = true
                    } label: {
                        Image(systemName: "person.circle")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .actionSheet(isPresented: $showActions) {
            ActionSheet(title: Text("Vyberte akciu"), message: nil, buttons: [
                .default(Text("Profil")) {showProfile = true},
                .destructive(Text("Odhlásiť sa")) {logOut()},
                .cancel()
            ])
        }
        .onAppear {
            loadCourses()
        }
    }
    
    func logOut() {
        interactors.auth.logOut()
    }
    
    func loadCourses() {
        interactors.courses.load()
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
