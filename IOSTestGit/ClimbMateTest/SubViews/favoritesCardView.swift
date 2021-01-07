//
//  favoritesCardView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/26.
//

import SwiftUI

struct favoritesCardView: View {
    
    let tempCenter : dommyCenter
    let cardHeight : CGFloat = 200
    let fontSizeBig : CGFloat = 11
    let fontSizeSmall : CGFloat = 8
    var body: some View {
        ZStack{
            
            VStack{
                VStack(spacing : 2){
                    HStack{
                        Spacer()
                        Text(self.tempCenter.beforeDay)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color("deepRed"))
                            .font(.system(size: self.fontSizeBig))

                    }
                    HStack{

                        Text(self.tempCenter.centerName)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: self.fontSizeBig))
                            .padding(.top , 3)
                        Spacer()

                    }

                    HStack{

                        Text(self.tempCenter.centerTag)
                            .font(.system(size: self.fontSizeSmall))
                            .padding(.top , 3)
                            .lineLimit(2)

                        Spacer()

                    }
                    Spacer()

                    HStack{

                        Text(self.tempCenter.centerSector)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: self.fontSizeBig))
                            .foregroundColor(Color("deepRed"))
                            .lineLimit(1)

                        Spacer()

                    }

                    Spacer()

                }
                .padding(.top , 5)


            }

            .padding(.horizontal , 5)
            .background(Color("primaryColorReverse"))
            .padding(.top ,  self.cardHeight / 2)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            )
            Image(self.tempCenter.imageName)
                .resizable()
                .frame(width: 120, height: self.cardHeight / 2)
                .padding(.bottom , self.cardHeight / 2)
            HStack{
                Image("event")
                    .resizable()
                    .cornerRadius(5)
                    .frame(width: 20, height: 20)
                Spacer()
            }
            .padding(.top , 10)
            .padding(.leading , 5)
            
            
        }
        .frame(width: 120, height: self.cardHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .cornerRadius(10)
    }
}


