//
//  testModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/04.
//


import SwiftyJSON


struct networkResModel: Codable{
    var resBody : [JSON]
    var resCode : String?
    var resErr : String?
    
}


