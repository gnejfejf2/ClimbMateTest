//
//  listViewModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/02.
//

import Foundation

class homeBannerListViewModel {
    
    func getBannerList(completion: @escaping([homeBannerImageModel]?,networkErrorModel) -> ()){
        // 통신에 필요한 바디를 만든다.
        //데이터 통신을 위해 실행하는곳
        //데이터 통신폼으로 변경 임시코드
        let parameterData=networkManager().reqParameterMake(reqCode: "100", reqBody: nil)
        if(parameterData != nil){
            //네트워크매니저에 포스트형식으로 통신을 요청한다.
            //reqData가 정상적으로 통신이 되었을경우 데이터가 담겨들어올공간
            //reaError이 오류가 생겻을경우 오류를 체크하고 오류에대한 이유를 저장하는 공간
            networkManager().Post(requestURL: 0, requestData:parameterData){
                reqData,reqError in
      
                if(reqError.errorCheck == true){
                    //네트워크에서 오류가 났을경우 이곳에서 알람을 만들고 해당 오류에대한 이유를 띄어준다.
                    
                    completion(nil , networkErrorModel(errorCheck: true, networkErrorReason: reqError.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0)))
                    
                   
                }
                else{
                    
                    var temphomeBannerList = [homeBannerImageModel]()
                    
                    for homeBanner in reqData!.resBody {
                        temphomeBannerList.append(homeBannerImageModel(imageURL:
                                                                    imageManager().imageURLReturn(getURL: homeBanner["homeBannerImageThumbUrl"].string!), imageClickLink: homeBanner["homeBannerImageLink"].string!))
                    }
                    
                    completion(temphomeBannerList , networkErrorModel(errorCheck: false, networkErrorReason: nil))
                    
                    
                }
            }
        }
    }
    
    
}


