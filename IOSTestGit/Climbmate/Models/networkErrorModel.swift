//
//  networkError.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/07.
//

import Foundation

struct networkErrorModel: Codable , Identifiable{
    var id = UUID()
    var errorCheck : Bool
    var networkErrorReason : String?
}
