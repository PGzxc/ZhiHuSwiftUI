import Foundation

@MainActor
class NetworkService {
    static let shared = NetworkService()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.timeoutInterval
        self.session = URLSession(configuration: config)
    }
    
    func fetch<T: Decodable>(_ endpoint: APIConfig.Endpoint) async throws -> T {
        do {
            let (data, response) = try await session.data(from: endpoint.url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIError.invalidData
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func post<T: Encodable, U: Decodable>(_ endpoint: APIConfig.Endpoint, body: T) async throws -> U {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(U.self, from: data)
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIError.invalidData
        } catch {
            throw APIError.networkError(error)
        }
    }
} 