//
//  user.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/08.
//


import SwiftyJSON

struct user: Codable , Identifiable{
    var id = UUID()
    var userLatitude : String?
    var userLongitude : String?
    var keyword : [JSON]
}

struct userEdit : Codable {
    var accessKey : String
    var userNickname : String
    var userProfileImageUrl : String
    var userInfo : String
}

struct userEditWithPass : Codable {
    var accessKey : String
    var userNickname : String
    var userProfileImageUrl : String
    var userInfo : String
    var userPassword : String
}

struct userQuit : Codable {
    var accessKey : String
    var userPassword : String
}
