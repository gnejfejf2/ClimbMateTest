//
//  searchResultView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/24.
//

import SwiftUI

struct searchResultView: View {
    
    
    @State var getSearchKeyword : String

    @State var showText : Bool = false
    //카카오에서 최초 받아온 순서대로 저장해놓는 값
    @State var searchListDefault = [searchCenterModel]()
    //페이징에서 사용할 searchCenterModel이 들어가는 공간
    @State var searchList = [searchCenterModel]()
    //실제 UI에서 사용하는 리스트
    @State var searchListTemp = [searchCenterModel]()
    //검색을 진행중인지를 파악하는 값
    @State var searchEnd : Bool = false
    //현재 페이지를 카운트하는 값
    @State var searchPage : Int = 1
    //searchListDefault리스트의 총갯수
    @State var totalCount : Int = 0
    //searchList리스트의 총갯수
    @State var listCount : Int = 0
    //페이징을 진행중인지 체크하는 값
    @State var pagingNetwork : Bool = false
    //통신을 진행중인지 체크하는 값
    @State var networking : Bool = true
    //페이징에 사용할값 최소 15부터 시작 15씩 증가함
    @State var pagingCount : Int = 15
    //업데이트 거리 정확도 를 선택할수있는 필터창이 켜져있는지에대한 값
    @State var filterSetting : Bool = false
    @State var filterSettingNumber : Int = 0
    //첫번째필터에 들어가는 값
    let selectFirstFilter = ["정확도순","업데이트순","거리순"]
    //두번째필터에 들어가는 값
    let selectSecFilter = ["세팅 유형","볼더링","지구력","밸런스"]
    //첫번째필터 선택한값
    @State var firstFilterNumber : Int = 0
    //2번째 필터 선택한값
    @State var secFilterNumber : Int = 0
    //상단 필터의 높이
    let filterHeight : CGFloat = 150
    //지역을 표시해줄때사용하는값 현재 사용하지않음
    @State var subKeyword : String = userData().returnUserData(index: 8) ?? "서초구 서초동"
    
    //디테일 세팅이 진행중인이 이값에따라 시트가 펴지고 꺼짐
    @State var detailSetting : Bool = false
    //디테일 세팅이 적용을 눌르고 조건이 합당할? 경우 로직을 실행하기위해 사용하는 코드
    @State var detailSettingApply : Bool = false
    //세부필터에서 사용하는값
    @State var selectgoodsType : Int = 0
    @State var startIndexCount : Int = 0
    @State var endIndexCount : Int = 50
    //편의시설에대한 아이템들이 저장되어있는 배열 세부필터에서 사용한다.
    @State var facilityItem = [facilityModel(name: "샤워실", checked: false)
                               ,facilityModel(name: "주차장", checked: false)
                                 ,facilityModel(name: "수건", checked: false)]
    
    //도구에대한 값들이 저장되어있는 배열 대한 아이템들이 저장되어있는 배열 세부필터에서 사용한다.
    @State var facilityToolItem = [facilityToolModel(name: "킬터보드", checked: false)
                                   ,facilityToolModel(name: "문보드", checked: false)]
    
    
    var body: some View {
        ZStack(alignment: .top){
            VStack{
                //실질적으로 보여주는 리스트는 searchListTemp 이기때문에 searchListTemp 가 최소 1개이상일때만 뷰를 보이게한다.
                if(self.searchListTemp.count > 0){
                    List(self.searchListTemp){ center in
                        //해당 센터가 마지막 인덱스일경우 인피니티 스크롤이 동작을 해야하기때문에 onAppear함수가달린 센터카드를 만들어준다.
                        if(center.lastIndex){
                            searchResultCard(center: center)
                                .onAppear{
                                    //현재 보여지는 갯수가 필터를 거치고난후의 리스트의 갯수보다 적어야 하고
                                    //현재 인터넷을 사용중이면 안되고
                                    //해당 아이템의 센터가 페이징카운트와 맞아야한다. 그렇지않으면 이미 사용해버린 인피니티스크롤 인덱스에서도 아이템이 추가가되는 불상사가 발생
                                    if(self.searchListTemp.count < self.totalCount && !self.pagingNetwork && center.page == self.searchPage){
                                        //전체갯수가 현재 아이템 갯수 + 15를 한것보다 클경우 15개 그대로 더해주고 페이징카운트에 15를 더해준다.
                                        //그리고 페이징을 진행중이기때문에 네트워크를 진행중으로 변경시켜준후
                                        //searchPage +1을해줘 다음페이지라는것을 명시해준다.
                                        if(self.totalCount > self.pagingCount + 15){
                                            for i in  self.pagingCount ..< self.pagingCount + 15{
                                           
                                                self.searchListTemp.append(self.searchList[i])
                                            }
                                            self.pagingCount += 15
                                            self.pagingNetwork = true
                                            self.searchPage = self.searchPage + 1
                                        }else{
                                            //전체갯수가 현재 아이템 갯수 + 15를 한것보다 작을경우 전체갯수까지만 추가시켜준다.
                                            for i in  self.pagingCount ..< self.totalCount{
                                                self.searchListTemp.append(self.searchList[i])
                                            }
                                            self.pagingCount += 15
                                            self.pagingNetwork = true
                                            self.searchPage = self.searchPage + 1
                                        }
                                        //약간의 딜레이를 주기위해 강제로 딜레이를 사용
                                        DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                            self.pagingNetwork = false
                                        }
                                    }
                                }
                        }
                        else{
                            searchResultCard(center: center)
                        }
                    }
                }
                else{
                    //검색결과가 없을경우를 보여주는 뷰
                    Spacer()
                    Text("검색 결과가 없습니다.")
                }
                Spacer()
            }
            .padding(.top,50)
            .onAppear{
                //화면이 최초 등장했을때 받아온 키워드를 통해 검색을 진행한다.
                if(self.searchList.isEmpty){
                    searchClearViewModel(searchListDefault: self.$searchListDefault, searchList: self.$searchList, searchListTemp: self.$searchListTemp, searchEnd: self.$searchEnd, searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount, pagingNetwork: self.$pagingNetwork, pagingCount: self.$pagingCount, firstFilterNumber: self.$firstFilterNumber, secFilterNumber: self.$secFilterNumber, networking: self.$networking).searchParameterClearAndSearch(searchKeyword : self.getSearchKeyword)
                }else{
                    self.networking = false
                }
            }
            VStack{
                //검색결과가 1개라도 존재하고 필터를 통해서 걸러진 경우도 있기때문에 self.searchListDefault 가 1개라도 있을경우 보여준다,
                if(self.searchListDefault.count > 0){
                    //상단버튼
                    HStack{
                        //필터중무엇 하나라도 선택되었을경우 초기화 버튼이 보여야한다.
                        if(self.firstFilterNumber != 0 || self.secFilterNumber != 0 || self.selectgoodsType != 0 || searchResultViewModel().facilityItemCheck(facilityItem : self.facilityItem) || searchResultViewModel().facilityToolCheck(facilityTool : self.facilityToolItem)){
                                Button(action: {
                                        self.firstFilterNumber = 0
                                        self.secFilterNumber = 0
                                        self.networking = true
                                        //세부필터에서 사용하는값들을 초기화 시켜준다.
                                        self.selectgoodsType = 0
                                        self.startIndexCount = 0
                                        self.endIndexCount = 50
                                        self.facilityItem = [facilityModel(name: "샤워실", checked: false)
                                                             ,facilityModel(name: "주차장", checked: false)
                                                               ,facilityModel(name: "수건", checked: false)]
                                        self.facilityToolItem = [facilityToolModel(name: "킬터보드", checked: false)
                                                             ,facilityToolModel(name: "문보드", checked: false)]
                                
                                        //초기화시켰을경우 초기화된 필터를 기준으로 새롭게 리스트를 업데이트 시켜주어야한다.
                                        DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                            searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                        }
                                }){
                                    HStack{
                                        Text("초기화")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(Color("primaryColor"))
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                    )
                                    .background(Color.yellow.opacity(0.1))
                                    .cornerRadius(20)
                                }
                        }
                        
                        
                        
                        Button(action: {
                            //filterSetting이 false 인경우 필터를 고르지 않는 상황이기 때문에
                            //필터를 셋팅중이라고 변경시켜주고 2번 세팅을 변경중이기때문에 셋팅넘버를 2로 변경해준다.
                            if(!self.filterSetting){
                                self.filterSetting.toggle()
                                self.filterSettingNumber = 1
                            }
                            //만약 현재 셋팅중이고 현재 셋팅넘버가 2번이였을경우 셋팅을 그만하겠다이기때문에 셋팅중이 아닌상태로 변경해준다.
                            else if(self.filterSettingNumber == 1 && self.filterSetting) {
                                self.filterSetting.toggle()
                                //만약 현재 셋팅중이고 현재 셋팅넘버가 2번이 아니였을경우 이버튼이 클릭되면 세팅을 바꾸겠다는 뜻이기때문에 셋팅넘버만 변경해준다.
                            }else if(self.filterSettingNumber != 1 && self.filterSetting) {
                                self.filterSettingNumber = 1
                            }
                        }){
                            HStack{
                                Text(self.selectFirstFilter[self.firstFilterNumber])
                                    .font(.system(size: 12))
//                                if(self.filterSetting && self.filterSettingNumber == 1){
//                                    Image(systemName: "arrow.up")
//                                }else{
//                                    Image(systemName: "arrow.down")
//                                }
                            }
                            .foregroundColor(Color("primaryColor"))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            )
                            .background(self.filterSetting ? Color("primaryColorReverse").opacity(0.1) :  Color("primaryColor").opacity(0.0))
                            .cornerRadius(20)
                        }
                        
                        Button(action: {
                            //filterSetting이 false 인경우 필터를 고르지 않는 상황이기 때문에
                            //필터를 셋팅중이라고 변경시켜주고 2번 세팅을 변경중이기때문에 셋팅넘버를 2로 변경해준다.
                            if(!self.filterSetting){
                                self.filterSetting.toggle()
                                self.filterSettingNumber = 2
                            }
                            //만약 현재 셋팅중이고 현재 셋팅넘버가 2번이였을경우 셋팅을 그만하겠다이기때문에 셋팅중이 아닌상태로 변경해준다.
                            else if(self.filterSettingNumber == 2 && self.filterSetting) {
                                self.filterSetting.toggle()
                                //만약 현재 셋팅중이고 현재 셋팅넘버가 2번이 아니였을경우 이버튼이 클릭되면 세팅을 바꾸겠다는 뜻이기때문에 셋팅넘버만 변경해준다.
                            }else if(self.filterSettingNumber != 2 && self.filterSetting) {
                                self.filterSettingNumber = 2
                            }
                            
                        }){
                            HStack{
                                Text(self.selectSecFilter[self.secFilterNumber])
                                    .font(.system(size: 12))
                                
//                                if(self.filterSetting && self.filterSettingNumber == 2){
//                                    Image(systemName: "arrow.up")
//                                }else{
//                                    Image(systemName: "arrow.down")
//                                }
                            }
                            .foregroundColor(Color("primaryColor"))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            )
                            .background(self.filterSetting ? Color("primaryColorReverse").opacity(0.1) :  Color("primaryColor").opacity(0.0))
                            .cornerRadius(20)
                        }
                        Spacer()
                        
                        Button(action: {
                            //detailSetting 컨트롤하는 공간
                            self.detailSetting.toggle()
                        }){
                            HStack{
                                Image(systemName: "slider.horizontal.3")
                            }
                            .foregroundColor(Color("primaryColor"))
                            .padding(10)
                            .background(self.filterSetting ? Color("primaryColorReverse").opacity(0.1) :  Color("primaryColor").opacity(0.0))
                            .cornerRadius(20)
                        }
                        
                    }
                    .padding(.top,10)
                    .padding(.bottom,5)
                    .padding(.horizontal,15)
                    .frame(height: 50)
                    .background(Color("primaryColorReverse"))
                    //필터를 클릭하였을경우
                    if(self.filterSetting){
                        //1번필터
                        if(self.filterSettingNumber == 1){
                            VStack(spacing : 10){
                                Spacer()
                                HStack{
                                    Button(action : {
                                        if(self.firstFilterNumber != 0){
                                            self.firstFilterNumber = 0
                                            self.networking = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                                searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                            }
                                        }else{
                                            self.filterSetting.toggle()
                                        }
                                    }){
                                        Text(self.selectFirstFilter[0])
                                            .foregroundColor(self.firstFilterNumber == 0 ? Color.yellow : Color("primaryColor"))
                                            .fontWeight(.light)
                                            .frame(width: UIScreen.main.bounds.width / 4 , alignment: .leading)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(self.firstFilterNumber == 0 ? Color.yellow : Color("primaryColor"))
                                            .opacity(self.firstFilterNumber == 0 ? 1.0 : 0.0)
                                    }
                                }
                                Spacer()
                                HStack{
                                    Button(action : {
                                        if(self.firstFilterNumber != 1){
                                            self.firstFilterNumber = 1
                                            self.networking = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                                searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                            }
                                        }else{
                                            self.filterSetting.toggle()
                                        }
                                    }){
                                        Text(self.selectFirstFilter[1])
                                            .foregroundColor(self.firstFilterNumber == 1 ? Color.yellow : Color("primaryColor"))
                                            .fontWeight(.light)
                                            .frame(width: UIScreen.main.bounds.width / 4 , alignment: .leading)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(self.firstFilterNumber == 1 ? Color.yellow : Color("primaryColor"))
                                            .opacity(self.firstFilterNumber == 1 ? 1.0 : 0.0)
                                    }
                                }
                                Spacer()
                                HStack{
                                    Button(action : {
                                        if(self.firstFilterNumber != 2){
                                            self.firstFilterNumber = 2
                                            self.networking = true
                                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                                searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                            }
                                        }else{
                                            self.filterSetting.toggle()
                                        }
                                    }){
                                        Text(self.selectFirstFilter[2])
                                            .foregroundColor(self.firstFilterNumber == 2 ? Color.yellow : Color("primaryColor"))
                                            .fontWeight(.light)
                                            .frame(width: UIScreen.main.bounds.width / 4 , alignment: .leading)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(self.firstFilterNumber == 2 ? Color.yellow : Color("primaryColor"))
                                            .opacity(self.firstFilterNumber == 2 ? 1.0 : 0.0)
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: self.filterHeight)
                            .padding(.horizontal,10)
                            .background(Color("primaryColorReverse"))
                        }
                        else if(self.filterSettingNumber == 2){
                            VStack(spacing : 10){
                                Spacer()
                                HStack{
                                    Button(action : {
                                        if(self.secFilterNumber != 1){
                                            self.secFilterNumber = 1
                                            self.networking = true
                                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                                searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                            }
                                            
                                        }else{
                                            self.filterSetting.toggle()
                                        }
                                    }){
                                        Text(self.selectSecFilter[1])
                                            .foregroundColor(self.secFilterNumber == 1 ? Color.yellow : Color("primaryColor"))
                                            .fontWeight(.light)
                                            .frame(width: UIScreen.main.bounds.width / 4 , alignment: .leading)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(self.secFilterNumber == 1 ? Color.yellow : Color("primaryColor"))
                                            .opacity(self.secFilterNumber == 1 ? 1.0 : 0.0)
                                    }
                                }
                                Spacer()
                                HStack{
                                    Button(action : {
                                        if(self.secFilterNumber != 2){
                                            self.secFilterNumber = 2
                                            self.networking = true
                                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                                searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                            }
                                        }else{
                                            self.filterSetting.toggle()
                                        }
                                    }){
                                        Text(self.selectSecFilter[2])
                                            .foregroundColor(self.secFilterNumber == 2 ? Color.yellow : Color("primaryColor"))
                                            .fontWeight(.light)
                                            .frame(width: UIScreen.main.bounds.width / 4 , alignment: .leading)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(self.secFilterNumber == 2 ? Color.yellow : Color("primaryColor"))
                                            .opacity(self.secFilterNumber == 2 ? 1.0 : 0.0)
                                    }
                                }
                                Spacer()
                                HStack{
                                    Button(action : {
                                        
                                        if(self.secFilterNumber != 3){
                                            self.secFilterNumber = 3
                                            self.networking = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                                                searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                                            }
                                        }else{
                                            self.filterSetting.toggle()
                                        }
                                    }){
                                        Text(self.selectSecFilter[3])
                                            .foregroundColor(self.secFilterNumber == 3 ? Color.yellow : Color("primaryColor"))
                                            .fontWeight(.light)
                                            .frame(width: UIScreen.main.bounds.width / 4 , alignment: .leading)
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(self.secFilterNumber == 3 ? Color.yellow : Color("primaryColor"))
                                            .opacity(self.secFilterNumber == 3 ? 1.0 : 0.0)
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: self.filterHeight)
                            .padding(.horizontal,10)
                            .background(Color("primaryColorReverse"))
                        }
                    }
                    //배경 공백
                    if(self.filterSetting){
                        Color("primaryColorReverse").opacity(0.1)
                            .onTapGesture(count: 1){
                                self.filterSetting.toggle()
                            }
                    }
                }
            }
            
            .background(self.filterSetting ? Color("primaryColor").opacity(0.1) :  Color("primaryColor").opacity(0.0))
            //
            //
            
            if self.networking || self.pagingNetwork{
                loadingView()
            }
        }
        .onChange(of: self.detailSettingApply){ value in
            if(value){
                self.networking = true
                
                DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                    searchResultSolt(searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp: self.$searchListTemp ,searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount , pagingCount : self.$pagingCount ,networking : self.$networking , filterSetting : self.$filterSetting , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem ,selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount).sortList(firstFilter : self.firstFilterNumber, secFilter: self.secFilterNumber)
                }
                self.detailSettingApply = false
            }
        }
        .fullScreenCover(isPresented: self.$detailSetting){
            filterSheet(detailSettingApply : self.$detailSettingApply , detailSetting : self.$detailSetting , selectgoodsType : self.$selectgoodsType , startIndexCount : self.$startIndexCount , endIndexCount : self.$endIndexCount , facilityItem : self.$facilityItem , facilityToolItem : self.$facilityToolItem)
        }
        //.sheet(item: self.detailSetting, content: filterSheet())
        .navigationBarItems(trailing:
                                Button(action: {
                                    
                                }, label: {
                                    searchItem(searchKeyword: self.$getSearchKeyword , searchListDefault: self.$searchListDefault , searchList: self.$searchList, searchListTemp : self.$searchListTemp ,searchEnd: self.$searchEnd, searchPage: self.$searchPage , totalCount: self.$totalCount , listCount: self.$listCount, pagingNetwork: self.$pagingNetwork , pagingCount: self.$pagingCount , networking : self.$networking , firstFilterNumber : self.$firstFilterNumber , secFilterNumber : self.$secFilterNumber)
                                }).foregroundColor(Color("primaryColor"))
                            
        )
        .navigationBarTitle("", displayMode: .inline)
        
    }
}


struct searchItem: View {
    
    @State var searchResult : Bool = false
    @Binding var searchKeyword : String
    
    @Binding var searchListDefault : [searchCenterModel]
    
    @Binding var searchList : [searchCenterModel]
    
    @Binding var searchListTemp : [searchCenterModel]
    
    @Binding var searchEnd : Bool
    
    
    @Binding var searchPage : Int
    
    @Binding var totalCount : Int
    
    @Binding var listCount : Int
    
    @Binding var pagingNetwork : Bool
    
    @Binding var pagingCount : Int
    
    
    @Binding var networking : Bool
    
    @Binding var firstFilterNumber : Int
    
    @Binding var secFilterNumber : Int
    
    var body: some View {
        VStack{
            
            
            HStack{
                TextField("키워드를 입력해주세요" , text : $searchKeyword , onCommit : {
                    if(self.searchKeyword != "" && searchResultViewModel().searchCkeck(searchText: self.searchKeyword)){
                        //검색시 파라미터를 초기화해주는 변수가 담긴 모델을 바인딩하는 구조체를 선언하여 파라미터 클리어한느 함수를 실행
                        searchClearViewModel(searchListDefault: self.$searchListDefault, searchList: self.$searchList, searchListTemp: self.$searchListTemp, searchEnd: self.$searchEnd, searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount, pagingNetwork: self.$pagingNetwork, pagingCount: self.$pagingCount, firstFilterNumber: self.$firstFilterNumber, secFilterNumber: self.$secFilterNumber, networking: self.$networking).searchParameterClearAndSearch(searchKeyword : self.searchKeyword)
                        
                        
                        
                    }
                    else{
                        alertManager().alertView(title: "검색", reason: "검색 키워드를 확인해주세요")
                    }
                })
                .foregroundColor(Color("primaryColor"))
                .font(.system(size: 13))
                .padding(.leading)
                Button(action: {
                    if(self.searchKeyword != "" && searchResultViewModel().searchCkeck(searchText: self.searchKeyword)){
                        
                        //검색시 파라미터를 초기화해주는 변수가 담긴 모델을 바인딩하는 구조체를 선언하여 파라미터 클리어한후 검색을 진행하는 함수를 실행
                        searchClearViewModel(searchListDefault: self.$searchListDefault, searchList: self.$searchList, searchListTemp: self.$searchListTemp, searchEnd: self.$searchEnd, searchPage: self.$searchPage, totalCount: self.$totalCount, listCount: self.$listCount, pagingNetwork: self.$pagingNetwork, pagingCount: self.$pagingCount, firstFilterNumber: self.$firstFilterNumber, secFilterNumber: self.$secFilterNumber, networking: self.$networking).searchParameterClearAndSearch(searchKeyword : self.searchKeyword)
                        
                    }
                    else{
                        alertManager().alertView(title: "검색", reason: "검색 키워드를 확인해주세요")
                    }
                }){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("primaryColor"))
                }
                .frame(width: 50, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .frame(width: (UIScreen.main.bounds.width/5 * 4),height: 35 ,alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color("primaryColor"), lineWidth: 2)
            )
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            //한번클릭했을때 키보드창이떠있으면 없애주는코드
            UIApplication.shared.windows.first?.endEditing(true)
            
        })
    }
    
}

