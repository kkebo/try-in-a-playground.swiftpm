import Foundation

typealias GitReferences = [GitReference]

struct GitReference: Codable {
    var ref: String
    var nodeID: String
    var url: URL
    var object: GitObject

    enum CodingKeys: String, CodingKey {
        case ref
        case nodeID = "node_id"
        case url
        case object
    }
}

struct GitObject: Codable {
    var type: String
    var sha: String
    var url: URL
}
