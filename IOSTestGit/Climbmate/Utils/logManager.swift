//
//  logManager.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/19.
//

import SwiftUI

class logManager {
    //로그매니저 이곳에서 로그를 전부 확인한다 이것만 false로바꾼다면 로그는 찍히지않음
    let logOnOff : Bool = false
    let kakaoLogOnOff : Bool = false
    func log(log : String){
        if(logOnOff){
            print(log)
        }
    }
    
    func kakaoLog(log : String){
        if(kakaoLogOnOff){
            print(log)
        }
    }
}
