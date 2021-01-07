//
//  favoritesView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/11.
//

import SwiftUI
import SDWebImageSwiftUI

struct favoritesView: View {
    
    @Binding var tabviewCount : Int
    
    @State var itemHeigh : CGFloat = UIScreen.main.bounds.height / 8 + 5
    
    
    
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    @Namespace var name
    
    @State var favoritesCenters = [favoritCenterModel]()
    
    @State var centerID : String = ""
    @State var centerName : String = ""
    @State var centerDetail : Bool = false
    
    @State var appear : Bool = false
    
    var body: some View {
        VStack{
            ZStack{
                VStack(spacing : 0){
                    //추후에 사용될 즐겨찾기 뷰아직 서버쪽 업데이트가 이뤄지지않아 사용하지 못하고있음
                    //                    HStack{
                    //                        Text("세팅 변경")
                    //                            .fontWeight(.bold)
                    //                            .padding()
                    //                        Spacer()
                    //                    }
                    //                    .background(Color("smokeBackgroundColor"))
                    //                    ScrollView(.horizontal , showsIndicators:false){
                    //                        HStack{
                    //                            ForEach(staticString().tempCenter){tempCenter in
                    //
                    //                                    favoritesCardView(tempCenter : tempCenter)
                    //                            }
                    //                        }
                    //                        .padding(.horizontal)
                    //                    }
                    
                    NavigationLink(destination: centerDetailViewRecreate(clickType: staticString().staticClickType[2] , centerID: self.centerID) , isActive: self.$centerDetail){
                    }
                    
                    
                    if(self.favoritesCenters.count>0 ){
                        HStack{
                            Text("즐겨찾기")
                                .fontWeight(.bold)
                                .padding()
                            Spacer()
                        }
                        .background(Color("smokeBackgroundColor"))
                        .cornerRadius(5)
                        ScrollView(.vertical  , showsIndicators:false , content: {
                            
                            VStack(alignment: .leading, spacing: 10, content: {
                                Text("총 \(self.favoritesCenters.count)개")
                                    .font(.system(size: 12))
                                    .font(.headline)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 20)
                                
                                ForEach(self.favoritesCenters) { center in
                                    ZStack {
                                        HStack{
                                            Spacer()
                                            Color.red
                                                .frame(width: 90)
                                                .opacity(center.offset < 0 ? 0.8 : 0)
                                        }
                                        
                                        HStack{
                                            Spacer()
                                                .frame(width: 90)
                                            Spacer()
                                            Button(action: {
                                                centerDetailViewModel().favoritesCenterDelete(centerID: center.id){ result in
                                                    if(result.errorCheck){
                                                        withAnimation(.default){
                                                            //.removeAll 조건을 주고 해당조건이 맞다면 해당조건에 맞는 모든 아이템을 삭제
                                                            self.favoritesCenters.removeAll { (center1) -> Bool in
                                                                if center.id == center1.id{
                                                                    return true
                                                                }
                                                                else{
                                                                    return false
                                                                }
                                                            }
                                                        }
                                                    }else{
                                                        alertManager().alertView(title: "통신오류", reason: result.networkErrorReason ?? "알 수 없음")
                                                    }
                                                }
                                                
                                            }, label: {
                                                Image(systemName: "trash.fill")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                            })
                                            .frame(width: 90)
                                        }
                                        
                                        centerListItem(center: center)
                                            .frame(height: self.itemHeigh)
                                            .padding(.horizontal, 20)
                                            .background(Color("primaryColorReverse"))
                                            .contentShape(Rectangle())
                                            // adding gesture...
                                            .offset(x: center.offset)
                                            .gesture(DragGesture().onChanged({ (value) in
                                                withAnimation(.default){
                                                    if(value.translation.width > -80 && value.translation.width <= 0){
                                                        self.favoritesCenters[favoritesViewModel().getIndex(centerName: center.centerName,favoritesCenters : self.favoritesCenters)].offset = value.translation.width
                                                    }
                                                }
                                            })
                                            .onEnded({ (value) in
                                                withAnimation(.default){
                                                    if value.translation.width < -80{
                                                        self.favoritesCenters[favoritesViewModel().getIndex(centerName: center.centerName,favoritesCenters : self.favoritesCenters)].offset = -90
                                                    }
                                                    else{
                                                        self.favoritesCenters[favoritesViewModel().getIndex(centerName: center.centerName,favoritesCenters : self.favoritesCenters)].offset = 0
                                                    }
                                                }
                                            }))
                                            .onTapGesture{
                                                //삭제하기 버튼을 꺼냈을경우에는 삭제기능만되도록
                                                if(  self.favoritesCenters[favoritesViewModel().getIndex(centerName: center.centerName,favoritesCenters : self.favoritesCenters)].offset == -90){
                                                    withAnimation(.default){
                                                        self.favoritesCenters[favoritesViewModel().getIndex(centerName: center.centerName,favoritesCenters : self.favoritesCenters)].offset = 0
                                                    }
                                                }
                                                else{
                                                    centerID = center.id
                                                    
                                                    centerName = center.centerName
                                                    
                                                    self.centerDetail = true
                                                }
                                            }
                                    }
                                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    
                                    devideLineView(height: 1, topPadding: 0, bottomPadding: 0)
                                }
                                
                                
                            })
                            
                            
                            
                            
                            
                        })
                    }else{
                        
                        if(userData().returnUserData(index: 0) == "" || userData().returnUserData(index: 0) == nil){
                            
                            
                            VStack{
                                Spacer()
                                
                                Text("로그인이 필요한 기능입니다.")
                                Spacer()
                                Button(action:{
                                    //메인에서 바인당받은 탭큐카운트를 이용하여 로그인 페이지로 전환시킨다.
                                    self.tabviewCount = 3
                                }){
                                    Text("로그인 하러가기")
                                        .foregroundColor(Color("primaryColorReverse"))
                                        .font(.system(size: 22))
                                        .padding(20)
                                        .background(Color("smokeBackgroundColorReverse"))
                                        .cornerRadius(5)
                                }
                                
                                Spacer()
                            }
                            
                            
                        }else{
                            VStack{
                                Spacer()
                                Text("즐겨찾기가 추가된 클라이밍장이 없습니다.")
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            
                        }
                        
                    }
                    
                }
                
                
            }
            .onAppear(){
                if(userData().returnUserData(index: 0) != nil && userData().returnUserData(index: 0) != ""){
                    favoritesViewModel().getFavoritesCenterList(){
                        result , error in
                        if(error.errorCheck){
                            if(result?.count == 0 && self.favoritesCenters.count > 0){
                                self.favoritesCenters.removeAll()
                            }
                            alertManager().alertView(title: "통신오류", reason: error.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                        }else{
                            
                            
                            self.favoritesCenters = result!
                        }
                        
                    }
                }else{
                    self.favoritesCenters.removeAll()
                    
                    
                    
                    
                }
            }
            .onDisappear(){
                if(userData().returnUserData(index: 0) == nil && !self.centerDetail){
                    self.favoritesCenters.removeAll()
                }
            }
            .navigationBarHidden(true)
        }
        
    }
}




