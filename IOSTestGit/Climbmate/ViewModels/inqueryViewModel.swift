

import Foundation

class inqueryViewModel {
    
    //questionContent
    /// <#Description#>
    /// - Parameters:
    ///   - questionContent: 유저의 불만사항
    ///   - questionContact: 유저의 접촉받을 아이디 , 이메일 , 전화번호 등
    /// - Returns networkErrorModel errorCheck -> false 정상접수  errorCheck -> true 접수실패
    func question(questionContent : String , questionContact : String ,completion: @escaping(networkErrorModel) -> ()){
        
   
        
        let reqBody = questionModel(listQuestionContents: questionContent, listQuestionUser: questionContact)
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        //로그인 코드 넣어야하고
        let parameterData=networkManager().reqParameterMake(reqCode: "400", reqBody: reqBodyJson)
        
        
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
    
    func questionContentCkeck(questionContent : String) -> Bool{
        
        
        //공백제거
        let trimStr = questionContent.trimmingCharacters(in: .whitespaces)
        //엔터 제거
        let enterStr = trimStr.components(separatedBy: ["\n"]).joined()
        
        //각각의 글자들이 해당 특수기호
        let trimReg = ("[A-Z0-9a-zㄱ-ㅎ가-힣!\"#$%&'()*+,-./:;<=>?@[＼]^_`{|}~ ]{3,1000}")
        
        let trimTesting = NSPredicate(format: "SELF MATCHES %@", trimReg)
        
      
        return trimTesting.evaluate(with: enterStr)
    }
}
