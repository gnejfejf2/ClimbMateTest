
import Foundation
import SwiftUI
import SwiftyJSON

struct searchCenterModel : Codable , Identifiable {

    let id : String
    let centerAddress : String
    let centerName : String
    let imageThumbUrl : String
    let centerDistance : Double
    let detailRecentUpdate : String
    let conceptEndurance : String
    let conceptBordering : String
    let conceptName : String
    
    //centerToolModel center.swift파일에 존재
    let centerFacility : [centerFacilityModel]
    //centerToolModel center.swift파일에 존재
    let centerTool : [centerToolModel]
    //centerGoodsModel center.swift파일에 존재
    let centerGoods : [centerGoodsModel]
    //centerSettingImageModel center.swift파일에 존재
    let centerSettingImage : [centerSettingImageModel]
    var lastIndex : Bool
    var page : Int

//    1 = 1일 이용권
//    2 = 암벽화 대여
//    3 = 1일강습권+암벽화 대여
//    4 = 1개월 회원권
//    5 = 3개월 회원권
    func centerGoodsReturn(type : Int) -> Int{
       
        let returnIndex = self.centerGoods.firstIndex{
            $0.goodsType == type
        } ?? 0
        
        return returnIndex
    }
}




//카카오 검색결과를 바로사용할경우
struct searchKeywordKaKaoModel : Codable {
    let userLatitude : String
    let userLongitude : String
    let keyword : [xyModel]
}
//45개이상검색이되서 키워드로 검색했을경우
struct searchKeywordStringModel : Codable {
    let userLatitude : String
    let userLongitude : String
    let keyword : String
}
//카카오에서 검색결과가없을경우
struct searchKeywordZeroModel : Codable {
    let userLatitude : String
    let userLongitude : String
    let searchKeyword : String
}


struct facilityModel : Identifiable {
    var id  = UUID().uuidString
    var name : String
    var checked : Bool
}

struct facilityToolModel : Identifiable {
    var id  = UUID().uuidString
    var name : String
    var checked : Bool
}
