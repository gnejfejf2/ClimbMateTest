//
//  notificationCardView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/12/01.
//

import SwiftUI
import SDWebImageSwiftUI


struct notificationCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var imagePage : Int = 0
    
    let fontSizeName : CGFloat = 14
    let fontSizeSmall : CGFloat = 10
    let imageWidthHeight : CGFloat = UIScreen.main.bounds.width / 9
    
    
    let centerNotice : centerNoticeModel
    let centerName : String
    
    var body: some View {
        HStack(alignment: .top , spacing : 0){
            VStack(alignment : .leading , spacing : 7){
                HStack(alignment : .center){
                    VStack(){
                        HStack{
                            Image(self.colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                                .resizable()
                                .frame(width: self.imageWidthHeight, height: self.imageWidthHeight)
                                .cornerRadius(50)
                            Spacer()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 7.2)
                    VStack(alignment : .leading , spacing : 5){
                        Button(action : {
                            
                        }){
                            Text("관리자")
                                .fontWeight(.bold)
                                .foregroundColor(Color("primaryColor"))
                                .font(.system(size: self.fontSizeName))
                        }
                        Button(action : {
                            
                        }){
                            Text(self.centerName)
                                .font(.system(size: self.fontSizeSmall))
                                .foregroundColor(Color("primaryColor"))
                                .fontWeight(.semibold)
                        }
                    }
                    Spacer()
                    Button(action : {
                        
                    }){
                        Image("menu")
                            .resizable()
                            .foregroundColor((Color("primaryColor")))
                            .frame(width: 30 , height: 30)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                
                
                NavigationLink(
                    destination: webViewModel(urlToLoad: self.centerNotice.noticeUrl)){
                    VStack{
                        WebImage(url: URL(string:self.centerNotice.noticeImageUrl))
                            .placeholder {
                                Image(systemName: "photo")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: UIScreen.main.bounds.height / 3, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: UIScreen.main.bounds.height / 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipped()
                        if(false){
                            pageControl(current: self.$imagePage , totalCount : 1)
                        }
                        VStack(alignment : .leading , spacing : 5){
                            HStack(spacing : 3){
                                Button(action : {
                                    self.imagePage += 1
                                }){
                                    Text(self.centerName)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("primaryColor"))
                                        .font(.system(size: self.fontSizeName))
                                }
                            }
                            Text(self.centerNotice.noticeDetail)
                                .font(.system(size: self.fontSizeName))
                            HStack{
                                Spacer()
                                Text(self.centerNotice.noticeDate)
                                    .fontWeight(.semibold)
                                    .font(.system(size: self.fontSizeSmall))
                            }
                        }
                    }
                        .foregroundColor(Color("primaryColor"))
                }
                
                
                
            }
        }
        .padding(.vertical , 10)
    }
}
