//
//  settigLevelListView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/30.
//

import SwiftUI

struct settigLevelCardView: View {
    let centerSetting : centerSettingLevelModel
    let fontSizeSmaell : CGFloat = 10
    let fontSizeBig : CGFloat = 16
    let symbolSize : CGFloat = 25
    var body: some View {
        VStack(spacing : 8){
            HStack(spacing : 5){
                VStack(spacing : 2){
                    Image(systemName: "arrow.up.right.square.fill")
                        .foregroundColor(Color.gray)
                        .font(.system(size: self.symbolSize))
                    Text(self.centerSetting.centerLevel)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray.opacity(0.9))
                        .font(.system(size: self.fontSizeSmaell))
                }
               
                Spacer()
                Capsule().fill(Color.gray.opacity(0.1))
                    .frame(height: 12)
                Spacer()
                Text("\(self.centerSetting.centerSettings.count)")
                    .font(.system(size: self.fontSizeBig))
                    .foregroundColor(Color.gray.opacity(0.3))
            }
            devideLineView(height: 1, topPadding: 0, bottomPadding: 0)
        }
    }
}

