//
//  singleImagePicker.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/22.
//

import SwiftUI
import PhotosUI

struct singleImagePicker : UIViewControllerRepresentable {
    
    @Binding var shown : Bool
    @Binding var imgData : Data
    @Binding var image : UIImage
    
    let library = PHPhotoLibrary.shared()
   
    
    func makeCoordinator() -> singleImagePicker.Coordinator {
        return Coordinator(shown1 : self.$shown , imgData1 : self.$imgData , image1 : self.$image)
    }
    
    //해당함수에서 이미지 피커를 사용하기위해 이미지피커에 해당하는 컨트롤러를 리턴한다.
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        
        config.filter = .images
        
        config.selectionLimit = 1
        
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        
//        library.presentLimitedLibraryPicker(from: controller)
//
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject,PHPickerViewControllerDelegate{
        
        
        @Binding var shown : Bool
        @Binding var imgData : Data
        @Binding var image : UIImage
        
     
        
        //받아온값들을 세팅한다 _ 이게 클래스에서 자기 자신의 값을 저장하는거 같긴한데 좀 더 공부가필요
        init( shown1 : Binding<Bool>, imgData1 : Binding<Data>  , image1: Binding<UIImage>){
            _imgData = imgData1
            _shown = shown1
            _image = image1
            
            
           
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            
            for img in results{
                
                if img.itemProvider.canLoadObject(ofClass: UIImage.self){
                    img.itemProvider.loadObject(ofClass: UIImage.self){
                        (image , error) in
                        
                        guard let image1 = image else {
                            return
                        }
                        

                        
                        self.image  = image1 as! UIImage
                        self.imgData = self.image.jpegData(compressionQuality: 80)!

                    }
                    
                }else{
                    
                }
            }
            
            self.shown.toggle()
            
        }
        
        
        
        //        @Binding var shown : Bool
        //        @Binding var imgData : Data
        //        @Binding var image : UIImage
        //
        
        //        //받아온값들을 셋팅한다 _ 이게 클래스에서 자기 자신의 값을 저장하는거 같긴한데 좀 더 공부가필요
        //        init(shown1 : Binding<Bool>, imgData1 : Binding<Data>  , image1: Binding<UIImage>){
        //            _imgData = imgData1
        //            _shown = shown1
        //            _image = image1
        //        }
        //        //이미지피커를 종료하였을경우 생기는 이벤트
        //        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //            shown.toggle()
        //        }
        //        //이미지를 클릭하였을경우 생기는 이벤트들이 담겨져 있는 함수
        //        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        //            withAnimation(.easeOut(duration: 0.3)){
        //                shown.toggle()
        //            }
        //
        //            image  = info[.originalImage] as! UIImage
        //            imgData = image.jpegData(compressionQuality: 80)!
        //        }
        //
        
        
    }
    
}





