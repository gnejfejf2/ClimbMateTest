//
//  openSourceModel.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/19.
//

import Foundation
struct openSourceModel : Identifiable {
    let id = UUID()
    let openSourceName : String
    let openSourceURL : String?
    let openSourceExplanation : String
}
