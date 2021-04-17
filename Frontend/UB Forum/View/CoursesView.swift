import SwiftUI

struct CoursesView: View {
    @ObservedObject var authVM: AuthVM
    
    @State private var showActions = false
    @State private var showProfile = false
    
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
                    ForEach(courses) { course in
                        NavigationLink(destination: CoursePostsView(course: course)) {
                            CourseGridItem(course: course)
                        }
                    }
                }.padding(.horizontal)
                
                NavigationLink(destination: ProfileView(user: authVM.user), isActive: $showProfile) {}
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationBarTitle("Predmety")
            /*.navigationBarItems(trailing: NavigationLink(destination: ProfileView()) {
                
            })*/
            .navigationBarItems(trailing: Button(action: {
                self.showActions = true
            }, label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 30))
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .actionSheet(isPresented: $showActions) { () -> ActionSheet in
            ActionSheet(title: Text("Vyberte akciu"), message: nil, buttons: [
                .default(Text("Profil")) {showProfile = true},
                .destructive(Text("Odhlásiť sa")) {logOut()},
                .cancel()
            ])
        }
    }
    
    func logOut() {
        authVM.logout()
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(authVM: AuthVM())
    }
}
