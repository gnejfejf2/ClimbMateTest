//
//  videoCardView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct videoCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let centerComment : centerCommentModel
    
    let fontSizeName : CGFloat = 12
    let fontSizeSmall : CGFloat = 10
    let imageWidthHeight : CGFloat = UIScreen.main.bounds.width / 8
    var body: some View {
        ZStack{
            HStack(alignment: .top , spacing : 0){
                VStack(){
                    HStack{
                        if(self.centerComment.userProfileImageUrl == staticString().nilImage()){
                            Image(self.colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                                .resizable()
                                .frame(width: self.imageWidthHeight, height: self.imageWidthHeight)
                                .cornerRadius(50)
                            Spacer()
                        }else{
                            
                    
                            WebImage(url: URL(string:self.centerComment.userProfileImageUrl))
                                .placeholder {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .resizable()
                                .frame(width: self.imageWidthHeight, height: self.imageWidthHeight)
                                .cornerRadius(50)
                            
                        }
                        
                        
                    }
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width / 7.2)
                
                VStack(alignment : .leading , spacing : 10){
                    HStack(alignment : .center){
                        VStack(alignment : .leading , spacing : 5){
                            
                            Button(action : {
                              
                            }){
                                Text(self.centerComment.commentNickName)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primaryColor"))
                                    .font(.system(size: self.fontSizeName))
                            }
//                            Button(action : {
//
//                            }){
//                                Text(self.dommyCenter.centerName)
//                                    .font(.system(size: self.fontSizeSmall))
//                                    .foregroundColor(Color("primaryColor"))
//                                    .fontWeight(.semibold)
//                            }
//                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Spacer()
                        if(self.centerComment.commentURL != staticString().nilString()){
                            Button(action : {
                                UIApplication.shared.open(URL(string: self.centerComment.commentURL)!)
                            }){
                                Image(systemName: "play.rectangle.fill")
                                    .resizable()
                                    .foregroundColor((Color("deepRed")))
                                    .background(Color.white)
                                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                    .frame(width: 30 , height: 15)
                                    .aspectRatio(contentMode: .fit)
                             }
                        }
                    }
                    Button(action : {
                        
                    }){
                        
                        
                        singleImageView(imageURL : self.centerComment.imageThumbUrl)
                           
                       
//                        WebImage(url: URL(string:self.centerComment.imageThumbUrl))
//                            .placeholder {
//                                Image(systemName: "photo")
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                            }
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: .infinity, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                            .cornerRadius(5)
//                            .clipped()
//
                        
                      
                    }.buttonStyle(BorderlessButtonStyle())
                 
                    
                    
                    HStack{
                        Spacer()
                        Text(self.centerComment.commentDate)
                            .fontWeight(.semibold)
                            .font(.system(size: self.fontSizeSmall))
                    }
                    
                }
            }
            
        }
        .padding(.vertical,5)
    }

}

