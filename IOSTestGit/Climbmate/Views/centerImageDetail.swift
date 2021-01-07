//
//  centerImageDetail.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/01.
//

import SwiftUI
import SDWebImageSwiftUI

struct centerImageDetail: View {
    
    @State var centerImages : [centerSettingImageModel]
    let centerName : String
    @State var showImageViewer: Bool = true
    
    @State var presented : Bool = false
    
    @State var imageIndex : Int = 0
    
    var body: some View {
        VStack{
            TabView {
                ForEach(0..<self.centerImages.count) { i in
                    VStack{
                        
                        Button(action : {
                            self.imageIndex = i
                            self.presented.toggle()
                        }){
                            WebImage(url: URL(string: self.centerImages[i].imageThumbUrl))
                                .placeholder {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .resizable()
                                .cornerRadius(5)
                                
                        }
                    }
                    
                  
                }
                
            }
            .frame(height : UIScreen.main.bounds.height/3)
            .onAppear(perform: {
               UIScrollView.appearance().bounces = false
             })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .sheet(isPresented: self.$presented) {
                detailImageView(centerSettingImageModels : self.centerImages , centerSettingModels : nil , index : self.imageIndex)
            }
            
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        .navigationBarTitle(self.centerName , displayMode: .inline)
    }
}

