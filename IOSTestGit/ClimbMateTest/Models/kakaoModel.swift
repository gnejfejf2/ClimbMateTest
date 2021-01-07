//
//  kakaoRestApiReqModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/25.
//

import Foundation
import SwiftyJSON

struct kakaoRestApiReqModel : Codable {
    
    let query : String
    let page : Int
    let size : Int

}

struct kakaoResModel : Codable {
    let documents : [JSON?]
    let meta : JSON
}

struct kakaoErrorModel : Codable {
    
    let errorType : String
    let message : String
}


struct xyModel  : Codable{
    let x : String
    let y : String
}
