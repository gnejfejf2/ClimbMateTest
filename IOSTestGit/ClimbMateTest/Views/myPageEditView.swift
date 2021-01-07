//
//  mypageEditView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct myPageEditView: View {
    
    //뷰의 모드 자체를 가져온다.
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var keywordWidth : CGFloat = UIScreen.main.bounds.width / 5
    @State var contentWidth : CGFloat = UIScreen.main.bounds.width / 2
    @State var contentheight : CGFloat = UIScreen.main.bounds.height / 20
    @State var fontSize : CGFloat = UIScreen.main.nativeScale * 7
    @State var height : CGFloat = 0
    
    //유저의 닉네임을 저장할공간
    @State var nickName : String = userData().returnUserData(index: 4) ?? "알 수 없음"
    //유저의 비밀번호를 저장하는 공간
    @State var pass : String = ""
    //유저가 비밀번호를 변경을 눌렀을 경우 true가 되며 텍스트 필드가 뛰어진다.
    @State var passChanger : Bool = false
    //비밀번호 정규식을 체크하는 공간
    @State var passwordRegCheck : Bool = false
    //유저 이메일동의를 체크하는 값
    @State var mailCheck : Bool = false
    //유저 SMS동의를 체크하는 값
    @State var SMSCheck : Bool = false
    //서버에 저장되어있는 이미지 URL값을 담아놓는 스트링값 최초에는 유저의 URL값을 저장하지만
    //추후에 유저가 이미지를 선택할경우 해당 이미지가 서버에 정상적으로 올라갔을경우
    //등록된 URL을 저장
    @State var imageURL : String = userData().returnUserData(index: 10) ?? ""
    //이미지피커를 하는값
    @State var shown : Bool  = false
    //이미지를 저장할 기본공간 nil값을 어떻게 만드는지 몰라 일단 가벼운이미지를 담아노았다.
    @State var image : UIImage = UIImage(systemName: "house")!
    //이미지를 변경하였는지 체크하는값
    @State var imageChange : Bool = false
    //해당페이지에서 네트워크를 사용하고있을경우 사용한다.
    @State var imageNetwoking : Bool = false
    //앨범에서 가져온이미지데이터 우선 이데이터를 통해 UI를 그려준다.
    @State var imgData : Data = Data.init(count : 0)
    
    var body: some View{
        ZStack{
            VStack(spacing : 0){
                ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : (self.height == 0 ? .init() : .vertical), showsIndicators: false) {
                    //image가 들어가는 HStack
                    HStack{
                        Spacer()
                        Button(action: {
                            //네트워크 통신을 하지 않는 동안에만 변경할수있게해야함
                            if(!self.imageNetwoking){
                                
                                
                                if(photoManager().openSingleImagePicker()){
                                    self.shown.toggle()
                                }
                                else{
                                    //권한설정으로 이동시킨다.
                                    alertManager().settingAlert(title : staticString().staticSettingTitleReturn(index : 1), message : staticString().staticSettingMessageReturn(index : 1))
                                    
                                }
                            
                            }
                        }){
                            ZStack{
                                
                                if(self.imageURL == "" || self.imageURL == "null" && !self.imageChange){
                                    Image("1")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 8)
                                        .clipShape(Circle())
                                }
                                else if(self.imageURL != "" && !self.imageChange){
                                    WebImage(url: URL(string: self.imageURL))
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 8)
                                        .clipShape(Circle())
                                }else if(self.imageChange && imgData.count > 0){
                                    Image(uiImage: UIImage(data: self.imgData)!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 8)
                                        .clipShape(Circle())
                                }
                                
                                VStack{
                                    Spacer()
                                    Text("편집")
                                        .frame(width: UIScreen.main.bounds.width / 4)
                                        .foregroundColor(.white)
                                        .background(Color.gray.opacity(0.6))
                                }
                                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 8)
                                .clipShape(Circle())
                                
                                
                            }
                            
                            
                        }
                        .sheet(isPresented: self.$shown){
                            singleImagePicker( shown: self.$shown , imgData : self.$imgData, image : self.$image)
                        }
                        Spacer()
                    }
                    TextField("닉네임", text: self.$nickName)
                        .textFieldStyle(customTextFieldStyle())
                        .border(Color("primaryColor").opacity(0.7), width: 0.5)
                        .foregroundColor(Color("primaryColor"))
                        .frame(width: UIScreen.main.bounds.width / 3)
                    devideLineView(height: 10, topPadding: 1, bottomPadding: 0)
                    //이메일
                    HStack(){
                        Text("이메일")
                            .font(.system(size: self.fontSize))
                            .frame(width: self.keywordWidth , alignment : .leading)
                            .padding(.leading,10)
                        
                        
                        Text("\(UserDefaults.standard.string(forKey: "userEmail") ?? "알 수 없음")")
                            .font(.system(size: self.fontSize))
                        Spacer()
                    }
                    
                    .padding(5)
                    
                    if(userData().returnUserData(index : 5) == "1"){
                        HStack(){
                            Text("비밀번호")
                                .font(.system(size: self.fontSize))
                                .frame(width: self.keywordWidth , alignment : .leading)
                                .padding(.leading,10)
                            
                            if(self.passChanger){
                                SecureField("8글자 이상 영어,숫자,특수문자 포함", text: self.$pass).onChange(of: self.pass, perform: { value in
                                    if(signUPViewModel().passwordCheck(mypassword : value)){
                                        self.passwordRegCheck = false
                                    }else{
                                        self.passwordRegCheck = true
                                    }
                                    
                                })
                                .textFieldStyle(customSecureFieldStyle())
                                .frame(width : self.contentWidth ,height: self.contentheight)
                                .background(Color.gray.opacity(0.1))
                                .border(Color("primaryColor").opacity(0.2), width: 0.5)
                                
                                Button(action : {
                                    self.passChanger = false
                                    self.pass = ""
                                }){
                                    Text("취소")
                                        .foregroundColor(Color("primaryColorReverse"))
                                        .frame(width: self.keywordWidth, height: self.contentheight, alignment: .center)
                                        .background(Color.black.opacity(0.9))
                                }
                            }
                            else{
                                Text("8글자 이상 영어,숫자,특수문자 포함")
                                    .padding(.leading,10)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("primaryColor").opacity(0.3))
                                    .frame(width : self.contentWidth ,height: self.contentheight , alignment: .leading)
                                    .background(Color.gray.opacity(0.1))
                                    .border(Color("primaryColor").opacity(0.2), width: 0.5)
                                
                                Button(action : {
                                    self.passChanger = true
                                    self.pass = ""
                                }){
                                    Text("변경")
                                        .foregroundColor(Color("primaryColorReverse"))
                                        .frame(width: self.keywordWidth, height: self.contentheight, alignment: .center)
                                        .background(Color.gray.opacity(0.9))
                                }
                                
                            }
                            
                            
                            Spacer()
                        }
                        .padding(5)
                    }
                    
                    
                  
                    if(self.passwordRegCheck){
                        HStack{
                            Spacer()
                            Text("비밀번호를 형식을 확인해 주세요")
                                .font(.system(size: UIScreen.main.scale * 7))
                                .foregroundColor(.red)
                                .padding(.horizontal)
                            
                        }
                    }
                    // 개인정보 마무리
                    
                    
                    //마케팅관련 푸시알람 관련 시작
                    maketingView(mailCheck: self.$mailCheck, SMSCheck: self.$SMSCheck)
                    
                    //
                    
                    HStack{
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button(action: {
                            self.imageNetwoking = true
                            //유저가 가입한플랫폼이 카카오톡일경우 카카오로그인자체도 로그아웃 처리해주어야함
                            if(userData().returnUserData(index: 5) == "2"){
                                kakaoViewModel().kakaoLogout()
                            }

                            //클라이메이트서버 로그아웃처리하는 처리
                            myPageEditViewModel().logout(){
                                result in
                                if(result.errorCheck){
                                    //현재화면에서 뒤로가게처리한후
                                    mode.wrappedValue.dismiss()
                                    //저장소에 저장되어있는 유저정보를 삭제한다.
                                    userData().userInformationClear()
                                }else{
                                    alertManager().alertView(title: "로그아웃 실패", reason: result.networkErrorReason ?? "알 수 없음")
                                }
                            }
                        }){
                            Text("로그아웃")
                                .foregroundColor(Color("primaryColor").opacity(0.3))
                                .font(.system(size: self.fontSize / 2))
                                .underline()
                        }
                        
                        
                        Button(action : {
                            
                            self.imageNetwoking = true
                            //유저가 로그인한 플랫폼이 자체로그인일경우
                            //클라이메이트 서버 자체 회원탈퇴를 진행할 수 있는 알람창을 뛰어준다.
                            if(userData().returnUserData(index: 5) == "1"){
                                alertManager().userQuitAlert(){
                                    result in
                                    if(result.errorCheck){
                                        //취소라고 넘어온경우 단순히 취소버튼을 누른거라 알람을 뛰어주지않아도되서 예외처리
                                        if(result.networkErrorReason != "취소"){
                                            alertManager().alertView(title: "회원탈퇴", reason: result.networkErrorReason ?? "알 수. 없음")
                                        }
                                        self.imageNetwoking = false
                                    }else{
                                        self.imageNetwoking = false
                                        mode.wrappedValue.dismiss()
                                        userData().userInformationClear()
                                        alertManager().alertView(title: "회원탈퇴", reason: "회원탈퇴 되었습니다.")
                                    }
                                }
                            
                            }
                            else if (userData().returnUserData(index: 5) == "2"){
                                alertManager().userQuitKakaoAlert(){
                                    result in
                                    if(result.errorCheck){
                                        //취소라고 넘어온경우 단순히 취소버튼을 누른거라 알람을 뛰어주지않아도되서 예외처리
                                        if(result.networkErrorReason != "취소"){
                                            alertManager().alertView(title: "회원탈퇴", reason: result.networkErrorReason ?? "알 수. 없음")
                                        }
                                        self.imageNetwoking = false
                                    }else{
                                        self.imageNetwoking = false
                                        mode.wrappedValue.dismiss()
                                        userData().userInformationClear()
                                        alertManager().alertView(title: "회원탈퇴", reason: "회원탈퇴 되었습니다.")
                                    }
                                }
                            }
                             
                            
                            
                        }){
                            Text("회원탈퇴")
                                .font(.system(size: self.fontSize / 2))
                                .foregroundColor(Color("primaryColor").opacity(0.3))
                                .underline()
                        }
                        
                       
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .onChange(of: self.image){ image in
                self.imageNetwoking = true
                
                DispatchQueue.main.asyncAfter(deadline: staticString().delayTime[0]) {
                    imageManager().uploadSingleImage(urlIndex : 0 ,paramName: "userProfileImage", fileName: "userProfile.jpg", image: image){
                        url , error in
                        if(error.errorCheck){
                            alertManager().alertView(title: "통신오류", reason: error.networkErrorReason ?? "이미지 업로드에 실패하였습니다.")
                        }else{
                            self.imageURL = url!
                           self.imageChange = true
                        }
                        
                        withAnimation(.easeOut(duration: 0.3)){
                            self.imageNetwoking = false
                        }
                       
                    }
                }
            }
            .navigationBarTitle(Text("내 정보 수정"), displayMode: .inline)
            .navigationBarItems(trailing:titleItemView(imageURL : self.$imageURL , imageChange : self.$imageChange , imageNetwoking : self.$imageNetwoking , nickName : self.$nickName , userPass : self.$pass , passwordRegCheck : self.$passwordRegCheck , passChanger : self.$passChanger))
            .padding(.top,10)
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
            
        
            
            if self.imageNetwoking{
                VStack{
                    
                    Spacer()
                    loadingView()
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .background(Color.black.opacity(0.3))
            }
 
        }
        .onAppear(){
            
            
            self.imageURL = userData().returnUserData(index: 10) ?? ""
            self.nickName = userData().returnUserData(index: 4) ?? "알 수 없음"
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            //한번클릭했을때 키보드창이떠있으면 없애주는코드
            UIApplication.shared.windows.first?.endEditing(true)
            
        })
    }
}


struct maketingView : View {
    
    var fontSize : CGFloat = (UIScreen.main.scale * 8)
    
    
    @Binding var mailCheck : Bool
    
    @Binding var SMSCheck : Bool
    
    
    var body: some View{
        devideLineView(height: 1, topPadding: 15, bottomPadding: 15)
        
        HStack{
            Text("마케팅 정보 수신 동의")
                .font(.system(size: self.fontSize))
                .frame(alignment : .leading)
                .padding(.leading,10)
            Spacer()
            
        }
        
        HStack{
            Text("이벤트 및 혜택에 대한 다양한 정보를 받으실 수 있어요")
                .font(.system(size: self.fontSize - 4))
                .foregroundColor(Color("primaryColor").opacity(0.3))
                .frame(alignment : .leading)
                .padding(.leading,10)
            Spacer()
        }
        .padding(.top,1)
        
        
        VStack {
            
//
//            Toggle(isOn: $mailCheck.didSet { (state) in
//                if(state){
//
//                    let time = Date()
//                    let timeFormatter = DateFormatter()
//                    timeFormatter.dateFormat = "YYYY-MM-dd HH:mm"
//                    let stringDate = timeFormatter.string(from: time)
//
//
//                    alertManager().alertLeftAlignmentView(title: "메일 수신동의", reason: "전송자 : 클라이메이트 \n메일 수신동의 일시 : \(stringDate)\n처리내용 : 수신동의 처리완료")
//                }else{
//
//                }
//
//
//            }) {
//                Text("메일 수신동의")
//                    .fontWeight(.thin)
//                    .foregroundColor(Color("primaryColor"))
//            }
//            .padding(10)
//            .frame(width: UIScreen.main.bounds.width)
//
//
            
            
            Toggle(isOn: $SMSCheck.didSet { (state) in
               
                    //클릭하면 무조건 노티의 상태를 체크하여 노티를 허락 거부 여부에따라 토글 스위치의 방향을 작동하도록하고
                    //클릭하면 무조건 설정창으로 넘긴다
                    //아이폰은 코드자체적으로 우리가 어떻게 변경할수가없기때문에
                    //무조건 설정창으로 넘겨야한다
                
                if(state){
                    notiManager().noticheck(){
                        result in
                        self.SMSCheck = result
                      
                    }
                    alertManager().settingAlert(title : staticString().staticSettingTitleReturn(index : 2), message : staticString().staticSettingMessageReturn(index : 2))
                }else{
                    notiManager().noticheck(){
                        result in
                        self.SMSCheck = result
                      
                    }
                    alertManager().settingAlert(title : staticString().staticSettingTitleReturn(index : 3), message : staticString().staticSettingMessageReturn(index : 3))
                }
            }) {
                Text("SMS 수신동의")
                    .fontWeight(.thin)
                    .foregroundColor(Color("primaryColor"))
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width)
            .onAppear(){
                
                notiManager().noticheck(){
                    result in
                    self.SMSCheck = result
                    
                }
            }
            
        }
        
    }
}



struct titleItemView : View {
    @Binding var imageURL : String
    
    @Binding var imageChange : Bool
    
    @Binding var imageNetwoking : Bool
    
    @Binding var nickName : String
    
    @Binding var userPass : String
    
    @Binding var passwordRegCheck : Bool
    
    @Binding var passChanger : Bool
    var body : some View{
        Button(action: {
            mypageEditCheck(imageURL: self.$imageURL, imageChange: self.$imageChange, imageNetwoking: self.$imageNetwoking, nickName: self.$nickName, userPass: self.$userPass, passwordRegCheck: self.$passwordRegCheck , passChanger : self.$passChanger).editCheck()
        }, label: {
            Text("저장")
                .foregroundColor(Color("primaryColor"))
        })
    }
    
    
}


//택스트필드를 컨트롤하기위해 만들어짐
public struct customTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal,10)
            .padding(.vertical,5)
        
    }
}

//택스트필드를 컨트롤하기위해 만들어짐
public struct customSecureFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: UIScreen.main.scale * 5))
            .padding(.horizontal,10)
            .padding(.vertical,5)
        
    }
}






struct myPageEditView_Previews: PreviewProvider {
    static var previews: some View {
        myPageEditView()
    }
}
