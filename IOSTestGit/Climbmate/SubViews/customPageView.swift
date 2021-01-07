//
//  customPageView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct customPageView: View {
    let imageStrings : [centerSettingImageModel]
    
    @State var isUserSwiping : Bool = false
    @State var offset : CGFloat = 0
    
    
    @State var spacing : CGFloat = 15
    
    @State var presented : Bool = false
    
    @State var imageIndex : Int = 0
    var body: some View {
        
        if(self.imageStrings.count > 0){
            TabView {
                if(self.imageStrings.count > 5){
                    
                    ForEach(0..<5) { i in
                        Button(action : {
                            self.imageIndex = i
                            self.presented.toggle()
                        }){
                            WebImage(url: URL(string: self.imageStrings[i].imageThumbUrl))
                                .placeholder {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .resizable()
                                .cornerRadius(5)
                                
                        }
                    }
                }else{
                    ForEach(0..<self.imageStrings.count) { i in
                        Button(action : {
                            self.imageIndex = i
                            self.presented.toggle()
                        }){
                            WebImage(url: URL(string: self.imageStrings[i].imageThumbUrl))
                                .placeholder {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .resizable()
                                .frame(height: UIScreen.main.bounds.height / 2.5 , alignment : .leading)
                                .cornerRadius(5)
                              
                        }
                    }
                }
                
            }
            .sheet(isPresented: self.$presented) {
                detailImageView(centerSettingImageModels : self.imageStrings , centerSettingModels : nil , index : self.imageIndex)
                
            }
            .frame(height: UIScreen.main.bounds.height / 2.5 , alignment : .center)
            .tabViewStyle(PageTabViewStyle())
            
            //        GeometryReader{ geometry in
            //            ZStack{
            //                ScrollView(.horizontal , showsIndicators : false){
            //                    HStack(alignment: .center, spacing: 0){
            //                        ForEach(0..<self.imageStrings.count) { i in
            //                            Button(action : {
            //                                self.imageIndex = i
            //                                self.presented.toggle()
            //                            }){
            //                                WebImage(url: URL(string: self.imageStrings[i].imageThumbUrl))
            //                                    .placeholder {
            //                                        Image(systemName: "photo")
            //                                            .resizable()
            //                                            .foregroundColor(.gray)
            //                                    }
            //                                    .resizable()
            //                                    .frame(width : geometry.size.width)
            //                                    .cornerRadius(5)
            //                                    .padding(.trailing , self.spacing)
            //                            }
            //                        }
            //                    }
            //                    .sheet(isPresented: self.$presented) {
            //                        detailImageView(centerSettingImageModels : self.imageStrings , centerSettingModels : nil , index : self.imageIndex)
            //                    }
            //                }
            //                .content
            //                .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.imageIndex) * (-geometry.size.width - self.spacing))
            //                .frame(width : geometry.size.width , height: UIScreen.main.bounds.height / 2.5 , alignment : .leading)
            //                .animation(.spring())
            //                .gesture(DragGesture()
            //                            .onChanged({ value in
            //                                self.isUserSwiping = true
            //                                self.offset = value.translation.width - (geometry.size.width + self.spacing) * CGFloat(self.imageIndex)
            //                            })
            //                            .onEnded({ value in
            //                                if(value.translation.width < 0){
            //                                    if value.translation.width < geometry.size.width / 2 , self.imageIndex < self.imageStrings.count - 1 {
            //                                        self.imageIndex += 1
            //                                    }
            //                                }
            //                                else if (value.translation.width > 0){
            //                                    if value.translation.width > 30.0 , self.imageIndex > 0 {
            //                                        self.imageIndex -= 1
            //                                    }
            //                                }
            //                                withAnimation{
            //                                    self.isUserSwiping = false
            //                                }
            //                            })
            //                )
            //                VStack{
            //                    Spacer()
            //                    pageControl(current : self.$imageIndex , totalCount : self.imageStrings.count)
            //                }
            //            }
            //        }
            //        .frame(height: UIScreen.main.bounds.height / 2.5 , alignment : .leading)
        }
        else{
            Image("mainLogo")
                .resizable()
                .frame(height: UIScreen.main.bounds.height / 2.5 , alignment : .leading)
        }
    }
}

