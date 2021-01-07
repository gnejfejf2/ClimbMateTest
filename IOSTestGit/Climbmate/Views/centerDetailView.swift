//
//  centerDetailView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/04.
//

import SwiftUI
import SDWebImageSwiftUI

struct centerDetailView: View {
    
    
    let centerID : String
    let centerName : String
    @State var show = false
    @State var selected = 0
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var heigtVStackMain : CGFloat = 100
    @State var heigtVStackTab : CGFloat = 100
    
    @State var networkCheck : Bool = false
    
    @State var getInfomation : Bool = false
    
    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    
    
    @State var centerDetailM : centerDetailModel?
    
    
    
    var body: some View {
        
        ZStack(alignment: .top){
//            if(self.centerDetailM != nil && self.getInfomation){
//                WebImage(url: URL(string: self.centerBannerImages[0].imageThumbUrl))
//                    .placeholder {
//                        Image(systemName: "photo")
//                            .resizable()
//                            .foregroundColor(.gray)
//                    }
//
//                ScrollView(.vertical, showsIndicators : false){
//                    VStack(spacing: 0){
//                        ZStack{
//                            GeometryReader{ g in
//                                VStack{
//                                    centerDetailTopViewRecreate(centerDetailInfo : self.centerDetailM!.centerDetail , centerRepresentationItem : self.centerDetailM!.centerGoods[0] , networkCheck: self.$networkCheck , centerDetailM : self.centerDetailM!)
//                                        .frame(width : g.size.width - staticString().statincCGFloat[5])
//
//                                    //                                centerCommentView(comment : self.centerDetailM!.centerDetail.detailComment)
//                                    //                                    .frame(width : g.size.width - staticString().statincCGFloat[3])
//
//                                    middleTabView(index: self.$selected,show : self.$show)
//                                    devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
//                                }
//                                .background(Color("smokeBackgroundColor"))
//                                .padding(.top , UIScreen.main.bounds.height / 3)
//                                //VStack의크기를 가져오기위해 사용한다.
//                                .background(
//                                    //지오메티르 리더를 선언하여 컬러가없는 빈객체를 선언하고 해당 객체의 크기를 구하고
//                                    GeometryReader { proxy in
//                                        Color.clear
//                                            .preference(key: sizePreferenceKey.self, value: proxy.size)
//                                    }
//
//                                )
//                                //SizePreferenceKey.self 값이 변경될때마다 실행되는 트리거를 실행하고
//                                .onPreferenceChange(sizePreferenceKey.self){ newSize in
//                                    self.heigtVStackMain = newSize.height
//                                }
//                                .frame(height : self.heigtVStackMain)
//                                .onReceive(self.time){ (_) in
//                                    let y = g.frame(in: .global).minY
//                                    if -y > self.heigtVStackMain - 110{
//                                        if(!self.show){
//                                            withAnimation{
//                                                self.show.toggle()
//                                            }
//                                        }
//                                    }else{
//                                        if(self.show){
//                                            withAnimation{
//                                                self.show.toggle()
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            .frame(width :screenWidth , height : self.heigtVStackMain)
//
//                            HStack(){
//                                Spacer()
//                                    .frame(width : 15)
//
//                                VStack(){
//                                    Spacer()
//                                    Spacer()
//                                    Image("mainLogo")
//                                        .resizable()
//                                        .frame(width : 60 , height : 30)
//                                    Spacer()
//                                    Spacer()
//                                    Spacer()
//                                }
//                                .frame(width : 60 , height : 60)
//                                .background(Color.white)
//                                .cornerRadius(10)
//
//
//
//
//
//                                //                            Image(colorScheme == .light ? "mainLogo" : "mainLogoReverse")
//                                //                                .resizable()
//                                //                                .frame(width : 60 , height : 60)
//                                //                                .background(Color("smokeBackgroundColor"))
//                                //                                .cornerRadius(10)
//                                Spacer()
//                            }.padding(.top , 45)
//                        }
//
//                        GeometryReader{ g in
//                            VStack{
//                                if(self.selected == 0){
//                                    informationView(centerDetailInfo : self.centerDetailM!)
//                                }
//                                else if(self.selected == 1){
//                                    settingView(centerDetailInfo : self.centerDetailM!)
//                                }
//                                else if(self.selected == 2){
//                                    VStack{
//                                        Text("추후 업데이트될 예정입니다.")
//                                    }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                                }
//                            }
//                            .background(Color("smokeBackgroundColor"))
//                            .background(
//                                //지오메티르 리더를 선언하여 컬러가없는 빈객체를 선언하고 해당 객체의 크기를 구하고
//                                GeometryReader { proxy in
//                                    Color.clear
//                                        .preference(key: sizePreferenceKey.self, value: proxy.size)
//                                }
//                            )
//                            //SizePreferenceKey.self 값이 변경될때마다 실행되는 트리거를 실행하고
//                            .onPreferenceChange(sizePreferenceKey.self){ newSize in
//
//
//                                self.heigtVStackTab = newSize.height
//
//                            }
//                        }
//                        .frame(width :screenWidth,height : self.heigtVStackTab)
//                    }
//
//                }.frame(width : screenWidth)
//
//                if(self.show){
//                    VStack(spacing : 0 ){
//                        middleTabView(index: self.$selected,show : self.$show)
//                            .background(Color("primaryColorReverse"))
//                        devideLineView(height : 1 , topPadding : 0 , bottomPadding : 0)
//                            .foregroundColor(Color("primaryColor"))
//                    }
//                }
//
//            }
        }
        .frame(width :screenWidth)
        .onAppear(){
            if (self.centerID).isEmpty {
                alertManager().alertView(title: "통신오류", reason: "암장 정보를 가져오기 실패하였습니다. \n 다시 한번 시도해주세요.")
            }
            else{
                centerDetailViewModel().getCenterDetailinformation(centerID: self.centerID , clickType: 0){
                    i in
                    self.centerDetailM = i
                    self.getInfomation = true
                }
            }
        }
        .navigationBarTitle(Text(self.centerName), displayMode: .inline)
        
    }
    
    
}




// 받아온 센터의 이미지수만큼 텝뷰를 만들어 보여준다.
struct  centerDetailPagingView: View {
    
    let centerBannerImages : [centerBannerImageModel]
    
    var body: some View {
        
        VStack{
            TabView {
                ForEach(0..<self.centerBannerImages.count) { i in
                    
                    WebImage(url: URL(string: self.centerBannerImages[i].imageThumbUrl))
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        // Supports ViewBuilder as well
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        .resizable()
                        .cornerRadius(staticString().statincCGFloat[1])
                    
                }
            }
            .frame(height : 230)
            .tabViewStyle(PageTabViewStyle())
        }
        .foregroundColor(Color("primaryColor").opacity(0.7))
        .padding()
        .background(Color("primaryColorReverse"))
        .overlay(Rectangle().stroke(Color("primaryColor").opacity(0.03), lineWidth: 2).shadow(radius: staticString().statincCGFloat[0]))
        .cornerRadius(staticString().statincCGFloat[1])
        
    }
    
}

struct centerDetailTopView : View {
    
    let centerDetailInfo : centerDetailInformation
    let centerRepresentationItem : centerGoodsModel
    
    @Binding var networkCheck : Bool
    
    @State var centerDetailM : centerDetailModel
    
    var body: some View{
        VStack(spacing : 10){
            
            Text(self.centerDetailInfo.centerName)
                .foregroundColor(Color("primaryColor"))
                .font(.title)
                .lineLimit(nil)
            
            
            HStack(spacing : 0){
                
                Text("세팅이 변경된 날짜")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor")).opacity(0.8)
                    .frame(width: UIScreen.main.bounds.width / 2.5 , alignment: .leading)
                Spacer()
                Text("\(self.centerDetailInfo.detailRecentUpdate)")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor")).opacity(0.8)
                    .frame(width: UIScreen.main.bounds.width / 3 , alignment: .leading)
                
            }
            
            HStack(spacing : 0){
                Text("\(self.centerRepresentationItem.goodsName)")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor")).opacity(0.8)
                    .frame(width: UIScreen.main.bounds.width / 2.5 , alignment: .leading)
                Spacer()
                
                Text(staticString().decimalWon(value: Int(self.centerRepresentationItem.goodsPrice) ?? 0))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor")).opacity(0.8)
                    .frame(width: UIScreen.main.bounds.width / 3 , alignment: .leading)
                
            }
            
            
            HStack{
                Spacer()
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + self.centerDetailM.centerDetail.centerNumber
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                }){
                    //buttonAction
                    HStack{
                        Image(systemName:"phone")
                            .foregroundColor(.green)
                        Text("전화")
                    }
                    .foregroundColor(Color("primaryColor"))
                    .font(.system(size: 20))
                    
                }
                //buttonUI
                Spacer()
                Button(action: {
                    if(networkManager().accessKeyCheck().errorCheck){
                        alertManager().alertView(title: "로그인", reason: "로그인이 필요한 기능입니다.")
                    }
                    else{
                        if(!self.networkCheck){
                            self.networkCheck = true
                            if(centerDetailM.subscription == "2"){
                                centerDetailViewModel().favoritesCenterAdd(centerID: self.centerDetailInfo.id){
                                    result in
                                    if(!result.errorCheck){
                                        alertManager().alertView(title: "통신오류", reason: result.networkErrorReason ?? "알 수 없음")
                                    }else{
                                        alertManager().alertView(title: "즐겨찾기", reason: "\(self.centerDetailInfo.centerName)이 즐겨찾기에 \n추가 되었습니다.")
                                        self.centerDetailM.subscription = "1"
                                    }
                                    self.networkCheck = false
                                }
                            }else{
                                centerDetailViewModel().favoritesCenterDelete(centerID: self.centerDetailInfo.id){
                                    result in
                                    if(!result.errorCheck){
                                        alertManager().alertView(title: "통신오류", reason: result.networkErrorReason ?? "알 수 없음")
                                    }else{
                                        alertManager().alertView(title: "즐겨찾기", reason: "\(self.centerDetailInfo.centerName)이 즐겨찾기에서 \n삭제 되었습니다.")
                                        self.centerDetailM.subscription = "2"
                                    }
                                    self.networkCheck = false
                                }
                            }
                        }
                    }
                }){
                    HStack{
                        //추후에 즐겨찾기를 판단하여 값을 리턴할 예정
                        if(self.centerDetailM.subscription == "1"){
                            Image(systemName:"suit.heart.fill")
                                .foregroundColor(.pink)
                        }
                        else{
                            Image(systemName:"suit.heart")
                        }
                        Text("즐겨찾기")
                    }
                    .foregroundColor(Color("primaryColor"))
                    .font(.system(size: 20))
                }
                //buttonUI
                Spacer()
                NavigationLink(destination: webViewModel(urlToLoad: "https://map.kakao.com/link/map/\(centerDetailM.centerDetail.centerName),\(centerDetailM.centerDetail.detailCenterY),\(centerDetailM.centerDetail.detailCenterX)")){
                    HStack{
                        Image(systemName:"map")
                        Text("길찾기")
                    }
                    .foregroundColor(Color("primaryColor"))
                    .font(.system(size: 20))
                }
                Spacer()
                //                Spacer()
                //                Button(action: {
                //                    //받아온전화번호로 전화하기 기능
                //                }){
                //                    //buttonAction
                //                    HStack{
                //                        Image(systemName:"square.and.arrow.up")
                //                        Text("공유")
                //                    }
                //                    .foregroundColor(Color("primaryColor"))
                //                    .font(.system(size: 20))
                //                }//buttonUI
            }
            //Hstack
            .padding(.top,10)
        }//Vstack
        .foregroundColor(Color("primaryColor").opacity(0.7))
        .padding()
        .background(Color("primaryColorReverse"))
        .overlay(Rectangle()
                    .stroke(Color("primaryColor")
                    .opacity(0.5), lineWidth: 1)
        )

        
        
    }//body
}//centerDetailTopView

struct centerCommentView : View {
    let comment : String
    var body: some View{
        VStack(alignment : .leading ,spacing : 5){
            HStack{
                Text("사장님 코멘트 : ")
                    .foregroundColor(Color("primaryColor"))
                    .padding(.top,8)
                    .padding(.horizontal,8)
                Spacer()
            }
            
            Text(self.comment)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal,8)
                .padding(.bottom,8)
                .foregroundColor(Color("primaryColor"))
            
        }
        
        
    }
    
}

struct middleTabView : View{
    @Binding var index : Int
    @Binding var show : Bool
    var body: some View{
        VStack(spacing: 0){
            HStack(spacing : 0){
                
                Button(action: {
                    if(self.index != 0){
                        self.show=false
                    }
                    self.index=0
                    
                }){
                    VStack(){
                        Capsule().fill(self.index == 0 ? Color.gray.opacity(0.7) : Color("primaryColorReverse"))
                            .frame(height: 4)
                        Text("정보")
                            .foregroundColor(Color("primaryColor"))
                            .font(self.index == 0 ? .body :.none)
                            .padding(.bottom,10)
                    }
                    .overlay(Rectangle().stroke(Color("primaryColor").opacity(0.03), lineWidth: 1)
                                .shadow(radius: 0))
                    .frame(alignment: .top)
                }
                
                Button(action: {
                    if(self.index != 1){
                        self.show=false
                    }
                    self.index=1
                    
                }){
                    VStack{
                        Capsule().fill(self.index == 1 ? Color.gray.opacity(0.7) : Color("primaryColorReverse"))
                            .frame(height: 4)
                        Text("세팅")
                            .foregroundColor(Color("primaryColor"))
                            .font(self.index == 1 ? .body :.none)
                            .padding(.bottom,10)
                    }.overlay(Rectangle().stroke(Color("primaryColor").opacity(0.03), lineWidth: 1)
                                .shadow(radius: 0))
                    .frame(alignment: .top)
                }
                
                Button(action: {
                    if(self.index != 2){
                        self.show=false
                    }
                    self.index=2
                    
                }){
                    VStack{
                        Capsule().fill(self.index == 2 ? Color.gray.opacity(0.7) : Color("primaryColorReverse"))
                            .frame(height: 4)
                        Text("후기")
                            .foregroundColor(Color("primaryColor"))
                            .font(self.index == 2 ? .body :.none)
                            .padding(.bottom,10)
                    }
                    .frame(alignment: .top)
                    .overlay(Rectangle().stroke(Color("primaryColor").opacity(0.03), lineWidth: 1)
                                .shadow(radius: 0))
                }
            }
        }
        
        
        
        
    }
}

struct informationView : View{
    let centerDetailInfo : centerDetailModel
    var body: some View{
        VStack{
            //운영시간
            Group{
                VStack(alignment: .leading,spacing: 10){
                    Text("운영 시간")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top,10)
                    if(self.centerDetailInfo.centerSchedules.count>0){
                        VStack(alignment: .trailing , spacing : 3){
                            ForEach(0..<self.centerDetailInfo.centerSchedules.count) { i in
                                if(self.centerDetailInfo.centerSchedules[i].scheduleDay != "-1"){
                                    HStack(spacing : 0){
                                        Text("\(self.centerDetailInfo.centerSchedules[i].scheduleDay)")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                        
                                        Spacer()
                                        Text("\(self.centerDetailInfo.centerSchedules[i].scheduleTime)")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                        
                                    }
                                }else{
                                    HStack{
                                        Spacer()
                                        Text("일정 정보가 없습니다.")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                        Spacer()
                                    }
                                }
                                
                            }
                        }//VStack 운영 시간
                        
                        
                        
                    }
                    else{
                        VStack(alignment: .trailing , spacing : 3){
                            
                            HStack{
                                Spacer()
                                Text("등록된 정보가 없습니다 확인 후 추가하겠습니다.")
                                    .fontWeight(.semibold)
                                    .font(.system(size:20))
                                Spacer()
                            }
                            
                        }//VStack 운영 시간
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        )
                        
                        
                    }
                }
            }
            .padding(.leading,staticString().statincCGFloat[4])
            .padding(.trailing,staticString().statincCGFloat[4])
            devideLineView()
            //편의시설에대한 정보가 하나라도있는경우에만 보여주기위하여
            if(self.centerDetailInfo.centerFacilitys.count>0){
                Group{
                    VStack(alignment: .leading,spacing: 10){
                        Text("편의 시설")
                            .font(.title)
                            .fontWeight(.bold)
                        VStack(alignment: .leading,spacing: 5){
                            
                            ForEach(0..<self.centerDetailInfo.centerFacilitys.count){ i in
                                if(centerDetailInfo.centerFacilitys[i].facilityName != "-1"){
                                    HStack{
                                        Text("\(self.centerDetailInfo.centerFacilitys[i].facilityName)")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                        Spacer()
                                        Text("제공")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                    }
                                }
                            }
                        }
                    }
                    devideLineView()
                }
                .padding(.leading,staticString().statincCGFloat[4])
                .padding(.trailing,staticString().statincCGFloat[4])
            }
            if(self.centerDetailInfo.centerGoods.count>0){
                Group{
                    VStack(alignment: .leading,spacing: 5){
                        Text("가격 정보")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .trailing , spacing : 3){
                            ForEach(0..<centerDetailInfo.centerGoods.count){ i in
                                if(centerDetailInfo.centerGoods[i].goodsName != "-1"){
                                    
                                    HStack{
                                        Text("\(centerDetailInfo.centerGoods[i].goodsName)")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                        Spacer()
                                        
                                        Text(staticString().decimalWon(value: Int(self.centerDetailInfo.centerGoods[i].goodsPrice) ?? 0))
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                            .frame(alignment: .leading)
                                    }
                                    
                                }
                                else{
                                    
                                    HStack{
                                        Spacer()
                                        Text("등록된 정보가 없습니다 확인 후 추가하겠습니다.")
                                            .fontWeight(.semibold)
                                            .font(.system(size:20))
                                        Spacer()
                                    }
                                    
                                    
                                }
                            }
                        }//VStack 운영 시간
                        
                        
                    }
                    devideLineView()
                }
                .padding(.leading,staticString().statincCGFloat[4])
                .padding(.trailing,staticString().statincCGFloat[4])
            }
            
            if(self.centerDetailInfo.centerTools.count>0){
                Group{
                    VStack(alignment: .leading,spacing: 5){
                        Text("상세 정보")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        ForEach(0..<centerDetailInfo.centerTools.count){ i in
                            if(centerDetailInfo.centerTools[i].toolName != "-1"){
                                HStack{
                                    Text("\(centerDetailInfo.centerTools[i].toolName)  ")
                                        .fontWeight(.semibold)
                                        .font(.system(size:20))
                                    Spacer()
                                    Text("제공")
                                        .fontWeight(.semibold)
                                        .font(.system(size:20))
                                }
                            }
                        }
                        
                        
                    }
                    devideLineView()
                }
                .padding(.leading,staticString().statincCGFloat[4])
                .padding(.trailing,staticString().statincCGFloat[4])
            }
        }
    }//body
}//informationView

struct settingView : View {
    
    let centerDetailInfo : centerDetailModel
    
    var body: some View{
        VStack(alignment: .leading , spacing : 10){
            
            Group{
                HStack{
                    Text("사장님 코멘트 ")
                        .font(.title)
                        .padding(.top,10)
                    Spacer()
                }.padding(.top,5)
                
                Text(self.centerDetailInfo.centerDetail.detailComment == "-1" ? "사장님 말씀이 없습니다." : self.centerDetailInfo.centerDetail.detailComment)
                    .font(self.centerDetailInfo.centerDetail.detailComment == "-1" ? .none : .body)
                    .foregroundColor(self.centerDetailInfo.centerDetail.detailComment == "-1" ? Color.gray.opacity(0.7) : Color("primaryColor"))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading,staticString().statincCGFloat[4])
            .padding(.trailing,staticString().statincCGFloat[4])
            devideLineView()
            
            
//
//            //업데이트 날짜가 없는경우 -1 스트링을 찍게되는게 그런경우 이미지도 없으므로 분기처리
//            if(self.centerDetailInfo.centerDetail.detailRecentUpdate != "-1"){
//
//                Group{
//                    HStack(spacing:0){
//                        Text("세팅날짜 : \(centerDetailInfo.centerDetail.detailRecentUpdate)")
//                            .font(.title3)
//                            .fontWeight(.bold)
//                        Text("")
//                        Spacer()
//
//                        NavigationLink(destination: centerImageDetail(centerImages: self.centerDetailInfo.centerSettingImages, centerName: self.centerDetailInfo.centerDetail.centerName)){
//                            Text("더보기")
//                                .foregroundColor(Color.gray.opacity(0.7))
//                        }
//
//                    }
//
//
//                    ScrollView(.horizontal,showsIndicators:false){
//                        HStack(){
//                            ForEach(0..<centerDetailInfo.centerSettingImages.count){ i in
//
//
//
//                                    imageZoomView(imageURL: self.centerDetailInfo.centerSettingImages , index: i)
//                                            .frame(width: 200, height: 150)
//                                            .cornerRadius(20)
//
//
//
////                                NavigationLink(destination : imageZoomView(imageURL : centerDetailInfo.centerSettingImages[i].imageThumbUrl)){
////
////
////                                    WebImage(url: URL(string: centerDetailInfo.centerSettingImages[i].imageThumbUrl))
////                                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
////                                        .onSuccess { image, data, cacheType in
////                                            // Success
////                                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
////                                        }
////                                        .placeholder(Image(systemName: "photo")) // Placeholder Image
////                                        // Supports ViewBuilder as well
////                                        .placeholder {
////                                            Rectangle().foregroundColor(.gray)
////                                        }
////                                        // Activity Indicator
////                                        .resizable()
////                                        .cornerRadius(20)
////                                        .frame(width: 200, height: 150)
////
////
////
////
////                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.leading,staticString().statincCGFloat[4])
//                .padding(.trailing,staticString().statincCGFloat[4])
//
//
//
//            }
//
//            devideLineView()
//
//
//            Group{
//                VStack(alignment: .leading,spacing: 10){
//                    Text("문제 정보")
//                        .font(.title3)
//                        .fontWeight(.bold)
//
//                    VStack(alignment: .trailing , spacing : 10){
//
//
//
//                        ForEach(0..<centerDetailInfo.centerSettings.count){ i in
//                            if(centerDetailInfo.centerSettings[i].settingColor != "-1"){
//
//                                HStack{
//                                    Text("\(centerDetailInfo.centerSettings[i].settingColor) ")
//                                        .fontWeight(.semibold)
//                                        .font(.system(size:20))
//                                        .frame(width: UIScreen.main.bounds.width / 3 , alignment: .leading)
//                                    Spacer()
//                                    Text("\(centerDetailInfo.centerSettings[i].settingLevel)  ")
//                                        .fontWeight(.semibold)
//                                        .font(.system(size:20))
//                                }
//                            }
//                        }
//                    }
//
//                }
//            }
//            .padding(.leading,staticString().statincCGFloat[4])
//            .padding(.trailing,staticString().statincCGFloat[4])
//
//            devideLineView()
            
        }
    }
}




