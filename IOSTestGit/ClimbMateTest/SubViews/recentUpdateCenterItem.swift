//
//  searchResultCard.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

//homeView -> 최근업데이트된 암장리스트에서 사용하는 아이템뷰 이곳도 아마 검색처럼 변하지 않을까?

struct recentUpadteCenterItem: View {
    
    let center : centerModel
    
    let fontSizeSmall : CGFloat = UIScreen.main.nativeScale * 5
    
 
    var body: some View {
        
        ZStack{
            
            VStack{
                HStack{
                    if(center.imageThumbUrl == staticString().nilImage()){
                        Image("1")
                            .resizable()
                            .cornerRadius(20)
                            .frame(width: 100, height: 100)
                    }
                    else{
                        
                        WebImage(url: URL(string: center.imageThumbUrl))
                            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                            .onSuccess { image, data, cacheType in
                                // Success
                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                            }
                            .placeholder {
                                Image(systemName: "photo")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .resizable()
                            .cornerRadius(20)
                            .frame(width: 100, height: 100)
                        
                  
                    }
                    
                    VStack{
                        HStack{
                            Text(center.centerName)
                                .foregroundColor(Color("primaryColor"))
                            Spacer()
                            Text("1회 25000원")
                                .foregroundColor(Color("primaryColor"))
                        }
                        HStack{
                            Text(center.centerAddress)
                                .font(.system(size: self.fontSizeSmall))
                                .fontWeight(.thin)
                                .foregroundColor(Color("primaryColor").opacity(0.8))
                            Spacer()
                        }.padding(.top,1)
                        Spacer()
                        HStack{
                            Spacer()
                            Text("세팅 날짜 : \(center.detailRecentUpdate)")
                                .fontWeight(.thin)
                                .foregroundColor(Color("primaryColor").opacity(0.8))
                        }
                        
                    }
                    .padding(.horizontal,8)
                    .padding(.top,8)
                    
                }
            }
            
            NavigationLink(
                destination: centerDetailViewRecreate(clickType: staticString().staticClickType[1] ,centerID: center.id )){
            }.opacity(0)
        }
        
      
    }
    
    
    
    
}

