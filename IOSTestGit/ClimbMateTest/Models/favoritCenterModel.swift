//
//  favoritCenterModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/22.
//

import Foundation
import SwiftUI

struct favoritCenterModel : Codable , Identifiable{
    let id : String
    let centerName : String
    let centerAddress : String
    let centerNumber : String
    let centerPhoneNumber : String
    let centerStatus : String
    let centerUrl : String
    let conceptBordering : String
    let conceptEndurance : String
    let locationParkingLotX : String
    let locationParkingLotY : String
    let locationInfo : String
    let detailCenterX : String
    let detailCenterY : String
    let detailComment : String
    let detailLocker : String
    let detailNextUpdate : String
    let detailRecentUpdate : String
    let detailShowerRoom : String
    let detailShowerTowel : String
    var offset : CGFloat = 0
    let imageThumbUrl : String
    let goodsPrice : String
}
