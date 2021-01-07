//
//  mypage.swift
//  tstory
//
//  Created by kang jiyoun on 2021/01/06.
//

import SwiftUI


struct myPageViewRecreate : View {
    
    @State var y : CGFloat = 0
    
    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    
    @State var actionSheetBool : Bool = false
    
    
    @State var editBool : Bool = false
    
    @State var inquiryBool : Bool = false
    
    @State var  preferencesBool : Bool = false
    
    let topPadding : CGFloat = UIScreen.main.bounds.height / 5.5
    
    var body : some View{
        VStack{
            HStack{
                Text("gnejfejf3")
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
                Button(action:{
                    self.actionSheetBool.toggle()
                }){
                    Image(systemName: "ellipsis")
                        .resizable()
                        .foregroundColor(Color("primaryColor"))
                        .frame(width: 30, height: 8)
                }
                
            }.padding(15)
            
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                
                NavigationLink(
                    destination: myPageEditView(),
                    isActive: self.$editBool,
                    label: {
                        
                    })
                
                
                NavigationLink(
                    destination: inquiryView(),
                    isActive: self.$inquiryBool,
                    label: {
                        
                    })
                
                NavigationLink(
                    destination:  preferencesView(),
                    isActive: self.$preferencesBool,
                    label: {
                        
                    })
                
                
                Image("1")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width , height: self.topPadding + 100)
                
                
                
                ScrollView(.vertical, showsIndicators : false){
                    
                    LazyVStack(alignment: .center, spacing: 0, pinnedViews: [.sectionHeaders], content: {
                        
                        //상단에 이미지가 보이게하기위해 비어놓은 공간
                        Section(header: Spacer()) {
                        }.frame(width: UIScreen.main.bounds.width , height: self.topPadding)
                        
                        myPageInformationView()
                        
                        contentWithBarView()
                        
                        
                    })
                }
                .padding(.top , 0.1)
                .frame(width : self.screenWidth)
                
            }
            
            
        } .actionSheet(isPresented: self.$actionSheetBool, content: {
            ActionSheet(title: Text("옵션"), buttons: [
                            .default(Text("마이페이지")){self.editBool.toggle()},
                            .default(Text("공지사항")){},
                            .default(Text("문의하기")){self.inquiryBool.toggle()},
                            .default(Text("환경설정")){self.preferencesBool.toggle()},
                            .cancel()])
        })
        .navigationBarHidden(true)
           
           
      
    }
}

struct myPageInformationView : View {
    var body: some View{
        VStack{
            Section(header: Color.clear) {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                    
                    
                    VStack(spacing : 7){
                        HStack{
                            Text("지윤강")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            Spacer()
                        }
                        
                        HStack(spacing : 5){
                            
                            
                            Text("KangJW204")
                                .font(.system(size: 15))
                            
                            Image("instagramIcon")
                                .resizable()
                                .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            Spacer()
                        }
                        
                        HStack(spacing : 5){
                            Text("팔로우 0 ")
                                .font(.system(size: 15))
                                .foregroundColor(Color("primaryColor")).opacity(0.9)
                            
                            Image(systemName: "circlebadge.fill")
                                .padding(.horizontal, 5)
                                .font(.system(size: 4))
                                .foregroundColor(Color.gray.opacity(0.7))
                            
                            Text("팔로잉 0 ")
                                .font(.system(size: 15))
                                .foregroundColor(Color("primaryColor")).opacity(0.9)
                            
                            Spacer()
                        }
                        
                        
                    }
                    .padding(.horizontal,15)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top , 45)
                    .background(Color("smokeBackgroundColor"))
                    .padding(.top , 40)
                    
                    HStack{
                        Image("mainLogoReverse")
                            .resizable()
                            .frame(width: 70, height: 70, alignment: .leading)
                            .background(Color("primaryColorReverse"))
                            .cornerRadius(10)
                        
                        Spacer()
                        
//                        Image(systemName: "house")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(Color("primaryColor"))
//                            .padding(.top , 45)
                    }
                    .frame(alignment: .bottom)
                    .padding(.horizontal,14)
                }
                
                
            }
        }
        
    }
}

struct contentWithBarView : View{
    @Namespace var animation
    @State var topTabSelection : Int = 0
    @State var screenWidth : CGFloat = UIScreen.main.bounds.width
    
    var body : some View{
        Section(header: tapBar(topTabSelection: self.$topTabSelection, animation: animation)
        ) {
            
            TabView(selection : self.$topTabSelection) {
                Text("Hello, World!1")
                    .tag(0)
                    .frame(width: 100, height: 1000, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("2")
                    .tag(1)
                    .frame(width: 100, height: 1000, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(width : self.screenWidth)
            
        }
        .padding(.top , 20)
        .background(Color("smokeBackgroundColor"))
    }
    
}


struct tapBar : View {
    
    @Binding var topTabSelection : Int
    
    
    let capsuleHeight : CGFloat = 4
    
    var animation : Namespace.ID
    var body : some View{
        VStack{
            
            
            HStack(spacing : 0){
                
                Button(action: {
                    
                    withAnimation(){
                        self.topTabSelection = 0
                        
                    }
                    
                }) {
                    VStack{
                        Image(systemName: ("square.grid.3x3"))
                            .resizable()
                            .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(self.topTabSelection == 0 ? .red : .gray)
                        
                        
                    }
                    .frame(width: UIScreen.main.bounds.width / 2)
                }
                Button(action: {
                    
                    withAnimation(){
                        self.topTabSelection = 1
                        
                    }
                }) {
                    VStack{
                        Image(systemName: ("calendar"))
                            .resizable()
                            .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(self.topTabSelection == 1 ? .red : .gray)
                        
                        
                    }
                    .frame(width: UIScreen.main.bounds.width / 2)
                }
                
                
            }
            
            GeometryReader{g in
                
                HStack{
                    
                    
                    
                    if self.topTabSelection == 0{
                        
                        Capsule()
                            .fill(Color.red)
                            .frame(width: g.size.width / 2, height: self.capsuleHeight)
                            .matchedGeometryEffect(id: "Tab_Change", in: animation)
                    }
                    
                    
                    
                    
                    if self.topTabSelection == 1{
                        
                        Capsule()
                            .fill(Color.clear)
                            .frame(width:  g.size.width / 2, height: self.capsuleHeight)
                        
                        Capsule()
                            .fill(Color.red)
                            .frame(width:  g.size.width / 2, height: self.capsuleHeight)
                            .matchedGeometryEffect(id: "Tab_Change", in: animation)
                    }
                    
                }
                
                
            }
            
        }
    }
}





struct mypage_Previews: PreviewProvider {
    static var previews: some View {
        myPageViewRecreate()
            .preferredColorScheme(.dark)
    }
}


