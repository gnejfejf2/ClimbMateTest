//
//  loginViewManager.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/16.
//
import Foundation
import SwiftUI
import SwiftyJSON
import Firebase

class loginViewModel : ObservableObject {
    
    let loginErrorReason : String = "로그인에 실패하였습니다. 다시한번 시도해주세요"
    //자체서버 로그인에서 사용하는코드이다
    //클라이메이트 서버에 이메일과 패스워드 플랫폼형식 -> 자체로그인은 "1" 을 보내
    //엑세스키를 받은후
    //엑세스키를 받은다면 자동로그인 코드를실행시켜 유저정보를 받아와 유저정보를 저장한다.
    func login(email: String , password : String , platform : String , completion: @escaping(networkErrorModel) -> ()){
  
        if(platform == "1"){
            Analytics.logEvent("자체로그인", parameters: [

                       "platform": platform as NSObject,

                       "full_text": "firstTest" as NSObject

                       ])
        }else if(platform == "2"){
            Analytics.logEvent("카카오로그인", parameters: [

                       "platform": platform as NSObject,

                       "full_text": "firstTest" as NSObject

                       ])
        }
        
        
        let reqBody = loginModel(userEmail: email, userPassword: password , userPlatform : platform)
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        //로그인 코드 넣어야하고
        let parameterData=networkManager().reqParameterMake(reqCode: "501", reqBody: reqBodyJson)
        
        
        if(parameterData != nil){
            //네트워크매니저에 포스트형식으로 통신을 요청한다.
            //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
            //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
            networkManager().Post(requestURL: 0, requestData:parameterData){
                reqData,reqError in
                if(reqError.errorCheck == true){
                    return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    
                }
                else{
                    if(reqData!.resCode == "200"){
                        
                        
                        guard reqData!.resBody[0]["accessKey"].string != nil else {
                            return completion(networkErrorModel(errorCheck: false, networkErrorReason: self.loginErrorReason))
                        }
                        
                       
                        //엑세스키 저장
                        UserDefaults.standard.set("\(reqData!.resBody[0]["accessKey"])" , forKey: "accessKey")
                        
                        
                        self.autoLogin(){
                            result in
                            if(result.errorCheck){
                                return completion(networkErrorModel(errorCheck: true , networkErrorReason : result.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                            }else{
                                return completion(result)
                            }
                            
                        }
                    }else{
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
            }
            
        }else{
            
            return completion(networkErrorModel(errorCheck: true, networkErrorReason:  staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
    }
    
    //추후에 통신되면 사용할코드
    func autoLogin(completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = accessKey(accessKey:  UserDefaults.standard.string(forKey: "accessKey") ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
        let encoder = JSONEncoder()
        
       
        let reqBodyJson = try? encoder.encode(reqBody)
        
        //자동로그인코드
        let parameterData=networkManager().reqParameterMake(reqCode: "502", reqBody: reqBodyJson)
        
        
        if(parameterData != nil){
            //네트워크매니저에 포스트형식으로 통신을 요청한다.
            //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
            //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
            networkManager().Post(requestURL: 0, requestData:parameterData){
                reqData,reqError in
                
               if(reqError.errorCheck == true){
                    return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                }
                else{
                    if(reqData!.resCode == "200"){
                        userData().userInformationSet(userData: reqData!.resBody[0])
                        if(reqData!.resBody[0]["userAccountStatus"] == "2"){
                            return completion(networkErrorModel(errorCheck: false , networkErrorReason :"change"))
                        }else{
                            return completion(networkErrorModel(errorCheck: false , networkErrorReason :""))
                        }
                    }else{
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                }
            }
            
        }else{
            return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
    }
    
    

}


