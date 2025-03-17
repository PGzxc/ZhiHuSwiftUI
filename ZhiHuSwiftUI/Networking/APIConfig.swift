import Foundation

struct APIConfig {
    static let baseURL = "https://api.zhihu.com/v1"
    static let timeoutInterval: TimeInterval = 30
    
    enum Endpoint {
        case login
        case register
        case posts
        case topics
        case columns
        case userProfile(String)
        case notifications
        case followTopic(String)
        case unfollowTopic(String)
        case followColumn(String)
        case unfollowColumn(String)
        case topicQuestions(String)
        case columnArticles(String)
        
        var path: String {
            switch self {
            case .login:
                return "/auth/login"
            case .register:
                return "/auth/register"
            case .posts:
                return "/posts"
            case .topics:
                return "/topics"
            case .columns:
                return "/columns"
            case .userProfile(let userId):
                return "/users/\(userId)"
            case .notifications:
                return "/notifications"
            case .followTopic(let id):
                return "/topics/\(id)/follow"
            case .unfollowTopic(let id):
                return "/topics/\(id)/unfollow"
            case .followColumn(let id):
                return "/columns/\(id)/follow"
            case .unfollowColumn(let id):
                return "/columns/\(id)/unfollow"
            case .topicQuestions(let topicId):
                return "/topics/\(topicId)/questions"
            case .columnArticles(let columnId):
                return "/columns/\(columnId)/articles"
            }
        }
        
        var method: String {
            switch self {
            case .login, .register, .followTopic, .unfollowTopic, .followColumn, .unfollowColumn:
                return "POST"
            default:
                return "GET"
            }
        }
        
        var url: URL {
            URL(string: baseURL + path)!
        }
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case invalidData
    case networkError(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "无效的服务器响应"
        case .invalidData:
            return "无效的数据格式"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .serverError(let code):
            return "服务器错误 (\(code))"
        }
    }
} 