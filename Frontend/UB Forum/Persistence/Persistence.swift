protocol Persistence {
    func load(state: AppState);
    func save(state: AppState);
}
