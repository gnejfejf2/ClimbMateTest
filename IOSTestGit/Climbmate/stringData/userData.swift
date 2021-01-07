//
//  userData.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/22.
//

import SwiftUI
import SwiftyJSON
//유저의 기본정보를 사용할수있는 클래스이다.
//유저의 기본정보를 userData에 스트링 배열로 하나씩 추가를 하고 필요할때마다 인덱스를 입력하여 리턴값을 받는형식으로 사용한다.
//그리고 해당하는 값들을 최신화 할수있는 함수들이 존재

//유저 위치정보가 x,y가 계속변경되서 일단 불러오는 위치 자체를 변경하엿는데 한번 맞춰줄필요가있따.

class userData {
    let userData : [String?] =
        [UserDefaults.standard.string(forKey: "accessKey")      // 0
         ,UserDefaults.standard.string(forKey: "exp")           // 1
         ,UserDefaults.standard.string(forKey: "userEmail")     // 2
         ,UserDefaults.standard.string(forKey: "userId")        // 3
         ,UserDefaults.standard.string(forKey: "userNickname")  // 4
         ,UserDefaults.standard.string(forKey: "userPlatform")  // 5
         ,UserDefaults.standard.string(forKey: "y")             // 6
         ,UserDefaults.standard.string(forKey: "x")             // 7
         ,UserDefaults.standard.string(forKey: "location")      // 8 화면에 보여주기용 ex 수원시 금곡동
         ,UserDefaults.standard.string(forKey: "sublocation")   // 9 카카오api검색용  ex 수원시
         ,UserDefaults.standard.string(forKey: "userProfileImageUrl")//유저프로필사진 URL 10
         ,UserDefaults.standard.string(forKey: "userInfo")] //유저정보
    
    //내부저장소에있는 값을 리턴해주는 함수 인덱스로 관리가된다.
    func returnUserData(index : Int) -> String?{
        return userData[index]
    }
 
    
    func accessKeyUpdate(accessKey : String){
        UserDefaults.standard.removeObject(forKey: "accessKey")
        UserDefaults.standard.set(accessKey , forKey: "accessKey")
    }
    
    func expUpdate(exp : String){
        UserDefaults.standard.removeObject(forKey: "exp")
        UserDefaults.standard.set(exp , forKey: "exp")
    }
    
    func userNicknameUpdate(userNickname : String){
        UserDefaults.standard.removeObject(forKey: "userNickname")
        UserDefaults.standard.set(userNickname , forKey: "userNickname")
    }
    
    func userProfileImageUrlUpdate(userProfileImageUrl : String){
        UserDefaults.standard.removeObject(forKey: "userProfileImageUrl")
        UserDefaults.standard.set(userProfileImageUrl , forKey: "userProfileImageUrl")
    }
    
    
    
    func userInformationSet(userData : JSON){
        UserDefaults.standard.set("\(userData["exp"])" , forKey: "exp")
        UserDefaults.standard.set("\(userData["userEmail"])" , forKey: "userEmail")
        UserDefaults.standard.set("\(userData["userId"])" , forKey: "userId")
        UserDefaults.standard.set("\(userData["userNickname"])" , forKey: "userNickname")
        UserDefaults.standard.set("\(userData["userPlatform"])" , forKey: "userPlatform")
        UserDefaults.standard.set("\(userData["userProfileImageUrl"])" , forKey: "userProfileImageUrl")
    }
    
    //내부저장소에 있는 유저정보를 지우는 함수
    func userInformationClear(){
        UserDefaults.standard.removeObject(forKey: "accessKey")
        UserDefaults.standard.removeObject(forKey: "exp")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userNickname")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userPlatform")
        UserDefaults.standard.removeObject(forKey: "userProfileImageUrl")
    }
    
   
    
    
    func userLocationClear(){
        UserDefaults.standard.removeObject(forKey: "x")
        UserDefaults.standard.removeObject(forKey: "y")
        UserDefaults.standard.removeObject(forKey: "location")
    }
    
    func setLocation(x : String , y : String , completion: @escaping(Bool) -> ()){
        
        UserDefaults.standard.set(x , forKey: "x")
        UserDefaults.standard.set(y , forKey: "y")
        
        locationManager().getAddressFromLatLon(pdblLatitude: y, withLongitude: x){
            loaction , subloaction in
            if(loaction == "-1"){
                self.userLocationSetTemp()
                
                completion(true)
            }else{
                UserDefaults.standard.set(loaction , forKey: "location")
                UserDefaults.standard.set(subloaction , forKey: "sublocation")
                
                completion(true)
            }
        }
    }

    
    func userLocationSetTemp(){
        UserDefaults.standard.set("127.032693842117" , forKey: "x")
        UserDefaults.standard.set("37.4835924256371" , forKey: "y")
        UserDefaults.standard.set("서초구 서초동" , forKey: "location")
        UserDefaults.standard.set("서초구" , forKey: "sublocation")
    }
    
  
}
