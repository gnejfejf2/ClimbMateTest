
//9월 28일 - 강지윤
//클라이메이트 어플 homeView.swift에서 최상단부에 사용하는 UI
//클라이메이트를 클릭할시 homeView.swift로 이동
//검색버튼 누를시 searchKeyword 변수에 해당하는 내용을 검색

import SwiftUI
import NotificationCenter

struct topNaviLogoSearch: View {
    var body: some View {
        HStack{
            Spacer()
            climbmateLogoButton()
            Spacer()
            searchPlaceView()
            Spacer()
        }
    }
}



//로고를 그려주는 공간
struct climbmateLogoButton : View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Image(colorScheme == .light ? "mainLogo" : "mainLogoReverse")
            .resizable()
            .frame(width : UIScreen.main.bounds.width/5 * 1,height: 30,alignment: .center)
       
    
      
    }
//    func test(){
//        var instagramHooks = "https://www.instagram.com/p/CHmrswxjf5z/?igshid=et0vr8u4cqpp"
//          var instagramUrl = URL(string: instagramHooks)
//        if UIApplication.shared.canOpenURL(instagramUrl!)
//          {
//            UIApplication.shared.open(instagramUrl!)
//
//           } else {
//            UIApplication.shared.open(URL(string: instagramHooks)!)
//
//              //redirect to safari because the user doesn't have Instagram
//          }
//
//    }
    
}

//검색창이 나오는 뷰
//변화하는 값에 반응하기 위하여 @State를 선언
//추후에 사용할 검색값 -> searchKeyword
struct searchPlaceView: View {
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
        .frame(width: (UIScreen.main.bounds.width/5 * 3),height: 40 ,alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color("primaryColor"), lineWidth: 2)
            
        )
       
        
        
    }
    
}


struct topNavi_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           
            topNaviLogoSearch()
        }
    }
}
