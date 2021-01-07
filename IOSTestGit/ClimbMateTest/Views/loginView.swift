//
//  loginView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/16.
//

import SwiftUI

struct loginView: View {
    @Environment(\.colorScheme) var colorScheme
   
   
    let nomalPlatformCode : String = "1"
    let kakaoPlatformCode : String = "2"
    @State var email = ""
    @State var pass = ""
    //해당값은 키패드가 나올경우 키패드만큼의 높이를 뷰의높이에 더해주기위하여 사용하는코드
    @State var height : CGFloat = 0
    
    //자체로그인회원가입을 시작하였을경우 해당값이 true가된다
    @State var register : Bool = false
    
    //소셜로그인 추가정보 기입이 시작하였을경우 해당값이 true가된다.
    @State var plusRegister : Bool = false
    @State var plusEmail : String = ""
    @State var plusUserID : String = ""
    @State var plusUserNickname : String = ""
    //해당값이 false가되면 이전페이지의 fullscreencover가 사라지게되어
    //loginView가 사라지게된다.
    @Binding var loginBool : Bool
    @Binding var passwordChange : Bool
    
    //화면의 기본크기는 screen크기에서 40을 뺀값이다.
    var body: some View{
        //키보드가 올라올경우 스크린뷰가 작동을해야함
        NavigationView{
            ZStack{
                
                VStack(spacing : 0){
                    
                    ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : (self.height == 0 ? .init() : .vertical), showsIndicators: false) {
                        VStack(spacing : 20){
                            
                            HStack{
                                //로그인화면 종료버튼
                                Button(action: {
                                    self.loginBool = false
                                }){
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .foregroundColor(Color("primaryColor"))
                                }
                                .frame(width: UIScreen.main.bounds.width / 30, height: UIScreen.main.bounds.height / 45)
                                .padding(.leading,10)
                                .padding()
                                Spacer()
                            }
                           
                            Image(colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Spacer()
                            VStack(alignment: .leading){
                                VStack{
                                    TextField("이메일", text: self.$email)
                                        .foregroundColor(Color("primaryColor"))
                                    Rectangle()
                                        .fill(self.email == "" ? Color("primaryColor").opacity(0.08) : Color.blue.opacity(0.7))
                                        .frame(height: 3)
                                }.padding(.top,10)
                                VStack{
                                    //onCommit 버튼은확인을 눌렀을경우 실행되는 버튼
                                    //비밀번호를 치고 확인을 눌렀을경우 로그인로직이 실행되도록
                                    SecureField("비밀번호", text: self.$pass , onCommit : {
                                        loginViewModel().login(email: self.email, password: self.pass ,  platform : nomalPlatformCode){ result in
                                            if(result.networkErrorReason == "change"){
                                                self.loginBool = false
                                                self.passwordChange = true
                                            }
                                            else if(!result.errorCheck){
                                                self.loginBool = false
                                            }else{
                                                alertManager().alertView(title: "로그인", reason: result.networkErrorReason!)
                                            }
                                        }
                                    })
                                    .foregroundColor(Color("primaryColor"))
                                    Rectangle()
                                        .fill(self.pass == "" ? Color("primaryColor").opacity(0.08) : Color.blue.opacity(0.7))
                                        .frame(height: 3)
                                }  .padding(.top, 20)
                                
                                HStack{
                                    Button(action: {
                                        //회원가입버튼을 클릭할경우 회원가입 시작 화면을 나오게하기위해
                                        //값을 true로 변경
                                        self.register = true
                                    }) {
                                        Text("회원 가입")
                                            .font(.system(size: 19))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("primaryColor"))
                                    }
                                    Spacer()
                                    
                                    NavigationLink(
                                        destination: passGetView() ){
                                        Text("비밀번호를 잊어버렸나요?")
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("primaryColor").opacity(0.75))
                                    }
                                    
                                    
                                }
                                .padding(.top)
                                .padding(.bottom, 10)
                            }
                            .foregroundColor(Color("primaryColor").opacity(0.7))
                            .padding()
                            .overlay(
                                Rectangle()
                                    .stroke(Color("primaryColor").opacity(0.5) , lineWidth: 1)
                                    .shadow(radius: 4))
                            .padding(.horizontal)
                            // for overviewing the view....
                            HStack{
                                Button(action: {
                                    if(!self.email.isEmpty && !self.pass.isEmpty){
                                        loginViewModel().login(email: self.email, password: self.pass , platform : nomalPlatformCode){ result in
                                            if(!result.errorCheck){
                                                self.loginBool = false
                                            }else{
                                                alertManager().alertView(title: "로그인", reason: result.networkErrorReason!)
                                            }
                                        }
                                    }
                                }) {
                                    Text("로그인")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("primaryColor"))
                                        .padding(.vertical)
                                        .padding(.horizontal)
                                        .frame(width: UIScreen.main.bounds.width - 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .background(LinearGradient(gradient: .init(colors: [Color.gray,Color.gray]), startPoint: .leading, endPoint: .trailing))
                                        .cornerRadius(5)
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal)
                            
                            //로그인을 나누는공간
                            HStack{
                                Rectangle()
                                    .fill(Color("primaryColor").opacity(0.2))
                                    .frame(height: 5)
                                Text("Social Login")
                                    .foregroundColor(Color("primaryColor").opacity(0.7))
                                    .fontWeight(.bold)
                                Rectangle()
                                    .fill(Color("primaryColor").opacity(0.2))
                                    .frame(height: 5)
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .padding(.top)
                            
                            //social login buttons...
                            NavigationLink(destination: plusRegisterView(userEmail: self.plusEmail, userID:  self.plusUserID , userNickname : self.plusUserNickname , loginBool : self.$loginBool), isActive: self.$plusRegister){
                                
                            }
                            
                            Button(action: {
                               
                                kakaoViewModel().kakaoLogin(platform : kakaoPlatformCode){
                                    //첫번째에 결과 코드가 넘어오고
                                    //오류가 난다면 2번째에 오류이유 만약 2번 로그인추가정보로 입력으로 이동해야할 경우
                                    //이곳에 이메일이 넘어오게된다
                                    //3번째 공간에는 유저의 고유 ID값이넘어오게된다.
                                    result , errorReason , userID ,userNickname in
                                    //로그인 오류
                                    if(result == 1){
                                        alertManager().alertView(title: "카카오 로그인", reason: errorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                                        //로그인 추가정보 입력으로 이동
                                    }else if(result == 2){
                                        //넘어온 값들 셋팅하고
                                        self.plusEmail = errorReason!
                                        self.plusUserID = userID!
                                        self.plusUserNickname = userNickname ?? ""
                                        //정보 추가기입 시작.
                                        self.plusRegister = true
                                        //로그인 성공
                                    }else if(result == 3){
                                        self.loginBool = false
                                    }
                                    
                                }
                            }) {
                                
                                Image("loginKakao")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 40 , height: 40)
                                
                            }
//
//                            PillButton(title: "Start Test")
//                              .frame(maxWidth: .infinity)       // << screen-wide
//                              .padding(.top)
//                            Button(action: {
//
////                                naverLoginViewModel().loginInstance!.requestThirdPartyLogin()
////
////
//
//
//                            }) {
//                                Image("loginFacebook")
//                                    .resizable()
//
//                                    .frame(width: UIScreen.main.bounds.width - 30 , height : 40)
//
//                            }
                            
//                            Button(action: {
//                                let loginConn = NaverThirdPartyLoginConnection.getSharedInstance()
//                           
//                                 loginConn?.requestDeleteToken()
////
//                            }) {
//                                Image("loginKakao")
//                                    .resizable()
//                                    .foregroundColor(.white)
//                                    .frame(width: UIScreen.main.bounds.width - 40)
//                                
//                            }
                            
                            Spacer()
                        }
                        
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    }
                    // moving view up...
                    .padding(.bottom, self.height)
                    .background(Color.black.opacity(0.03).edgesIgnoringSafeArea(.all))
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        //키보드가 올라온것을감지하고
                        //그 높이만큼 스크롤뷰를 추가한다.
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (not) in
                            
                            let data = not.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                            
                            let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
                            
                            self.height = height
                        }
                        //사라진다면 높이는 0
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (_) in
                            self.height = 0
                        }
                    }
                    //회원가입이 시작할경우 회원가입 툴이 나옵니다.
                    .fullScreenCover(isPresented: self.$register, content: {
                        registerView(register: self.$register)
                    })
                }
                
                
                
            }
            .navigationBarHidden(true)
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            //한번클릭했을때 키보드창이떠있으면 없애주는코드
            UIApplication.shared.windows.first?.endEditing(true)
            
        })
    }
    
   
}



struct plusRegisterView : View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    
    
    let userEmail : String
    let userID : String
    @State var userNickname : String
    @State var height : CGFloat = 0
    
    @State var nicknameCheck : Bool = false
    @State var networking : Bool = false
    @Binding var loginBool : Bool
    
    @State var selected : Int = 0
    @State var register : Bool = true
    var body: some View {
        ZStack{
            if(self.selected == 0){
                agreeCheckView(selected: self.$selected, register: self.$register)
            }else{
                VStack(alignment: .leading, spacing : 0){
                    HStack{
                        Spacer()
                        Text("회원가입")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.top,5)
                    devideLineView(height : 1)
                    VStack(alignment: .leading, spacing : 15){
                        Text("닉네임을 입력하세요")
                            .font(.headline)
                            .padding(.top , 10)
                        
                        TextField("닉네임을 입력해주세요", text: self.$userNickname , onCommit : {
                            if(self.userNickname != "" && !self.networking && signUPViewModel().nicknameCkeck(mynickname: self.userNickname)){
                                self.networking = true
                                kakaoViewModel().registerTryKakao(email: self.userEmail, password: self.userID, nickname: self.userNickname){
                                    result in
                                    if(!result.errorCheck){
                                        mode.wrappedValue.dismiss()
                                    }else{
                                        alertManager().alertView(title: "카카오 로그인 오류", reason: result.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                                    }
                                    self.networking = false
                                    self.loginBool = false
                                }
                            }else{
                                withAnimation(.easeIn(duration: 0.5)){
                                    self.nicknameCheck = true
                                }
                            }
                        })
                        .background(Color("primaryColor").opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.nicknameCheck ? Color.red.opacity(1) : Color.red.opacity(0))
                                .shadow(radius: 10)
                        )
                        .textFieldStyle(customFieldStyle())
                        
                        if self.nicknameCheck{
                            HStack{
                                Text("닉네임을 확인해주세요")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Button(action: {
                            if(self.userNickname != "" && !self.networking && signUPViewModel().nicknameCkeck(mynickname: self.userNickname)){
                                self.networking = true
                                kakaoViewModel().registerTryKakao(email: self.userEmail, password: self.userID, nickname: self.userNickname){
                                    result in
                                    if(!result.errorCheck){
                                        mode.wrappedValue.dismiss()
                                    }else{
                                        alertManager().alertView(title: "카카오 로그인 오류", reason: result.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                                    }
                                    self.networking = false
                                    self.loginBool = false
                                }
                            }else{
                                withAnimation(.easeIn(duration: 0.5)){
                                    self.nicknameCheck = true
                                }
                            }
                        }){
                            HStack{
                                Spacer()
                                Text("가입")
                                    .font(.headline)
                                Spacer()
                            }
                            .foregroundColor(Color("primaryColorReverse"))
                            .padding(.vertical,10)
                            .background(Color("primaryColor").opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        Button(action: {
                            mode.wrappedValue.dismiss()
                        }){
                            HStack{
                                Spacer()
                                Text("취소")
                                    .font(.headline)
                                    .foregroundColor(Color("primaryColorReverse"))
                                Spacer()
                            }
                            .padding(.vertical,10)
                            .background(Color("primaryColor").opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                    }
                    .padding(15)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: self.register){ value in
            if(!value){
                mode.wrappedValue.dismiss()
            }
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            //한번클릭했을때 키보드창이떠있으면 없애주는코드
            UIApplication.shared.windows.first?.endEditing(true)
            
        })
        
    }
    
    
    
}

