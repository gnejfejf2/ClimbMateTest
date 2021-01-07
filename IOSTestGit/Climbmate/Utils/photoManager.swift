//
//  SwiftUIView.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/30.
//

import SwiftUI
import Photos

struct photoManager{
    
   
    func openSingleImagePicker() -> Bool{

        //퍼미션검사를 한적이 없다면 검사를하고
        self.photoPermissionGet()
        
        //퍼미션값이있으면 값을 리턴
        return self.photoPermissionCheck()
    }
    
    
    func photoPermissionGet(){
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
            switch authorizationStatus {
            case .limited:
                logManager().log(log: "limited authorization granted")
            case .authorized:
                logManager().log(log: "authorization granted")
                
            default:
                logManager().log(log: "Unimplemented")
                
            }
        }
    }
    
    func photoPermissionCheck() -> Bool {
        let accessLevel: PHAccessLevel = .readWrite
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)

        switch authorizationStatus {
        case .limited:
            return false
        case .authorized:
            return true
        default:
           return false
        }
    }

}
