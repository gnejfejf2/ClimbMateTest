//
//  center.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/03.
//


struct centerModel : Codable , Identifiable {

    
    let id : String
    let centerName : String
    let centerAddress : String
    let centerDistance : String
    let imageThumbUrl : String
    let detailCenterX : String
    let detailCenterY : String
    let detailRecentUpdate : String
    

}


//게터 세터 잡아주고
//기본값 잡아주기
//원본데이터는 고정시키고 게터 세터
