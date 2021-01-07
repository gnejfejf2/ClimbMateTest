//
//  centerDetailViewModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/04.
//


import Foundation
import SwiftyJSON
import SwiftUI


class favoritesViewModel : ObservableObject {
    
    
    let favortesErrorReason : String = "즐겨찾기에 등록된 클라이밍장이 없습니다."
    
    
    
    
    func getFavoritesCenterList(completion: @escaping([favoritCenterModel]? , networkErrorModel) -> ()){
        
        //엑세스 키가 있는지 확인
        if(networkManager().accessKeyCheck().errorCheck){
            completion(nil,networkManager().accessKeyCheck())
        }
        else{
            let reqBody = accessKey(accessKey: UserDefaults.standard.string(forKey: "accessKey")!)
            let encoder = JSONEncoder()
            let reqBodyJson = try? encoder.encode(reqBody)
            
            //로그인 코드 넣어야하고
            let parameterData=networkManager().reqParameterMake(reqCode: "507", reqBody: reqBodyJson)
            
            if(parameterData != nil){
                //네트워크매니저에 포스트형식으로 통신을 요청한다.
                //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                networkManager().Post(requestURL: 0, requestData:parameterData){
                    reqData,reqError in
                    
                    if(reqError.errorCheck == true){
                        
                        
                        return completion(nil,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                        
                    }
                    else{
                        if(reqData!.resCode == "200"){
                            var favoritesCenters = [favoritCenterModel]()
                            
                            for center in reqData!.resBody {
                               
                               
                                favoritesCenters.append(self.favoritCenterModelMake(reqData: center))
                            }
                            if(favoritesCenters.count > 0){
                                return completion(favoritesCenters,networkErrorModel(errorCheck: false, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                            }else{
                                return completion(favoritesCenters,networkErrorModel(errorCheck: true, networkErrorReason: "추가 된 즐겨찾기가 없습니다."))
                            }

                        }else{
                            
                            return completion(nil,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                          
                        }
                    }
                    
                }
            }else{
                return completion(nil,networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
              
            }
        }
        
    }
    
    func favoritCenterModelMake(reqData : JSON) -> favoritCenterModel{
        
        var idParsing : String
        var centerNameParsing : String
        var centerAddressParsing : String
        var centerNumberParsing : String
        var centerPhoneNumberParsing : String
        var centerStatusParsing : String
        var centerUrlParsing : String
        var conceptBorderingParsing : String
        var conceptEnduranceParsing : String
        var locationParkingLotXParsing : String
        var locationParkingLotYParsing : String
        var locationInfoParsing : String
        var detailCenterXParsing : String
        var detailCenterYParsing : String
        var detailCommentParsing : String
        var detailLockerParsing : String
        var detailNextUpdateParsing : String
        var detailRecentUpdateParsing : String
        var detailShowerRoomParsing : String
        var detailShowerTowelParsing : String
        
        var imageThumbUrlParsing : String
        var goodsPriceParsing : String
        
        if reqData["id"].string == nil{
            idParsing = staticString().nilString()
        }else{
            idParsing = reqData["id"].string!
        }
        
        if reqData["centerName"].string == nil{
            centerNameParsing = staticString().nilString()
        }else{
            centerNameParsing = reqData["centerName"].string!
        }
        
        if reqData["centerAddress"].string == nil{
            centerAddressParsing = staticString().nilString()
        }else{
            centerAddressParsing = reqData["centerAddress"].string!
        }
        
        if reqData["centerNumber"].string == nil{
            centerNumberParsing = staticString().nilString()
        }else{
            centerNumberParsing = reqData["centerNumber"].string!
        }
        
        if reqData["centerPhoneNumber"].string == nil{
            centerPhoneNumberParsing = staticString().nilString()
        }else{
            centerPhoneNumberParsing = reqData["centerPhoneNumber"].string!
        }
        
        if reqData["centerStatus"].string == nil{
            centerStatusParsing = staticString().nilString()
        }else{
            centerStatusParsing = reqData["centerStatus"].string!
        }
        
        if reqData["centerUrl"].string == nil{
            centerUrlParsing = staticString().nilString()
        }else{
            centerUrlParsing = reqData["centerUrl"].string!
        }
        
        if reqData["conceptBordering"].string == nil{
            conceptBorderingParsing = staticString().nilString()
        }else{
            conceptBorderingParsing = reqData["conceptBordering"].string!
        }
        
        
        if reqData["conceptEndurance"].string == nil{
            conceptEnduranceParsing = staticString().nilString()
        }else{
            conceptEnduranceParsing = reqData["conceptEndurance"].string!
        }
        
        if reqData["locationParkingLotX"].string == nil{
            locationParkingLotXParsing = staticString().nilString()
        }else{
            locationParkingLotXParsing = reqData["locationParkingLotX"].string!
        }
        
        if reqData["locationParkingLotY"].string == nil{
            locationParkingLotYParsing = staticString().nilString()
        }else{
            locationParkingLotYParsing = reqData["locationParkingLotY"].string!
        }
        
        if reqData["locationInfo"].string == nil{
            locationInfoParsing = staticString().nilString()
        }else{
            locationInfoParsing = reqData["locationInfo"].string!
        }
        
        if reqData["detailCenterX"].string == nil{
            detailCenterXParsing = staticString().nilString()
        }else{
            detailCenterXParsing = reqData["detailCenterX"].string!
        }
        
        if reqData["detailCenterY"].string == nil{
            detailCenterYParsing = staticString().nilString()
        }else{
            detailCenterYParsing = reqData["detailCenterY"].string!
        }
        
        if reqData["detailComment"].string == nil{
            detailCommentParsing = staticString().nilString()
        }else{
            detailCommentParsing = reqData["detailComment"].string!
        }
        
        if reqData["detailLocker"].string == nil{
            detailLockerParsing = staticString().nilString()
        }else{
            detailLockerParsing = reqData["detailLocker"].string!
        }
        
        if reqData["detailNextUpdate"].string == nil{
            detailNextUpdateParsing = staticString().nilString()
        }else{
            detailNextUpdateParsing = reqData["detailNextUpdate"].string!
        }
        
        if reqData["detailRecentUpdate"].string == nil{
            detailRecentUpdateParsing = staticString().nilString()
        }else{
            detailRecentUpdateParsing = reqData["detailRecentUpdate"].string!
        }
        
        if reqData["detailShowerRoom"].string == nil{
            detailShowerRoomParsing = staticString().nilString()
        }else{
            detailShowerRoomParsing = reqData["detailShowerRoom"].string!
        }
        
        if reqData["detailShowerTowel"].string == nil{
            detailShowerTowelParsing = staticString().nilString()
        }else{
            detailShowerTowelParsing = reqData["detailShowerTowel"].string!
        }
        
        
        if reqData["imageThumbUrl"].string == nil{
            imageThumbUrlParsing = staticString().nilImage()
        }else{
            imageThumbUrlParsing = imageManager().imageURLReturn(getURL: reqData["imageThumbUrl"].string!)
        }
        
        
        if reqData["goodsPrice"].string == nil{
            goodsPriceParsing = staticString().nilString()
        }else{
            goodsPriceParsing = reqData["goodsPrice"].string!
        }
        
        
        
        return favoritCenterModel(id: idParsing, centerName: centerNameParsing, centerAddress: centerAddressParsing, centerNumber: centerNumberParsing, centerPhoneNumber: centerPhoneNumberParsing, centerStatus: centerStatusParsing, centerUrl: centerUrlParsing, conceptBordering: conceptBorderingParsing, conceptEndurance: conceptEnduranceParsing, locationParkingLotX: locationParkingLotXParsing, locationParkingLotY: locationParkingLotYParsing, locationInfo: locationInfoParsing, detailCenterX: detailCenterXParsing, detailCenterY: detailCenterYParsing, detailComment: detailCommentParsing, detailLocker: detailLockerParsing, detailNextUpdate: detailNextUpdateParsing, detailRecentUpdate: detailRecentUpdateParsing, detailShowerRoom: detailShowerRoomParsing, detailShowerTowel: detailShowerTowelParsing , imageThumbUrl : imageThumbUrlParsing , goodsPrice : goodsPriceParsing)
        
    }
    
    //리스트뷰에서 정확한 인덱스를 가져오기위해사용
    func getIndex(centerName: String , favoritesCenters : [favoritCenterModel])->Int{
        
        var index = 0
        
        for i in 0..<favoritesCenters.count{
            
            if centerName == favoritesCenters[i].centerName{
                
                index = i
            }
        }
        
        return index
    }
}
   
