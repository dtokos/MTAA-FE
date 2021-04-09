import SwiftUI

struct EditPostView: View {
    @State private var title: String = "Lorem ipsum"
    @State private var category: Category? = Category(id: 0, title: "Prednášky", color: .systemPink, createdAt: Date(), updatedAt: Date())
    @State private var content: String = "Lorem ipsum sit dolor amet..."
    
    let categories = [
        Category(id: 0, title: "Prednášky", color: .systemPink, createdAt: Date(), updatedAt: Date()),
        Category(id: 1, title: "Cvičenia", color: .systemGreen, createdAt: Date(), updatedAt: Date()),
        Category(id: 2, title: "Zadania", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        Category(id: 3, title: "Skúšky", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        Category(id: 4, title: "Iné", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Názov")) {
                TextField("Lorem ipsum", text: $title)
            }
            
            Section(header: Text("Kategória")) {
                Picker("Kategória", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category.title)
                            .tag(category as UB_Forum.Category?)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Obsah")) {
                TextEditor(text: $content)
                    .frame(minHeight: 300, alignment: .leading)
            }
        }.navigationTitle("Upraviť príspevok")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Uložiť") {
            print("Edit post")
        })
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPostView()
        }
    }
}
