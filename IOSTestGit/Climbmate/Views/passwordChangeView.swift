//
//  passGetView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/29.
//

import SwiftUI

struct passwordChangeView: View {
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    
    @State var height : CGFloat = 0
    @State var pass : String = ""
    @State var passCheck : String = ""
    @State var passwordRegCheck : Bool = true
    @State var passwordCheck : Bool = true
    @State var networking : Bool = false
    
    var body: some View {
        ZStack{
            
            
            VStack(alignment: .leading, spacing : 0){
                
                
                HStack{
                    Spacer()
                    Text("비밀번호 변경하기")
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                
                
                .padding(.top,5)
                devideLineView(height : 1)
                VStack(alignment: .leading, spacing : 15){
                    HStack{
                        
                        Text("비밀번호는 8자 이상 문자 + 숫자 + 특수문자 조합 필수")
                            .font(.system(size: 13))
                        Spacer()
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
                      
                        if(!self.passwordRegCheck){
                            HStack{
                                Spacer()
                                Text("비밀번호를 형식을 확인해 주세요")
                                    .foregroundColor(.red)
                            }
                        }
                    }  .padding(.top, 20)
                    VStack{
                        SecureField("비밀번호 확인", text: self.$passCheck , onCommit : {
                            if(self.pass != "" && !self.networking && signUPViewModel().passwordCheck(mypassword: self.pass) && self.pass == self.passCheck){
                                self.networking = true
                                passwordChangeViewModel().passwordChange(password: self.pass){
                                    result in
                                    if(result.errorCheck){
                                        alertManager().alertView(title: "비밀번호", reason: result.networkErrorReason ?? "알수없음")
                                    }else{
                                        mode.wrappedValue.dismiss()
                                    }
                                    self.networking = false
                                }
                            }
                        })
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
                        
                    }.padding(.top, 20)

                    Button(action: {
                        if(self.pass != "" && !self.networking && signUPViewModel().passwordCheck(mypassword: self.pass) && self.pass == self.passCheck){
                            self.networking = true
                            passwordChangeViewModel().passwordChange(password: self.pass){
                                result in
                                if(result.errorCheck){
                                    alertManager().alertView(title: "비밀번호", reason: result.networkErrorReason ?? "알수없음")
                                }else{
                                    mode.wrappedValue.dismiss()
                                }
                                self.networking = false
                            }
                        }
                    }){
                        HStack{
                            Spacer()
                            Text("변경")
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
        
        .navigationBarHidden(true)
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            //한번클릭했을때 키보드창이떠있으면 없애주는코드
            UIApplication.shared.windows.first?.endEditing(true)
            
        })
        
    }
}


struct passwordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        passwordChangeView()
    }
}
