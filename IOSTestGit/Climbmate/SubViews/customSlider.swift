//
//  customSlider.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/10.
//

import SwiftUI

struct customSlider: View {
    let totalWidth = UIScreen.main.bounds.width - 80
  
    @Binding var startIndexCount : Int
    @Binding var endIndexCount : Int
  
    @Binding var startIndexWidth : CGFloat
    @Binding var endIndexWidth : CGFloat
    //최대 갯수
    @Binding var maxCount : Int
    var body: some View {
        
        VStack{
            ZStack(alignment : .leading){
                HStack{
                    Rectangle()
                    .fill(Color("primaryColor").opacity(0.20))
                    .frame(width : self.totalWidth + 30 ,height: 6)
                    Spacer()
                }.frame(alignment : .leading)
               
                HStack{
                Rectangle()
                 .fill(Color("primaryColor"))
                    .frame(width: self.endIndexWidth - self.startIndexWidth  , height: 6)
                    .offset(x: self.startIndexWidth + 18)
                    Spacer()
                }.frame(alignment : .leading)
                HStack(spacing : 0){
                    Circle()
                        .fill(Color("primaryColorReverse"))
                        .frame(width: 18, height: 18)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("primaryColor"), lineWidth: 1)
                                    .shadow(radius: 1))
                        .offset(x: self.startIndexWidth)
                        .gesture(
                            DragGesture()
                                .onChanged(){ value in
                
                                    if self.startIndexCount <= self.endIndexCount && self.startIndexCount >= 0{
                                        if(value.translation.width < 0 && value.location.x < self.startIndexWidth){
                                            
                                            if(self.startIndexCount != 0){
                                                self.startIndexCount -= 1
                                            }
                                        
                                        }
                                        else if (value.translation.width > 0 && value.location.x > self.startIndexWidth){
                                            if(self.startIndexCount != self.endIndexCount){
                                                self.startIndexCount += 1
                                            }
                                        }
                                        self.startIndexWidth = (self.totalWidth / CGFloat(self.maxCount)) * CGFloat(self.startIndexCount)
                                    }
                                }
                        )
                   
                    Circle()
                        .fill(Color("primaryColorReverse"))
                        .frame(width: 18, height: 18)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("primaryColor"), lineWidth: 1)
                                    .shadow(radius: 1))
                        .offset(x: self.endIndexWidth)
                        .gesture(
                            DragGesture()
                                .onChanged(){ value in
                                     if self.startIndexCount <= self.endIndexCount && self.endIndexCount <= self.maxCount{
                                        
                                        if(value.translation.width < 0 && value.location.x < self.endIndexWidth){
                                            if(self.startIndexCount != self.endIndexCount){
                                                self.endIndexCount -= 1
                                            }
                                        
                                        }
                                        else if (value.translation.width > 0 && value.location.x > self.endIndexWidth){
                                            if(self.endIndexCount != self.maxCount){
                                                self.endIndexCount += 1
                                            }
                                        }
                                        self.endIndexWidth = (totalWidth / CGFloat(self.maxCount)) * CGFloat(self.endIndexCount)
                                    }
                                }
                        )
                }
            
            }
            
            HStack{
                
                Text("\(self.getValue(val : (self.startIndexWidth / self.totalWidth) * CGFloat(self.maxCount))) 만원 ")
                Spacer()
                Text("\(self.getValue(val : (self.endIndexWidth / self.totalWidth) * CGFloat(self.maxCount))) 만원 ")
                
            }
            
            .padding(.top , 20)
        }
        
    
       
    
    }
    
    func getValue(val : CGFloat) -> String{
        
        return String(format: "%.0f", val)
    }
}

