//
//  searchResultViewModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/24.
//

import SwiftUI
import SwiftyJSON
import Firebase
//검색에서 사용하는 뷰모델이다.
//최초검색은 카카오에서 가져오고 그후 카카오에서 가져온 x,y좌표를 클라이메이트 서버와통신하여
//디테일한 정보를 가져오는방식
class searchResultViewModel{
    
    
    let searchErrorReason : String = "검색결과가 없습니다."
    
    func getSearchList(searchKeyword : String , completion: @escaping([searchCenterModel]? , networkErrorModel) -> ()){
        
        Analytics.logEvent("검색", parameters: [
            "searchKeyword": searchKeyword as NSObject
        ])
        
        
        searchHistoryModel().writeData(keyword: searchKeyword, totalCount: 0)
        
        
        self.getKakaoXYModel(searchKeyword: searchKeyword){
            result , error , keyword in
            
            if(error.errorCheck){
                
                completion(nil , error)
                
            }else{
                //검색페이지 리턴하는 결과
                //검색 토탈 결과가 45개이상일경우 클라이메이트서버에 요청하는공간 카카오에서받은 xy 상관없이 내가 검색한 키워드와 위치를 서버에 넘겨줘
                //검색결과를 받아온다.
                if(error.networkErrorReason == "45"){
                    let reqBody = searchKeywordStringModel(userLatitude: userData().returnUserData(index: 6) ?? "0", userLongitude: userData().returnUserData(index: 7) ??  "0", keyword: keyword!)
                    let encoder = JSONEncoder()
                    let reqBodyJson = try? encoder.encode(reqBody)
                    
                    //검색코드를 넣고 바디에 담은후 전송
                    let parameterData=networkManager().reqParameterMake(reqCode: "107", reqBody: reqBodyJson)
                    
                    
                    if(parameterData != nil){
                        //네트워크매니저에 포스트형식으로 통신을 요청한다.
                        //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                        //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                        networkManager().Post(requestURL: 0, requestData:parameterData){
                            reqData,reqError in
                            
                            if(reqError.errorCheck == true){
                                return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                            }
                            else{
                                if(reqData!.resCode == "200"){
                                    
                                    
                                    var returnSearchCenterModel = [searchCenterModel]()
                                    
                                    
                                    let pagingIndex = reqData!.resBody.count / 15
                                    
                                    //페이징카운트가 1이상일경우
                                    if(pagingIndex>0){
                                        //0번부터 인덱스를 재정렬한다.
                                        for i in 1..<pagingIndex + 1{
                                            for j in (i-1) * 15..<i*15{
                                                if(j == (i*15 - 1)){
                                                    let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: true , searchPage: i)
                                                    if(makedSearchCenter.id != "-1"){
                                                        returnSearchCenterModel.append(makedSearchCenter)
                                                    }
                                                }
                                                else{
                                                    let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: false , searchPage: i)
                                                    if(makedSearchCenter.id != "-1"){
                                                        returnSearchCenterModel.append(makedSearchCenter)
                                                    }
                                                }
                                            }
                                            
                                            if(pagingIndex  ==  i){
                                                if((pagingIndex * 15) < reqData!.resBody.count){
                                                    for j in (pagingIndex * 15)..<reqData!.resBody.count{
                                                        
                                                        let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: false , searchPage: pagingIndex + 1)
                                                        if(makedSearchCenter.id != "-1"){
                                                            returnSearchCenterModel.append(makedSearchCenter)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        for i in 0..<reqData!.resBody.count {
                                            let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[i], lastIndexParsing: false , searchPage: i)
                                            if(makedSearchCenter.id != "-1"){
                                                returnSearchCenterModel.append(makedSearchCenter)
                                            }
                                        }
                                    }
                                   
                                    return completion(returnSearchCenterModel ,networkErrorModel(errorCheck: false, networkErrorReason: "성공"))
                                }else{
                                    return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                                    
                                }
                            }
                        }
                        
                    }else{
                        return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
                //카카오검색 api를 통해 검색했을경우 xy가 담겨져있는 배열을 keyWord에 넣어 서버에 전송한다
                else if(result!.count != 0){
                    let reqBody = searchKeywordKaKaoModel(userLatitude: userData().returnUserData(index: 6) ?? "0", userLongitude: userData().returnUserData(index: 7) ??  "0", keyword: result!)
                    let encoder = JSONEncoder()
                    let reqBodyJson = try? encoder.encode(reqBody)
                    
                    //검색코드를 넣고 바디에 담은후 전송
                    let parameterData=networkManager().reqParameterMake(reqCode: "101", reqBody: reqBodyJson)
                    
                    
                    if(parameterData != nil){
                        //네트워크매니저에 포스트형식으로 통신을 요청한다.
                        //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                        //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                        networkManager().Post(requestURL: 0, requestData:parameterData){
                            reqData,reqError in
                            
                            logManager().kakaoLog(log: "2차통신 결과\(String(describing: reqData))")
                            
                            logManager().kakaoLog(log: "2차통신 에러\(reqError)")
                            
                            if(reqError.errorCheck == true){
                                return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                            }
                            else{
                                if(reqData!.resCode == "200"){
                                    
                                    var returnSearchCenterModel = [searchCenterModel]()
                                    
                                    logManager().kakaoLog(log: "총 갯수 \(reqData!.resBody.count)")
                                    //0에서 14는 1페이지에 마지막 인덱스가아님
                                    
                                    let pagingIndex = reqData!.resBody.count / 15
                                    
                                    //페이징카운트가 1이상일경우
                                    if(pagingIndex>0){
                                        //0번부터 인덱스를 재정렬한다.
                                        for i in 1..<pagingIndex + 1{
                                            for j in (i-1) * 15..<i*15{
                                                if(j == (i*15 - 1)){
                                                    let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: true , searchPage: i)
                                                    if(makedSearchCenter.id != "-1"){
                                                        returnSearchCenterModel.append(makedSearchCenter)
                                                    }
                                                }
                                                else{
                                                    let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: false , searchPage: i)
                                                    if(makedSearchCenter.id != "-1"){
                                                        returnSearchCenterModel.append(makedSearchCenter)
                                                    }
                                                }
                                            }
                                            
                                            if(pagingIndex  ==  i){
                                                if((pagingIndex * 15) < reqData!.resBody.count){
                                                    for j in (pagingIndex * 15)..<reqData!.resBody.count{
                                                        
                                                        let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: false , searchPage: pagingIndex + 1)
                                                        if(makedSearchCenter.id != "-1"){
                                                            returnSearchCenterModel.append(makedSearchCenter)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        for i in 0..<reqData!.resBody.count {
                                            let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[i], lastIndexParsing: false , searchPage: i)
                                            if(makedSearchCenter.id != "-1"){
                                                returnSearchCenterModel.append(makedSearchCenter)
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    return completion(returnSearchCenterModel ,networkErrorModel(errorCheck: false, networkErrorReason: "성공"))
                                }else{
                                    return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                                    
                                }
                            }
                        }
                        
                    }else{
                        return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
                else if(result!.count == 0){
                    let reqBody = searchKeywordZeroModel(userLatitude: userData().returnUserData(index: 6) ?? "0", userLongitude: userData().returnUserData(index: 7) ??  "0", searchKeyword: searchKeyword)
                    let encoder = JSONEncoder()
                    let reqBodyJson = try? encoder.encode(reqBody)
                    
                    //검색코드를 넣고 바디에 담은후 전송
                    let parameterData=networkManager().reqParameterMake(reqCode: "107", reqBody: reqBodyJson)
                    
                    
                    if(parameterData != nil){
                        //네트워크매니저에 포스트형식으로 통신을 요청한다.
                        //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                        //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                        networkManager().Post(requestURL: 0, requestData:parameterData){
                            reqData,reqError in
                            
                            logManager().kakaoLog(log: "2차통신 결과\(String(describing: reqData))")
                            
                            logManager().kakaoLog(log: "2차통신 에러\(reqError)")
                            
                            if(reqError.errorCheck == true){
                                return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                            }
                            else{
                                if(reqData!.resCode == "200"){
                                    
                                    var returnSearchCenterModel = [searchCenterModel]()
                                    
                                    logManager().kakaoLog(log: "총 갯수 \(reqData!.resBody.count)")
                                    //0에서 14는 1페이지에 마지막 인덱스가아님
                                    
                                    let pagingIndex = reqData!.resBody.count / 15
                                    
                                    //페이징카운트가 1이상일경우
                                    if(pagingIndex>0){
                                        //0번부터 인덱스를 재정렬한다.
                                        for i in 1..<pagingIndex + 1{
                                            for j in (i-1) * 15..<i*15{
                                                if(j == (i*15 - 1)){
                                                    let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: true , searchPage: i)
                                                    if(makedSearchCenter.id != "-1"){
                                                        returnSearchCenterModel.append(makedSearchCenter)
                                                    }
                                                }
                                                else{
                                                    let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: false , searchPage: i)
                                                    if(makedSearchCenter.id != "-1"){
                                                        returnSearchCenterModel.append(makedSearchCenter)
                                                    }
                                                }
                                            }
                                            
                                            if(pagingIndex  ==  i){
                                                if((pagingIndex * 15) < reqData!.resBody.count){
                                                    for j in (pagingIndex * 15)..<reqData!.resBody.count{
                                                        
                                                        let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[j], lastIndexParsing: false , searchPage: pagingIndex + 1)
                                                        if(makedSearchCenter.id != "-1"){
                                                            returnSearchCenterModel.append(makedSearchCenter)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        for i in 0..<reqData!.resBody.count {
                                            let makedSearchCenter = self.searchCenterMake(body: reqData!.resBody[i], lastIndexParsing: false , searchPage: i)
                                            if(makedSearchCenter.id != "-1"){
                                                returnSearchCenterModel.append(makedSearchCenter)
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    return completion(returnSearchCenterModel ,networkErrorModel(errorCheck: false, networkErrorReason: "성공"))
                                }else{
                                    return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                                    
                                }
                            }
                        }
                        
                    }else{
                        return completion(nil ,networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
                
                else{
                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: self.searchErrorReason))
                }
            }
        }
    }
    
    //카카오에서 검색결과 최대 45개까지 XY모델을 리턴하는 함수
    func getKakaoXYModel(searchKeyword : String ,completion: @escaping([xyModel]? , networkErrorModel , String?) -> ()){
        
        networkManager().kakaoRestApi(searchKeyword: searchKeyword, page: 1){
            kakaoReqData,kakaoReqError in
            
            //파싱결과를 저장하는 배열
            var parsingResult = [xyModel]()
            //            print(kakaoReqData)
            //            print(kakaoReqError)
            if(kakaoReqError.errorCheck){
                completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: kakaoReqError.networkErrorReason), nil)
            }else{
                
                if(kakaoReqData!.meta["total_count"].int ?? 0 <= 45){
                    //값이 최소 1개 이상이여야하기때문에 0개인지 아닌지 체크한다.
                    if(kakaoReqData!.documents.count == 0 && kakaoReqData?.documents != nil){
                        if(kakaoReqData?.meta["total_count"].stringValue == "0"){
                            completion(parsingResult , networkErrorModel(errorCheck: false, networkErrorReason: nil) , nil)
                        }else{
                            completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: self.searchErrorReason) , nil)
                        }
                    }
                    else{
                        for i in 0..<kakaoReqData!.documents.count {
                            if(JSON(kakaoReqData!.documents)[i]["x"].string != nil && (JSON(kakaoReqData!.documents)[i]["y"].string != nil)){
                                parsingResult.append(xyModel(x: JSON(kakaoReqData!.documents)[i]["x"].string!, y: JSON(kakaoReqData!.documents)[i]["y"].string!))
                            }
                        }
                        //토탈갯수가 15보다큰경우 2페이지에있는 결과까지 요청
                        //1차 파싱결과
                        if(kakaoReqData!.meta["total_count"].int ?? 0 > 15){
                            networkManager().kakaoRestApi(searchKeyword: searchKeyword, page: 2){
                                kakaoReqData,kakaoReqError in
                                
                                //파싱결과를 저장하는 배열
                                
                                if(kakaoReqError.errorCheck){
                                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: kakaoReqError.networkErrorReason) , nil)
                                }else{
                                    //값이 최소 1개 이상이여야하기때문에 0개인지 아닌지 체크한다.
                                    if(kakaoReqData?.documents.count == 0 && kakaoReqData?.documents != nil){
                                        completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: self.searchErrorReason) , nil)
                                    }
                                    else{
                                        for i in 0..<kakaoReqData!.documents.count {
                                            if(JSON(kakaoReqData!.documents)[i]["x"].string != nil && (JSON(kakaoReqData!.documents)[i]["y"].string != nil)){
                                                parsingResult.append(xyModel(x: JSON(kakaoReqData!.documents)[i]["x"].string!, y: JSON(kakaoReqData!.documents)[i]["y"].string!))
                                            }
                                        }
                                    }
                                    
                                    if(kakaoReqData!.meta["total_count"].int ?? 0 > 30){
                                        networkManager().kakaoRestApi(searchKeyword: searchKeyword, page: 3){
                                            kakaoReqData,kakaoReqError in
                                            //파싱결과를 저장하는 배열
                                            if(kakaoReqError.errorCheck){
                                                completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: kakaoReqError.networkErrorReason) , nil)
                                            }else{
                                                //값이 최소 1개 이상이여야하기때문에 0개인지 아닌지 체크한다.
                                                if(kakaoReqData?.documents.count == 0 && kakaoReqData?.documents != nil){
                                                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: self.searchErrorReason) , nil)
                                                }
                                                else{
                                                    for i in 0..<kakaoReqData!.documents.count {
                                                        if(JSON(kakaoReqData!.documents)[i]["x"].string != nil && (JSON(kakaoReqData!.documents)[i]["y"].string != nil)){
                                                            parsingResult.append(xyModel(x: JSON(kakaoReqData!.documents)[i]["x"].string!, y: JSON(kakaoReqData!.documents)[i]["y"].string!))
                                                        }
                                                    }
                                                    completion(parsingResult , networkErrorModel(errorCheck: false, networkErrorReason: "성공") , nil)
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        completion(parsingResult , networkErrorModel(errorCheck: false, networkErrorReason: "성공") , nil)
                                    }
                                }
                            }
                        }
                        else{
                            completion(parsingResult , networkErrorModel(errorCheck: false, networkErrorReason: "성공") , nil)
                        }
                    }
                }else{
                    guard kakaoReqData!.meta["same_name"]["selected_region"].string != nil else {
                        completion(parsingResult , networkErrorModel(errorCheck: true, networkErrorReason: "검색키워드가 없습니다.") , nil)
                        return
                    }
                    completion(nil , networkErrorModel(errorCheck: false, networkErrorReason: "45") , kakaoReqData!.meta["same_name"]["selected_region"].string)
                }
            }
        }
    }
    
    
    func searchCkeck(searchText : String) -> Bool{
        
        //각각의 글자들이 해당 특수기호
        let passwordreg = ("[A-Z0-9a-z가-힣!\"#$%&'()*+,-./:;<=>?@[＼]^_`{|}~]{0,12}")
        
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        
        
        return passwordtesting.evaluate(with: searchText)
    }
    
    
    func searchCenterMake(body : JSON , lastIndexParsing : Bool , searchPage : Int) -> searchCenterModel{
        var idParsing : String
        var centerAddressParsing : String
        var centerNameParsing : String
        var imageThumbUrlParsing : String
        var centerDistanceParsing : Double
        var detailRecentUpdateParsing : String
        
        var conceptEnduranceParsing : String
        var conceptBorderingParsing : String
        var conceptNameParsing : String
        
        var centerFacility = [centerFacilityModel]()
        var centerToolParsing = [centerToolModel]()
        var centerGoodsParsing = [centerGoodsModel]()
        var centerSettingImageParsing = [centerSettingImageModel]()
        
        
        if body["id"].string != nil && body["id"].string != ""{
            idParsing = body["id"].string!
        }else{
            idParsing = staticString().nilString()
        }
        
        if body["centerAddress"].string != nil && body["centerAddress"].string != ""{
            centerAddressParsing = body["centerAddress"].string!
        }else{
            centerAddressParsing = staticString().nilString()
        }
        
        if body["centerName"].string != nil && body["centerName"].string != ""{
            centerNameParsing = body["centerName"].string!
        }else{
            centerNameParsing = staticString().nilString()
        }
        
        if body["imageThumbUrl"].string != nil && body["imageThumbUrl"].string != ""{
            imageThumbUrlParsing = imageManager().imageURLReturn(getURL: body["imageThumbUrl"].string!)
        }else{
            imageThumbUrlParsing = staticString().nilImage()
        }
        
        if body["centerDistance"].double != nil && body["centerDistance"].double != 0{
            centerDistanceParsing = Double(self.kmGetThird(doubleNumber: body["centerDistance"].double!)) ?? 0
        }else{
            centerDistanceParsing = staticString().nilDouble()
        }
        
        if body["detailRecentUpdate"].string != nil && body["detailRecentUpdate"].string != ""{
            detailRecentUpdateParsing = body["detailRecentUpdate"].string!
        }else{
            detailRecentUpdateParsing = staticString().nilString()
        }
        
        if body["conceptEndurance"].string != nil && body["conceptEndurance"].string != ""{
            conceptEnduranceParsing = body["detailRecentUpdate"].string!
        }else{
            conceptEnduranceParsing = staticString().nilString()
        }
        
        if body["conceptBordering"].string != nil && body["conceptBordering"].string != ""{
            conceptBorderingParsing = body["conceptBordering"].string!
        }else{
            conceptBorderingParsing = staticString().nilString()
        }
        
        if body["conceptName"].string != nil && body["conceptName"].string != ""{
            conceptNameParsing = body["conceptName"].string!
        }else{
            conceptNameParsing = staticString().nilString()
        }
        
        
        
        if body["centerFacilities"].count > 0{
            for i in 0..<body["centerFacilities"].count {
                let facilityName =  body["centerFacilities"][i]["facilities"].string ?? staticString().nilString()
                centerFacility.append(centerFacilityModel(facilityName: facilityName))
            }
        }else{
            centerFacility.append(centerFacilityModel(facilityName: staticString().nilString()))
        }
        
        
        if body["centerTool"].count > 0{
            for i in 0..<body["centerTool"].count {
                let toolName =  body["centerTool"][i]["toolName"].string ?? staticString().nilString()
                centerToolParsing.append(centerToolModel(toolName: toolName))
            }
        }else{
            centerToolParsing.append(centerToolModel(toolName: staticString().nilString()))
        }
        //
        if body["centerGoods"].count > 0{
            for i in 0..<body["centerGoods"].count {
                let goodsName =  body["centerGoods"][i]["goodsName"].string ?? staticString().nilString()
                let goodsPrice =  body["centerGoods"][i]["goodsPrice"].string ?? staticString().nilString()
                let goodsOrder =  body["centerGoods"][i]["goodsOrder"].int ?? staticString().nilInt()
                let goodsType =  body["centerGoods"][i]["goodsType"].int ?? staticString().nilInt()
                
                centerGoodsParsing.append(centerGoodsModel(goodsName: goodsName, goodsPrice: goodsPrice , goodsOrder: goodsOrder , goodsType: goodsType))
            }
        }else{
            centerGoodsParsing.append(centerGoodsModel(goodsName: staticString().nilString(), goodsPrice: staticString().nilString() , goodsOrder:   staticString().nilInt() , goodsType :  staticString().nilInt()))
        }
        
        if body["centerSettingImage"].count > 0{
            for i in 0..<body["centerSettingImage"].count {
                let imageThumbUrl = imageManager().imageURLReturn(getURL: body["centerSettingImage"][i]["imageThumbUrl"].string!)
                
                let imageOrder =  body["centerSettingImage"][i]["imageOrder"].int ?? staticString().nilInt()
                
                centerSettingImageParsing.append(centerSettingImageModel(imageThumbUrl: imageThumbUrl , imageOrder : imageOrder))
            }
            centerSettingImageParsing.sort {
                $0.imageOrder < $1.imageOrder
            }
        }else{
            centerSettingImageParsing.append(centerSettingImageModel(imageThumbUrl: staticString().nilImage() , imageOrder : staticString().nilInt()))
        }
        
        return searchCenterModel(id: idParsing , centerAddress : centerAddressParsing, centerName: centerNameParsing,
                                 imageThumbUrl: imageThumbUrlParsing, centerDistance: centerDistanceParsing,
                                 detailRecentUpdate: detailRecentUpdateParsing , conceptEndurance : conceptEnduranceParsing
                                 , conceptBordering: conceptBorderingParsing , conceptName: conceptNameParsing, centerFacility: centerFacility
                                 , centerTool : centerToolParsing ,centerGoods : centerGoodsParsing,
                                 centerSettingImage : centerSettingImageParsing , lastIndex: lastIndexParsing , page : searchPage)
        
    }
    
    
    func kmGetThird(doubleNumber : Double) -> String{
        
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor         // 형식을 버림으로 지정
        numberFormatter.minimumSignificantDigits = 3  // 자르길 원하는 자릿수
        
        guard let floorNumber = numberFormatter.string(from: NSNumber(value: doubleNumber)) else { return "-1" }
        return "\(floorNumber)"
        
    }
    
    func facilityItemCheck(facilityItem : [facilityModel]) -> Bool{
        var check = false
        for i in 0..<facilityItem.count{
            if( facilityItem[i].checked){
                check = true
            }
        }
        
        return check
    }
    
    func facilityToolCheck(facilityTool : [facilityToolModel]) -> Bool{
        var check = false
        for i in 0..<facilityTool.count{
            if( facilityTool[i].checked){
                check = true
            }
        }
        
        return check
    }
    
}


struct searchResultSolt {
    
    let typeString = ["볼더링","지구력","밸런스"]
    
    //검색리스트 디폴트값 -> 검색기 카카오 검색 기준으로 키워드에대한 값을 전부 저장하고있음
    @Binding var searchListDefault : [searchCenterModel]
    //필터링과 정렬이 완료된 전체 리스트
    @Binding var searchList : [searchCenterModel]
    //실질적으로 리스트에서 사용하는리스트
    @Binding var searchListTemp : [searchCenterModel]
    //리스트에 해당 아이템이 몇번째 페이지인지를 표시해주기위해 사용하는값
    @Binding var searchPage : Int
    //필터를 거치고난후의 리스트의 총갯수
    @Binding var totalCount : Int
    //페이징을통해 보여주기전 리스트의 총 수
    @Binding var listCount : Int
    //현재 페이징이 어디까지 보여지는지 확인하기 위한 값
    @Binding var pagingCount : Int
    //현재 네트워크를 사용하기 있는지 체크
    @Binding var networking : Bool
    //필터를 세팅하고있는지 체크 검색이 끝나면 false로 변하게하기위해 바인딩시킴
    @Binding var filterSetting : Bool
    //편의시설의 필터값이 저장되어있는배열
    @Binding var facilityItem : [facilityModel]
    //도구의 필터값이 저장되어있는 배열
    @Binding var facilityToolItem : [facilityToolModel]
    //현재 어떤상품을 선택해 가격필터를 걸었는지 확인하는코드
    @Binding var selectgoodsType : Int
    //최소값 startIndexCount * 10000
    @Binding var startIndexCount : Int
    //최대값 endIndexCount * 10000
    @Binding var endIndexCount : Int
    
    //정렬에 관련된 로직 정렬쪽문제가 생긴다면 이쪽을 보는게 가장 최우선이다.
    func sortList(firstFilter : Int , secFilter : Int){
        //페이징관련인트들을 초기화해주고
        self.searchPage = 1
        self.pagingCount = 15
        //searchListDefault 고유 리스트를 제외한 나머지 리스트의 아이템을 삭제한다.
        
        self.searchListTemp.removeAll()
        self.searchList.removeAll()
        
        //그리고 고유리스트를 복사한후
        self.searchList = self.searchListDefault
        
        
        //가격에대한 필터링이 존재할경우
        if(self.selectgoodsType != 0){
            //해당 유형의 상품을 판매하는지 우선적으로 걸러내고
            self.searchList = self.searchList.filter{
                $0.centerGoods.contains(where: { $0.goodsType == self.selectgoodsType})
            }
            self.searchList = self.searchList.filter{
                //해당상품의 인덱스를 찾아내 해당상품의 가격을 비교한다.
                //$0.centerGoods.firstIndex(where: { $0.goodsType == self.selectgoodsType })! 인덱스를 찾는함수
                // ! 가 들어간이유는 상단에서 해당상품이 없다면 리스트에서 삭제하도록 로직을 생성함
                Int($0.centerGoods[$0.centerGoods.firstIndex(where: { $0.goodsType == self.selectgoodsType })!].goodsPrice) ?? 0 >= self.startIndexCount * 10000 &&
                    Int($0.centerGoods[$0.centerGoods.firstIndex(where: { $0.goodsType == self.selectgoodsType })!].goodsPrice) ?? 0 <= self.endIndexCount * 10000
            }
        }
        
        //도구의 필터수 만큼 for문을 돌리는데
        //해당 도구를 필터링 체크를 하였을경우에만 필터링에 들어간다.
        for i in 0..<self.facilityItem.count {
            if(self.facilityItem[i].checked){
                self.searchList = self.searchList.filter{ $0.centerFacility.contains(centerFacilityModel(facilityName: self.facilityItem[i].name)) == true}
            }
        }
        
        
        
        //도구의 필터수 만큼 for문을 돌리는데
        //해당 도구를 필터링 체크를 하였을경우에만 필터링에 들어간다.
        for i in 0..<self.facilityToolItem.count {
            if(self.facilityToolItem[i].checked){
                self.searchList = self.searchList.filter{ $0.centerTool.contains(centerToolModel(toolName: self.facilityToolItem[i].name)) == true}
            }
        }
        
        
        
        //0번이 정확도  1번에 업데이트 2번이 거리순
        if(firstFilter == 0){
            
        }else if(firstFilter == 1){
            self.searchList.sort {
                $1.detailRecentUpdate < $0.detailRecentUpdate
            }
        }else if(firstFilter == 2){
            self.searchList.sort {
                $0.centerDistance < $1.centerDistance
            }
        }
        
        
        //조건없음
        if(secFilter == 0){
            
        }
        //볼더링
        else if(secFilter == 1){
            //볼더링 리스트
            let boardList = self.searchList.filter(){$0.conceptName == self.typeString[0]}
            //지구력 리스트
            let enduranceList = self.searchList.filter(){$0.conceptName == self.typeString[1]}
            //밸런스 리스트
            let balanceList = self.searchList.filter(){$0.conceptName == self.typeString[2]}
            
            self.searchList.removeAll()
            
            self.searchList += boardList
            
            self.searchList += enduranceList
            
            self.searchList += balanceList
            
        }
        //지구력
        else if(secFilter == 2){
            //볼더링 리스트
            let boardList = self.searchList.filter(){$0.conceptName == self.typeString[0]}
            //지구력 리스트
            let enduranceList = self.searchList.filter(){$0.conceptName == self.typeString[1]}
            //밸런스 리스트
            let balanceList = self.searchList.filter(){$0.conceptName == self.typeString[2]}
            
            self.searchList.removeAll()
            
            self.searchList += enduranceList
            
            self.searchList += balanceList
            
            self.searchList += boardList
            
        }
        //밸런스
        else if(secFilter == 3){
            //볼더링 리스트
            let boardList = self.searchList.filter(){$0.conceptName == self.typeString[0]}
            //지구력 리스트
            let enduranceList = self.searchList.filter(){$0.conceptName == self.typeString[1]}
            //밸런스 리스트
            let balanceList = self.searchList.filter(){$0.conceptName == self.typeString[2]}
            
            self.searchList.removeAll()
            
            self.searchList += balanceList
            
            self.searchList += boardList
            
            self.searchList += enduranceList
        }
        
        self.totalCount = self.searchList.count
        
        let pagingIndex = self.totalCount / 15
        
        //페이징카운트가 1이상일경우
        if(pagingIndex>0){
            //0번부터 인덱스를 재정렬한다.
            for i in 1..<pagingIndex + 1{
                for j in (i-1) * 15..<i*15{
                    self.searchList[j].page = i
                    if(j == (i*15 - 1)){
                        self.searchList[j].lastIndex = true
                    }
                    else{
                        self.searchList[j].lastIndex = false
                    }
                }
                
                
                if(pagingIndex ==  i){
                    if((pagingIndex * 15) < self.totalCount){
                        for i in (pagingIndex * 15)..<self.totalCount{
                            self.searchList[i].lastIndex = false
                            self.searchList[i].page = pagingIndex + 1
                        }
                    }
                }
            }
        }
        else{
            for i in 0..<self.searchList.count {
                self.searchList[i].page = 1
                
                if(i == 14){
                    self.searchList[i].lastIndex = true
                }
            }
        }
        
        if(self.totalCount > 15){
            for i in 0..<15{
                self.searchListTemp.append(self.searchList[i])
            }
            self.listCount = 15
        }else{
            self.searchListTemp = self.searchList
            self.listCount = self.totalCount
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[2]) {
            self.networking = false
            self.filterSetting = false
        }
        
    }
}

struct searchClearViewModel {
    
    @Binding var searchListDefault : [searchCenterModel]
    @Binding var searchList : [searchCenterModel]
    @Binding var searchListTemp : [searchCenterModel]
    @Binding var searchEnd : Bool
    @Binding var searchPage : Int
    @Binding var totalCount : Int
    @Binding var listCount : Int
    @Binding var pagingNetwork : Bool
    @Binding var pagingCount : Int
    @Binding var firstFilterNumber : Int
    @Binding var secFilterNumber : Int
    @Binding var networking : Bool
    
    //파리미터 클리어한후 검색조건에 맞춰 실행하는 함수
    func searchParameterClearAndSearch(searchKeyword : String){
        
        self.networking = true
        
        
        self.searchListDefault.removeAll()
        self.searchList.removeAll()
        self.searchListTemp.removeAll()
        //검색종료가 아니라고 알려주고
        self.searchEnd = false
        //기본셋팅값을 기본값으로 되돌린다.
        self.searchPage = 1
        self.totalCount = 0
        self.listCount = 0
        self.pagingNetwork = false
        self.pagingCount = 15
        self.firstFilterNumber = 0
        self.secFilterNumber = 0
        
        DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
            searchResultViewModel().getSearchList(searchKeyword: searchKeyword){
                result , error in
                
              
                
                if(error.errorCheck){
                    DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                        alertManager().alertView(title: "통신오류", reason: error.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                        self.networking = false
                    }
                }else{
                    
                    //검색결과리스트가 총 갯수임
                    self.searchListDefault = result!
                    self.searchList = result!
                    
               
                    self.totalCount = result!.count
                    //총갯수가 15보다 큰경우 페이징을위해 리스트카운트를 15로 제한을두고
                    if(self.totalCount > 15){
                        for i in 0..<15{
                            self.searchListTemp.append(self.searchList[i])
                        }
                        self.listCount = 15
                    }else{
                        self.searchListTemp = self.searchList
                        self.listCount = self.totalCount
                    }
                    self.searchEnd = true
                    
                    
                
                    
                    DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                        self.networking = false
                    }
                }
            }
        }
    }
    
}
