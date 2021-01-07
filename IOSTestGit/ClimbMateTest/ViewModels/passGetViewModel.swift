//
//  passGetViewModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/29.
//

import SwiftUI

class passGetViewModel {
    
    func passGet(email: String , completion: @escaping(networkErrorModel) -> ()){
        
        let reqBody = passGetModel(userEmail: email)
        let encoder = JSONEncoder()
        let reqBodyJson = try? encoder.encode(reqBody)
        
        
        let parameterData=networkManager().reqParameterMake(reqCode: "511", reqBody: reqBodyJson)
        
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
                        return completion(networkErrorModel(errorCheck: false, networkErrorReason:  staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }else{
                        return completion(networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    }
                }
            }
            
        }else{
            
            return completion(networkErrorModel(errorCheck: true, networkErrorReason:  staticString().staticNilNetworkErrorReasonReturn(index: 0)))
        }
    }
    
}
