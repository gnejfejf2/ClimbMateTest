
import SwiftUI
import UIKit
import Lightbox


struct detailImageView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LightboxController
    
    var index : Int
    
    var images = [LightboxImage]()
    
    init(centerSettingImageModels : [centerSettingImageModel]? , centerSettingModels : [centerSettingModel]? , index : Int) {
        
        self.index = index
        
        
        if(centerSettingImageModels != nil){
            for i in 0..<centerSettingImageModels!.count{
                images.append(LightboxImage(imageURL: URL(string: centerSettingImageModels![i].imageThumbUrl)! , text: ""))
            }
            
            //
        }else if(centerSettingModels != nil){
            for i in 0..<centerSettingModels!.count{
                images.append(LightboxImage(imageURL: URL(string: centerSettingModels![i].imageThumbUrl)! , text: ""))
            }
        }
        
        
    }
    func makeUIViewController(context: Context) -> LightboxController {
        let controller = LightboxController(images: images, startIndex: self.index)
        controller.dynamicBackground = false
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: LightboxController, context: Context) {
        
    }
    
}

