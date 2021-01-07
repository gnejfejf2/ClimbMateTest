
import SwiftUI
import UIKit
import SDWebImageSwiftUI
import ImageViewer_swift



struct imageZoomView: UIViewRepresentable {

    var urls = [URL]()

    var index : Int
    var titleIndex : Int
    let imageView = UIImageView()


    init(imageURL : [centerSettingImageModel] , index : Int) {

        self.index = index
        self.titleIndex = index

        //ex index = 1 1..<2 -> 1
        for i in 0..<imageURL.count{
            urls.append(URL(string: imageURL[i].imageThumbUrl) ?? URL(string: "https://climbmate.co.kr/1.jpg")!)
        }
    }
    func makeUIView(context: Context) -> UIImageView {
        let transformer = SDImageResizingTransformer(size: CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2.5), scaleMode: .fill)
        imageView.sd_setImage(with: self.urls[self.index], placeholderImage: UIImage(systemName: "photo")  , context: [.imageTransformer: transformer])
        //        imageView.setupImageViewer(urls: urls , initialIndex: 1)
        //        imageView.setupImageViewer(urls: urls)
        imageView.setupImageViewer(urls: self.urls, initialIndex: self.index ,options: [
            .theme(.dark),
        ])

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {

    }



}


struct centerSettingZoomView: UIViewRepresentable {

    var urls = [URL]()

    var index : Int
    var titleIndex : Int
    let imageView = UIImageView()


    init(imageURL : [centerSettingModel] , index : Int) {

        self.index = index
        self.titleIndex = index

        //ex index = 1 1..<2 -> 1
        for i in 0..<imageURL.count{
            urls.append(URL(string: imageURL[i].imageThumbUrl) ?? URL(string: "https://climbmate.co.kr/1.jpg")!)
        }
    }
    func makeUIView(context: Context) -> UIImageView {
        let transformer = SDImageResizingTransformer(size: CGSize(width: (UIScreen.main.bounds.width - 20) / 3, height: (UIScreen.main.bounds.width - 20) / 3 ), scaleMode: .fill)
        imageView.sd_setImage(with: self.urls[self.index], placeholderImage: UIImage(systemName: "photo")  , context: [.imageTransformer: transformer])
        //        imageView.setupImageViewer(urls: urls , initialIndex: 1)
        //        imageView.setupImageViewer(urls: urls)
        imageView.setupImageViewer(urls: self.urls, initialIndex: self.index ,options: [
            .theme(.dark),
        ])

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {

    }



}

