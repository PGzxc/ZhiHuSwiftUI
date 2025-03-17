import Foundation

struct RichText: Codable {
    var text: String
    var attributes: [Attribute]
    
    struct Attribute: Codable {
        var range: Range<Int>
        var type: AttributeType
        var data: AttributeData?
        
        enum AttributeType: String, Codable {
            case bold
            case italic
            case link
            case mention
            case topic
            case code
            case quote
        }
        
        enum AttributeData: Codable {
            case link(url: String)
            case mention(userId: String)
            case topic(topicId: String)
            
            private enum CodingKeys: String, CodingKey {
                case type, value
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case .link(let url):
                    try container.encode("link", forKey: .type)
                    try container.encode(url, forKey: .value)
                case .mention(let userId):
                    try container.encode("mention", forKey: .type)
                    try container.encode(userId, forKey: .value)
                case .topic(let topicId):
                    try container.encode("topic", forKey: .type)
                    try container.encode(topicId, forKey: .value)
                }
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)
                let value = try container.decode(String.self, forKey: .value)
                
                switch type {
                case "link": self = .link(url: value)
                case "mention": self = .mention(userId: value)
                case "topic": self = .topic(topicId: value)
                default: throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Invalid type"
                )
                }
            }
        }
    }
} 