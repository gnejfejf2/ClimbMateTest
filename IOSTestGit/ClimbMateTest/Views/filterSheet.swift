//
//  filterSheet.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/10.
//

import SwiftUI

struct filterSheet: View {
    let totalWidth = UIScreen.main.bounds.width - 80
    //상품정보
    let goodsType = ["빈공간","1일 이용권","1일 이용권 + 강습","1개월 회원권","1개월 회원권 + 강습"]
    let goodsMax = [0,5,5,20,30]
    @Binding var detailSettingApply : Bool
    @Binding var detailSetting : Bool
    
    //세부필터 가격에대한 부분
    @Binding var selectgoodsType : Int
    @Binding var startIndexCount : Int
    @Binding var endIndexCount : Int
    //시설에 대한 정보들
    @Binding var facilityItem : [facilityModel]
    @Binding var facilityToolItem : [facilityToolModel]
    
    //시트에서 아이템을 변경하고 적용을 누르지 않을경우도 있기때문에
    //적용을 눌렀을경우에만 Binding된 값을 변경하고 그렇지 않을경우 UI에서 사용하는 아래의 값들만 변경한다.
    @State var selectgoodsTypeSheet : Int = 0
    @State var startIndexCountSheet : Int = 0
    @State var endIndexCountSheet : Int = 20
    //편의시설에대한 아이템들이 저장되어있는 배열 세부필터에서 사용한다.
    @State var facilityItemSheet = [facilityModel(name: "샤워실", checked: false)
                                    ,facilityModel(name: "수건", checked: false)
                                    ,facilityModel(name: "락커룸", checked: false)]
    
    //도구에대한 값들이 저장되어있는 배열 대한 아이템들이 저장되어있는 배열 세부필터에서 사용한다.
    @State var facilityToolItemSheet = [facilityToolModel(name: "킬터보드", checked: false)
                                        ,facilityToolModel(name: "문보드", checked: false)]
    @State var bindingSetting : Bool = false
    
    @State var startIndexWidth : CGFloat = 0
    @State var endIndexWidth : CGFloat = 0
    @State var maxCount : Int = 0
    var body: some View {
        VStack{
            if(self.bindingSetting){
                HStack{
                    Button(action :{
                        self.detailSetting = false
                    }){
                        Text("취소")
                            .padding(.top,10)
                            .font(.system(size: 16))
                    }
                    Spacer()
                    Text("필터")
                        .bold()
                        .font(.system(size: 22))
                    Spacer()
                    Button(action :{
                        //적용 버튼을 눌렀을경우 선택했던 값들로 검색을하기위해 각각의 값들을 변경해준다.
                        self.selectgoodsType = self.selectgoodsTypeSheet
                        self.startIndexCount = self.startIndexCountSheet
                        self.endIndexCount = self.endIndexCountSheet
                        
                        self.facilityItem = self.facilityItemSheet
                        self.facilityToolItem = self.facilityToolItemSheet
                        
                        
                        
                        
                        self.detailSettingApply = true
                        self.detailSetting = false
                        
                    }){
                        Text("적용")
                            .padding(.top,10)
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal,15)
                .padding(.top,10)
                
                devideLineView(height: 1, topPadding: 1, bottomPadding: 1)
                ScrollView{
                    VStack(alignment: .leading , spacing : 15){
                        //이용권 선택
                        Group{
                            Text("이용권 선택")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            
                            Button(action : {
                                if(self.selectgoodsTypeSheet == 1){
                                    withAnimation(Animation.easeInOut(duration: 0.3)){
                                        self.selectgoodsTypeSheet = 0
                                    }
                                }
                                else{
                                    self.selectgoodsTypeSheet = 1
                                    self.startIndexCountSheet = 0
                                    self.endIndexCountSheet = self.goodsMax[self.selectgoodsTypeSheet]
                                    self.startIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.startIndexCount)
                                    self.endIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.endIndexCountSheet)
                                    self.maxCount = self.goodsMax[self.selectgoodsTypeSheet]
                                }
                            }){
                                HStack{
                                    Text(self.goodsType[1])
                                        .foregroundColor(self.selectgoodsTypeSheet == 1 ? Color.yellow : Color("primaryColor"))
                                        .fontWeight(.light)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(self.selectgoodsTypeSheet == 1 ? Color.yellow : Color("primaryColor"))
                                        .opacity(self.selectgoodsTypeSheet == 1 ? 1.0 : 0.0)
                                }
                            }
                            
                            Button(action : {
                                
                                if(self.selectgoodsTypeSheet == 2){
                                    withAnimation(Animation.easeInOut(duration: 0.3)){
                                        self.selectgoodsTypeSheet = 0
                                    }
                                }
                                else{
                                    self.selectgoodsTypeSheet = 2
                                    self.startIndexCountSheet = 0
                                    self.endIndexCountSheet = self.goodsMax[self.selectgoodsTypeSheet]
                                    self.startIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.startIndexCount)
                                    self.endIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.endIndexCountSheet)
                                    self.maxCount = self.goodsMax[self.selectgoodsTypeSheet]
                                    
                                }
                                
                            }){
                                HStack {
                                    Text(self.goodsType[2])
                                        .foregroundColor(self.selectgoodsTypeSheet == 2 ? Color.yellow : Color("primaryColor"))
                                        .fontWeight(.light)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(self.selectgoodsTypeSheet == 2 ? Color.yellow : Color("primaryColor"))
                                        .opacity(self.selectgoodsTypeSheet == 2 ? 1.0 : 0.0)
                                }
                            }
                            
                            Button(action : {
                                if(self.selectgoodsTypeSheet == 3){
                                    withAnimation(Animation.easeInOut(duration: 0.3)){
                                        self.selectgoodsTypeSheet = 0
                                    }
                                }
                                else{
                                    self.selectgoodsTypeSheet = 3
                                    self.startIndexCountSheet = 0
                                    self.endIndexCountSheet = self.goodsMax[self.selectgoodsTypeSheet]
                                    self.startIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.startIndexCount)
                                    self.endIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.endIndexCountSheet)
                                    self.maxCount = self.goodsMax[self.selectgoodsTypeSheet]
                                }
                            }){
                                HStack{
                                    Text(self.goodsType[3])
                                        .foregroundColor(self.selectgoodsTypeSheet == 3 ? Color.yellow : Color("primaryColor"))
                                        .fontWeight(.light)
                                    
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(self.selectgoodsTypeSheet == 3 ? Color.yellow : Color("primaryColor"))
                                        .opacity(self.selectgoodsTypeSheet == 3 ? 1.0 : 0.0)
                                }
                            }
                            
                            Button(action : {
                                if(self.selectgoodsTypeSheet == 4){
                                    withAnimation(Animation.easeInOut(duration: 0.3)){
                                        self.selectgoodsTypeSheet = 0
                                    }
                                }
                                else{
                                    self.selectgoodsTypeSheet = 4
                                    self.startIndexCountSheet = 0
                                    self.endIndexCountSheet = self.goodsMax[self.selectgoodsTypeSheet]
                                    self.startIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.startIndexCount)
                                    self.endIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.endIndexCountSheet)
                                    self.maxCount = self.goodsMax[self.selectgoodsTypeSheet]
                                }
                            }){
                                HStack{
                                    Text(self.goodsType[4])
                                        .foregroundColor(self.selectgoodsTypeSheet == 4 ? Color.yellow : Color("primaryColor"))
                                        .fontWeight(.light)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(self.selectgoodsTypeSheet == 4 ? Color.yellow : Color("primaryColor"))
                                        .opacity(self.selectgoodsTypeSheet == 4 ? 1.0 : 0.0)
                                }
                            }
                            
                            if(self.selectgoodsTypeSheet != 0){
                                customSlider(startIndexCount: self.$startIndexCountSheet, endIndexCount: self.$endIndexCountSheet , startIndexWidth: self.$startIndexWidth , endIndexWidth: self.$endIndexWidth , maxCount : self.$maxCount)
                                    .padding(.vertical , 20)
                                
                            }
                            
                            devideLineView(height: 1, topPadding: 1, bottomPadding: 1)
                        }
                        
                        // 시설 관련 그룹
                        Group{
                            Text("시설")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            ForEach(self.facilityItemSheet.indices){ facility in
                                
                                facilityFilterItem(filter: self.$facilityItemSheet[facility])
                                
                            }
                            
                            devideLineView(height: 1, topPadding: 1, bottomPadding: 1)
                        }
                        
                        // 시설 관련 그룹
                        Group{
                            Text("도구")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            ForEach(self.facilityToolItemSheet.indices){  facilityTool in
                                facilityToolFilterItem(filter: self.$facilityToolItemSheet[facilityTool])
                            }
                            
                            devideLineView(height: 1, topPadding: 1, bottomPadding: 1)
                        }
                        
                    }.padding(.horizontal,20)
                    
                    .frame(alignment: .leading)
                }
            }
        }
        
        .onAppear(){
            //화면에 보일때 기존에 저장되어있는 값으로 초기화를 해준후 사용한다.
            //기존에 필터가 저장되어있을경우 보여주기위하여
            self.selectgoodsTypeSheet = self.selectgoodsType
            self.startIndexCountSheet = self.startIndexCount
            self.endIndexCountSheet = self.endIndexCount
            self.facilityItemSheet = self.facilityItem
            self.facilityToolItemSheet = self.facilityToolItem
            
            self.startIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.startIndexCount)
            self.endIndexWidth = (self.totalWidth / CGFloat(self.goodsMax[self.selectgoodsTypeSheet])) * CGFloat(self.endIndexCountSheet)
            self.maxCount = self.goodsMax[self.selectgoodsTypeSheet]
            
            
            
            self.bindingSetting = true
        }
        
    }
}



struct facilityFilterItem : View{
    @Binding var filter : facilityModel
    var body: some View{
        HStack{
            Text(filter.name)
                .foregroundColor(filter.checked ? Color.yellow : Color("primaryColor"))
                .fontWeight(.light)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(filter.checked ? Color.yellow : Color("primaryColor"))
                .opacity(filter.checked ? 1.0 : 0.0)
        }
        .onTapGesture(perform: {
            filter.checked.toggle()
        })
    }
}

struct facilityToolFilterItem : View{
    @Binding var filter : facilityToolModel
    var body: some View{
        HStack{
            Text(filter.name)
                .foregroundColor(filter.checked ? Color.yellow : Color("primaryColor"))
                .fontWeight(.light)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(filter.checked ? Color.yellow : Color("primaryColor"))
                .opacity(filter.checked ? 1.0 : 0.0)
            
         }
        .onTapGesture(perform: {
            filter.checked.toggle()
        })
    }
}



