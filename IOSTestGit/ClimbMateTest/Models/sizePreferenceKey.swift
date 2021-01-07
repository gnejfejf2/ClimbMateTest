//
//  sizePreferenceKey.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/12.
//

import SwiftUI


//View의 크기를 알기위해 사용하는 변수
struct sizePreferenceKey: PreferenceKey{
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
