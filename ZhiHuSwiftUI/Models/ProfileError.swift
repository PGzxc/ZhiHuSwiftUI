import Foundation

enum ProfileError: LocalizedError {
    case networkError
    case unauthorized
    case notFound
    case serverError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "网络连接失败，请检查网络设置"
        case .unauthorized:
            return "登录已过期，请重新登录"
        case .notFound:
            return "未找到用户信息"
        case .serverError:
            return "服务器错误，请稍后重试"
        case .unknown:
            return "发生未知错误"
        }
    }
} 