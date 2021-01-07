//
//  recentUpdateCenterListView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/05.
//

import SwiftUI

struct recentUpdateCenterListView: View {
    
    @Binding var recentUpdateCenterList : [centerModel]
    let cornerRadiusCGFloat : CGFloat = 10
    var body: some View {
        VStack{
            List(self.recentUpdateCenterList){ center in
                recentUpadteCenterItem(center: center)
            }
            Spacer()
        } .navigationBarTitle("최근 세팅이 변경된 클라이밍장", displayMode: .inline)
    }
}
