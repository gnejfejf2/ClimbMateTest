//
//  devideLineView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/15.
//


//각각의 아이템을 나눌때 사용하는 뷰로 기본값이 높이 2 상하단 패딩 10으로 주어져있고
//값들을 입력을 받아서 사용할수있게 변수 처리해놨다

import SwiftUI

struct devideLineView: View {
    
    var height : CGFloat = 2
    var topPadding : CGFloat = 10
    var bottomPadding : CGFloat = 10
    
    var body: some View {
        Capsule().fill(Color.gray.opacity(0.2))
            .frame(height: self.height)
            .padding(.top, self.topPadding)
            .padding(.bottom, self.bottomPadding)
        
    }
}


