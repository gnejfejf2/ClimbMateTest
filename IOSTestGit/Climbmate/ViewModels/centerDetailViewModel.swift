import Foundation
import SwiftyJSON
import SwiftUI
import Firebase

class centerDetailViewModel : ObservableObject {
    
    
    
    //    @State var center : centerModel
    //
    func getCenterDetailinformation(centerID : String , clickType : Int , completion: @escaping(centerDetailModel) -> ()){
        //들어온경로
        //1번 근처 클라이밍장
        //2번 최근 업데이트된 클라이밍장
        //3번 즐겨찾기
        //4번 검색
        if(clickType == staticString().staticClickType[0]){
            Analytics.logEvent("디테일페이지", parameters: [
                       "clickType": "근처 클라이밍장" as NSObject,
                       "centerID": centerID as NSObject
                       ])
        }else if(clickType == staticString().staticClickType[1]){
            Analytics.logEvent("디테일페이지", parameters: [
                       "clickType": "최근 업데이트된 클라이밍장" as NSObject,
                       "centerID": centerID as NSObject
                       ])
        }else if(clickType == staticString().staticClickType[2]){
            Analytics.logEvent("디테일페이지", parameters: [
                       "clickType": "즐겨찾기" as NSObject,
                       "centerID": centerID as NSObject
                       ])
        }else if(clickType == staticString().staticClickType[3]){
            Analytics.logEvent("디테일페이지", parameters: [
                       "clickType": "검색" as NSObject,
                       "centerID": centerID as NSObject
                       ])
        }else if(clickType == staticString().staticClickType[4]){
            Analytics.logEvent("디테일페이지", parameters: [
                       "clickType": "푸쉬알림" as NSObject,
                       "centerID": centerID as NSObject
                       ])
        }
        
        
        // 통신에 필요한 바디를 만든다.
        var reqBody : centerDetailNetWorkReqModel
        
        if(networkManager().accessKeyCheck().errorCheck){
            reqBody = centerDetailNetWorkReqModel(id: centerID , accessKey: "")
        }
        else{
            reqBody = centerDetailNetWorkReqModel(id: centerID , accessKey: userData().returnUserData(index: 0)!)
        }
        
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        //데이터 통신을 위해 실행하는곳
        //데이터 통신폼으로 변경 임시코드
        let parameterData=networkManager().reqParameterMake(reqCode: "103", reqBody: reqBodyJson)
        if(parameterData != nil){
            //네트워크매니저에 포스트형식으로 통신을 요청한다.
            //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
            //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
            networkManager().Post(requestURL: 0, requestData:parameterData){
                reqData,reqError in
                
              
                if(reqError.errorCheck == true){
                    alertManager().alertView(title: "통신오류", reason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                }
                else{
                    if reqData != nil{
                        var subscription : String = "2"
                        
                        let makedCenterInformation = self.centerDetailInformationMake(reqData: reqData!.resBody[0]["centerDetail"][0])
                        var makedCenterBannerImages =  self.makeCenterBannerImageModel(reqData: reqData!.resBody)
                        let makedCenterFacilities = self.makeCenterFacility(reqData: reqData!.resBody)
                        var makedCenterGoods = self.makeCenterGooods(reqData: reqData!.resBody)
                        var makedCenterSchedules = self.makeCenterSchedule(reqData: reqData!.resBody)
                        var makedCenterSettings = self.makeCenterSetting(reqData: reqData!.resBody)
                        let makedCenterTools = self.makeCenterTool(reqData: reqData!.resBody)
                        let makedCenterComments = self.makeCenterComment(reqData: reqData!.resBody)
                        let makedCenterNotices = self.makeCenterNotice(reqData: reqData!.resBody)
                        if(reqData!.resBody[0]["subscription"].string != nil){
                            subscription = reqData!.resBody[0]["subscription"].string!
                        }else{
                            subscription = "2"
                        }
                        
                        //비어있는 배열의 오류를 없애주기위해 하나라도 채워넣는코드
                        if(makedCenterBannerImages.isEmpty || makedCenterBannerImages.count == 0){
                            makedCenterBannerImages.append(centerBannerImageModel(imageThumbUrl: staticString().nilImage()))
                        }
                        if(makedCenterGoods.isEmpty || makedCenterGoods.count == 0){
                            makedCenterGoods.append(centerGoodsModel(goodsName: staticString().nilString(), goodsPrice: staticString().nilString() , goodsOrder: staticString().nilInt() , goodsType: staticString().nilInt()))
                        }
                        if(makedCenterSchedules.isEmpty || makedCenterSchedules.count == 0){
                            makedCenterSchedules.append(centerScheduleModel(scheduleDay: staticString().nilString(), scheduleTime: staticString().nilString()))
                        }
                      
                      
                       
                        
                        completion(centerDetailModel(centerDetail: makedCenterInformation , centerBannerImage: makedCenterBannerImages , centerGoods: makedCenterGoods , centerSchedules: makedCenterSchedules , centerSettings : makedCenterSettings , centerTools: makedCenterTools, centerFacilitys: makedCenterFacilities, centerComments: makedCenterComments  , centerNotices : makedCenterNotices ,subscription : subscription))
                     
                    }else{
                        
                        alertManager().alertView(title: "통신오류", reason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                    }
                }
            }
        }else{
            alertManager().alertView(title: "통신오류", reason: "센터 정보를 가져오지 못하였습니다.")
        }
    }
    
    func favoritesCenterAdd(centerID : String , completion: @escaping(networkErrorModel) -> ()){
        
        
        
        Messaging.messaging().subscribe(toTopic: centerID) { error in
            logManager().log(log: "구독성공 : \(centerID)")
        }
        
        
        //엑세스 키가 있는지 확인
        if(networkManager().accessKeyCheck().errorCheck){
            completion(networkManager().accessKeyCheck())
        }
        else{
            let reqBody = subscriptionCenterModel(accessKey: UserDefaults.standard.string(forKey: "accessKey")!, subscriptionCenterId: centerID)
            let encoder = JSONEncoder()
            let reqBodyJson = try? encoder.encode(reqBody)
            
            //로그인 코드 넣어야하고
            let parameterData=networkManager().reqParameterMake(reqCode: "505", reqBody: reqBodyJson)
            
            if(parameterData != nil){
                //네트워크매니저에 포스트형식으로 통신을 요청한다.
                //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                networkManager().Post(requestURL: 0, requestData:parameterData){
                    reqData,reqError in
                    
                    if(reqError.errorCheck == true){
                        return completion(networkErrorModel(errorCheck: false, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                    else{
                        if(reqData!.resCode == "200"){
                            return completion(networkErrorModel(errorCheck: true))
                        }else{
                            return completion(networkErrorModel(errorCheck: false, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                    }
                }
                
            }else{
                return completion(networkErrorModel(errorCheck: false, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
            }
        }
    }
    
    
    func favoritesCenterDelete(centerID : String , completion: @escaping(networkErrorModel) -> ()){
        
        Messaging.messaging().unsubscribe(fromTopic: centerID){ error in
            
            
            logManager().log(log: "구독취소 : \(centerID)")
            
        }
        
        //엑세스 키가 있는지 확인
        if(networkManager().accessKeyCheck().errorCheck){
            completion(networkManager().accessKeyCheck())
        }
        else{
            let reqBody = subscriptionCenterModel(accessKey: UserDefaults.standard.string(forKey: "accessKey")!, subscriptionCenterId: centerID)
            let encoder = JSONEncoder()
            let reqBodyJson = try? encoder.encode(reqBody)
            
            //로그인 코드 넣어야하고
            let parameterData=networkManager().reqParameterMake(reqCode: "506", reqBody: reqBodyJson)
            
            if(parameterData != nil){
                //네트워크매니저에 포스트형식으로 통신을 요청한다.
                //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
                //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
                networkManager().Post(requestURL: 0, requestData:parameterData){
                    reqData,reqError in
                    
                    if(reqError.errorCheck == true){
                        return completion(networkErrorModel(errorCheck: false, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                    else{
                        if(reqData!.resCode == "200"){
                            return completion(networkErrorModel(errorCheck: true))
                        }else{
                            return completion(networkErrorModel(errorCheck: false, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                    }
                }
                
            }else{
                return completion(networkErrorModel(errorCheck: false, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
            }
        }
    }
    
    
    
    
    func centerDetailInformationMake(reqData : JSON) -> centerDetailInformation{
        
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
        
        var detailNextUpdateParsing : String
        var detailRecentUpdateParsing : String
        
        
        
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
        
        return centerDetailInformation(id: idParsing, centerName: centerNameParsing, centerAddress: centerAddressParsing, centerNumber: centerNumberParsing, centerPhoneNumber: centerPhoneNumberParsing, centerStatus: centerStatusParsing, centerUrl: centerUrlParsing, conceptBordering: conceptBorderingParsing, conceptEndurance: conceptEnduranceParsing, locationParkingLotX: locationParkingLotXParsing, locationParkingLotY: locationParkingLotYParsing, locationInfo: locationInfoParsing, detailCenterX: detailCenterXParsing, detailCenterY: detailCenterYParsing, detailComment: detailCommentParsing, detailNextUpdate: detailNextUpdateParsing, detailRecentUpdate: detailRecentUpdateParsing)
        
    }
    
    
    
    func makeCenterBannerImageModel(reqData : [JSON]) -> [centerBannerImageModel]{
        
        var tempCenterBannerImages = [centerBannerImageModel]()
        
        var imageThumbUrlParsing : String
        
        for i in 0..<reqData[0]["centerBannerImage"].count {
            if(reqData[0]["centerBannerImage"][i]["imageThumbUrl"].string != nil){
                imageThumbUrlParsing = imageManager().imageURLReturn(getURL: reqData[0]["centerBannerImage"][i]["imageThumbUrl"].string!)
                tempCenterBannerImages.append(centerBannerImageModel(imageThumbUrl: imageThumbUrlParsing))
            }
        }
        
        return tempCenterBannerImages
    }
    
    func makeCenterFacility(reqData : [JSON]) -> [centerFacilityModel]{
        
        var tempFacility = [centerFacilityModel]()
        for i in 0..<reqData[0]["centerFacilities"].count {
            if(reqData[0]["centerFacilities"][i]["facilities"].string != nil){
                tempFacility.append(centerFacilityModel(facilityName:reqData[0]["centerFacilities"][i]["facilities"].string!))
            }else{
              
            }
        }
        return tempFacility
    }

    
    
    func makeCenterGooods(reqData : [JSON]) -> [centerGoodsModel]{
        var tempCenterGoods = [centerGoodsModel]()
        
        var goodsNameParsing : String
        var goodsPriceParsing : String
        var goodsOrderParsing : Int
        var goodsTypeParsing : Int
        
        for i in 0..<reqData[0]["centerGoods"].count {
            if(reqData[0]["centerGoods"][i]["goodsName"].string != nil){
                goodsNameParsing = reqData[0]["centerGoods"][i]["goodsName"].string!
            }else{
                goodsNameParsing = "전화를 통해 확인해 주세요."
            }
            if(reqData[0]["centerGoods"][i]["goodsPrice"].string != nil){
                goodsPriceParsing = reqData[0]["centerGoods"][i]["goodsPrice"].string!
            }else{
                goodsPriceParsing = staticString().nilString()
                
            }
            if(reqData[0]["centerGoods"][i]["goodsOrder"].string != nil){
                goodsOrderParsing = reqData[0]["centerGoods"][i]["goodsOrder"].int!
            }else{
                goodsOrderParsing = staticString().nilInt()
            }
            if(reqData[0]["centerGoods"][i]["goodsType"].string != nil){
                goodsTypeParsing = reqData[0]["centerGoods"][i]["goodsType"].int!
            }else{
                goodsTypeParsing = staticString().nilInt()
            }
            
            tempCenterGoods.append(centerGoodsModel(goodsName: goodsNameParsing, goodsPrice: goodsPriceParsing , goodsOrder: goodsOrderParsing , goodsType: goodsTypeParsing))
        }
        tempCenterGoods.sort {
            $0.goodsOrder! < $1.goodsOrder!
        }
        return tempCenterGoods
    }
    
    
    func makeCenterSchedule(reqData : [JSON]) -> [centerScheduleModel]{
        var tempCenterSchedules = [centerScheduleModel]()
        var scheduleDayParsing : String
        var scheduleTimeParsing : String
    
        for i in 0..<reqData[0]["centerSchedule"].count {
            if(reqData[0]["centerSchedule"][i]["scheduleDay"].string != nil){
                scheduleDayParsing = reqData[0]["centerSchedule"][i]["scheduleDay"].string!
            }else{
                scheduleDayParsing = "휴무"
            }
            if(reqData[0]["centerSchedule"][i]["scheduleTime"].string != nil){
                scheduleTimeParsing = reqData[0]["centerSchedule"][i]["scheduleTime"].string!
            }else{
                scheduleTimeParsing = ""
            }
            
            tempCenterSchedules.append(centerScheduleModel(scheduleDay: scheduleDayParsing, scheduleTime: scheduleTimeParsing))
        }
        
        
        return tempCenterSchedules
    }
    
    
    func makeCenterSetting(reqData : [JSON]) -> [centerSettingLevelModel]{
        var tempcenterSettingLevels = [centerSettingLevelModel]()
        var tempCenterLevel = [String]()
      
       
        
        var centerSettingImageParsing : String = staticString().nilImage()
        var centerColorParsing : String = staticString().nilString()
        var settingLevelParsing : String = staticString().nilString()
        var settingCenterDifficultyParsing : String = staticString().nilString()
       
        
       
        if(reqData[0]["centerLevel"].count > 0){
            
            for i in 0..<reqData[0]["centerLevel"].count{
                if(reqData[0]["centerLevel"][i]["settingLevel"].string != nil){
                    tempCenterLevel.append(reqData[0]["centerLevel"][i]["settingLevel"].string!)
                }
            }
        
            
            if(tempCenterLevel.count > 0){
                
                for level in tempCenterLevel{
                 
                   
                    if(reqData[0]["centerSetting"][level].count > 0){
                        var tempCenterSetting = [centerSettingModel]()
                        
                        for i in 0..<reqData[0]["centerSetting"][level].count {
                            if(reqData[0]["centerSetting"][level][i]["imageThumbUrl"].string != nil){
                                centerSettingImageParsing = imageManager().imageURLReturn(getURL: reqData[0]["centerSetting"][level][i]["imageThumbUrl"].string!)
                            }
                            if(reqData[0]["centerSetting"][level][i]["settingColor"].string != nil){
                                centerColorParsing = reqData[0]["centerSetting"][level][i]["settingLevel"].string!
                            }
                            if(reqData[0]["centerSetting"][level][i]["settingLevel"].string != nil){
                                settingLevelParsing = reqData[0]["centerSetting"][level][i]["settingLevel"].string!
                            }
                            if(reqData[0]["centerSetting"][level][i]["settingCenterDifficulty"].string != nil){
                                settingCenterDifficultyParsing = reqData[0]["centerSetting"][level][i]["settingCenterDifficulty"].string!
                            }
                          
                            
                            tempCenterSetting.append(centerSettingModel(settingColor: centerColorParsing, settingLevel: settingLevelParsing, imageThumbUrl: centerSettingImageParsing, settingCenterDifficulty: settingCenterDifficultyParsing))
                        }
                        
                        tempcenterSettingLevels.append(centerSettingLevelModel(centerLevel: level, centerSettings: tempCenterSetting))
                    }
                }
            }
            
        }
        
        
    
        return tempcenterSettingLevels
    }
    
    
    func makeCenterTool(reqData : [JSON]) -> [centerToolModel]{
        var tempCenterTools = [centerToolModel]()
        
        var toolNameParsing : String
      
        for i in 0..<reqData[0]["centerTool"].count {
            if(reqData[0]["centerTool"][i]["toolName"].string != nil){
                toolNameParsing = reqData[0]["centerTool"][i]["toolName"].string!
            }
            else{
                toolNameParsing = staticString().nilString()
            }
            
            tempCenterTools.append(centerToolModel(toolName: toolNameParsing))
        }
        
        return tempCenterTools
    }
    
    func makeCenterComment(reqData : [JSON]) -> [centerCommentModel]{
        var tempCenterComments = [centerCommentModel]()
        
        var commentDateParsing : String = staticString().nilString()
        var commentNickNameParsing : String = staticString().nilString()
        var commentSettingIdParsing : String = staticString().nilString()
        var commentUserIdParsing : String = staticString().nilString()
        var commentURLParsing : String = staticString().nilString()
        var imageThumbUrlParsing : String = staticString().nilImage()
  
   
        var userProfileImageUrlParsing : String = staticString().nilImage()
        for i in 0..<reqData[0]["centerComment"].count {
            if(reqData[0]["centerComment"][i]["commentDate"].string != nil){
                commentDateParsing = reqData[0]["centerComment"][i]["commentDate"].string!
            }
            if(reqData[0]["centerComment"][i]["commentNickName"].string != nil){
                commentNickNameParsing = reqData[0]["centerComment"][i]["commentNickName"].string!
            }
            if(reqData[0]["centerComment"][i]["commentSettingId"].string != nil){
                commentSettingIdParsing = reqData[0]["centerComment"][i]["commentSettingId"].string!
            }
            if(reqData[0]["centerComment"][i]["commentUserId"].string != nil){
                commentUserIdParsing = reqData[0]["centerComment"][i]["commentUserId"].string!
            }
            
            if(reqData[0]["centerComment"][i]["imageThumbUrl"].string != nil){
                imageThumbUrlParsing = imageManager().imageURLReturn(getURL: reqData[0]["centerComment"][i]["imageThumbUrl"].string!)
            }
            
            if(reqData[0]["centerComment"][i]["userProfileImageUrl"].string != nil){
                userProfileImageUrlParsing = imageManager().imageURLReturn(getURL: reqData[0]["centerComment"][i]["userProfileImageUrl"].string!)
            }
            if(reqData[0]["centerComment"][i]["commentUrl"].string != nil){
                commentURLParsing = reqData[0]["centerComment"][i]["commentUrl"].string!
            }
            
            tempCenterComments.append(centerCommentModel(commentDate: commentDateParsing, commentNickName: commentNickNameParsing, commentSettingId: commentSettingIdParsing, commentUserId: commentUserIdParsing, commentURL : commentURLParsing , imageThumbUrl: imageThumbUrlParsing ,  userProfileImageUrl: userProfileImageUrlParsing))
        }
        
    
        return tempCenterComments
    }
    
    func makeCenterNotice(reqData : [JSON]) -> [centerNoticeModel]{
        var tempCenterNotices = [centerNoticeModel]()
    
        var noticeCenterIdParsing : String = staticString().nilString()
        var noticeDateParsing : String = staticString().nilString()
        var noticeTitleParsing : String = staticString().nilString()
        var noticeDetailParsing : String = staticString().nilString()
        var noticeUrlParsing : String = staticString().nilImage()
        var noticeImageUrlParsing : String = staticString().nilImage()
        
        for i in 0..<reqData[0]["centerNotice"].count {
            if(reqData[0]["centerNotice"][i]["noticeCenterId"].string != nil){
                noticeCenterIdParsing = reqData[0]["centerNotice"][i]["noticeCenterId"].string!
            }
            if(reqData[0]["centerNotice"][i]["noticeDate"].string != nil){
                noticeDateParsing = reqData[0]["centerNotice"][i]["noticeDate"].string!
            }
            if(reqData[0]["centerNotice"][i]["noticeTitle"].string != nil){
                noticeTitleParsing = reqData[0]["centerNotice"][i]["noticeTitle"].string!
            }
            if(reqData[0]["centerNotice"][i]["noticeDetail"].string != nil){
                noticeDetailParsing = reqData[0]["centerNotice"][i]["noticeDetail"].string!
            }
            
            if(reqData[0]["centerNotice"][i]["noticeUrl"].string != nil){
                noticeUrlParsing = reqData[0]["centerNotice"][i]["noticeUrl"].string!
            }
            
            if(reqData[0]["centerNotice"][i]["noticeImageUrl"].string != nil){
                noticeImageUrlParsing = imageManager().imageURLReturn(getURL: reqData[0]["centerNotice"][i]["noticeImageUrl"].string!)
                
                
            }
         
            
            tempCenterNotices.append(centerNoticeModel(noticeCenterId: noticeCenterIdParsing, noticeDate: noticeDateParsing, noticeTitle: noticeTitleParsing, noticeDetail: noticeDetailParsing, noticeUrl: noticeUrlParsing, noticeImageUrl: noticeImageUrlParsing))
        }
        
        
        return tempCenterNotices
    }
    
    
    
    func actionSheetShareURL(centerID : String) {
         guard let data = URL(string: staticString().staticDetailURLReturn(centerID: centerID)) else {
            print(staticString().staticDetailURLReturn(centerID: centerID))
            print("빽턴")
            return
         }
         let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
      
         UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
     }
    
}

struct BlurBG : UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}





