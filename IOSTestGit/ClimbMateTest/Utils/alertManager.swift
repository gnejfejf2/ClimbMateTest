//
//  alertManager.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/18.
//

import SwiftUI
import SystemConfiguration
import KakaoSDKAuth
import KakaoSDKUser

class alertManager {
    
    
    //해당함수를 사용하는이유는 화면을 내가 다시 따지않으면 기존에 알람창이 있을경우
    //추가 알람이 가지않음
    func alertView(title : String ,reason : String){
        
        //알람을 뛰울 화면을 만들어주고
        var alertWindow: UIWindow?
        //현재화면의 맨앞의 화면 즉 보여주는 뷰를 가져옴
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        //기존에 화면이 있는지 없는지 체크를하고
        if let windowScene = windowScene as? UIWindowScene {
            alertWindow = UIWindow(windowScene: windowScene)
        } else {
            alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        }
        
        //알람창의 크기설정
        alertWindow?.frame = UIScreen.main.bounds
        //UI 컨트롤러 만들기
        alertWindow?.rootViewController = UIViewController.init()
        //알람이 최상단에 위치하기위해 레벨 선언
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        
        //알람을 보여준다.
        alertWindow?.makeKeyAndVisible()
        //알람의 내용이들어가는공간
        let alert: UIAlertController = UIAlertController.init(title: title,
                                                              message: reason,
                                                              preferredStyle: .alert)
        
        //알람의 행동이 들어가는공간.
        let onAction: UIAlertAction = UIAlertAction.init(title: "확인",
                                                         style: .default) { (action: UIAlertAction) in
            alertWindow?.isHidden = true
        }
        //알람에 행동을 담아
        alert.addAction(onAction)
        //보여준다,
        alertWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func alertLeftAlignmentView(title : String ,reason : String){
        
        //알람을 뛰울 화면을 만들어주고
        var alertWindow: UIWindow?
        //현재화면의 맨앞의 화면 즉 보여주는 뷰를 가져옴
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        //기존에 화면이 있는지 없는지 체크를하고
        if let windowScene = windowScene as? UIWindowScene {
            alertWindow = UIWindow(windowScene: windowScene)
        } else {
            alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        }
        
        //알람창의 크기설정
        alertWindow?.frame = UIScreen.main.bounds
        //UI 컨트롤러 만들기
        alertWindow?.rootViewController = UIViewController.init()
        //알람이 최상단에 위치하기위해 레벨 선언
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        
        //알람을 보여준다.
        alertWindow?.makeKeyAndVisible()
        //알람의 내용이들어가는공간
        
        
        
        
        
        let alert: UIAlertController = UIAlertController.init(title: title,
                                                              message: reason,
                                                              preferredStyle: .alert)
        
        //알람의 행동이 들어가는공간.
        let onAction: UIAlertAction = UIAlertAction.init(title: "확인",
                                                         style: .default) { (action: UIAlertAction) in
            alertWindow?.isHidden = true
        }
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: reason,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        
        //알람에 행동을 담아
        alert.addAction(onAction)
        //보여준다,
        alertWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func settingAlert(title: String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정", style: .default, handler: {action in
            
            // open the app permission in Settings app
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        alert.preferredAction = settingsAction
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated : false)
        
    }
    
   
   
    
    
    func userQuitAlert(completion : @escaping(networkErrorModel) -> ()){
        //알람
        let alert = UIAlertController(title: "회원 탈퇴", message: "회원탈퇴 진행을 위해\n비밀번호를 입력해주세요", preferredStyle: .alert)
        
        
        alert.addTextField() { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "비밀번호"
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .destructive ){ _ in
            completion(networkErrorModel(errorCheck: true, networkErrorReason: "취소"))
        }
        //알람 액션
        let retry = UIAlertAction(title: "탈퇴", style: .default){ _ in
            if(alert.textFields![0].text! != ""){
                myPageEditViewModel().userQuitTry(pass: alert.textFields![0].text!){
                    result in
                    
                    if(result.errorCheck){
                        completion(result)
                    }else{
                        completion(networkErrorModel(errorCheck: false, networkErrorReason: ""))
                    }
                }
            }
            else{
                completion(networkErrorModel(errorCheck: true, networkErrorReason: "비밀번호를 입력해주세요"))
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(retry)
        
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated : true)
        
    }
    
    //카카오 회원탈퇴 알람을 뛰어주는 코드이다.
    func userQuitKakaoAlert(completion : @escaping(networkErrorModel) -> ()){
        //알람에 담길 메세지
        let alert = UIAlertController(title: "회원 탈퇴", message: "회원탈퇴 진행을 위해\n회원탈퇴를 입력해주세요", preferredStyle: .alert)
        
        //알람에 택스트 필드를 추가하고
        alert.addTextField() { textField in
            textField.placeholder = "회원탈퇴"
            
        }
        //알람의 기본적인 취소버튼
        let cancel = UIAlertAction(title: "취소", style: .destructive ){ _ in
            completion(networkErrorModel(errorCheck: true, networkErrorReason: "취소"))
        }
        //알람에서 실행할 액션을 담는곳
        let retry = UIAlertAction(title: "탈퇴", style: .default){ _ in
            //타이핑을 정확하게 회원탈퇴라고 입력했을경우
            if(alert.textFields![0].text! == "회원탈퇴"){
                //카카오톡어플이 있는지 확인후 (없는경우도 처리해야함)
                if (AuthApi.isKakaoTalkLoginAvailable()) {
                    //카카오톡로그인이 정상적으로 처리되었을경우
                    AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error = error {
                            completion(networkErrorModel(errorCheck: false, networkErrorReason: error.localizedDescription))
                        }
                        else {
                            //유저의 정보를 요청한다.
                            UserApi.shared.me() {(user, error) in
                                if let error = error {
                                    completion(networkErrorModel(errorCheck: false, networkErrorReason: error.localizedDescription))
                                }
                                else {
                                    //클라이메이트서버에서 카카오 유저아이디를 비밀번호로 사용하기때문에
                                    //유저아이디를 받아온다.
                                    guard String(user!.id) != "" else {
                                        completion(networkErrorModel(errorCheck: false, networkErrorReason: "카카오 로그인 오류"))
                                        return
                                    }
                                    //클라이메이트서버에 카카오 유저아이디를 비밀번호로 사용하여 회원탈퇴를 요청한다.
                                    myPageEditViewModel().userQuitTry(pass: String(user!.id)){
                                        result in
                                        
                                        if(result.errorCheck){
                                            completion(result)
                                        }else{
                                            //클라이메이트서버에서 정상적으로 회원탈퇴처리가되었다면
                                            //카카오도 연결을 끊어준다.
                                            kakaoViewModel().kakaoUnlink()
                                            completion(networkErrorModel(errorCheck: false, networkErrorReason: ""))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else{
                completion(networkErrorModel(errorCheck: true, networkErrorReason: "회원탈퇴를 입력해주세요"))
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(retry)
        
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated : true)
        
    }
    
}





//네트워크가 없을경우 알람창을 뛰어주는코드
//해당을 스트럭쳐로 다시만든이유는 바인딩을 하기위하여
struct networkAlarmView {
    //네트워크 체크하는 값을 하나 선언을하고
    @Binding var networkCheck : Bool
    //네트워크 체크를용 URL
    let connectivity = SCNetworkReachabilityCreateWithName(nil, "www.app-designer2.io")
    
    func alert(){
        //알람
        let alert = UIAlertController(title: "네트워크", message: "네트워크 응답이 없습니다.", preferredStyle: .alert)
        //알람 액션
        let retry = UIAlertAction(title: "다시 시도", style: .destructive){ _ in
            //네트워크체크를위한 플래그
            var flgs = SCNetworkReachabilityFlags()
            //현재 네트워크 상태를 확인하기 위한 테스트
            SCNetworkReachabilityGetFlags(self.connectivity!, &flgs)
            //네트워크가 통신된다면 true 아니라면 false
            if networkMonitor().networkReachable(to: flgs){
                self.networkCheck = true
            }else{
                self.alert()
            }
            
            
        }
        
        alert.addAction(retry)
        
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated : true)
        
    }
    
    
}


