import Foundation

class StorageService {
    private let storageKey = "cuentacuentos-stories"
    
    func loadStories() -> [Story] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let stories = try? JSONDecoder().decode([Story].self, from: data) else {
            return []
        }
        return stories
    }
    
    func saveStories(_ stories: [Story]) {
        guard let data = try? JSONEncoder().encode(stories) else {
            return
        }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

