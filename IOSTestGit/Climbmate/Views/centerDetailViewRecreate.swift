//실제사용하는 디테일페이지
import SwiftUI
import SDWebImageSwiftUI

struct centerDetailViewRecreate: View {
    @Environment(\.colorScheme) var colorScheme
    
    let clickType : Int
    
    
    let centerID : String
   
    @State var centerName : String = ""
    
    @State var show = false
    @State var selected = 0
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    @State var heigtVStackMain : CGFloat = 100
    @State var heigtVStackTab : CGFloat = 100
    //즐겨찾기에서 사용하는 네트워크 체크
    @State var networkCheck : Bool = false
    
    @State var getInfomation : Bool = false
    
    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    
    
    @State var centerDetailM : centerDetailModel?
    
    var body: some View {
        
        ZStack(alignment: .top){
            if(self.getInfomation){
                WebImage(url: URL(string:self.centerDetailM!.centerBannerImage[0].imageThumbUrl))
                    .placeholder {
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                    .resizable()
                    .frame(width: self.screenWidth , height : UIScreen.main.bounds.height / 2)
                
                ScrollView(.vertical, showsIndicators : false){
                    ZStack(alignment: .top){
                        GeometryReader{ g in
                            VStack(spacing : 0){
                                centerDetailTopViewRecreate(centerDetailInfo : self.centerDetailM!.centerDetail , centerRepresentationItem : self.centerDetailM!.centerGoods[0] , networkCheck: self.$networkCheck , centerDetailM : self.centerDetailM!)
                                    .frame(width : g.size.width - staticString().statincCGFloat[5])
                                
                                //                                centerCommentView(comment : self.centerDetailM!.centerDetail.detailComment)
                                //                                    .frame(width : g.size.width - staticString().statincCGFloat[3])
                                
                                middleTabViewRecreate(index: self.$selected,show : self.$show)
                                devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
                                
                            }
                            .background(Color("smokeBackgroundColor"))
                            .padding(.top , UIScreen.main.bounds.height / 3)
                            .background(
                                //지오메티르 리더를 선언하여 컬러가없는 빈객체를 선언하고 해당 객체의 크기를 구하고
                                GeometryReader { proxy in
                                    Color.clear
                                        
                                        .preference(key: sizePreferenceKey.self, value: proxy.size)
                                }
                                
                            )
                            
                            //SizePreferenceKey.self 값이 변경될때마다 실행되는 트리거를 실행하고
                            .onPreferenceChange(sizePreferenceKey.self){ newSize in
                                self.heigtVStackMain = newSize.height
                            }
                            .frame(height : self.heigtVStackMain)
                            .onReceive(self.time){ (_) in
                                let y = g.frame(in: .global).minY
                                if -y > self.heigtVStackMain - 140{
                                    if(!self.show){
                                        withAnimation{
                                            self.show.toggle()
                                        }
                                    }
                                }else{
                                    if(self.show){
                                        withAnimation{
                                            self.show.toggle()
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width :self.screenWidth , height : self.heigtVStackMain - 10)
                        HStack(){
                            Spacer()
                                .frame(width : 15)
                            
                            VStack(){
                                Image("mainLogo")
                                    .resizable()
                                    .frame(width : 60 , height : 30)
                            }
                            .frame(width : 60 , height : 60)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            
                            Spacer()
                        }
                        .padding(.top , UIScreen.main.bounds.height / 3 - 20)
                        
                        
                    }
                    
                    VStack{
                        if(self.selected == 0){
                            settingViewRecreateTemp(centerDetailInfo : self.centerDetailM!)
                        }
                        else if(self.selected == 1){
                            videoView(centerComment : self.centerDetailM!.centerComments)
                        }
                        else if(self.selected == 2){
                            informationViewRecreate(centerDetailInfo : self.centerDetailM!)
                            
                        }
                        else if(self.selected == 3){
                            noticeView(centerNotice : self.centerDetailM!.centerNotices , centerName : self.centerDetailM!.centerDetail.centerName)
                        }
                    }
                    .background(Color("primaryColorReverse"))
                    .frame(width : self.screenWidth)
                    
                    
                    
                    
                    
                    
                }
                .frame(width : self.screenWidth)
                
                if(self.show){
                    VStack(spacing : 0 ){
                        middleTabViewRecreate(index: self.$selected,show : self.$show)
                            .background(Color("smokeBackgroundColor"))
                        devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
                        
                    }
                }
                
            }
            else{
                loadingView()
            }
        }
        .frame(width :screenWidth)
        .onAppear(){
            if (self.centerID).isEmpty {
                alertManager().alertView(title: "통신오류", reason: "암장 정보를 가져오기 실패하였습니다. \n 다시 한번 시도해주세요.")
            }
            else{
                centerDetailViewModel().getCenterDetailinformation(centerID: self.centerID , clickType : self.clickType){
                    i in
                    
                    
                    self.centerDetailM = i
                    self.centerName = centerDetailM!.centerDetail.centerName
                    self.getInfomation = true
                }
            }
        }
        .navigationBarTitle(Text(self.centerName), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    centerDetailViewModel().actionSheetShareURL(centerID: self.centerID)
                                }, label: {
                                    Image(systemName: "square.and.arrow.up")
                                }).foregroundColor(Color("primaryColor"))
                            
        )
    }
    
    
}



struct centerDetailTopViewRecreate : View {
    
    let centerDetailInfo : centerDetailInformation
    let centerRepresentationItem : centerGoodsModel
    
    let smallTextSize : CGFloat = 12
    
    @Binding var networkCheck : Bool
    
    @State var centerDetailM : centerDetailModel
    
    var body: some View{
        
        
        VStack(alignment: .leading, spacing: 7){
            HStack{
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
                    
                    //추후에 즐겨찾기를 판단하여 값을 리턴할 예정
                    if(self.centerDetailM.subscription == "1"){
                        Text("팔로잉")
                            .fontWeight(.semibold)
                            .padding(.vertical,5)
                            .font(.system(size: 14))
                            .frame(width: UIScreen.main.bounds.width / 3.3)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("primaryColor"), lineWidth: 1)
                                    .shadow(radius: 7)
                            )
                    }
                    else{
                        Text("팔로우")
                            .fontWeight(.semibold)
                            .padding(.vertical,5)
                            .font(.system(size: 14))
                            .foregroundColor(Color.white)
                            
                            .frame(width: UIScreen.main.bounds.width / 3.3)
                            .background(Color("deepRed"))
                            .cornerRadius(7)
                        
                    }
                    
                    
                }
            }
            .padding(.top , 3)
            .foregroundColor(Color("primaryColor"))
            .font(.system(size: 20))
            HStack{
                
                Text(self.centerDetailM.centerDetail.centerName)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primaryColor"))
                    .font(.system(size: 20))
            }
            
            
            NavigationLink(destination: webViewModel(urlToLoad: "https://map.kakao.com/link/map/\(self.centerDetailM.centerDetail.centerName),\(self.centerDetailM.centerDetail.detailCenterY),\(self.centerDetailM.centerDetail.detailCenterX)")){
                HStack(spacing : 3){
                    
                    Text(self.centerDetailM.centerDetail.centerAddress)
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color("primaryColor")).opacity(0.9)
                .font(.system(size: 15))
            }
            
            
            HStack(spacing : 5){
                Text("세팅 변경")
                    .font(.system(size: self.smallTextSize))
                    .foregroundColor(Color("primaryColor")).opacity(0.9)
                Text("\(self.centerDetailInfo.detailRecentUpdate)")
                    
                    .font(.system(size: self.smallTextSize))
                    .foregroundColor(Color("primaryColor")).opacity(0.9)
                
                Image(systemName: "circlebadge.fill")
                    .padding(.horizontal, 2)
                    .font(.system(size: 4))
                    .foregroundColor(Color.gray.opacity(0.7))
                
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + self.centerDetailM.centerDetail.centerNumber
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                }){
                    //buttonAction
                    HStack{
                        Text("전화번호 \(self.centerDetailM.centerDetail.centerNumber)")
                            .foregroundColor(Color("primaryColor")).opacity(0.9)
                            .font(.system(size: self.smallTextSize))
                    }
                }
                Spacer()
            }
            
            
            
            
            
            
            
            //            HStack{
            //
            //                //buttonUI
            //                Spacer()
            //                NavigationLink(destination: webViewModel(urlToLoad: "https://map.kakao.com/link/map/\(centerDetailM.centerDetail.centerName),\(centerDetailM.centerDetail.detailCenterY),\(centerDetailM.centerDetail.detailCenterX)")){
            //                    HStack{
            //                        Image(systemName:"map")
            //                        Text("길찾기")
            //                    }
            //                    .foregroundColor(Color("primaryColor"))
            //                    .font(.system(size: 20))
            //                }
            //                Spacer()
            //                //                Spacer()
            //                //                Button(action: {
            //                //                    //받아온전화번호로 전화하기 기능
            //                //                }){
            //                //                    //buttonAction
            //                //                    HStack{
            //                //                        Image(systemName:"square.and.arrow.up")
            //                //                        Text("공유")
            //                //                    }
            //                //                    .foregroundColor(Color("primaryColor"))
            //                //                    .font(.system(size: 20))
            //                //                }//buttonUI
            //            }
            //            //Hstack
            //            .padding(.top,10)
        }//Vstack
        .padding(.vertical , 5)
        .foregroundColor(Color("primaryColor").opacity(0.7))
        
        
        
        
    }//body
}//centerDetailTopView
struct middleTabViewRecreate : View{
    @Binding var index : Int
    @Binding var show : Bool
    
    let symbolSize : CGFloat = 20
    let symboltextSize : CGFloat = 10
    var body: some View{
        VStack(spacing: 20){
            HStack(spacing : 0){
                //문제 영상 정보 공지
                Button(action: {
                    if(self.index != 0){
                        self.show=false
                    }
                    self.index=0
                    
                }){
                    VStack(spacing : 5){
                        Image(systemName: "circle.grid.2x2")
                            .foregroundColor(self.index == 0 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symbolSize))
                        Text("문제")
                            .foregroundColor(self.index == 0 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symboltextSize))
                        
                    }
                    
                    .frame(width : UIScreen.main.bounds.width / 4 , alignment: .top)
                }
                
                Button(action: {
                    if(self.index != 1){
                        self.show=false
                    }
                    self.index=1
                    
                }){
                    VStack(spacing : 5){
                        Image(systemName: "play.rectangle.fill")
                            .foregroundColor(self.index == 1 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symbolSize))
                        Text("영상")
                            .foregroundColor(self.index == 1 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symboltextSize))
                        
                    }
                    .frame(width : UIScreen.main.bounds.width / 4 , alignment: .top)
                }
                
                Button(action: {
                    if(self.index != 2){
                        self.show=false
                    }
                    self.index=2
                    
                }){
                    VStack(spacing : 5){
                        Image(systemName: "text.bubble")
                            .foregroundColor(self.index == 2 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symbolSize))
                        Text("정보")
                            .foregroundColor(self.index == 2 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symboltextSize))
                        
                    }
                    .frame(width : UIScreen.main.bounds.width / 4 , alignment: .top)
                }
                Button(action: {
                    if(self.index != 3){
                        self.show=false
                    }
                    self.index=3
                    
                }){
                    VStack(spacing : 5){
                        Image(systemName: "megaphone")
                            .foregroundColor(self.index == 3 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symbolSize))
                        Text("공지")
                            .foregroundColor(self.index == 3 ? Color("deepRed") : Color.gray.opacity(0.7))
                            .font(.system(size: self.symboltextSize))
                        
                    }
                    .frame(width : UIScreen.main.bounds.width / 4 , alignment: .top)
                }
            }
            
        }
        .padding(.vertical , 15)
        
        
        
        
    }
}
struct informationViewRecreate : View{
    let centerDetailInfo : centerDetailModel
    let fontSizeTitle : CGFloat = 17
    let fontSizeBody : CGFloat = 16
    let titleWidth : CGFloat = UIScreen.main.bounds.width / 5
    let itemWidth : CGFloat = UIScreen.main.bounds.width / 6
    var body: some View{
        VStack(spacing : 0){
            //운영시간
            Group{
                VStack(alignment: .leading,spacing: 10){
                    HStack(alignment : .top){
                        Text("시간")
                            .font(.system(size: self.fontSizeTitle))
                            .fontWeight(.bold)
                            .frame(width: self.titleWidth , alignment : .leading)
                        
                        if(self.centerDetailInfo.centerSchedules.count>0){
                            VStack(alignment: .trailing , spacing : 3){
                                ForEach(0..<self.centerDetailInfo.centerSchedules.count) { i in
                                    if(self.centerDetailInfo.centerSchedules[i].scheduleDay != "-1"){
                                        HStack(spacing : 5){
                                            Text("\(self.centerDetailInfo.centerSchedules[i].scheduleDay)")
                                                .font(.system(size: self.fontSizeBody))
                                                
                                                .frame(width : self.itemWidth , alignment : .leading)
                                            
                                            
                                            Text("\(self.centerDetailInfo.centerSchedules[i].scheduleTime)")
                                                .font(.system(size: self.fontSizeBody))
                                            
                                            Spacer()
                                            
                                        }
                                    }else{
                                        HStack{
                                            Spacer()
                                            Text("일정 정보가 없습니다.")
                                                .font(.system(size: self.fontSizeBody))
                                            
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
                                        .font(.system(size: self.fontSizeBody))
                                    
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
                
            }
            
            .padding(.horizontal,staticString().statincCGFloat[4])
            .padding(.vertical,staticString().statincCGFloat[2])
            devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
            //편의시설에대한 정보가 하나라도있는경우에만 보여주기위하여
            if(self.centerDetailInfo.centerFacilitys.count>0){
                Group{
                    
                    VStack(alignment: .leading,spacing: 10){
                        HStack(alignment : .top){
                            Text("편의시설")
                                .font(.system(size: self.fontSizeTitle))
                                .fontWeight(.bold)
                                .frame(width: self.titleWidth , alignment : .leading)
                            
                            if(self.centerDetailInfo.centerFacilitys.count>0){
                                VStack(spacing : 3){
                                    ForEach(0..<self.centerDetailInfo.centerFacilitys.count){ i in
                                        if(centerDetailInfo.centerFacilitys[i].facilityName != "-1"){
                                            HStack{
                                                Text("\(self.centerDetailInfo.centerFacilitys[i].facilityName)")
                                                    .font(.system(size: self.fontSizeBody))
                                                    
                                                    .frame(width : self.itemWidth , alignment : .leading)
                                                
                                                Text("제공")
                                                    .font(.system(size: self.fontSizeBody))
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            else{
                                VStack(alignment: .trailing , spacing : 3){
                                    
                                    HStack{
                                        Spacer()
                                        Text("등록된 정보가 없습니다 확인 후 추가하겠습니다.")
                                            .font(.system(size: self.fontSizeBody))
                                            .fontWeight(.semibold)
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
                    .padding(.horizontal,staticString().statincCGFloat[4])
                    .padding(.vertical,staticString().statincCGFloat[2])
                    
                    devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
                    
                }
                
            }
            if(self.centerDetailInfo.centerGoods.count>0){
                
                Group{
                    
                    VStack(alignment: .leading,spacing: 10){
                        HStack(alignment : .top){
                            Text("가격 정보")
                                .font(.system(size: self.fontSizeTitle))
                                .fontWeight(.bold)
                                .frame(width: self.titleWidth , alignment : .leading)
                            
                            if(self.centerDetailInfo.centerGoods.count>0){
                                VStack(alignment: .trailing , spacing : 3){
                                    ForEach(0..<centerDetailInfo.centerGoods.count){ i in
                                        if(centerDetailInfo.centerGoods[i].goodsName != "-1"){
                                            
                                            HStack{
                                                Text("\(centerDetailInfo.centerGoods[i].goodsName)")
                                                    .font(.system(size: self.fontSizeBody))
                                                
                                                Spacer()
                                                Text(staticString().decimalWon(value: Int(self.centerDetailInfo.centerGoods[i].goodsPrice) ?? 0))
                                                    .font(.system(size: self.fontSizeBody))
                                                
                                                
                                            }
                                            
                                        }
                                        else{
                                            
                                            HStack{
                                                Spacer()
                                                Text("등록된 정보가 없습니다 확인 후 추가하겠습니다.")
                                                    .font(.system(size: self.fontSizeBody))
                                                    .fontWeight(.semibold)
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
                                            .font(.system(size: self.fontSizeBody))
                                            .fontWeight(.semibold)
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
                    .padding(.horizontal,staticString().statincCGFloat[4])
                    .padding(.vertical,staticString().statincCGFloat[2])
                    
                    devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
                    
                }
                
                
                
            }
            
            if(self.centerDetailInfo.centerTools.count>0){
                
                
                
                Group{
                    VStack(alignment: .leading,spacing: 10){
                        HStack(alignment : .top){
                            Text("상세 정보")
                                .font(.system(size: self.fontSizeTitle))
                                .fontWeight(.bold)
                                .frame(width: self.titleWidth , alignment : .leading)
                            
                            if(self.centerDetailInfo.centerTools.count>0){
                                VStack(alignment: .trailing , spacing : 3){
                                    ForEach(0..<centerDetailInfo.centerTools.count){ i in
                                        if(centerDetailInfo.centerTools[i].toolName != "-1"){
                                            HStack{
                                                Text("\(centerDetailInfo.centerTools[i].toolName)  ")
                                                    .font(.system(size: self.fontSizeBody))
                                                    
                                                    .frame(width : self.itemWidth , alignment : .leading)
                                                
                                                Text("제공")
                                                    .font(.system(size: self.fontSizeBody))
                                                
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
                                            .font(.system(size: self.fontSizeBody))
                                            .fontWeight(.semibold)
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
                    .padding(.horizontal,staticString().statincCGFloat[4])
                    .padding(.vertical,staticString().statincCGFloat[2])
                    
                    devideLineView(height: 3, topPadding: 0, bottomPadding: 0)
                    
                }
                
                
                
                
                
            }
        }
        
    }//body
}//informationView
struct videoView : View{
    @State var centerComment : [centerCommentModel]
    var body: some View{
        if(self.centerComment.count > 0){
            LazyVStack(spacing : 0){
                ForEach(centerComment){ centerComment in
                    videoCardView(centerComment: centerComment)
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.horizontal,staticString().statincCGFloat[4])
                    devideLineView(height: 1, topPadding: 1, bottomPadding: 1)
                }
            }
        }else{
            VStack{
                Spacer()
                Text("등록된 정보가 없습니다 확인 후 추가하겠습니다.")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: 300)
        }
    }
}


struct noticeView : View{
    @State var centerNotice : [centerNoticeModel]
    let centerName : String
    var body: some View{
        if(self.centerNotice.count > 0){
            LazyVStack(spacing : 0){
                ForEach(centerNotice){ centerNotice in
                    notificationCardView(centerNotice : centerNotice , centerName : self.centerName)
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.horizontal,staticString().statincCGFloat[4])
                    devideLineView(height: 1, topPadding: 1, bottomPadding: 1)
                }
            }
        }else{
            VStack{
                Spacer()
                Text("등록된 정보가 없습니다 확인 후 추가하겠습니다.")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: 300)
        }
    }
}


//
//  videoCardView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/26.
//


struct settingViewRecreate : View {
    
    let centerDetailInfo : centerDetailModel
    
    //
    let fontSizeSmall : CGFloat = 14
    //셋팅 상단탭뷰에대한 값
    @State var selectedTab : Int = 0
    
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
                    .fontWeight(.bold)
                    .foregroundColor(self.centerDetailInfo.centerDetail.detailComment == "-1" ? Color.gray.opacity(0.7) : Color("primaryColor"))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading,staticString().statincCGFloat[4])
            .padding(.trailing,staticString().statincCGFloat[4])
            
            devideLineView(bottomPadding: 1)
            
            HStack(spacing : 0){
                Spacer()
                Button(action: {
                    if(self.selectedTab != 0){
                        withAnimation(.easeInOut(duration:  0.2)){
                            self.selectedTab = 0
                        }
                    }
                }){
                    Text("볼더링")
                        .foregroundColor(self.selectedTab == 0 ? Color("deepRed") : Color.gray)
                    Text("\(centerDetailInfo.centerSettings.count)")
                        .font(.system(size: self.fontSizeSmall))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .frame(width: 50 , alignment : .center)
                        .padding(.vertical , 2)
                        .background(
                            Capsule()
                                .fill(self.selectedTab == 0 ? Color("deepRed") : Color.gray.opacity(0.8))
                        )
                }
                Spacer()
                Button(action: {
                    if(self.selectedTab != 1){
                        withAnimation(.easeInOut(duration: 0.2)){
                            self.selectedTab = 1
                        }
                    }
                }){
                    Text("지구력")
                        .foregroundColor(self.selectedTab == 1 ? Color("deepRed") : Color.gray)
                    Text("11")
                        .font(.system(size: self.fontSizeSmall))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .frame(width: 50 , alignment : .center)
                        .padding(.vertical , 2)
                        .background(
                            Capsule()
                                .fill(self.selectedTab == 1 ? Color("deepRed") : Color.gray.opacity(0.8))
                        )
                    
                }
                Spacer()
            }
            HStack(spacing : 0){
                Capsule().fill(self.selectedTab == 0 ? Color("deepRed") : Color.white)
                    .frame(height: 2)
                
                Capsule().fill(self.selectedTab == 1 ? Color("deepRed") : Color.white)
                    .frame(height: 2)
            }
            
            
            if(self.selectedTab == 0){
                Group{
                    ForEach(0..<centerDetailInfo.centerSettings.count){ i in
                        settigLevelCardView(centerSetting : centerDetailInfo.centerSettings[i])
                    }
                }
                .padding(.leading,staticString().statincCGFloat[2])
                .padding(.trailing,staticString().statincCGFloat[2])
            }
            else if(self.selectedTab == 1){
                Group{
                    ForEach(0..<11){ i in
                        //settigLevelCardView()
                        
                    }
                }
                .padding(.leading,staticString().statincCGFloat[2])
                .padding(.trailing,staticString().statincCGFloat[2])
            }
        }
    }
}


struct settingViewRecreateTemp : View {
    
    let centerDetailInfo : centerDetailModel
    
    var columns = Array(repeating: GridItem(.flexible() , spacing: 5), count: 3)
    //
    let fontSizeSmall : CGFloat = 14
    //셋팅 상단탭뷰에대한 값
    @State var selectedTab : Int = 0
    
    @State var presented : Bool = false
    
    @State var settingIndex : Int = 0
    @State var imageIndex : Int = 0
  
    
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
                    .fontWeight(.bold)
                    .foregroundColor(self.centerDetailInfo.centerDetail.detailComment == "-1" ? Color.gray.opacity(0.7) : Color("primaryColor"))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading,staticString().statincCGFloat[4])
            .padding(.trailing,staticString().statincCGFloat[4])
            
            devideLineView(bottomPadding: 1)
            //
            //            HStack(spacing : 0){
            //                Spacer()
            //                Button(action: {
            //                    if(self.selectedTab != 0){
            //                        withAnimation(.easeInOut(duration:  0.2)){
            //                            self.selectedTab = 0
            //                        }
            //                    }
            //                }){
            //                    Text("볼더링")
            //                        .foregroundColor(self.selectedTab == 0 ? Color("deepRed") : Color.gray)
            //                    Text("\(centerDetailInfo.centerSettings.count)")
            //                        .font(.system(size: self.fontSizeSmall))
            //                        .foregroundColor(Color.white)
            //                        .fontWeight(.bold)
            //                        .frame(width: 50 , alignment : .center)
            //                        .padding(.vertical , 2)
            //                        .background(
            //                            Capsule()
            //                                .fill(self.selectedTab == 0 ? Color("deepRed") : Color.gray.opacity(0.8))
            //                        )
            //                }
            //                Spacer()
            //                Button(action: {
            //                    if(self.selectedTab != 1){
            //                        withAnimation(.easeInOut(duration: 0.2)){
            //                            self.selectedTab = 1
            //                        }
            //                    }
            //                }){
            //                    Text("지구력")
            //                        .foregroundColor(self.selectedTab == 1 ? Color("deepRed") : Color.gray)
            //                    Text("11")
            //                        .font(.system(size: self.fontSizeSmall))
            //                        .foregroundColor(Color.white)
            //                        .fontWeight(.bold)
            //                        .frame(width: 50 , alignment : .center)
            //                        .padding(.vertical , 2)
            //                        .background(
            //                            Capsule()
            //                                .fill(self.selectedTab == 1 ? Color("deepRed") : Color.gray.opacity(0.8))
            //                        )
            //
            //                }
            //                Spacer()
            //            }
            //            HStack(spacing : 0){
            //                Capsule().fill(self.selectedTab == 0 ? Color("deepRed") : Color.white)
            //                    .frame(height: 2)
            //
            //                Capsule().fill(self.selectedTab == 1 ? Color("deepRed") : Color.white)
            //                    .frame(height: 2)
            //            }
            //            if(self.selectedTab == 0){
            //                Group{
            //                    ForEach(0..<centerDetailInfo.centerSettings.count){ i in
            //                        settigLevelCardView(centerSetting : centerDetailInfo.centerSettings[i])
            //                    }
            //                }
            //                .padding(.leading,staticString().statincCGFloat[2])
            //                .padding(.trailing,staticString().statincCGFloat[2])
            //            }
            //            else if(self.selectedTab == 1){
            //                Group{
            //                    ForEach(0..<11){ i in
            //                        //settigLevelCardView()
            //2
            //                    }
            //                }
            //                .padding(.leading,staticString().statincCGFloat[2])
            //                .padding(.trailing,staticString().statincCGFloat[2])
            //            }
            
            ScrollView{
                LazyVGrid(columns:self.columns ){
                    ForEach(0..<self.centerDetailInfo.centerSettings.count){i in
                        ForEach(0..<self.centerDetailInfo.centerSettings[i].centerSettings.count){index in
                            Button(action : {
                                self.settingIndex = i
                                self.imageIndex = index
                                self.presented.toggle()
                            }){
                                WebImage(url: URL(string: self.centerDetailInfo.centerSettings[i].centerSettings[index].imageThumbUrl))
                                    .placeholder {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .foregroundColor(.gray)
                                    }
                                    .resizable()
                                    .frame(width: (UIScreen.main.bounds.width - 20) / 3, height: (UIScreen.main.bounds.width - 20) / 3)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
                
            }
        }
        .sheet(isPresented: self.$presented) {
            detailImageView(centerSettingImageModels : nil , centerSettingModels : self.centerDetailInfo.centerSettings[self.settingIndex].centerSettings , index :  self.imageIndex)
        }
    }
}
