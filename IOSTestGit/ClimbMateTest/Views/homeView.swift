//
//  homeView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/09/28.
//
//주석주석
// ㅎㅎ 한석


import SwiftUI
import SDWebImageSwiftUI
import MapKit
import SystemConfiguration

struct homeView: View {
    
    //어플리케이션을 처음으로 켰을경우 애니메이션에대한 on off를 컨트롤해주는 bool 값
    @Binding var firstSettingAni : Bool
    //위치정보를 최초 셋팅을 판단해주는 공간
    @State var firstLocation : Bool = false
    //배너리스트 이미지에대한 값들이 저장되어있는 배열
    @State var bannerList = [homeBannerImageModel]()
    //근처암장리스트를 받아왔음
    @State var nearCenterList = [centerModel]()
    @State var resentUpdateCenterList = [centerModel]()
    // 근처암장리스트에서 들어가는 검색키워드를 저장핺는공간
    @State var subKeyword : String = ""
    // 최초 gps를통해 위치를 세팅하고있는지 체크해주는값
    @State var placeSetting : Bool = false
    // 위치권한 퍼미션체크
    @State var locationPermission : Bool = false
    @State var animate : Bool = false
    @State var networking : Bool = false
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    //    let locationMGR = locationManager()
    let location = CLLocationManager()
    //해당변수가 true가되면 노티피케이션에 해당하는 이벤트가 실행이됨
    @State var notiActive : Bool = false
    //해당변수가 노티이벤트타입이 결정되는공간
    @State var eventType : String = ""
    //해당변수가 노티이벤트의 변수를 결정한다 대부분 한가지로 사용하기때문에 한가지로 통일함
    @State var eventValue : String = ""
    @State private var currentImageIndex = 0
    var body: some View {
        ZStack{
            if(self.eventType == "0"){
                NavigationLink(
                    //추후에 사용할것
                    //푸시알람
                    destination: centerDetailViewRecreate(clickType: staticString().staticClickType[4],centerID: notiManager().readData()[0].value(forKey: "eventNumber") as! String),
                    isActive: self.$notiActive){
                }
            }
            VStack{
                //상단로고와 검색바
                topNaviLogoSearch().padding(.vertical,10)
                ScrollView{
                    //배너의 갯수가 최소 0개 이상 있을때만 사용
                    if(self.bannerList.count > 0){
                        //탭뷰
                            TabView(selection: self.$currentImageIndex){
                                //받아온 배너리스트의 카운트 만큼 뿌려준다.
                                ForEach(0..<self.bannerList.count){ num in
                                    //클릭시 넘어갈 웹뷰로 넘어간다.
                                    NavigationLink(destination: webViewModel(urlToLoad: self.bannerList[num].imageClickLink).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)){
                                        WebImage(url: URL(string: self.bannerList[num].imageURL))
                                            //다운로드전에 or 실패했을경우 보여줄 이미지
                                            .placeholder {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .foregroundColor(.gray)
                                            }
                                            .resizable()
                                            .overlay(Color("primaryColor").opacity(0.4))
                                            .tag(num)
                                            
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.horizontal)
                            //탭뷰시 위아래 스크롤을 못하게 막아주는 코드
                            .onReceive(self.timer, perform: { _ in
                                withAnimation(.easeInOut(duration: 0.3)){
                                    //일정시간마다 인덱스를 변경해준
                                    self.currentImageIndex = self.currentImageIndex < self.bannerList.count ? self.currentImageIndex + 1 : 0
                                }
                                
                            })
                            .tabViewStyle(PageTabViewStyle())
                            .frame(height: 250, alignment: .center)
                        
                    }
                    //라인을 구분해주는 뷰
                    devideLineView(height: 2, topPadding: 5, bottomPadding: 5)
                    homeViewRecommendCenter(centerList: self.$nearCenterList, subKeyword: self.$subKeyword, placeSetting: self.$placeSetting , keyWord : "내 주변 클라이밍장은?" , centerListType : staticString().staticClickType[0] , networking : self.$networking)
                    devideLineView(height: 2, topPadding: 5, bottomPadding: 5)
                    homeViewRecommendCenter(centerList: self.$resentUpdateCenterList , subKeyword: self.$subKeyword, placeSetting: self.$placeSetting, keyWord : "최근 세팅이 변경된 클라이밍장은?", centerListType :staticString().staticClickType[1] , networking : self.$networking)
                    devideLineView(height: 2, topPadding: 5, bottomPadding: 5)
                }//VStack
                .frame(width: UIScreen.main.bounds.size.width)
                
            }//스크롤뷰
            //내 주변 암장 같은 경우위치정보를 받았을경우에만 근처 암장리스트를 받아야하고
            .onChange(of: self.placeSetting){_ in
                if(self.nearCenterList.isEmpty && self.placeSetting){
                    centerListViewModel().getNearCenterList{
                        result , error , totalCount in
                        if(error.errorCheck){
                            alertManager().alertView(title: "통신오류", reason: error.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                        }
                        else{
                            if((result?.isEmpty) != nil){
                                self.nearCenterList = result!
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[3]) {
                            self.firstSettingAni = true
                            
                            if(!notiManager().readData().isEmpty){
                                self.eventType = notiManager().readData()[0].value(forKey: "eventType") as! String
                                self.notiActive = true
                                DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[3]) {
                                    notiManager().allDelete()
                                }
                            }
                        }
                        withAnimation(.easeOut(duration: 0.3)){
                            self.networking = false
                        }
                    }
                }
            }
            .padding(.top,1)
            .navigationBarHidden(true)
            .frame(width: UIScreen.main.bounds.size.width)
            
             if(self.networking){
                loadingView()
            }
           
        }
        .onAppear(){
          
            
            
            //위치권한 요청
            locationManager().locationManagerDidChangeAuthorization(self.location)
            //최근 업데이트된암장과 주변클라이밍장 정보같은경우 같은 경우 위치정보와 상관없이 로직이 동작할거기때문에 스크롤뷰가 보이자마자 바로 데이터요청
            if(self.bannerList.isEmpty){
                self.networking = true
                homeBannerListViewModel().getBannerList(){
                    result , error in
                    if(error.errorCheck){
                        alertManager().alertView(title: "배너", reason: error.networkErrorReason!)
                    }else{
                        self.bannerList = result!
                    }
                    
                }
            }
            
            if(self.resentUpdateCenterList.isEmpty){
                centerListViewModel().getRecentUpdateCenterList(){
                    result , error in
                    
                    if(error.errorCheck){
                        alertManager().alertView(title: "통신오류", reason: error.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                    }
                    else{
                        if((result?.isEmpty) != nil){
                            self.resentUpdateCenterList = result!
                        }
                    }
                }
            }
            
            if(!self.firstLocation){
                userData().userLocationClear()
                //위치정보 기반으로 XY값을 가져온다.
                let tempXY = locationManager().getlocation()
                //유저데이터에 XY데이터를 넣어준후
                userData().setLocation(x: tempXY.x, y: tempXY.y){
                    _ in
                    //유저정보 세팅이 끝 난후 셋팅한 GPS값을 기준으로  x , y , 시 동을 셋팅한다.
                    if(userData().returnUserData(index: 8) != nil && userData().returnUserData(index: 8) != "" && locationManager().locationPermissonCheck()){
                        self.subKeyword = userData().returnUserData(index: 8)!
                        self.placeSetting = true
                        self.firstLocation = true
                    }else{
                        userData().userLocationSetTemp()
                        self.subKeyword = userData().returnUserData(index: 8)!
                        self.placeSetting = true
                        self.firstLocation = true
                    }
                }
            }
        }
        .onChange(of: self.locationPermission){ change in
            if(change && self.nearCenterList.isEmpty){
                userData().userLocationClear()
                //위치정보 기반으로 XY값을 가져온다.
                let tempXY = locationManager().getlocation()
                //유저데이터에 XY데이터를 넣어준후
                userData().setLocation(x: tempXY.x, y: tempXY.y){
                    _ in
                    //유저정보 셋팅이 끝 난후 셋팅한 GPS값을 기준으로  x , y , 시 동을 셋팅한다.
                    if(userData().returnUserData(index: 8) != nil && userData().returnUserData(index: 8) != "" && locationManager().locationPermissonCheck()){
                        
                        self.subKeyword = userData().returnUserData(index: 8)!
                        self.placeSetting = true
                        
                        self.firstLocation = true
                    }else{
                        userData().userLocationSetTemp()
                        self.subKeyword = userData().returnUserData(index: 8)!
                        self.placeSetting = true
                        
                        self.firstLocation = true
                    }
                }
            }
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            UIApplication.shared.windows.first?.endEditing(true)
        })
    }
}

struct homeViewRecommendCenter: View {
    @Binding var centerList : [centerModel]
    @Binding var subKeyword : String
    @Binding var placeSetting : Bool
    
    var keyWord : String
    var centerListType : Int
    
    @Binding var networking : Bool
    @State var networkCheck : Bool = true
    
    let connectivity = SCNetworkReachabilityCreateWithName(nil, "www.app-designer2.io")
    
    var body: some View {
        VStack{
            HStack(spacing : 5){
                Text(keyWord)
                    .fontWeight(.black)
                if(self.centerListType == 1){
                    Button(action:{
                        var flgs = SCNetworkReachabilityFlags()
                        SCNetworkReachabilityGetFlags(self.connectivity!, &flgs)
                        
                        if networkMonitor().networkReachable(to: flgs){
                            //위치정보를 동의하였을경우 현재위치에맞춰 위치를 셋팅
                            if locationManager().locationPermissonCheck(){
                                self.placeSetting = false
                                self.networking = true
                                userData().userLocationClear()
                                //위치정보 기반으로 XY값을 가져온다.
                                let tempXY = locationManager().getlocation()
                                //유저데이터에 XY데이터를 넣어준후
                                userData().setLocation(x: tempXY.x, y: tempXY.y){
                                    _ in
                                    //유저정보 셋팅이 끝 난후 셋팅한 GPS값을 기준으로  x , y , 시 동을 셋팅한다.
                                    if(userData().returnUserData(index: 8) != nil && userData().returnUserData(index: 8) != "" && locationManager().locationPermissonCheck()){
                                        self.subKeyword = userData().returnUserData(index: 8)!
                                        self.placeSetting = true
                                        //위치정보를 초기화해서 다시 받았으니 리스트를 삭제하여 다시 만들어야한다.
                                        if(self.centerListType == 1){
                                            self.centerList.removeAll()
                                            centerListViewModel().getNearCenterList{
                                                result , error , totalCount in
                                                if(error.errorCheck){
                                                    alertManager().alertView(title: "통신오류", reason: error.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                                                }
                                                else{
                                                    if((result?.isEmpty) != nil){
                                                        self.centerList = result!
                                                    }
                                                }
                                                self.networking = false
                                            }
                                            
                                        }
                                    }else{
                                        userData().userLocationSetTemp()
                                        self.subKeyword = userData().returnUserData(index: 8)!
                                        self.placeSetting = true
                                        self.networking = false
                                    }
                                }
                            }else{
                                alertManager().settingAlert(title : staticString().staticSettingTitleReturn(index: 0), message : staticString().staticSettingMessageReturn(index: 0))
                                
                            }
                        }else{
                            self.networkCheck = false
                            networkAlarmView(networkCheck : self.$networkCheck).alert()
                        }
                        
                        
                    }){
                        
                        Text(self.subKeyword)
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 13))
                    }
                }
                Spacer()
                if(centerListType == 1){
                    NavigationLink(
                        //유저데이터중 수원시 금곡동으로 검색할경우 아예 없는게 나올수도있어 좀 넓게 작업함 수원시
                        //서울일경우 구단위로 체크됨
                        destination: searchResultView(getSearchKeyword: userData().returnUserData(index: 9) ?? "서초구"),
                        label: {
                            Text("더보기")
                                .font(.system(size: 15))
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                        })
                }
                else{
                    NavigationLink(
                        destination: recentUpdateCenterListView(recentUpdateCenterList : self.$centerList),
                        label: {
                            Text("더보기")
                                .font(.system(size: 15))
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                        })
                }
            }
            .padding()
            if(self.centerListType == 1){
                ScrollView(.horizontal,showsIndicators:false){
                    HStack{
                        if(self.centerList.count <= 15){
                            ForEach(0..<self.centerList.count , id: \.self){center in
                                centerCard(center: self.centerList[center] , centertype : self.centerListType)
                            }
                        }
                        else{
                            ForEach(0..<15 , id: \.self){i in
                                centerCard(center: self.centerList[i] , centertype : self.centerListType)
                            }
                        }
                    }
                    .padding(.leading,10)
                    .padding(.trailing,10)
                }
            }
            else if (self.centerListType == 2){
                ScrollView(.horizontal,showsIndicators:false){
                    HStack{
                        if(self.centerList.count <= 10){
                            ForEach(0..<self.centerList.count , id: \.self){center in
                                centerCard(center: self.centerList[center] , centertype : self.centerListType)
                            }
                        }
                        else{
                            ForEach(0..<10 , id: \.self){i in
                                centerCard(center: self.centerList[i] , centertype : self.centerListType)
                            }
                        }
                    }.padding(.leading,10)
                    .padding(.trailing,10)
                }
            }
        }
    }
}

