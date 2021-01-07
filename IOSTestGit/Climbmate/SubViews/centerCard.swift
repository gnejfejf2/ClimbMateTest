import SwiftUI
import SDWebImageSwiftUI

struct centerCard : View {
    
    //한번받으면 값이 변할일이 없기때문 let으로 선언
    let center : centerModel
    let centertype : Int
    //homeView 에서 근처암장 , 가장최근세팅된 암장부분을 보여줄때 사용하는
    //사용할시 center에 대한 정보를 받은 후 아래의 뷰를 그려준다.
    var body : some View {
        NavigationLink(destination: centerDetailViewRecreate(clickType: self.centertype ,centerID: center.id)){
            VStack(alignment: .leading , spacing : 4){
                
                //이미지값에 1000이 들어가있다면 이미지값이 없다는것이다.
                if(center.imageThumbUrl == staticString().nilImage()){
                    Image(staticString().nilImage())
                        .resizable()
                        .cornerRadius(5)
                        .frame(width: 200, height: 150)
                }
                else{
                    WebImage(url: URL(string: center.imageThumbUrl))
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        .resizable()
                        .cornerRadius(5)
                        .frame(width: 200, height: 150)
                }
                Text(self.center.centerName)
                    .foregroundColor(Color("primaryColor"))
                    .font(.callout)
                    .frame(alignment: .leading)
                    .padding(.leading,5)
                    .lineLimit(1)
                Text(self.center.centerAddress)
                    .foregroundColor(.gray)
                    .fontWeight(.thin)
                    .font(.system(size: 12))
                    .frame(alignment: .leading)
                    .padding(.leading,5)
                //근처에있는 클라이밍장리스트에서 사용하는 센터카드에맞게 변형
                if(self.centertype == 1){
                    HStack{
                        if(Double(center.centerDistance) ?? 0.0 < 1){
                            Spacer()
                            Text("\(Int(Double(center.centerDistance)! * 1000))m")
                                .foregroundColor(Color("primaryColor"))
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .frame(alignment: .trailing)
                        }
                        else{
                            Spacer()
                            Text("\(String(center.centerDistance))km")
                                .foregroundColor(Color("primaryColor"))
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .frame(alignment: .trailing)
                        }
                    }
                //최근 업데이트된 클라이밍장리스트에서 사용하는 센터카드에맞게 변형
                } else{
                    Text("세팅이 변경된 날짜 :\(self.center.detailRecentUpdate)")
                        .foregroundColor(Color("primaryColor"))
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(alignment: .leading)
                        
                        .padding(.leading,5)
                }
            }
            .frame(width: 200)
            .padding(.horizontal,5)
            
            
        }
    }
}




