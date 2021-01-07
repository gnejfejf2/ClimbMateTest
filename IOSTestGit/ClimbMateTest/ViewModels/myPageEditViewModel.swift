//
//  classMyPageEditViewModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/21.
//

import SwiftUI

class myPageEditViewModel: ObservableObject {
    
    
    
    
    //로그아웃하는코드
    func logout(completion: @escaping(networkErrorModel) -> ()){
        
        if(networkManager().accessKeyCheck().errorCheck){
            return completion(networkManager().accessKeyCheck())
        }else{
            let reqBody = accessKey(accessKey:  "\(UserDefaults.standard.string(forKey: "accessKey")!)")
            let encoder = JSONEncoder()
            let reqBodyJson = try? encoder.encode(reqBody)
            
            //로그인 코드 넣어야하고
            let parameterData=networkManager().reqParameterMake(reqCode: "901", reqBody: reqBodyJson)
            
            
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
                            UserDefaults.standard.removeObject(forKey: "accessKey")
                            UserDefaults.standard.removeObject(forKey: "exp")
                            UserDefaults.standard.removeObject(forKey: "userEmail")
                            UserDefaults.standard.removeObject(forKey: "userNickname")
                            UserDefaults.standard.removeObject(forKey: "userId")
                            UserDefaults.standard.removeObject(forKey: "userPlatform")
                            
                            
                            return completion(networkErrorModel(errorCheck: false))
                        }else{
                            return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                    }
                }
                
            }else{
                return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
            }
        }
    }
    
    func mypageEdit(userNickname : String , userProfileImageUrl : String , userInfo : String , userPass : String ,completion: @escaping(networkErrorModel) -> ()){
        if(networkManager().accessKeyCheck().errorCheck){
            return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }else{
            var reqBodyJson : Data
            let encoder = JSONEncoder()
            
            if(userPass == ""){
                let reqBody = userEdit(accessKey: userData().returnUserData(index: 0)!, userNickname: userNickname, userProfileImageUrl: userProfileImageUrl, userInfo: userInfo)
                
                reqBodyJson = try! encoder.encode(reqBody)
            }
            else{
                let reqBody = userEditWithPass(accessKey: userData().returnUserData(index: 0)!, userNickname: userNickname, userProfileImageUrl: userProfileImageUrl, userInfo: userInfo , userPassword : userPass )
                
                reqBodyJson = try! encoder.encode(reqBody)
            }
            
            
            
            
            
            //로그인 코드 넣어야하고
            let parameterData=networkManager().reqParameterMake(reqCode: "504", reqBody: reqBodyJson)
            
            
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
                            //유저 닉네임 업데이트
                            if(userNickname != ""){
                                userData().userNicknameUpdate(userNickname: userNickname)
                            }
                            //유저프로필이미지 업데이트
                            if(userProfileImageUrl != ""){
                                userData().userProfileImageUrlUpdate(userProfileImageUrl: userProfileImageUrl)
                            }
                            
                            return completion(networkErrorModel(errorCheck: false))
                        }else{
                            return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                    }
                }
            }
        }
    }
    
    
    
    
    func userQuitTry(pass : String ,completion: @escaping(networkErrorModel) -> ()){
        
        if(networkManager().accessKeyCheck().errorCheck){
            return completion(networkManager().accessKeyCheck())
        }else{
            let reqBody = userQuit(accessKey:  "\(UserDefaults.standard.string(forKey: "accessKey")!)" , userPassword: pass)
            let encoder = JSONEncoder()
            let reqBodyJson = try? encoder.encode(reqBody)
            
            //로그인 코드 넣어야하고
            let parameterData=networkManager().reqParameterMake(reqCode: "510", reqBody: reqBodyJson)
            
            
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
                            return completion(networkErrorModel(errorCheck: false))
                        }else{
                            return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                    }
                }
            }else{
                return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
            }
        }
    }
    
    
}


struct mypageEditCheck {
    
    @Binding var imageURL : String
    
    @Binding var imageChange : Bool
    
    @Binding var imageNetwoking : Bool
    
    @Binding var nickName : String
    
    @Binding var userPass : String
    
    @Binding var passwordRegCheck : Bool
    
    @Binding var passChanger : Bool
    
    func editCheck(){
        
        self.imageNetwoking = true
        
        var changeNickname : String = ""
        var changeUserProfileImageUrl : String = ""
        var changeUserPass : String = ""
        //우선 닉네임 형식에 맞아야하고 닉네임을 변경했는지를 체크해야한다.
        if !signUPViewModel().nicknameCkeck(mynickname: self.nickName){
            self.imageNetwoking = false
            alertManager().alertView(title: staticString().staticSettingTitleReturn(index: 4), reason: staticString().staticSettingMessageReturn(index: 4))
            
        }else if (passwordRegCheck){
            
            self.imageNetwoking = false
            alertManager().alertView(title: staticString().staticSettingTitleReturn(index: 5), reason: staticString().staticSettingMessageReturn(index: 5))
            
        }
        else {
            if self.nickName != userData().returnUserData(index: 4) {
                changeNickname = self.nickName
            }
            if(self.imageURL != "" && self.imageChange){
                changeUserProfileImageUrl = self.imageURL
            }
            
            if(self.userPass != ""){
                changeUserPass = self.userPass
            }
            
            
            
            //서버에서 변경시 닉네임이 null이라면 파라미터가 없다고 나오기때문에 현재 닉네임을 채워서 넣어준다.
            if(changeNickname == ""){
                //닉네임이 없는경우는 없기떄문에 !를 붙여준다.
                changeNickname = userData().returnUserData(index: 4)!
            }
            if(changeUserProfileImageUrl == ""){
                changeUserProfileImageUrl = userData().returnUserData(index: 10) ?? ""
            }
            
            
            myPageEditViewModel().mypageEdit(userNickname: changeNickname, userProfileImageUrl: changeUserProfileImageUrl, userInfo: "" , userPass: changeUserPass){
                result in
                if(result.errorCheck){
                    alertManager().alertView(title: "정보변경", reason: result.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                }else{
                    alertManager().alertView(title: "정보변경", reason: "정보가 변경되었습니다.")
                }
                
                self.passChanger = false
                self.imageNetwoking = false
            }
        }
    }
    
    
}

//토글스위치에서 true false 를 리턴하는함수 Binding을 정의하고 결과값을 리턴한다
extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
