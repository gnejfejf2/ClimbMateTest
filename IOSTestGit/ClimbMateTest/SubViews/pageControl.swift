//
//  pageControl.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/26.
//

import SwiftUI

struct pageControl: UIViewRepresentable {

    
    
    @Binding var current : Int
    var totalCount : Int
    
    func makeUIView(context: UIViewRepresentableContext<pageControl>) -> UIPageControl {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = UIColor(Color("primaryColor"))
        
        if(self.totalCount > 5){
            page.numberOfPages = 5
            
        }
        else{
            page.numberOfPages = self.totalCount
        }
        page.hidesForSinglePage = true
        page.pageIndicatorTintColor = .gray
        return page
    }
 
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        
        if(self.totalCount > 4){
            uiView.backgroundStyle.rawValue
        }
        
        uiView.currentPage = current
    }
    
}
