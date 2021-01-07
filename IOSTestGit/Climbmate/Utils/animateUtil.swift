//
//  animateUtil.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct animateUtil : View{
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        
            VStack{
                Spacer()
                Spacer()
                HStack{
                    Spacer()
                    
                    Image(self.colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                        .resizable()
                        .frame(width: 320, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                
                }
                Spacer()
                Spacer()
                Spacer()
            }
            .background(Color("primaryColorReverse"))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
           
    }
   

    
    
}

