import Foundation

extension Game {
    var formattedReleaseDate: String {
        guard let released = released else { return "Unknown" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: released) {
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        }
        
        return released
    }
    
    var platformNames: String {
        guard let platforms = platforms else { return "Unknown" }
        
        let names = platforms.compactMap { $0.platform.name }
        return names.joined(separator: ", ")
    }
    
    var genreNames: String {
        guard let genres = genres else { return "Unknown" }
        
        let names = genres.compactMap { $0.name }
        return names.joined(separator: ", ")
    }
}
