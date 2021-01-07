//
//  loginViewManager.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/16.
//
import Foundation
import SwiftUI

class signUPViewModel : ObservableObject {
  
    
    //이메일확인요청코드
    //실패시 false와 실패이유를 리턴한다.
    func emailCertification(email: String , completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = certificationEmailModel(certificationEmail : email)
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        //로그인 코드 넣어야하고
        let parameterData=networkManager().reqParameterMake(reqCode: "900", reqBody: reqBodyJson)
        
        
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
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
            }
            
        }else{
           
            return completion(networkErrorModel(errorCheck: true, networkErrorReason:  staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
    }
    
    //이메일확인 재요청코드
    //실패시 false와 실패이유를 리턴한다.
    func emailCertificationRetry(email: String , completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = certificationEmailModel(certificationEmail : email)
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        //로그인 코드 넣어야하고
        let parameterData=networkManager().reqParameterMake(reqCode: "902", reqBody: reqBodyJson)
        
        
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
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
            }
            
        }else{
           
            return completion(networkErrorModel(errorCheck: true, networkErrorReason:  staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
    }
    
    
    //이메일확인코드를 확인하는 코드
    //실패시 false와 실패이유를 리턴한다.
    func certificationEmailCheck(email: String , code : String, completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = certificationEmailCheckModel(certificationEmail : email , certificationCode : code)
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
                        return completion(networkErrorModel(errorCheck: false))
                    }else{
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))) }
                }
            }
            
        }else{
            return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
    }
    
    //회원가입 요청코드
    //실패시 false와 실패이유를 리턴한다.
    //현재 유저플랫폼을 1로 고정해놨지만 추후에 변경될예정
    func registerTry(email : String , password : String , nickname : String  , certificationCode : String , completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = registerModel(userNickname: nickname, userPassword: password, userEmail: email, userPlatform: "1" , certificationCode: certificationCode)
        
         
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        let parameterData=networkManager().reqParameterMake(reqCode: "500", reqBody: reqBodyJson)
        
        
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
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))}
                }
            }
            
        }else{
         
            return completion(networkErrorModel(errorCheck: true, networkErrorReason: staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
        
    }
    

    
    //이메일 정규식 체크
    func textFieldValidatorEmail(string : String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }

    //패스워드 정규식 체크 영어 숫자 특수문자를 최소 1글자씩 포함해야하고 글자수는 8~16 글자
    //그이외의값이 넘어온다면 false
    func passwordCheck(mypassword : String) -> Bool {
        //숫자+문자+특수문자 포함하는지체크
        let passwordRegInclude = ("(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!\"#$%&'()*+,-./:;<=>?@[＼]^_`{|}~]).{8,16}")
        let passwordIncludeTesting = NSPredicate(format: "SELF MATCHES %@", passwordRegInclude)
        
        //각각의 글자들이 해당하는 글자들만 들어있는지 체크하는 코드
        let passwordRegException = ("[A-Z0-9a-z!\"#$%&'()*+,-./:;<=>?@[＼]^_`{|}~]{0,12}")
        
        let passwordExceptionTesting = NSPredicate(format: "SELF MATCHES %@", passwordRegException)
       
        if(!passwordIncludeTesting.evaluate(with: mypassword) || !passwordExceptionTesting.evaluate(with: mypassword)){
            return false
        }else{
            return true
        }
    }
    
    //닉네임 정규식
    //허용하지않은 값이 들어온다면 false를 리턴
    func nicknameCkeck(mynickname : String) -> Bool{
        
        //각각의 글자들이 해당 특수기호
        let passwordreg = ("[A-Z0-9a-z가-힣!\"#$%&'()*+,-./:;<=>?@[＼]^_`{|}~]{1,12}")
        
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        
       
        return passwordtesting.evaluate(with: mynickname)
    }
    
    
    
}
 
