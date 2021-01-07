//
//  myPageView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/20.
//

import SwiftUI
import SDWebImageSwiftUI
import KakaoSDKUser

struct myPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var logoutCheck : Bool = false
    @State var loginViewBool : Bool = false
    @State var passwordChange : Bool = false
    
    var body: some View {
  
            ZStack{
                NavigationLink(
                    destination:  passwordChangeView(),
                    isActive: self.$passwordChange
                ){
                    
                }
                
               
                VStack{
                   
                    
                    Image(self.colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                        .resizable()
                        .frame(height: UIScreen.main.bounds.height / 4)
                        .padding(.horizontal , 5)
                        .padding(.top, 20)
                        devideLineView(height: 0, topPadding: 5, bottomPadding:5)
                    
                    
                        VStack(spacing: 0){
                            if(self.logoutCheck){
                                logOutUserMyPageView(loginBool: self.$loginViewBool)
                            }else{
                                loginMyPageView()
                            }
                          
                            Button(action: {
                                
                            }){
                                myPageBodyView(text: "공지사항")
                            }.foregroundColor(Color("primaryColor"))
//                            Button(action: {}){
//                                myPageBodyView(text: "이벤트")
//                            }.foregroundColor(Color("primaryColor"))
                            
                            NavigationLink(destination: inquiryView()){
                                myPageBodyView(text: "문의하기")
                                    .foregroundColor(Color("primaryColor"))
                            }
                            
                            NavigationLink(destination:
                                preferencesView()
                            ){
                                myPageBodyView(text: "환경설정")
                            }.foregroundColor(Color("primaryColor"))
                            devideLineView(topPadding: 10, bottomPadding: 0)
                           
                        }
                        .padding(.horizontal , 15)
                    Spacer()
                    myPageBottonView()
                }
               
                
            }
            .onAppear(){
         
                if(UserDefaults.standard.string(forKey: "accessKey") == nil){
                    self.logoutCheck = true
                }
                else{
                    self.logoutCheck = false
                }
            }
            .padding(.top,5)
            .navigationBarHidden(true)
            .onChange(of: self.loginViewBool, perform: { value in
                if(UserDefaults.standard.string(forKey: "accessKey") == nil){
                    self.logoutCheck = true
                }
                else{
                    self.logoutCheck = false
                }
            })
            .fullScreenCover(isPresented: self.$loginViewBool, content: {
                loginView(loginBool: self.$loginViewBool , passwordChange : self.$passwordChange)
            })
        
    }
}

struct loginMyPageView : View {
    
    @State var allWidth : CGFloat = UIScreen.main.bounds.width
    @State var nomalWidth : CGFloat = UIScreen.main.bounds.width / 4
    
    @State var userNickName : String = userData().returnUserData(index: 4) ?? "알 수 없음"
    @State var profilURL : String = userData().returnUserData(index: 10) ?? "1000"
    
    var body: some View{
        VStack(spacing : 5){
            NavigationLink(destination: myPageEditView()){
                HStack(spacing : 10){
                    if(userData().returnUserData(index: 10) == nil || userData().returnUserData(index: 10) == "" ||
                        userData().returnUserData(index: 10) == "1000" || self.profilURL == "1000"){
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .foregroundColor(Color("primaryColor"))
                            .frame(width: 40 , height: 40)
                    }else{
                        WebImage(url: URL(string: self.profilURL))
                            .resizable()
                            .foregroundColor(Color("primaryColor"))
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
            
                    }
                    Text("\(self.userNickName)님 안녕하세요")
                        .foregroundColor(Color("primaryColor").opacity(0.8))
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Spacer()
                    
                }
            }
        }
        
        .padding(.top, 10)
        .onAppear(){
            if( self.userNickName != userData().returnUserData(index: 4) ?? "알 수 없음"){
                self.userNickName = userData().returnUserData(index: 4) ?? "알 수 없음"
            }
            if( self.profilURL != userData().returnUserData(index: 10) ?? "1000"){
                self.profilURL = userData().returnUserData(index: 10) ?? "1000"
            }
        }
    }
}
struct logOutUserMyPageView : View {
    @Binding var loginBool : Bool
    var body: some View{
        VStack{

            Button(action : {
                
                self.loginBool = true
            }){
                HStack{
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .foregroundColor(Color("primaryColor"))
                        .frame(width: UIScreen.main.bounds.height / 13, height: UIScreen.main.bounds.height / 13)
                    
                    Text("로그인 해주세요")
                        .foregroundColor(Color.gray.opacity(0.8))
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .foregroundColor(Color.gray.opacity(0.8))
                        .frame(width: UIScreen.main.bounds.width / 40, height: UIScreen.main.bounds.height / 30)
                        .padding(.trailing,10)
                }
                .frame(height: UIScreen.main.bounds.height / 15)
                .padding(.top, 15)
             
            }
        }
        
    }
}

struct myPageBodyView : View{
    let text : String
    var body: some View{
        VStack{
            devideLineView()
            HStack{
                Text(self.text)
                    .fontWeight(.light)
                    .font(.system(size: UIScreen.main.scale * 8))
                    
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(width: UIScreen.main.bounds.width / 40, height: UIScreen.main.bounds.height / 40)
                    
            }
            .frame(height: UIScreen.main.bounds.height / 25)
           
        }
    }
}
struct myPageBottonView : View {
    var body: some View{
        VStack{
            Capsule()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.bottom,10)
            Spacer()
            HStack{
                Group{
                    Spacer()
                    Button(action : {
                       
                        
                    }){
                        Text("사업자정보 확인")
                            .foregroundColor(Color.gray.opacity(0.9))
                            .font(.system(size: UIScreen.main.nativeScale * 4))
                        
                    }
                    Spacer()
                }
               
//                Group{
//                    Spacer()
//                    Button(action : {}){
//                        Text("전자금융거래이용약관")
//                            .foregroundColor(Color.gray.opacity(0.9))
//                            .font(.system(size: UIScreen.main.nativeScale * 4))
//
//                    }
//                    Spacer()
//                }
                Group{
                    Spacer()
                    NavigationLink(destination: webViewModel(urlToLoad: "https://climbmate.co.kr/policy?category=private&client=iOS")){
                        Text("개인정보처리방침")
                            .foregroundColor(Color("primaryColor"))
                            .font(.system(size: UIScreen.main.nativeScale * 4))
                    }
                   
                    Spacer()
                }
                Group{
                    Spacer()
                    NavigationLink(destination: webViewModel(urlToLoad: "https://climbmate.co.kr/policy?category=use&client=iOS")){
                        Text("이용약관")
                            .foregroundColor(Color.gray.opacity(0.9))
                            .font(.system(size: UIScreen.main.nativeScale * 4))
                        
                    }
                    Spacer()
                }
            }
            .padding(.bottom,10)
            Spacer()
            Capsule()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.bottom,10)

        }
        
        .background(Color.gray.opacity(0.2))
        .frame(height: UIScreen.main.bounds.height / 20)
        
        
      
    }
}



