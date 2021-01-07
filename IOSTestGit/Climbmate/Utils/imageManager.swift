

import SwiftUI
import Alamofire

class imageManager : ObservableObject{
    let uploadServerURL = ["https://climbmate.co.kr/profileImageUpload.php"]
    let staticURL : String = "https://climbmate.co.kr/"
    
    
    
    //이미지값을넣으면 고정 파라미터값을 추가하여 넘겨줌
    func imageURLReturn(getURL : String) -> String {
        let imageThumbUrlParsing = "\(staticURL)\(getURL)"
        
        return imageThumbUrlParsing
    }
    
    
    //한장의 이미지를 서버에 업로드할때 사용하는 코드
    func uploadSingleImage(urlIndex : Int , paramName: String, fileName: String, image: UIImage,completion: @escaping (String?,networkErrorModel) -> () ){
        let url = URL(string: uploadServerURL[urlIndex])

       
        // 고유 한 앱별 문자열을 사용하여 경계 문자열 생성
        let boundary = UUID().uuidString

        let session = URLSession.shared

       
        //URLRequest를 POST 및 지정된 UR로 설정
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        
        // Content-Type Header를 multipart / form-data로 설정합니다. 이는 웹 브라우저에서 파일 업로드로 양식 데이터를 제출하는 것과 같습니다.
        // 여기에도 경계가 설정됩니다.
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        var imageQualty : Double
        
        imageQualty = self.resizeImageQuality(image: image)
        // 원시 http 요청 데이터에 이미지 데이터 추가
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: CGFloat(imageQualty))!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\("123")\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        data.append(image.jpegData(compressionQuality: CGFloat(imageQualty))!)
//        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        
        session.uploadTask(with: urlRequest, from: data, completionHandler: {
            responseData, response, error in
            
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                    print(json["success"] as? Int as Any)
                    DispatchQueue.main.async {
                       
                    }
                   
                    if(json["success"] as? Int == 1){
                        DispatchQueue.main.async {
                            completion(json["url"] as? String , networkErrorModel(errorCheck: false , networkErrorReason : ""))
                        }
                       
                    }else{
                        DispatchQueue.main.async {
                            completion(nil , networkErrorModel(errorCheck: true , networkErrorReason : "전송실패"))
                        }
                        
                    }
                }else{
                    completion(nil , networkErrorModel(errorCheck: true , networkErrorReason : "전송실패"))
                }
            }
            else{
                completion(nil , networkErrorModel(errorCheck: true , networkErrorReason : error.debugDescription))
            }
        }).resume()
    }
 
    
    //이미지퀄리티를 조정하는 코드
    func resizeImageQuality(image : UIImage) -> Double {
        if(image.imageAsset != nil){
            if(image.jpegData(compressionQuality: 1)!.count < 1500000){
                return 1
            }
            else if(image.jpegData(compressionQuality: 0.9)!.count < 1500000){
                return 0.9
            }
            else if(image.jpegData(compressionQuality: 0.8)!.count < 1500000){
                return 0.8
            }
            else if(image.jpegData(compressionQuality: 0.7)!.count < 1500000){
                return 0.7
            }
            else if(image.jpegData(compressionQuality: 0.6)!.count < 1500000){
                return 0.6
            }
            else if(image.jpegData(compressionQuality: 0.5)!.count < 1500000){
                return 0.5
            }
            else if(image.jpegData(compressionQuality: 0.4)!.count < 1500000){
                return 0.4
            }
            else if(image.jpegData(compressionQuality: 0.3)!.count < 1500000){
                return 0.3
            }
            else if(image.jpegData(compressionQuality: 0.2)!.count < 1500000){
                return 0.2
            }
            else{
                return 0.1
            }
        }else{
            return -1
        }
    }
    
    
    private func urlRequestWithComponentsForUploadMultipleImages(urlString:String, parameters:Dictionary<String, String>, imagesData:[Data], imageName: String) -> (URLRequestConvertible , Data) {

        // create url request to send
        var mutableURLRequest = URLRequest(url: NSURL(string: urlString)! as URL)

        mutableURLRequest.httpMethod = Alamofire.HTTPMethod.post.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")


        // create upload data to send
        var uploadData = Data()
        // add image
        for data in imagesData {
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"\(imageName)\"; filename=\"\(Date().timeIntervalSince1970).jpeg\"\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append(data)
        }
        // add parameters
        for (key, value) in parameters {
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
        }
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        print("upload",parameters)
        return (mutableURLRequest , uploadData)
    }
}
