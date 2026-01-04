import Foundation

class StorageService {
    private let storageKey = "cuentacuentos-stories"
    private let profileKey = "cuentacuentos-profile"
    private let lastPlayedStoryKey = "cuentacuentos-last-played-story"
    
    func loadStories() -> [Story] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            print("No stories data found in UserDefaults")
            return []
        }
        
        do {
            let stories = try JSONDecoder().decode([Story].self, from: data)
            print("Successfully loaded \(stories.count) stories from UserDefaults")
        return stories
        } catch {
            print("Error decoding stories: \(error)")
            return []
        }
    }
    
    func saveStories(_ stories: [Story]) {
        do {
            let data = try JSONEncoder().encode(stories)
        UserDefaults.standard.set(data, forKey: storageKey)
            UserDefaults.standard.synchronize() // Force immediate write
            print("Successfully saved \(stories.count) stories to UserDefaults")
        } catch {
            print("Error encoding stories: \(error)")
        }
    }
    
    func loadProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return nil
        }
        return profile
    }
    
    func saveProfile(_ profile: UserProfile) {
        guard let data = try? JSONEncoder().encode(profile) else {
            return
        }
        UserDefaults.standard.set(data, forKey: profileKey)
    }
    
    func saveLastPlayedStoryId(_ storyId: String?) {
        if let storyId = storyId {
            UserDefaults.standard.set(storyId, forKey: lastPlayedStoryKey)
        } else {
            UserDefaults.standard.removeObject(forKey: lastPlayedStoryKey)
        }
    }
    
    func loadLastPlayedStoryId() -> String? {
        return UserDefaults.standard.string(forKey: lastPlayedStoryKey)
    }
}

