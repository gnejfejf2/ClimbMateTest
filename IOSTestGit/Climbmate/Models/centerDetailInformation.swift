

struct centerDetailInformation : Codable , Identifiable{
    let id : String
    let centerName : String
    let centerAddress : String
    let centerNumber : String
    let centerPhoneNumber : String
    let centerStatus : String
    let centerUrl : String
    //볼더링
    let conceptBordering : String
    //밸런스
    let conceptEndurance : String
    //주차장 위치X
    let locationParkingLotX : String
    //주차장 위치Y
    let locationParkingLotY : String
    
    let locationInfo : String
    let detailCenterX : String
    let detailCenterY : String
    let detailComment : String
    let detailNextUpdate : String
    let detailRecentUpdate : String

}
