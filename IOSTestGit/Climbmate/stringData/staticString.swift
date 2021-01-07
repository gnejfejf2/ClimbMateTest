//
//  nilCheckNumber.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/14.
//


import SwiftUI

//각종 상수화 필요한값들이 저장되어있는공간
//파싱을할때 string자체가 nil인경우 -1 이미지 url이 없는경우 1000으로 파싱하여 사용하였다.

class staticString {
  
    let staticNilString : String = "-1"
    let staticNilImage : String = "1000"
    let staticNilInt : Int = -1
    let staticNilDouble : Double = -1.0
    //디테일페이지 들어온 경로
    //1번 근처 클라이밍장
    //2번 최근 업데이트된 클라이미장
    //3번 즐겨찾기
    //4번 검색
    let staticClickType = [1,2,3,4,5,6,7,8,9,10]
    let staticNilURL : String = "https://climbmate.co.kr/1.jpg"
    let staticNilNetworkErrorReason = ["죄송합니다 알수없는 오류로 인해 요청이 취소되었습니다."]
    let staticSettingTitle = ["현재 위치를 확인을 위해\n위치정보 동의가 필요합니다."  //0
                              ,"앨범 권한이 필요한 기능입니다."                  //1
                              ,"푸시알람"                                  //2
                              ,"푸시알람"                                  //3
                              ,"닉네임"                                   //4
                              ,"비밀번호"]                                 //5
    let staticSettingMessage = ["위치정보를 동의 후 다시 눌러주세요",                    //0
                                "앨범 권한을 동의 후 다시 눌러주세요",                   //1
                                "푸시알람을 허용으로 변경해주세요.",                     //2
                                "푸시알람을 취소하시겠습니까? \n푸시알람을 취소할시\n클라이메이트가 제공하는 정보를\n 빠르게 확인하실수 없습니다." //3
                                ,"닉네임형식에 맞지 않습니다. \n닉네임은 최소 1글자 이상입니다."                          //4
                                ,"비밀번호형식에 맞지 않습니다. \n 비밀번호는 8자 이상 문자 + 숫자 + 특수문자 조합 필수입니다."] //5
    
    let tempCenter = [
        dommyCenter(centerName: "사당클라이밍", centerTag: "볼더링,사당역,클린이,실내암벽,암벽등반,운동,등산,다이어트", beforeDay: "4일전", imageName: "1", updateDate: "2020년 11월 23일", optionName: "새 세팅 : A색터 16문제", centerSector: "새 세팅 : A색터 16문제"),
        dommyCenter(centerName: "더클라임양재", centerTag: "볼더링,양재역,취미,다이어트,climbing,운동하는여자,운동하는남자,등빨좋아", beforeDay: "7일전", imageName: "2", updateDate: "2020년 11월 20일", optionName: "11월 20일 볼더링 B색터 변경완료", centerSector: "새 세팅 : B색터 13문제"),
        dommyCenter(centerName: "게이트원클라이밍", centerTag: "내방역,다이어트,볼더링,바위클라이밍,일상,운동,climbing,운동하는여자,운동하는남자", beforeDay: "14일전", imageName: "3", updateDate: "2020년 11월 13일", optionName: "새 세팅 : B-2색터 10문제", centerSector: "새 세팅 : B-2색터 10문제")
    ]
    
    let tempDetailCenter = [
        dommyCenter(centerName: "사당클라이밍", centerTag: "볼더링,사당역,클린이,실내암벽,암벽등반,운동,등산,다이어트", beforeDay: "4일전", imageName: "1", updateDate: "2020년 11월 23일", optionName: "강지윤", centerSector: "새 세팅 : A색터 16문제"),
        dommyCenter(centerName: "사당클라이밍", centerTag: "볼더링,사당역,취미,다이어트,climbing,운동하는여자,운동하는남자,등빨좋아", beforeDay: "7일전", imageName: "2", updateDate: "2020년 11월 20일", optionName: "강지윤", centerSector: "새 세팅 : B색터 13문제"),
        dommyCenter(centerName: "사당클라이밍", centerTag: "사당역,다이어트,볼더링,바위클라이밍,일상,운동,climbing,운동하는여자,운동하는남자", beforeDay: "14일전", imageName: "3", updateDate: "2020년 11월 13일", optionName: "강지윤", centerSector: "새 세팅 : B-2색터 10문제")
    ]
    
    let tempDetailCenter2 = [
        dommyCenter(centerName: "사당클라이밍", centerTag: "볼더링,사당역,클린이,실내암벽,암벽등반,운동,등산,다이어트", beforeDay: "4일전", imageName: "4", updateDate: "2020년 11월 23일", optionName: "강지윤", centerSector: "새 세팅 : A색터 16문제"),
        dommyCenter(centerName: "사당클라이밍", centerTag: "볼더링,사당역,취미,다이어트,climbing,운동하는여자,운동하는남자,등빨좋아", beforeDay: "7일전", imageName: "5", updateDate: "2020년 11월 20일", optionName: "강지윤", centerSector: "새 세팅 : B색터 13문제"),
        dommyCenter(centerName: "사당클라이밍", centerTag: "사당역,다이어트,볼더링,바위클라이밍,일상,운동,climbing,운동하는여자,운동하는남자", beforeDay: "14일전", imageName: "6", updateDate: "2020년 11월 13일", optionName: "강지윤", centerSector: "새 세팅 : B-2색터 10문제")
    ]
    
    
    
    let statincCGFloat : [CGFloat] = [5,10,15,20,25,30]
    
    let staticInt : [Int] = [5,10,15,20,25,30]
    
    let delayTime = [Dispatch.DispatchTime.now() + 0.3 , .now() + 1.0 , .now() + 1.5 , .now() + 2.0 ]
    func nilString() -> String{
        return staticNilString
    }
    
    func nilImage() -> String{
        return staticNilImage
    }
    
    func nilURL() -> String{
        return staticNilURL
    }
    
    func nilInt() -> Int{
        return staticNilInt
    }
    
    func nilDouble() -> Double{
        return staticNilDouble
    }
    
    func staticDetailURLReturn(centerID : String) -> String{
        return "\(networkManager().staticURL)detail?id=\(centerID)"
    }
    
    func staticNilNetworkErrorReasonReturn(index : Int) -> String{
        return staticNilNetworkErrorReason[index]
    }
    
    
    func staticSettingTitleReturn(index : Int) -> String{
        return staticSettingTitle[index]
    }
    
    func staticSettingMessageReturn(index : Int) -> String{
        return staticSettingMessage[index]
    }
    
    func deleteSpaceNumbr(str : String) -> String {
        var deleteString : String
        deleteString = str.components(separatedBy: ["1","2","3","4","5","6","7","8","9"," "]).joined()

        return deleteString
    }
    // 금액을 표현할때 사용한다.
    // Int -> 콤마 3개마다 .을 붙여주고 원으로 변환시켜줌
    func decimalWon(value: Int) -> String{
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let result = numberFormatter.string(from: NSNumber(value: value))! + "원"
            
            return result
    }
    
    
}
