import Foundation
import SwiftyJSON
import Firebase

class centerListViewModel : ObservableObject {
    
   
    //    func getBannerList(completion: @escaping ([homeBannerImageModel]?) -> Void) {
    
    func getNearCenterList(completion: @escaping([centerModel]? , networkErrorModel , Int?) -> ()){
        networkManager().kakaoRestApi(searchKeyword: userData().returnUserData(index: 9)!, page: 1){
            kakaoReqData,kakaoReqError in
          
            //카카오데이터 요청시 오류가 생긴경우 검색이 중단이 되야하고 에러를 메세지가 나와야한다.
            if(kakaoReqError.errorCheck){
                completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: kakaoReqError.networkErrorReason) , nil)
            }else{
                //그게아니라면 정상적인 xy좌표값을 담는 배열을 만들어준후
                var parsingResult = [JSON]()
                //값이 최소 1개 이상이여야하기때문에 0개인지 아닌지 체크한다.
                if(kakaoReqData?.documents.count == 0 && kakaoReqData?.documents != nil){
                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: "검색결과가 없습니다."), nil)
                }
                else{
                    for i in 0..<kakaoReqData!.documents.count {
                        
                        
                        if(JSON(kakaoReqData!.documents)[i]["x"].string != nil && (JSON(kakaoReqData!.documents)[i]["y"].string != nil)){
                            parsingResult.append(JSON(["x": "\(JSON(kakaoReqData!.documents)[i]["x"].string!)", "y": "\(JSON(kakaoReqData!.documents)[i]["y"].string!)"]))
                            
                    
                        }
                    }
                    
                   
                    //카카오api에서 document에 빈값이 넘어오는 경우가 있기때문에 정확하게 x,y 이 파싱이 안되는 경우도 생긴다.
                    //그래서 다시한번더 파싱한데이터의 카운트가 0개가 아닌지를 체크한다.
                    
                    if(parsingResult.count != 0){
                        
                        
                        // 통신에 필요한 바디를 만든다.
                        // 큰거 -> userLongitude -> X
                        // 작은거 -> userLatitude -> Y
                        let reqBody = user(userLatitude: userData().returnUserData(index: 6), userLongitude: userData().returnUserData(index: 7), keyword : parsingResult)
                        
                        
                            
                        let encoder = JSONEncoder()
                        let reqBodyJson = try? encoder.encode(reqBody)
                        //데이터 통신을 위해 실행하는곳
                        //데이터 통신폼으로 변경 임시코드
                        
                        let parameterData=networkManager().reqParameterMake(reqCode: "101", reqBody: reqBodyJson)
                        
                        if(parameterData != nil){
                            //네트워크매니저에 포스트형식으로 통신을 요청한다.
                            //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                            //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                            networkManager().Post(requestURL: 0, requestData:parameterData){
                                reqData,reqError in
                                
                                var nearCenterList = [centerModel]()
                                
                                if(reqError.errorCheck == true){
                                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)), nil)
                                }
                                else{
                                    //통신결과
                                    for nearCenter in reqData!.resBody {
                                        nearCenterList.append(self.centerMake(reqBody: nearCenter))
                                    }
                                    
                                    
                                    completion(nearCenterList , networkErrorModel(errorCheck: false, networkErrorReason: "성공"), nearCenterList.count)
                                }
                            }
                        }else{
                            completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: "주변 클라이밍장 정보가 없습니다"), nil)
                        }
                    }else{
                        completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: "검색결과가 없습니다."), nil)
                    }
                }
            }
        }
    }
    
    func getRecentUpdateCenterList(completion: @escaping([centerModel]? , networkErrorModel) -> ()){
        
        let parameterData=networkManager().reqParameterMake(reqCode: "102", reqBody: nil)
        
        if(parameterData != nil){
            //네트워크매니저에 포스트형식으로 통신을 요청한다.
            //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
            //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
            networkManager().Post(requestURL: 0, requestData:parameterData){
                reqData,reqError in
                
                
                if(reqError.errorCheck == true){
                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                }
                else{
                    var resentUpdateCenterList = [centerModel]()
                   
                    for rescentUpdateCenter in reqData!.resBody {
                        resentUpdateCenterList.append(self.centerMake(reqBody: rescentUpdateCenter))
                    }
                    if(resentUpdateCenterList.count > 0){
                        completion(resentUpdateCenterList , networkErrorModel(errorCheck: false, networkErrorReason: "통신성공!"))
                    }else{
                        completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: "최근 업데이트된 클라이밍장을 가져오는데 오류가 생겼습니다."))
                    }
                }
            }
        }else{
            completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: "최근 업데이트된 클라이밍장을 가져오는데 오류가 생겼습니다."))
        }
    }
    
    
    //센터를 만드는 함수 제이슨을 파싱하여 이곳에서 센터모델로 변경한다.
    //값이 없는경우 -1 로 통일시킨다 모든 모델 동일
    func centerMake(reqBody : JSON) -> centerModel{
        var idParsing : String
        var centerNameParsing : String
        var centerAddressParsing : String
        var centerDistanceParsing : String
        var imageThumbUrlParsing : String
        var detailCenterXParsing : String
        var detailCenterYParsing : String
        var detailRecentUpdateParsing : String
        
        if reqBody["id"].string == nil{
            idParsing = UUID().uuidString
        }
        else{
            idParsing = reqBody["id"].string!
        }
        
        if reqBody["centerName"].string == nil{
            centerNameParsing = staticString().nilString()
        }
        else{
            centerNameParsing = reqBody["centerName"].string!
        }
        
        if reqBody["centerAddress"].string == nil{
            centerAddressParsing = staticString().nilString()
        }
        else{
            centerAddressParsing = reqBody["centerAddress"].string!
        }
        
        if reqBody["centerDistance"].int == nil{
            
            centerDistanceParsing = staticString().nilString()
        }
        else{
            centerDistanceParsing = "\(searchResultViewModel().kmGetThird(doubleNumber: reqBody["centerDistance"].doubleValue))"
        }
        
        if reqBody["imageThumbUrl"].string == nil{
            imageThumbUrlParsing = staticString().nilImage()
        }
        else{
            imageThumbUrlParsing = imageManager().imageURLReturn(getURL : reqBody["imageThumbUrl"].string!)
            
        }
        
        if reqBody["detailCenterX"].string == nil{
            detailCenterXParsing = staticString().nilString()
        }
        else{
            detailCenterXParsing = reqBody["detailCenterX"].string!
        }
        
        if reqBody["detailCenterY"].string == nil{
            detailCenterYParsing = staticString().nilString()
        }
        else{
            detailCenterYParsing = reqBody["detailCenterY"].string!
        }
        
        if reqBody["detailRecentUpdate"].string == nil{
            detailRecentUpdateParsing = staticString().nilString()
        }
        else{
            detailRecentUpdateParsing = reqBody["detailRecentUpdate"].string!
        }
        
        
        return centerModel(id: idParsing, centerName: centerNameParsing, centerAddress: centerAddressParsing, centerDistance: centerDistanceParsing, imageThumbUrl: imageThumbUrlParsing, detailCenterX: detailCenterXParsing, detailCenterY: detailCenterYParsing,detailRecentUpdate : detailRecentUpdateParsing)
        
        
    }
    
}

