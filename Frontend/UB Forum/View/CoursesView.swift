import SwiftUI
import Combine

struct CoursesView: View {
    @EnvironmentObject var authVM: AuthVM
    @ObservedObject private var vm = CoursesVM()
    
    @State private var showActions = false
    @State private var showProfile = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.courses) { course in
                        NavigationLink(destination: CoursePostsView(course: course)) {
                            CourseGridItem(course: course)
                        }
                    }
                }.padding(.horizontal)
                .animation(.default)
                
                NavigationLink(destination: ProfileView(user: authVM.user), isActive: $showProfile) {}
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
        .actionSheet(isPresented: $showActions) { () -> ActionSheet in
            ActionSheet(title: Text("Vyberte akciu"), message: nil, buttons: [
                .default(Text("Profil")) {showProfile = true},
                .destructive(Text("Odhlásiť sa")) {logOut()},
                .cancel()
            ])
        }
        .onAppear {loadCourses()}
    }
    
    func logOut() {
        authVM.logout()
    }
    
    func loadCourses() {
        vm.load()
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView().environmentObject(AuthVM())
    }
}

class CoursesVM: ObservableObject {
    //private let api: CoursesApi = MemoryCoursesApi()
    private let api: CoursesApi = WebCoursesApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var courses = [Course]()
    
    public func load() {
        api.load()
            .sink{_ in} receiveValue: { res in
                self.courses = res.courses.values.sorted {$0.title < $1.title}
            }.store(in: &cancelBag)
    }
}

