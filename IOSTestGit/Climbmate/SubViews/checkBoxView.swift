import SwiftUI

//MARK:- Checkbox Field
//회원가입에서 사용하는 체크박스
//단순하게 체크가 선택되었경우 체크표시가 되도록하는 단순한 뷰이다.
struct checkBoxView: View {
    
    let size: CGFloat
    
    @Binding var isMarked : Bool
 
    var body: some View {
        Image(systemName: self.isMarked ? "checkmark.circle" : "checkmark.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(self.isMarked ? Color("primaryColor") : .gray)
            .frame(width: self.size, height: self.size)
            
    }
}



