
import SwiftUI
import ImageViewer_swift
import SDWebImageSwiftUI

struct singleImageView: UIViewRepresentable {
    
    var urls = [URL]()
    
    let imageView = UIImageView()
    
    
    init(imageURL : String) {
        
        
        urls.append(URL(string: imageURL) ?? URL(string: "https://climbmate.co.kr/1.jpg")!)
        
        
    }
    
    //    let urls = [
    //        URL(string: "https://climbmate.co.kr/1.jpg")!,
    //        URL(string: "https://climbmate.co.kr/1.jpg")!,
    //        URL(string: "https://climbmate.co.kr/1.jpg")!
    //    ]
    
    
    func makeUIView(context: Context) -> UIImageView {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 100), scaleMode: .fill)
        imageView.sd_setImage(with: self.urls[0], placeholderImage: UIImage(systemName: "photo")  , context: [.imageTransformer: transformer])

        imageView.setupImageViewer(urls: urls)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }
    
    
}
