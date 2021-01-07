//
//  dommy.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/09.
//

import Foundation

struct dommyModel : Codable,Identifiable{
    var id = UUID()

}

struct dommyCenter : Codable,Identifiable {
    var id = UUID()
    var centerName : String
    var centerTag : String
    var beforeDay : String
    var imageName : String
    var updateDate : String
    var optionName : String
    var centerSector : String
}
