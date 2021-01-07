//
//  ContentView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/09/28.
//

import SwiftUI
import MapKit
import CoreData
import SystemConfiguration

struct mainView: View {
    
    @State var tabviewCount : Int = 0
    
    //네트워크 체크
    let connectivity = SCNetworkReachabilityCreateWithName(nil, "www.app-designer2.io")
    
    @State var networkCheck : Bool = false
    
    @State var firstSettingAni : Bool = false
    @State var animate : Bool = false
    @State var passwordChange : Bool = false
    
    @State var notiActive : Bool = false
    
    @State var eventType : String = ""
    
    var body: some View {
        ZStack{
            
            //네비게이션뷰가 탭뷰 위에있는 이유는 탭뷰안에 있다면 하단 바텀네비게이션이 페이지를 옮겨도 사라지지않음
            NavigationView{
                ZStack{
                    
                    
                    if(self.networkCheck){
                        TabView(selection: self.$tabviewCount){
                            homeView(firstSettingAni : self.$firstSettingAni)
                                .tabItem {
                                    Image(systemName: "house.fill")
                                    Text("홈")
                                }.tag(0)
                            searchView()
                                .tabItem {
                                    Image(systemName: "magnifyingglass")
                                    Text("검색")
                                    
                                }
                                .environment(\.managedObjectContext, persistenteContainer.viewContext)
                                .tag(1)
                            favoritesView(tabviewCount : self.$tabviewCount)
                                .tabItem {
                                    Image(systemName: "suit.heart")
                                    Text("즐겨찾기")
                                }
                                .tag(2)
                            myPageViewRecreate()
                                .tabItem {
                                    Image(systemName: "person")
                                    Text("MY")
                                }
                                .tag(3)
                        }
                        .onReceive(NotificationCenter.default
                                    .publisher(for: NSNotification.Name("FCMToken"))){ obj in
                            
                            if let userInfo = obj.userInfo , let getEventType = userInfo["eventType"] {
                                self.eventType = getEventType as! String
                                self.notiActive = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[3]) {
                                notiManager().allDelete()
                            }
                        }
                        //탭뷰
                    }
                    else{
                        VStack{
                            Text("Networking...")
                        }
                    }
                    
                    //이벤트타입이 0이였을경우
                    if self.eventType == "0"{
                        NavigationLink(
                            //추후에 사용할것
                            //푸시알람
                            destination: centerDetailViewRecreate(clickType: staticString().staticClickType[4], centerID: notiManager().readData()[0].value(forKey: "eventNumber") as! String),
                            isActive: self.$notiActive){
                        }
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
            
            
            //네비게이션뷰
            .onAppear(){
                
                var flgs = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(self.connectivity!, &flgs)
                
                if networkMonitor().networkReachable(to: flgs){
                    self.networkCheck = true
                }else{
                    self.networkCheck = false
                    networkAlarmView(networkCheck : self.$networkCheck).alert()
                }
                if(UserDefaults.standard.string(forKey: "accessKey") != nil){
                    loginViewModel().autoLogin(){
                        result in
                        if(result.errorCheck){
                            userData().userInformationClear()
                            alertManager().alertView(title: "로그아웃", reason: "세션이 만료되 로그아웃 처리 되었습니다.")
                        }else if(result.networkErrorReason == "change"){
                            self.passwordChange = true
                        }else{
                            logManager().log(log: "자동로그인성공")
                        }
                    }
                }
            }
            
            if(!self.firstSettingAni){
                animateUtil()
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        mainView()
    }
}
