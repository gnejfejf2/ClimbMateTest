//
//  loginView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/16.
//

import SwiftUI



struct registerView : View{
    @State var selected : Int = 0
    @Binding var register : Bool
    
    var body: some View{
        ZStack{
            if(self.selected == 0){
                agreeCheckView(selected: self.$selected, register: self.$register)
                
            }else if(self.selected == 1){
                registerFormView(register: self.$register)
            }
            
            
        }.onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            //한번클릭했을때 키보드창이떠있으면 없애주는코드
            UIApplication.shared.windows.first?.endEditing(true)
            
        })
    }
}

struct agreeCheckView : View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selected : Int
    @Binding var register : Bool
    
    let checkBoxSize : CGFloat = UIScreen.main.scale*10
    
    
   
    @State var allCheck : Bool = false
    //이용약관 체크
    @State var ToSCheck : Bool = false
    //개인정보 수집 및 이용 동의
    @State var privacyCheck : Bool = false
    //위치정보 이용약관 동의
    @State var placeCheck : Bool = false
    //프로모션 정보 수신 동의
    @State var promotionCheck : Bool = false
    //이용약관 개인정보 수집및이용동의를 체크안하고 확인버튼을 누를시 false로 변환
    @State var agreeCheck : Bool = true
    var body: some View{
        ZStack{
            NavigationView{
                VStack(spacing : 20){
                    Spacer()
                    Image(colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                    VStack(alignment: .leading){
                        
                        HStack{
                            Button(action: {
                                
                                //전체약관동의 같은경우 체크할경우 모든 약관을 동의로 변경해주어야하고
                                //해제할경우 모든 약관을 해제해야함
                                
                                if(self.allCheck){
                                    self.allCheck.toggle()
                                    
                                    if(self.ToSCheck){
                                        self.ToSCheck.toggle()
                                    }
                                    if(self.privacyCheck){
                                        self.privacyCheck.toggle()
                                    }
//                                    if(self.placeCheck){
//                                        self.placeCheck.toggle()
//                                    }
//                                    if(self.promotionCheck){
//                                        self.promotionCheck.toggle()
//                                    }
                                    
                                }else{
                                    self.allCheck.toggle()
                                    
                                    if(!self.ToSCheck){
                                        self.ToSCheck.toggle()
                                    }
                                    if(!self.privacyCheck){
                                        self.privacyCheck.toggle()
                                    }
//                                    if(!self.placeCheck){
//                                        self.placeCheck.toggle()
//                                    }
//                                    if(!self.promotionCheck){
//                                        self.promotionCheck.toggle()
//                                    }
                                }
                            }, label: {
                                checkBoxView(size: checkBoxSize , isMarked: self.$allCheck)
                            })
                            Spacer()
                                .frame(width: 10)
                            Text("클라이메이트 이용약관 , 개인정보 수집 및 이용, 위치정보 이용약관(선택), 프로모션 정보 수신(선택)에 모두 동의 합니다.")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                        }
                        Spacer()
                            .frame(height: 30)
                        HStack{
                            Button(action: {
                                // 전체약관동의 같은경우 하나라도 체크가 되어있지 않다면 전체동의가 아니기 때문에 취소로 변경해주어야함
                                if(self.allCheck){
                                    self.allCheck.toggle()
                                    self.ToSCheck.toggle()
                                }
                                else{
                                    self.ToSCheck.toggle()
                                    if(self.ToSCheck && self.privacyCheck && self.placeCheck && self.promotionCheck){
                                        self.allCheck.toggle()
                                    }
                                }
                                
                            }, label: {
                                checkBoxView(size: checkBoxSize , isMarked: self.$ToSCheck)
                            })
                            Spacer()
                                .frame(width: 10)
                            Text("클라이 메이트 이용약관 동의")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            Text("(필수)")
                               
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                          
                            Spacer()
                            
                            NavigationLink(destination: webViewModel(urlToLoad: "https://climbmate.co.kr/policy?category=use&client=iOS")){
                                Text("약관보기")
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primaryColor"))
                            }
                            
                            Spacer()
                                .frame(width: 10)
                            
                            
                        }
                        Spacer()
                            .frame(height: 30)
                        HStack{
                            Button(action: {
                                if(self.allCheck){
                                    self.allCheck.toggle()
                                    self.privacyCheck.toggle()
                                }
                                else{
                                    self.privacyCheck.toggle()
                                    if(self.ToSCheck && self.privacyCheck && self.placeCheck && self.promotionCheck){
                                        self.allCheck.toggle()
                                    }
                                }
                                
                            }, label: {
                                checkBoxView(size: checkBoxSize , isMarked: self.$privacyCheck)
                            })
                            Spacer()
                                .frame(width: 10)
                            Text("개인정보 수집 및 이용 동의")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            Text("(필수)")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            
                            Spacer()
                            NavigationLink(destination: webViewModel(urlToLoad: "https://climbmate.co.kr/policy?category=private&client=iOS")){
                                Text("약관보기")
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primaryColor"))
                            }
                            
                            Spacer()
                                .frame(width: 10)
                            
                        }
                        Spacer()
                            .frame(height: 30)
//                        HStack{
//                            Button(action: {
//                                // 전체약관동의 같은경우 하나라도 체크가 되어있지 않다면 전체동의가 아니기 때문에 취소로 변경해주어야함
//                                if(self.allCheck){
//                                    self.allCheck.toggle()
//                                    self.placeCheck.toggle()
//                                }
//                                else{
//                                    self.placeCheck.toggle()
//                                    if(self.ToSCheck && self.privacyCheck && self.placeCheck && self.promotionCheck){
//                                        self.allCheck.toggle()
//                                    }
//                                }
//
//                            }, label: {
//                                checkBoxView(size: checkBoxSize , isMarked: self.$placeCheck)
//                            })
//                            Spacer()
//                                .frame(width: 10)
//                            Text("위치정보 이용약관 동의")
//                                .font(.system(size: 15))
//                                .fontWeight(.semibold)
//
//                            Text("(선택)")
//                                .font(.system(size: 13))
//                                .fontWeight(.semibold)
//                                .foregroundColor(.gray)
//
//                            Spacer()
//
//
//                            NavigationLink(destination: webViewModel(urlToLoad: "https://www.naver.com").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)){
//                                Text("약관보기")
//                                    .font(.system(size: 13))
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.black)
//                            }
//
//
//                            Spacer()
//                                .frame(width: 10)
//
//                        }
//                        Spacer()
//                            .frame(height: 30)
//                        HStack{
//                            Button(action: {
//                                // 전체약관동의 같은경우 하나라도 체크가 되어있지 않다면 전체동의가 아니기 때문에 취소로 변경해주어야함
//                                if(self.allCheck){
//                                    self.allCheck.toggle()
//                                    self.promotionCheck.toggle()
//                                }
//                                else{
//                                    self.promotionCheck.toggle()
//                                    if(self.ToSCheck && self.privacyCheck && self.placeCheck && self.promotionCheck){
//
//                                        self.allCheck.toggle()
//                                    }
//
//                                }
//                            }, label: {
//                                checkBoxView(size: checkBoxSize , isMarked: self.$promotionCheck)
//                            })
//                            Spacer()
//                                .frame(width: 10)
//                            Text("프로모션 정보 수신 동의")
//                                .font(.system(size: 15))
//                                .fontWeight(.semibold)
//                            Text("(선택)")
//                                .font(.system(size: 13))
//                                .fontWeight(.semibold)
//                                .foregroundColor(.gray)
//
//                            Spacer()
//
//                            NavigationLink(destination: webViewModel(urlToLoad: "https://www.naver.com").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)){
//                                Text("약관보기")
//                                    .font(.system(size: 13))
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.black)
//                            }
//
//                            Spacer()
//                                .frame(width: 10)
//
//
//                        }
//
                        
                    }
                    .foregroundColor(Color("primaryColor").opacity(0.7))
                    .padding()
                    .background(Color("primaryColorReverse"))
                    .overlay(Rectangle().stroke(Color("primaryColor").opacity(0.03), lineWidth: 1).shadow(radius: 4))
                    .padding(.horizontal)
                    
                    
                    Spacer()
                    
                    if(!self.agreeCheck){
                        Text("서비스이용 동의 , 개인정보 동의를 체크해주세요")
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    
                    
                    HStack{
                        Button(action: {
                            self.register.toggle()
                        }){
                            Text("취소")
                                .font(.system(size: 33))
                                .foregroundColor(.white)
                                .frame(width: (UIScreen.main.bounds.width/2) - 40)
                                
                                .background(Color.gray.opacity(0.4))
                                .overlay(Rectangle().stroke(Color.black, lineWidth: 0))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            if(!self.ToSCheck || !self.privacyCheck){
                                
                                self.agreeCheck=false
                            }else{
                                self.selected = 1
                            }
                            
                            
                        }){
                            Text("확인")
                                .font(.system(size: 33))
                                .foregroundColor(.white)
                                .frame(width: (UIScreen.main.bounds.width/2) - 40)
                                .overlay(Rectangle().stroke(Color.black, lineWidth: 0))
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .navigationBarHidden(true)
            }
            
        }
        .background(Color.black.opacity(0.03)
        .edgesIgnoringSafeArea(.all))
        .padding(.top,10)
        
    }
}







struct registerFormView : View {
    @Environment(\.colorScheme) var colorScheme
    @State var email = ""
    @State var emailCertification = ""
    @State var pass = ""
    @State var passCheck = ""
    @State var nickname = ""
    
    
    @State var rem = false
    @State var height : CGFloat = 0
    @State private var isEmailValid : Bool   = true
    
    @Binding var register : Bool
    
    //통신중 상태 체크
    @State var networkingCheck : Bool = false
    
    //이메일체크
    @State var emailCheck : Bool = true
    //이메일 인증 시작 체크
    @State var emailCertificationStart : Bool = false
    //이메일 인증체크
    @State var emailCertificationCheck : Bool = true
    //이메일 인증시 이메일을 비워두거나, 형식에 맞지않는 정규식을 이용했을 경우 text창을 띄어주기위해
    @State var emailCertificationRegCheck : Bool = true
    //패스워드 정규식체크
    @State var passwordRegCheck : Bool = true
    //패스워드 일치 체크
    @State var passwordCheck : Bool = true
    //닉네임체크
    @State var nicknameCheck : Bool = true
    
    
    
    var body: some View{
        ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : (self.height == 0 ? .init() : .vertical), showsIndicators: false) {
            ZStack{
                
                VStack(spacing : 20){
                    Spacer()
                    Image(colorScheme == .light ? "mainLogo" : "mainLogoReverse")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                    VStack(alignment: .leading){
                        VStack{
                            HStack{
                                TextField("climbmate@climbmate.com", text: self.$email)
                                    .onChange(of: self.email, perform: { value in
                                        if(!signUPViewModel().textFieldValidatorEmail( string : self.email)){
                                            
                                            
                                            self.emailCheck = false
                                        }
                                        else{
                                            self.emailCheck = true
                                        }
                                    })
                                //이메일 최초인증시에는 인증이라고나오고 인증이 이미 진행중일경우 재전송으로 변경
                                if(!self.emailCertificationStart){
                                    Button(action : {
                                        if(self.networkingCheck){
                                            alertManager().alertView(title : "오류" , reason : "메일 인증이 진행중입니다.")
                                        }else{
                                            //이메일 체크가 진행중이고 이메일을 적는공간이 null이 아닌경우
                                            //이메일전송을 시작한다.
                                            if(self.emailCheck && self.email != ""){
                                                self.networkingCheck = true
                                                signUPViewModel().emailCertification(email : self.email){
                                                    result in
                                                  
                                                    if(!result.errorCheck){
                                                        withAnimation(.easeIn(duration: 0.5)){
                                                            self.emailCertificationStart = true
                                                        }
                                                        self.networkingCheck = false
                                                        
                                                    }
                                                    else{
                                                        alertManager().alertView(title: "메일전송 실패", reason: result.networkErrorReason ?? "알 수 없음")
                                                        self.networkingCheck = false
                                                    }
                                                }
                                            }
                                            else{
                                                self.emailCheck = false
                                            }
                                        }
                                    }){
                                        Text("인증")
                                            .padding(.horizontal,10)
                                            .padding(.vertical,5)
                                            .overlay(Rectangle().stroke(Color.black.opacity(0.9), lineWidth: 1).shadow(radius: 15))
                                    }
                                }
                                else{
                                    Button(action : {
                                        if(self.networkingCheck){
                                            alertManager().alertView(title : "오류" , reason : "메일 인증이 진행중입니다.")
                                        }else{
                                            if(self.emailCheck && self.email != "이메일 인증"){
                                                self.networkingCheck = true
                                                signUPViewModel().emailCertificationRetry(email : self.email){
                                                    result in
                                                    if(!result.errorCheck){
                                                        alertManager().alertView(title: "", reason: "이메일 재전송이 완료되었습니다.")
                                                        self.networkingCheck = false
                                                    }
                                                    else{
                                                        alertManager().alertView(title: "메일전송 실패", reason: result.networkErrorReason ?? "알 수 없음")
                                                        self.networkingCheck = false
                                                    }
                                                }
                                            }
                                            else{
                                                self.emailCheck = false
                                            }
                                        }
                                    }){
                                        Text("재전송")
                                            .padding(.horizontal,10)
                                            .padding(.vertical,5)
                                            .overlay(Rectangle().stroke(Color.black.opacity(0.9), lineWidth: 1).shadow(radius: 15))
                                    }
                                }
                                
                            }
                            if(self.email == ""){
                                Rectangle()
                                    .fill(Color.black.opacity(0.08))
                                    .frame(height: 3)
                            }
                            else{
                                Rectangle()
                                    .fill(self.emailCheck ? Color.blue.opacity(0.7) : Color.red)
                                    .frame(height: 3)
                            }
                            if(!self.emailCheck){
                                HStack{
                                    Spacer()
                                    Text("이메일을 확인해 주세요.")
                                        .foregroundColor(.red)
                                }
                            }
                        }.padding(.top,10)
                        
                        //이메일인증을 시작했을때만 UI에 나오게
                        if(self.emailCertificationStart){
                            VStack{
                                HStack{
                                    Spacer()
                                    Text("메일이 전송되었습니다. 메일을 확인해주세요.")
                                        .font(.system(size: 13))
                                        .foregroundColor(.red)
                                }

                                HStack{
                                    TextField("인증번호", text: self.$emailCertification)
                                       
                                    Button(action : {
                                        if(self.emailCertification != "" &&  self.emailCertification.count == 6){
                                            signUPViewModel().certificationEmailCheck(email : self.email , code : self.emailCertification){
                                                result in
                                                if(!result.errorCheck){
                                                    self.emailCertificationCheck = true
                                                    alertManager().alertView(title : "인증성공" , reason : "이메일 인증이 되었습니다.")
                                                }else{
                                                    alertManager().alertView(title: "인증실패", reason: result.networkErrorReason ?? "알 수 없음")
                                                }
                                            }
                                        }
                                        else{
                                            alertManager().alertView(title : "인증번호 오류" , reason : "인증번호를 확인해주세요")
                                        }
                                    }){
                                        Text("확인")
                                            .padding(.horizontal,10)
                                            .padding(.vertical,5)
                                            .overlay(Rectangle().stroke(Color.black.opacity(0.9), lineWidth: 1).shadow(radius: 15))
                                    }
                                }
                                if(self.emailCertification == ""){
                                    Rectangle()
                                        .fill(Color.black.opacity(0.08))
                                        .frame(height: 3)
                                }
                                else{
                                    Rectangle()
                                        .fill(self.emailCertificationCheck ? Color.blue.opacity(0.7) : Color.red)
                                        .frame(height: 3)
                                }
                                if(!self.emailCertificationRegCheck){
                                    HStack{
                                        Spacer()
                                        Text("이메일을 확인해 주세요.")
                                            .foregroundColor(.red)
                                    }
                                }
                            }.padding(.top,10)
                        }

                        VStack{
                            SecureField("비밀번호", text: self.$pass)
                                .textContentType(.password)
                                .onChange(of: self.pass, perform: { value in
                                if(!signUPViewModel().passwordCheck(mypassword : value)){
                                    self.passwordRegCheck = false
                                }else{
                                    withAnimation(.easeIn(duration: 0.5)){
                                        self.passwordRegCheck = true
                                    }
                                    
                                }
                                
                                if(value != self.passCheck && self.passCheck != ""){
                                    self.passwordCheck = false
                                }else{
                                    self.passwordCheck = true
                                }
                            })
                            if(self.pass == ""){
                                Rectangle()
                                    .fill(Color.black.opacity(0.08))
                                    .frame(height: 3)
                            }
                            else{
                                Rectangle()
                                    .fill(self.passwordRegCheck ? Color.blue.opacity(0.7) : Color.red)
                                    .frame(height: 3)
                            }
                            HStack{
                                Spacer()
                                Text("비밀번호는 8자 이상 문자 + 숫자 + 특수문자 조합 필수")
                                    .font(.system(size: 13))
                            }
                            if(!self.passwordRegCheck){
                                HStack{
                                    Spacer()
                                    Text("비밀번호를 형식을 확인해 주세요")
                                        .foregroundColor(.red)
                                }
                            }
                        }  .padding(.top, 20)
                        VStack{
                            SecureField("비밀번호 확인", text: self.$passCheck)
                                .textContentType(.password)
                                .onChange(of: self.passCheck, perform: { value in
                                    if(value != self.pass){
                                        self.passwordCheck = false
                                    }else{
                                        self.passwordCheck = true
                                    }
                                })
                            if(self.passCheck == ""){
                                Rectangle()
                                    .fill(Color.black.opacity(0.08))
                                    .frame(height: 3)
                            }
                            else{
                                Rectangle()
                                    .fill(self.passwordCheck ? Color.blue.opacity(0.7) : Color.red)
                                    .frame(height: 3)
                            }
                            if(!self.passwordCheck){
                                HStack{
                                    Spacer()
                                    Text("비밀번호가 일치하지 않습니다.")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        }  .padding(.top, 20)
                        VStack{
                            TextField("닉네임", text: self.$nickname)
                                .onChange(of: self.nickname, perform: { value in
                                    
                                    
                                    if(!signUPViewModel().nicknameCkeck(mynickname: value)){
                                        self.nicknameCheck = false
                                    }else{
                                        self.nicknameCheck = true
                                    }
                                    
                                })
                            
                            if(self.nickname == ""){
                                Rectangle()
                                    .fill(Color.black.opacity(0.08))
                                    .frame(height: 3)
                            }
                            else{
                                Rectangle()
                                    .fill(self.nicknameCheck ? Color.blue.opacity(0.7) : Color.red)
                                    .frame(height: 3)
                            }
                            
                            if(!self.nicknameCheck){
                                HStack{
                                    Spacer()
                                    Text("닉네임 형식에 맞지 않습니다.")
                                        .foregroundColor(.red)
                                }
                            }
                        }.padding(.top,10)
                        
                        
                    }
                    .foregroundColor(Color("primaryColor").opacity(0.7))
                    .padding()
                    .background(Color("primaryColorReverse"))
                    .overlay(Rectangle().stroke(Color("primaryColor").opacity(0.03), lineWidth: 1).shadow(radius: 4))
                    .padding(.horizontal)
                    
                    
                    
                    // for overviewing the view....
                    
                    Spacer()
                    
                    HStack{
                        
                        Button(action: {
                            self.register.toggle()
                        }){
                            Text("취소")
                                .font(.system(size: 33))
                                .foregroundColor(.white)
                                .frame(width: (UIScreen.main.bounds.width/2) - 40)
                                
                                .background(Color.gray.opacity(0.4))
                                .overlay(Rectangle().stroke(Color.black, lineWidth: 0))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            
                            if(networkingCheck){
                                alertManager().alertView(title : "오류" , reason : "통신이 진행중입니다.")
                            }
                            else{
                                if(!self.emailCertificationCheck){
                                    alertManager().alertView(title : "메일인증" , reason : "메일인증을 진행해주세요.")
                                }
                                else if(self.emailCheck && self.email != "" && self.emailCertificationCheck && self.emailCertification != "" && self.passwordRegCheck && self.pass != ""  && self.passCheck != "" && self.passwordCheck && self.nickname != "" && self.nicknameCheck ){
                                    self.networkingCheck = true
                                    
                                    signUPViewModel().registerTry(email: self.email, password: self.pass, nickname: self.nickname , certificationCode: self.emailCertification){
                                        result in
                                        
                                        if(!result.errorCheck){
                                            self.register.toggle()
                                            self.networkingCheck = false
                                            alertManager().alertView(title: "회원가입", reason: "회원가입이 완료되었습니다.")
                                        }else{
                                            self.networkingCheck = false
                                            alertManager().alertView(title: "회원가입 실패", reason: result.networkErrorReason ?? "알 수 없음")
                                        }
                                        
                                    }
                                }
                                else{
                                    alertManager().alertView(title : "오류" , reason : "기입한 값을 확인해주세요.")
                                }
                            }
                        }){
                            Text("확인")
                                .font(.system(size: 33))
                                .foregroundColor(.white)
                                .frame(width: (UIScreen.main.bounds.width/2) - 40)
                                .overlay(Rectangle().stroke(Color.black, lineWidth: 0))
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                    
                    
                    
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                
                
                if self.networkingCheck{
                    VStack{
                        
                        Spacer()
                        loadingView()
                        
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .background(Color.black.opacity(0.3))
                }
            }
        }
        // moving view up...
        .padding(.bottom, self.height)
        .background(Color.black.opacity(0.03).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (not) in
                
                let data = not.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                
                let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
                
                self.height = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (_) in
                
                
                self.height = 0
            }
            
        }
    }
}








