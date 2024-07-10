import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Router {
    case dictionary(word: String)
    case synonyms(word: String)
    
    var baseURL: String {
        switch self {
        case .dictionary:
            return "https://api.dictionaryapi.dev/api/v2/entries/en/"
        case .synonyms:
            return "https://api.datamuse.com/words"
        }
    }
    
    var path: String {
        switch self {
        case .dictionary(let word):
            return "\(word)"
        case .synonyms:
            return ""
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .dictionary:
            return [:]
        case .synonyms(let word):
            return ["rel_syn": word]
        }
    }
}
