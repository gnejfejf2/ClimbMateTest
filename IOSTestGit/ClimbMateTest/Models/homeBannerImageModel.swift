//
//  homeViewPagingImage.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/09/28.
//

import UIKit

struct homeBannerImageModel : Codable,Identifiable{
    var id = UUID()
    var imageURL : String
    var imageClickLink : String
}
