//
//  searchView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/11.
//

import SwiftUI
import CoreData

struct searchView: View {
    
     
    var body: some View {
        ZStack{
            VStack{
            
                    //빈공간을 인식해주는 배경색과 똑같은 컬러를 선언해주고 이것을 클릭했을시 키보드가 올라와있을경우 사리지도록 컨트롤해준다.
                    Color("primaryColorReverse").opacity(1)
                        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                            UIApplication.shared.windows.first?.endEditing(true)

                        })
                
                
                
            }
            VStack{
                Text("검색")
                    .font(.title)
                    .padding(.top)
                
                devideLineView(height: 0, topPadding: 5, bottomPadding: 5)
                
                searchingView()
                searchHistoryList()
              
                Spacer()
                    //빈공간을 인식해주는 배경색과 똑같은 컬러를 선언해주고 이것을 클릭했을시 키보드가 올라와있을경우 사리지도록 컨트롤해준다.
//                    Color("primaryColorReverse").opacity(1)
//                        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
//                            UIApplication.shared.windows.first?.endEditing(true)
//
//                        })
                
                
                
            }
            
           
            
        }   .navigationBarHidden(true)
            
         
         
       
    }
}

struct searchView_Previews: PreviewProvider {
    static var previews: some View {
        searchView()
    }
}

//검색창이 나오는 뷰
//변화하는 값에 반응하기 위하여 @State를 선언
//추후에 사용할 검색값 -> searchKeyword
struct searchingView: View {
    @State var searchStart : Bool = false
    @State var searchKeyword = ""
    
    
    @State var output: String = ""
    @State var input: String = ""
    @State var typing = false
    
    
    var body: some View {
        
        //검색결과를 반영하여 네비게이션 링크를 동작
        //네비게이션 링크에있는 UI를 클릭하는방식이아닌
        //isActive 를 통해 true false 로 실행
        
        NavigationLink(
            destination: searchResultView(getSearchKeyword: self.searchKeyword),
            isActive: self.$searchStart,
            label: {
               
            })
        
        HStack{
            

            //onCommit 리턴키이벤트
            //리턴키를 눌렀을 경우 검색이벤트가 실행됨
            TextField("키워드를 입력해주세요" , text : $searchKeyword , onCommit: {
                
                //검색조건에 맞는지를 확인한후 검색조건이맞다면 검색 시작
                if(self.searchKeyword != "" && searchResultViewModel().searchCkeck(searchText: self.searchKeyword)){
                    self.searchStart = true
                }
                else{
                    alertManager().alertView(title: "검색", reason: "검색 키워드를 확인해주세요")
                }
            })
                .foregroundColor(Color("primaryColor"))
                .font(.system(size: 13))
                .padding(.leading)
                
                
            //마찬가지로 돋보기 버튼을 눌렀을경우에도
            //검색조건에 맞는지를 확인한후 검색조건이맞다면 검색 시작
            Button(action: {
                if(self.searchKeyword != "" && searchResultViewModel().searchCkeck(searchText: self.searchKeyword)){
                    self.searchStart = true
                }
                else{
                    alertManager().alertView(title: "검색", reason: "검색 키워드를 확인해주세요")
                }
            }){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("primaryColor"))
            }
            .frame(width: 50, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("primaryColor"), lineWidth: 2)
            
        )
        .padding(15)
        .frame(width: (UIScreen.main.bounds.width),height: 40 ,alignment: .center)
        .onAppear(){
            //해당화면이 다시 노출되었을경우 검색했던 키워드를 다시 사용하지 않기위하여
            self.searchKeyword = ""
        }
    }
}



struct searchPageSearchView: View {
   
    @State var searchKeyword = ""
    var body: some View {
        
        VStack{
            HStack{
                TextField("키워드를 입력해주세요" , text : $searchKeyword)
                    .font(.system(size: 13))
                    .padding(.leading)
                
                Button(action: {
                
                }){
                    Image(systemName: "magnifyingglass")
                }
                .frame(width: UIScreen.main.bounds.width/6, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            .frame(height: 40 ,alignment: .center)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
    
}

//코어데이터랑 연결

struct searchHistoryList : View {
    @StateObject var searchHistory = searchHistoryModel()

    var body: some View{
        VStack{
            HStack{
                Text("최근 검색기록")
                Spacer()
                Button(action: {
                    withAnimation(.easeOut(duration: 0.5)){
                        self.searchHistory.allDelete()
                    }
                }){
                    Text("전체삭제")
                }
            }
            .padding()
            
            if(!self.searchHistory.searchHistorys.isEmpty){
                List{
                    ForEach(self.searchHistory.searchHistorys, id: \.self){ obj in
                        ZStack{
                            searchHistoryCard(keyword: self.searchHistory.getKeyword(obj: obj), searchDate: self.searchHistory.getDate(obj: obj))
                            NavigationLink(
                                destination: searchResultView(getSearchKeyword: self.searchHistory.getKeyword(obj: obj))){
                               
                            }.opacity(0)
                        }
                    }
                    .onDelete(perform: searchHistory.deleteData(indexSet:))
                 
                }
            }
            else{
                
                Text("검색 기록이 없습니다.")
                
            }
        }
        
        .onAppear(){
            self.searchHistory.readData()
        }
    }
}
