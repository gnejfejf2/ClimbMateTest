//
//  kakaoViewModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/03.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class kakaoViewModel {
    
    //체크 스트링
    let kakaoErrorReason : String = "100"
    //카카오로그인
    //클라이언트기준
    //카카오서버 로그인 성공시
    //카카오서버에서 받은 UUID 와 이메일로 로그인요청을 시도한다
    //로그인이 성공한다면 기존에 로그인을 진했했던 유저이기때문에
    //정상적으로 access코드를 발급받고
    //서버에서 500 코드와 100 이라는 이유를 받는다면
    //가입이 되어있지 않은 유저이기때문에 해당유저는 추가정보 기입란을 띄어준다.
    func kakaoLogin(platform : String , completion: @escaping(Int , String? , String? , String?) -> ()){
        
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if error != nil {
                    completion(1,error?.localizedDescription,nil,nil)
                }
                else {
                    
                    UserApi.shared.me() {(user, error) in
                        if error != nil {
                            completion(1,error?.localizedDescription,nil,nil)
                        }
                        else {
                            guard String(user!.id) != "" else {
                                completion(1,"카카오로그인 오류",nil,nil)
                                return
                            }
                            //이메일이 공백
                            guard user!.kakaoAccount!.email != nil else {
                                self.kakaoUnlink()
                                completion(1,"카카오로그인 오류",nil,nil)
                                return
                            }
                            
                            
                            
                            loginViewModel().login(email : user!.kakaoAccount!.email!, password : String(user!.id) , platform : platform){
                                result in
                                
                                if(!result.errorCheck){
                                    //정상적으로 로그인이 된상태
                                    completion(3,nil,nil,nil)
                                }else{
                                    //카카오로그인은 정상적으로 진행되었지만 아직 클라이메이트서버 DB에 해당유저의
                                    //정보가 없는경우 추가정보 기입란 페이지로 이동시켜주어야함
                                    if(result.networkErrorReason == self.kakaoErrorReason){
                                        completion(2,user!.kakaoAccount!.email,String(user!.id),String(user?.properties?["nickname"] ?? ""))
                                    }
                                    else{
                                        //단순히 오류가뜸
                                        completion(1,result.networkErrorReason,nil,nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else{
            
                AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if error != nil {
                        completion(1,error?.localizedDescription,nil,nil)
                    }
                    else {
                        
                        UserApi.shared.me() {(user, error) in
                            if error != nil {
                                completion(1,error?.localizedDescription,nil,nil)
                            }
                            else {
                                guard String(user!.id) != "" else {
                                    completion(1,"카카오로그인 오류",nil,nil)
                                    return
                                }
                                //이메일이 공백
                                guard user!.kakaoAccount!.email != nil else {
                                    self.kakaoUnlink()
                                    completion(1,"카카오로그인 오류",nil,nil)
                                    return
                                }
                                
                                
                                
                                loginViewModel().login(email : user!.kakaoAccount!.email!, password : String(user!.id) , platform : platform){
                                    result in
                                    
                                    if(!result.errorCheck){
                                        //정상적으로 로그인이 된상태
                                        completion(3,nil,nil,nil)
                                    }else{
                                        //카카오로그인은 정상적으로 진행되었지만 아직 클라이메이트서버 DB에 해당유저의
                                        //정보가 없는경우 추가정보 기입란 페이지로 이동시켜주어야함
                                        if(result.networkErrorReason == self.kakaoErrorReason){
                                            completion(2,user!.kakaoAccount!.email,String(user!.id),String(user?.properties?["nickname"] ?? ""))
                                        }
                                        else{
                                            //단순히 오류가뜸
                                            completion(1,result.networkErrorReason,nil,nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            
        }
    }
    
    
    //카카오톡으로로그인으로 가입요청을한다
    //카카오톡으로 가입요청을 할경우 닉네임은 입력을 받을예정이고
    //이메일은 카카오톡에서 제공해주는 이메일을 사용할예정이다.
    //certificationCode는 사용하지않지만 기존 회원가입모델을 사용하기때문에
    //그대로 nil이라는 공백스트링을 넣어서 전달한다.
    
    func registerTryKakao(email : String , password : String , nickname : String , completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = registerModel(userNickname: nickname, userPassword: password, userEmail: email, userPlatform: "2" , certificationCode: "nil")
        
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        let parameterData=networkManager().reqParameterMake(reqCode: "500", reqBody: reqBodyJson)
        
        if(parameterData != nil){
            networkManager().Post(requestURL: 0, requestData:parameterData){
                reqData,reqError in
                if(reqError.errorCheck == true){
                    return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                }
                else{
                    if(reqData!.resCode == "200"){
                        loginViewModel().login(email: email, password: password, platform: "2"){
                            result in
                            if(!result.errorCheck){
                                completion(networkErrorModel(errorCheck: false, networkErrorReason: "성공"))
                            }else{
                                completion(networkErrorModel(errorCheck: true, networkErrorReason: result.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                            }
                        }
                    }else{
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))}
                }
            }
            
        }else{
            
            return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
        
    }
    
    /// <#Description#>
    func kakaoLogout(){
        UserApi.shared.logout {(error) in
            if let error = error {
                logManager().log(log : error.localizedDescription)
            }
            else {
                logManager().log(log : "logout() success.")
                
            }
        }
    }
    
    func kakaoUnlink(){
        UserApi.shared.unlink {(error) in
            if let error = error {
                logManager().log(log : error.localizedDescription)
            }
            else {
                
            }
        }
    }
    
}
