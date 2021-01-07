//
//  centerDetailInformationModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/04.
//

import SwiftUI

struct centerDetailModel : Codable {
    var centerDetail : centerDetailInformation
    var centerBannerImage : [centerBannerImageModel]
    var centerGoods : [centerGoodsModel]
    var centerSchedules : [centerScheduleModel]
    var centerSettings : [centerSettingLevelModel]
    var centerTools : [centerToolModel]
    var centerFacilitys : [centerFacilityModel]
    var centerComments : [centerCommentModel]
    var centerNotices: [centerNoticeModel]
    var subscription : String
}


struct centerBannerImageModel : Codable {
    let imageThumbUrl : String
}

struct centerGoodsModel : Codable {
    let goodsName : String
    let goodsPrice : String
    //보여줄 순서
    let goodsOrder : Int?
    //물품의 종류
    let goodsType : Int?
    
}

struct centerScheduleModel : Codable {
    let scheduleDay : String
    let scheduleTime : String
}

struct centerSettingLevelModel : Codable , Identifiable{
    let id = UUID()
    var centerLevel : String
    var centerSettings : [centerSettingModel]
}

struct centerSettingModel : Codable {
    var settingColor : String
    var settingLevel : String
    var imageThumbUrl : String
    var settingCenterDifficulty : String
}

struct centerFacilityModel : Codable , Equatable {
    let facilityName : String
}

struct centerToolModel : Codable , Equatable {
    let toolName : String
}

struct centerDetailNetWorkReqModel : Codable , Identifiable{
    let id : String
    let accessKey : String
}

struct centerCommentModel : Codable , Identifiable {
    var id = UUID()
    var commentDate : String
    var commentNickName : String
    var commentSettingId : String
    var commentUserId : String
    var commentURL : String
    var imageThumbUrl : String
    var userProfileImageUrl : String
}

struct centerNoticeModel : Codable , Identifiable {
    var id = UUID()
    var noticeCenterId : String
    var noticeDate : String
    var noticeTitle : String
    var noticeDetail : String
    var noticeUrl : String
    var noticeImageUrl : String
}


struct centerSettingImageModel : Codable , Identifiable {
    var id = UUID()
    var imageThumbUrl : String
    var imageOrder : Int
}
