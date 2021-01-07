// 2020년 10월 5일 작업자 강지윤
// 실질적으로 통신이 이뤄지는 공간
// 통신쪽에서 문제가생긴다면 이쪽 유틸파일에서 통신을 요청하는 함수부분만 수정하면된다.
// 해당 파일의 형식은 대부분 비슷하므로 이해할때 getCenters함수에 적혀있는 주석을 읽은 후 다른 함수들을 보면 이해가 좀더 빠를것이다.
// 각각의 함수에서 변경사항이 생기는부분은 해당함수에 적어놓았음
// 함수의 기본틀은 getCenters 로 확인하면됨
// errorCheckModel 에서 errokCheck 가 트루르면 오류가 있는것 이것은 이번프로젝트 모든곳에서 통일한다.

import SwiftyJSON

class networkManager : ObservableObject{
    
    //고정적으로 요청받는 URL이고 추후에 뒤에 페이지 부분만 변경되면 되므로 고정 URL을 선언한다
    //추후에 서버가 변경이 된다면 이쪽부분만 수정하면 전체 통신의 서버가 변경된다.
    let staticURL : String = "https://climbmate.co.kr/"
    let index : String = "index.php"
    
    
    //에러메세지를 담을공간 추후에 뷰에서 오류내용을 보여주기위해 에러메세지를 담아놓을공간
    
    //디버깅하기 쉽게
    
    //네트워크응답에대한 예외처리를 위한 변수 선언
    let responseErrorCode = [404,443]
    let responseSuccessCode = [200,201,401,500]
    
    //
    
    let resCodeSucces = ["200"]
    let resCodeError = ["404"]
    let resCodeRetry = ["500"]
    
    //통신할 페이지를 배열로 만들어 이곳에서 모든 통신을 관리한다.
    let kakaoURL = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
    
    let requestURLList = ["indexTest1.php","result.php"]
    
    //에러가 생기면 true로 값이 변경되고 view단에서 appear함수를 사용하여 에러내용을 보여줄예정
    //스테이터스 코드도 변수로받아서 파싱해서 에러체크
    
    let kakaoHeader = "KakaoAK 09873ec377f6d10525731af0097b9a26"
    
    
    func Post(requestURL : Int , requestData : Data?, completion: @escaping (networkResModel?,networkErrorModel) -> () ){
        
        logManager().log(log : "requestData 시작")
        logManager().log(log : "requestData :  \(String(data: requestData ?? Data(base64Encoded: "널")!, encoding: .utf8))))")
        logManager().log(log : "requestData 끝 ")
        
        let parameterCheckModel = self.networkParameterCheck(requestURL: self.requestURLList[requestURL], requestData: requestData)
        //파라미터값을체크후 파라미터에 문제가있다면 통신중단.
        if(parameterCheckModel.errorCheck){
            DispatchQueue.main.async {
                alertManager().alertView(title: "통신오류", reason: "통신값에 문제가 있습니다.")
                return completion(nil,parameterCheckModel)
            }
        }
        else{
            let networkURL = URL(string: "\(staticURL)\(self.requestURLList[requestURL])")
            // 데이터를 파라미터 데이터 형태로 변경
            // URLRequest 객체를 정의
            // nerworkURL은 무조건 있기때문에 ! 를 붙여줌
            logManager().log(log: "통신주소 시작")
            logManager().log(log : "통신주소 :  \(staticURL)\(self.requestURLList[requestURL])")
            logManager().log(log: "통신주소 끝")
            var request = URLRequest(url: networkURL!)
            //통신방법을 선택
            request.httpMethod = "POST"
            //통신에사용할 데이터를 담은후
            request.httpBody = requestData
            // HTTP 메시지 헤더
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            //json을 사용할거기때문에 사용
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            // 위에서 만들어놓은 정보를 포함하여 HTTP통신을 요청한다.
            URLSession.shared.dataTask(with: request) {
                //해당 요청을 하였을 경우 발생되는 3가지 값
                // data -> 실질적인 데이터가 담겨져 있는 공간
                // response 의 응답값은 예시로 아래에 있는 주석을 풀어보면 볼수있다.
                // 전송이 실패했는지 서버가 무엇인지 등이 리턴되어온다.
                // error 에러가 넘어온다면 의 이유가 들어있는공간
                data , response , error in
                
                let networkErrorModel = self.networkErrorCheck(data: data,error: error,response: response)

                if(networkErrorModel.errorCheck){
                    DispatchQueue.main.async {
                        print(networkErrorModel)
                        return completion(nil,networkErrorModel)
                    }
                }
                else{
                    logManager().log(log: "서버응답값 시작")
                    let stringValue = String(decoding: data!, as: UTF8.self)
                    
                    logManager().log(log : "서버응답값 만들기 :  \(stringValue)")
                    logManager().log(log: "서버응답값 끝")
                
                    
                    
                    let networkResult = try? JSONDecoder().decode(networkResModel.self , from: data!)
                    logManager().log(log: "최종결과값 시작")
                    logManager().log(log : "최종결과값 만들기 :  \(String(describing: networkResult))")
                    logManager().log(log: "최종결과값 끝")
                    
                    
                    DispatchQueue.main.async {
                        return completion(networkResult,networkErrorModel)
                    }
                }
                //에러가 널값이아니라면 에러메세지를 담고 에러를 false -> true로 변경한다.
                // Http 통신이 성공했을 경우, php나 서버에서 echo로 찍어줬을 때 받는 방법
            }.resume()
        }
    }
    
    
    //넘어온 파라미터를 체크한다. 파라미터가 하나라도 비워있을경우
    func networkParameterCheck(requestURL : String? ,requestData : Data?) -> networkErrorModel{
        //요청하는 URL이 존재하는지확인
        if requestURL == nil{
            return networkErrorModel(errorCheck: true,networkErrorReason: "통신 오류가 생겼습니다.")
        }
        else{
            //통신용 파라미터 데이터가 null값이 아닌지 확인
            if requestData == nil{
                return networkErrorModel(errorCheck: true,networkErrorReason: "통신 데이터가 잘못되었습니다.")
            }
            else{
                //두가지 조건이 아니라면 통신오류가 없다고 리턴
                return networkErrorModel(errorCheck: false,networkErrorReason: "")
            }
        }
    }
    
    //accessKey가 있는지를 체크한다. 해당값이 비어있다면 리턴값을 true로 전달한다..
    func accessKeyCheck() -> networkErrorModel{
        
        guard userData().returnUserData(index: 0) != nil else {
            userData().userInformationClear()
            return networkErrorModel(errorCheck: true, networkErrorReason: "로그인이 필요합니다.")
        }
        
        logManager().log(log: "\(String(describing: UserDefaults.standard.string(forKey: "accessKey")))")
        
        return networkErrorModel(errorCheck: false, networkErrorReason: "")
        
        
    }
    
    
    //네트워크 오류를 체크하는 공간 여기서 false가뜬다면 오류가없다.
    func networkErrorCheck(data : Data?,error : Error? , response : URLResponse?) -> networkErrorModel {
        //우선 통신자체 오류가있는지 확인하기위해 에러값이 존재하는지 없는지확인
        //서버가 닫혀있다거나 이상한 URL, 아니면 네트워크가 존재하지않는경우 1차적으로 이곳에서 처리가됨
        if error != nil{
            return networkErrorModel(errorCheck: true, networkErrorReason: error?.localizedDescription)
        }
        else{
            //http리스폰값이 200,201이 정상이고 그이외값들은 정상이 아니기때문에 오류라고 판단함 통신을 중단하고 알림을 뛰어줌
            let httpResponse = response as? HTTPURLResponse
            if(responseErrorCode.contains(httpResponse!.statusCode) || !responseSuccessCode.contains(httpResponse!.statusCode)){
                
                return networkErrorModel(errorCheck: true, networkErrorReason: "httpResponse 응답이 없습니다.")
            }
            else{
                
                
                let dataDecoder = try? JSONDecoder().decode(networkResModel.self , from: data!)
                if(dataDecoder == nil){
                    // 넘어온 데이터가 문제가있을경우 우리가 사용하는 폼을 어겼을경우 이곳에서 걸러짐
                    // 스위프트의 Json구조의 특성상 없는 키값이 넘어오면
                    // 디코딩자체가안됨 서버쪽넘겨주는 데이터가 문제라면 이곳에서 오류가 잡힘
                    return networkErrorModel(errorCheck: true, networkErrorReason: "데이터리턴에 문제가 생겼습니다.")
                }else{
                    //상단부에서 데이터디코더를 nil값을 체크하기때문에 아래부분에 널값이 뜨지않는다.
                    //넘어온데이터가 서버측에서 200을 주었을경우 정상 404 는 통신오류 500은 재시도 이기때문에 200이 아닌경우 오류로 판단하여 알람을 뛰어줌
                    if(dataDecoder!.resCode == "" || dataDecoder!.resCode == "{}"){
                        return networkErrorModel(errorCheck: true, networkErrorReason: "응답값이 존재하지 않습니다.")
                    }
                    else{
                        if( resCodeError.contains(dataDecoder!.resCode!) || resCodeRetry.contains(dataDecoder!.resCode!)){
                            if(dataDecoder!.resErr == nil){
                                return networkErrorModel(errorCheck: true, networkErrorReason: "서버데이터 오류입니다.")
                            }
                            else{
                                return networkErrorModel(errorCheck: true, networkErrorReason: dataDecoder!.resErr)
                            }
                        }
                        else{
                            //정상인경우 에러가없다고 판단함
                            return networkErrorModel(errorCheck: false, networkErrorReason: "")
                        }
                    }
                }
                
            }
        }
    }
    
    
    func reqParameterMake(reqCode : String , reqBody : Data?) -> Data? {
        if reqCode != "" || reqCode != "{}"{
            if(reqBody == nil){
                
                //  reqBody가 필요없는요청도 존재하는데 해당하는 데이터같은경우 nil값으로 넘어가게된다면 해당 파라미터 자체가 존재하지 않는것으로 인식하기떄문에 의미없는 json을 하나 끼워넣는다.
                let nilReqBody = dommyModel()
                let encoder = JSONEncoder()
                let reqBodyJson = try? encoder.encode(nilReqBody)
                //서버에 통신하기위해 json오브젝트가 필요한데 swift 에서는 공식적으로 JSON타입이 없기 때문에
                //라이브러리로 만들어준 JSON형태로 변경을 해야함
                let jsonEncoding = JSON(reqBodyJson!)
                let parameterJson = networkReqModel(reqCode: reqCode, reqBody: jsonEncoding)
                let returnParameterJson = try? encoder.encode(parameterJson)
                return returnParameterJson
            }
            else{
                
                logManager().log(log: "파라미터 데이터 만들기 시작")
                logManager().log(log : "파라미터 데이터 만들기 :  \(String(describing: String(data: reqBody!, encoding: .utf8)))")
                logManager().log(log: "파라미터 데이터 만들기 끝")
                
                let encoder = JSONEncoder()
                //서버에 통신하기위해 json오브젝트가 필요한데 swift 에서는 공식적으로 JSON타입이 없기 때문에
                //라이브러리로 만들어준 JSON형태로 변경을 해야함
                let jsonEncoding = JSON(reqBody!)
                
                let parameterJson = networkReqModel(reqCode: reqCode, reqBody: jsonEncoding)
                let returnParameterJson = try? encoder.encode(parameterJson)
                return returnParameterJson
                
            }
        }
        else{
            return nil
        }
    }
    
    
    
    
    
    func kakaoRestApi(searchKeyword : String , page : Int ,completion: @escaping (kakaoResModel?,networkErrorModel) -> () ){
        
        //카카오요청 URL get방식을 통해 요청하기때문에 URL에 직접 넣어준다.
        //searchKeyword 검색키워드
        //page는 카카오 RestApi내에서 사용하는 페이징값
        let urlString = "\(kakaoURL)\(searchKeyword) 클라이밍&page=\(page)&size=15"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        //예외처리 공부해서 추가해야함
        let networkURL = try? URL(string: encodedString)
        
        logManager().kakaoLog(log: "\(String(describing: networkURL))")
        // 데이터를 파라미터 데이터 형태로 변경
        // URLRequest 객체를 정의
        // nerworkURL은 무조건 있기때문에 ! 를 붙여줌
        var request = URLRequest(url: networkURL!)
        //통신방법을 선택
        request.httpMethod = "POST"
        //통신에사용할 데이터를 담은후
        // HTTP 메시지 헤더
        request.setValue(kakaoHeader, forHTTPHeaderField: "Authorization")
        
        //
        URLSession.shared.dataTask(with: request) {
            //해당 요청을 하였을 경우 발생되는 3가지 값
            // data -> 실질적인 데이터가 담겨져 있는 공간
            // response 의 응답값은 예시로 아래에 있는 주석을 풀어보면 볼수있다.
         
            // 전송이 실패했는지 서버가 무엇인지 등이 리턴되어온다.
            // error 에러가 넘어온다면 의 이유가 들어있는공간
            data , response , error in
            
            
            //카카오네트워크 에러를 체크하는 함수 이곳에서오류가생긴다면 true값이 넘어온다.
            let networkErrorModel = self.networkErrorCheckKaKao(data: data,error: error,response: response)
            
            
             if(networkErrorModel.errorCheck){
                DispatchQueue.main.async {
                    return completion(nil,networkErrorModel)
                }
            }
            else{
                let networkResult = try? JSONDecoder().decode(kakaoResModel.self , from: data!)
               DispatchQueue.main.async {
                    return completion(networkResult,networkErrorModel)
                }
            }
            //에러가 널값이아니라면 에러메세지를 담고 에러를 false -> true로 변경한다.
            // Http 통신이 성공했을 경우, php나 서버에서 echo로 찍어줬을 때 받는 방법
        }.resume()
        
    }
    
    
    
    //카카오톡API에서 사용할 에러체크용 코드
    // 이곳의경우 리스폰값이 401이 오는경우가있는데 그럴경우 카카오톡api 해더가 잘못되었을경우일확률이크다.
    func networkErrorCheckKaKao(data : Data?,error : Error? , response : URLResponse?) -> networkErrorModel {
        
        //우선 통신자체 오류가있는지 확인하기위해 에러값이 존재하는지 없는지확인
        //서버가 닫혀있다거나 이상한 URL, 아니면 네트워크가 존재하지않는경우 1차적으로 이곳에서 처리가됨
        if error != nil{
            return networkErrorModel(errorCheck: true, networkErrorReason: error?.localizedDescription)
        }
        else{
            //http리스폰값이 200,201이 정상이고 그이외값들은 정상이 아니기때문에 오류라고 판단함 통신을 중단하고 알림을 뛰어줌
            let httpResponse = response as? HTTPURLResponse
            if(responseErrorCode.contains(httpResponse!.statusCode) || !responseSuccessCode.contains(httpResponse!.statusCode)){
                
                return networkErrorModel(errorCheck: true, networkErrorReason: "httpResponse 응답이 없습니다.")
            }
            else{
                
                if let dataDecoder = try? JSONDecoder().decode(kakaoErrorModel.self , from: data!){
                    
                    
                    return networkErrorModel(errorCheck: true, networkErrorReason: dataDecoder.message)
                }else{
                    if let dataDecoder = try? JSONDecoder().decode(kakaoResModel.self , from: data!){
                        logManager().kakaoLog(log: "\(dataDecoder)")
                        return networkErrorModel(errorCheck: false, networkErrorReason: "")
                    }else{
                        
                        return networkErrorModel(errorCheck: true, networkErrorReason: "통신오류")
                    }
                }
            }
        }
    }
    
    
    


}




