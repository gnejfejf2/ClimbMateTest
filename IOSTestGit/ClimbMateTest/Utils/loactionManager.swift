//
//  loactionManager.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/10/26.
//


import SwiftUI
import MapKit
import CoreLocation

class locationManager : NSObject,ObservableObject,CLLocationManagerDelegate{
    
    let manager = CLLocationManager()
    
    
    
    func locationPermissonCheck() -> Bool{
        //유저가 위치권한을 체크했는지 안했는지 체크하는 코드 
        if self.manager.authorizationStatus == .authorizedWhenInUse{
            return true
        }
        else{
            
            return false
        }
    }
    
    

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager ){
        if manager.authorizationStatus == .authorizedWhenInUse{
                //
           
        }
        else{
            manager.delegate = self
            //포그라운드 상태에서 위치 추적 권한 요청
            manager.requestWhenInUseAuthorization()
       
        }
    }
    
    func getlocation()-> xyModel{
        
        
        var locationManager:CLLocationManager!
        
        //위도와 경도
        var latitude: Double?
        var longitude: Double?
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //위치업데이트
        locationManager.startUpdatingLocation()
        
        //위도 경도 가져오기
        let coor = locationManager.location?.coordinate
        //위도
        latitude = coor?.latitude
        //경도
        longitude = coor?.longitude
        
        //카카오에서는 숫자가 큰게 x  작은게 y로가는데 아이폰에서는 반대로 사용한다 하지만 서버통신을
        //우리서버에서 주로할거기떄문에 우리서버 기준에 맞춰서 저장한다
        return xyModel(x: String(longitude ?? 0), y: String(latitude ?? 0))
        
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, completion: @escaping(String , String) -> ()){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        //널값인경우 -1
        var addressString : String = "-1"
        var subString : String = "-1"
        
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        
                                       
                                        if (error != nil)
                                        {
                                            logManager().log(log: "reverse geodcode fail: \(error!.localizedDescription)")
                                        
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                      
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            //addressString 을 비워주고 값을 더해준다.
                                            addressString = ""
                                            subString = ""
                                            //사당동
                                            
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + " "
                                                subString = pm.locality!
                                                //동작구
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare!
                                                    completion(addressString,subString)
                                                }else{
                                                    
                                                    completion(subString,subString)
                                                }
                                            }
                                            else{
                                                completion(subString,subString)
                                            }
                                        }else{
                                            completion(subString,subString)
                                        }
                                    })
    }
}


