import Foundation


enum NetworkError: Error {
        case invalidRequest
        case requestFailed(String)
        case invalidData
        case jsonParsingFailed(String)
        case invalidURL
        case noData
        case decodingError
        case apiError(Error) // apiError case'i ekleniyor
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Decoding error"
            case .apiError(let underlyingError):
                return "API error: \(underlyingError.localizedDescription)"
            case .invalidRequest:
                return "Invalid Request"
            case .requestFailed(_):
                return "Request Failed"
            case .invalidData:
                return "Invalid Data"
            case .jsonParsingFailed(_):
                return "json Parsing Failed"
            }
        }
    }


