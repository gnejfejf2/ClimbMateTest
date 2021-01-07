//
//  loadingView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/28.
//

import SwiftUI
//전체적인 통신대기에서 나오는 에니메이션을 담당하는 뷰이다.
struct loadingView: View {
    
    @State var animate : Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                VStack(alignment : .center){
                    
                    Circle()
                        .trim(from: 0, to: 1.0)
                        .stroke(AngularGradient(gradient: .init(colors: [.black,.white]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 45, height: 45)
                        .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                        .animation(Animation.linear(duration: 0.7)
                                    .repeatForever(autoreverses: false))
                    
                    Text("잠시만 기다려주세요..")
                        .foregroundColor(Color.black)
                        .padding(.top , 10)
                    
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(15)
                .onAppear(){
                  
                    self.animate.toggle()
                }
                Spacer()
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .background(Color.black.opacity(0.3))
         
      
    
    }
}



struct loadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            
          
           
            
            Text("테스트")
           
            
            
          
          
        }
        
       
    }
}
