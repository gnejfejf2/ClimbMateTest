//
//  centerList.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/24.
//

import SwiftUI
import SDWebImageSwiftUI

//자주찾는 클라이밍장 리스트에 추가한 클라이밍장에대한 정보를 보여주는 리스트에서 사용하는 아이템 뷰이다.
struct centerListItem: View {
    
    //즐겨찾기에 추가한 모델값을 입력을 받은후
    let center : favoritCenterModel
    @Namespace var name
    //기본적인 아이템들의 기본적인 높이를 선언
    @State var itemHeigh : CGFloat = UIScreen.main.bounds.height / 8
    
    
    var body: some View {
        VStack(spacing: 0){
            
            HStack(spacing: 10){
                //이미지가 없을경우 기본이미지를 보여주고
                if(center.imageThumbUrl == staticString().nilImage()){
                    Image(staticString().nilImage())
                        .resizable()
                        .frame(width: self.itemHeigh, height: self.itemHeigh )
                        .cornerRadius(20)
                        .matchedGeometryEffect(id: center.centerName, in: name)
                }
                else{
                //해당 암장에 이미지가 있을경우 이미지 URL을 이미지를 불러오고
                    WebImage(url: URL(string: center.imageThumbUrl))
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        // Activity Indicator
                        .resizable()
                        .frame(width: self.itemHeigh, height: self.itemHeigh)
                        .cornerRadius(25)
                        .matchedGeometryEffect(id: center.centerName, in: name)
                    
                    
                    
                }
                VStack(spacing : 3){
                    HStack{
                        Text(center.centerName)
                            .font(.callout)
                            .foregroundColor(Color("primaryColor"))
                            .font(.system(size: 19))
                        Spacer()
                    }
                    HStack{
                        Text(center.centerAddress)
                            .font(.system(size: UIScreen.main.scale * 6))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .font(.body)
                        Spacer()
                    }
                    
                    Spacer()
                    //추후에 변경될공간 1회 이용료에 한 가격이 적혀있지만 이곳도 변하지 않을까?
//                    HStack{
//                        Text("1회 \(staticString().decimalWon(value: Int(self.center.goodsPrice) ?? 0))")
//                            .foregroundColor(Color("primaryColor"))
//                            .font(.system(size: 14))
//                            .font(.body)
//                        Spacer()
//
//                    }
                    
                    
                    HStack{
                        Text("세팅이 변경된 날짜 : \(center.detailRecentUpdate)")
                            .font(.system(size: 14))
                            .foregroundColor(Color("primaryColor"))
                            .lineLimit(1)
                            .font(.body)
                        Spacer()
                    }
                 
                }
                .padding(.top , 5)
            }
            
        }
    }
}

