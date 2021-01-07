
import SwiftUI

struct inquiryView: View {
    
    //뷰의 모드 자체를 가져온다.
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    @State var questionContent : String = ""
    @State var questionContact : String =
        userData().returnUserData(index: 2) ?? ""
    
    @State var questionContentCheck : Bool = false
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading , spacing : 10){
                Spacer()
                
                HStack{
                    
                        Text("문의 내용")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                    
                    Spacer()
                }
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(UIColor.secondarySystemBackground))
                    
                    if questionContent.isEmpty || self.questionContent == "" {
                        Text("서비스 이용 중 궁금한 내용이나 불편한 사항 \n추가되었으면 하는 기능 등 , 문의할 내용을 자유롭게 적어주세요")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $questionContent)
                        .padding(4)
                        .background(Color.clear).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("primaryColor").opacity(0.8), lineWidth: 1)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        )
                }
                .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height/3)
                .font(.body)
                
                if(self.questionContentCheck){
                    Text("문의 내용을 확인해 주세요")
                        .foregroundColor(.red)
                    
                }
                HStack{
                    Text("연락처")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                TextField("답변받을 연락처를 입력해주세요", text: self.$questionContact)
                    .textFieldStyle(inquiryFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("primaryColor").opacity(0.8), lineWidth: 1)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    )
                
                Group{
                    Text("이메일 , 휴대폰 번호 등 연락 받으실 연락처를 적어 주세요")
                        .font(.system(size: UIScreen.main.scale * 6))
                    Text("연락처를 적지 않을시 답변을 받으실 수 없습니다.")
                        .foregroundColor(.red)
                        .font(.system(size: UIScreen.main.scale * 6))
                    
                    Spacer()
                    Button(action: {
                        if(self.questionContent == "" || self.questionContent.isEmpty || !inqueryViewModel().questionContentCkeck(questionContent: self.questionContent)){
                            withAnimation(.easeIn(duration: 0.3)){
                                self.questionContentCheck = true
                            }
                        }else{
                            if(self.questionContact.isEmpty){
                                self.questionContact = "익명"
                            }
                            
                            inqueryViewModel().question(questionContent: self.questionContent, questionContact: self.questionContact){ result in
                                if(result.errorCheck){
                                    alertManager().alertView(title: "문의하기", reason: result.networkErrorReason ?? staticString().staticNilNetworkErrorReasonReturn(index: 0))
                                }else{
                                    mode.wrappedValue.dismiss()
                                    alertManager().alertView(title: "문의하기", reason: "소중한 문의 감사합니다. \n 최대한 빠른 답변을 위해 \n노력하겠습니다.")
                                }
                            }
                        }
                    }){
                        HStack{
                            Spacer()
                            Text("문의 하기")
                                .foregroundColor(Color("primaryColorReverse"))
                            Spacer()
                        }
                        .frame(height : 40)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal,10)
            .navigationBarTitle("문의하기" , displayMode: .inline)
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                UIApplication.shared.windows.first?.endEditing(true)
            })
            
        }
    }
}
public struct inquiryFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: UIScreen.main.scale * 5))
            .padding(.horizontal,10)
            .padding(.vertical,5)
        
    }
}


struct inquiryView_Previews: PreviewProvider {
    static var previews: some View {
        inquiryView()
    }
}
