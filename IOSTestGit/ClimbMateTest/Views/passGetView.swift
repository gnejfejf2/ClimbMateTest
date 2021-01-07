//
//  passGetView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/29.
//

import SwiftUI

struct passGetView: View {
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    
    @State var height : CGFloat = 0
    @State var email : String = ""
    
    @State var errorCheck : Bool = false
    
    @State var networking : Bool = false
    
    var body: some View {
        ZStack{
            
            
            VStack(alignment: .leading, spacing : 0){
                ZStack{
                    HStack(spacing : 0){
                        Button(action : {
                            mode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark")
                                .padding(.leading,20)
                        }
                        Spacer()
                    }
                    HStack(spacing : 0){
                        Spacer()
                        Text("비밀번호 찾기")
                            .font(.title)
                        Spacer()
                    }
                }
                .padding(.top,5)
                devideLineView(height : 1)
                VStack(alignment: .leading, spacing : 15){
                    Text("이메일을 입력하세요")
                        .font(.headline)
                        .padding(.top , 10)
                    
                    TextField("이메일을 입력해주세요", text: self.$email , onCommit : {
                        if(email != "" && !self.networking){
                            self.networking = true
                            passGetViewModel().passGet(email: self.email){
                                result in
                                if(result.errorCheck){
                                    withAnimation(.easeIn(duration: 0.5)){
                                        self.errorCheck = true
                                    }
                                }else{
                                    mode.wrappedValue.dismiss()
                                }
                                self.networking = false
                            }
                        }
                    })
                        .background(Color("primaryColor").opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.errorCheck ? Color.red.opacity(1) : Color.red.opacity(0))
                                .shadow(radius: 10)
                        )
                        .textFieldStyle(customFieldStyle())
                    
                    if self.errorCheck{
                        HStack{
                            Text("이메일을 확인해주세요")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {
                        if(email != "" && !self.networking){
                            self.networking = true
                            passGetViewModel().passGet(email: self.email){
                                result in
                                if(result.errorCheck){
                                    withAnimation(.easeIn(duration: 0.5)){
                                        self.errorCheck = true
                                    }
                                }else{
                                    alertManager().alertView(title: "비밀번호찾기", reason: "임시비밀번호가 이메일로 발송되었습니다.")
                                    mode.wrappedValue.dismiss()
                                }
                                self.networking = false
                            }
                        }
                    }){
                        HStack{
                            Spacer()
                            Text("찾기")
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


//택스트필드를 컨트롤하기위해 만들어짐
public struct customFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 15))
            .padding(.horizontal,10)
            .padding(.vertical,10)
        
    }
}



