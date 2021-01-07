//
//  registerModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/18.
//


struct registerModel : Codable{
    let userNickname : String
    let userPassword : String
    let userEmail : String
    let userPlatform : String
    let certificationCode : String
}

struct certificationEmailModel : Codable{
    let certificationEmail : String
}

struct certificationEmailCheckModel  : Codable{
    let certificationEmail : String
    let certificationCode : String
}


struct passGetModel : Codable{
    let userEmail : String
}

