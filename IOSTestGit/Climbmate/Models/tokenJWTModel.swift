import SwiftUI
import CoreData

struct loginJWTModel : Codable{
    
    let userPlatform : String
    let userEmail : String
    let userNickname : String
    let userId : String
}


struct accessKey : Codable {
    let accessKey : String
}
