//검색후 검색결과 리스트에서 사용하는 아이템에 대한 뷰를 그려주는 파일

import SwiftUI
import SDWebImageSwiftUI
import ImageViewer_swift

struct searchResultCard: View {
    //해당하는 클라이밍장에 대한 정보를 받아온후
    var center : searchCenterModel
    //폰트사이즈 스몰을 상수화
    let fontSizeSmall : CGFloat = 11
    let imageView = UIImageView()
    var urls = [URL(string: "https://climbmate.co.kr/1.jpg")!,URL(string: "https://climbmate.co.kr/1.jpg")!]

    var body: some View {
        //상단 이미지 텝뷰를 그려주는공간이다. 이미지를 최대 3개까지로 현재 제한을 걸어두었는데
        //아이폰8 으로 디버깅할경우 아이템들이 많아지면서 속도저하가 생겨 해당페이지에서 제한을 두었다
        VStack(spacing : 0){
            customPageView(imageStrings: self.center.centerSettingImage)

            
          
            ZStack{
                VStack{
                    HStack{
                        VStack(alignment : .leading ,spacing : 5){
                            HStack(alignment : .bottom , spacing : 0){
                                Text(self.center.centerName)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("primaryColor"))
                                Text(" (\(self.center.conceptName))")
                                    .font(.system(size: self.fontSizeSmall))
                                    .foregroundColor(Color("primaryColor").opacity(0.6))
                            }
                            
                            
                            
                            HStack(spacing : 5){
                                Text(self.center.centerAddress)
                                    .font(.system(size: self.fontSizeSmall))
                                    .fontWeight(.thin)
                                    .foregroundColor(Color("primaryColor").opacity(0.8))
                                
                                
                            }
                            
                            
                            HStack(spacing : 0){
                                HStack(spacing : 5){
                                    Image(systemName: "location")
                                        .font(.system(size: self.fontSizeSmall))
                                    
                                    //센터의 위치가 1km이하인경우 m로 변경해주기 위하여 이렇게 선언
                                    if(self.center.centerDistance < 1){
                                        Text("\(Int(self.center.centerDistance * 1000))m")
                                            .font(.system(size: self.fontSizeSmall))
                                            .foregroundColor(Color("primaryColor").opacity(0.8))
                                    }
                                    else{
                                        Text("\(String(self.center.centerDistance))km")
                                            .font(.system(size: self.fontSizeSmall))
                                            
                                            .foregroundColor(Color("primaryColor").opacity(0.8))
                                    }
                                }
                                //현재 type의 의 인덱스를 1로 선언해놓은 이유는 2020 11월 10일 기준 type: 1 1회암장이용가격이기때문
                                Spacer()
                                Text(self.center.centerGoods[self.center.centerGoodsReturn(type: 1)].goodsName)
                                    .font(.system(size: self.fontSizeSmall))
                                    .foregroundColor(Color("primaryColor").opacity(0.8))
                                    .frame(width: UIScreen.main.bounds.width / 5.5 , alignment: .leading)
                                
                                Text("\(staticString().decimalWon(value: Int(self.center.centerGoods[self.center.centerGoodsReturn(type: 1)].goodsPrice) ?? 0))")
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color("primaryColor").opacity(0.8))
                                    .frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .leading)
                                
                            }
                            
                            HStack(spacing : 0){
                                Spacer()
                                Text("세팅 날짜 ")
                                    .font(.system(size: self.fontSizeSmall))
                                    .foregroundColor(Color("primaryColor").opacity(0.8))
                                    .frame(width: UIScreen.main.bounds.width / 5.5 , alignment: .leading)
                                Text("\(self.center.detailRecentUpdate)")
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color("primaryColor").opacity(0.8))
                                    .frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .leading)
                            }
                        }
                        .padding(.horizontal,8)
                        .padding(.top,8)
                        
                    }
                }
                
                NavigationLink(
                    destination: centerDetailViewRecreate(clickType : staticString().staticClickType[3] , centerID: center.id)){
                }.opacity(0)
            }
            .padding(.vertical,10)
            
            devideLineView(height: 2, topPadding: 0, bottomPadding: 0)
            
        }
    }
}

