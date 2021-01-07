//
//  searchHistoryCard.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/29.
//

import SwiftUI
//검색페이지에서 검색기록을 보여주는 공간이다.
//coreData에 저장되어있는 데이터를 사용하여 보여준다.
struct searchHistoryCard: View {
    
    let keyword : String
    
    let searchDate : String
    
    var body: some View {
        VStack{
            HStack(alignment : .top,spacing: 0){
                Image(systemName: "timer")
                    .foregroundColor(Color("primaryColor").opacity(0.3))
                    .padding(.top , 2)
                    .padding(.trailing,10)
                HStack{
                    Text(self.keyword)
                            .foregroundColor(Color("primaryColor").opacity(0.7))
                    Spacer()
                }
                .frame(width: 100)
                Spacer()
                Text("\(self.searchDate)")
                        .foregroundColor(Color("primaryColor").opacity(0.3))
                Spacer()
            }
            
            
        }
    }
}

