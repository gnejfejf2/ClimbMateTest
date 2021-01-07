//
//  notiManager.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/05.
//

import SwiftUI
import CoreData

class notiManager {
    
   
    let context = persistenteContainer.viewContext
    
    
    func noticheck(completion : @escaping (Bool) ->()){
        //푸시알람 , 노티피케이션을 허용상태인지 아닌지 체크하는 코드
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                completion(false)
            } else if settings.authorizationStatus == .denied {
                completion(false)
            } else if settings.authorizationStatus == .authorized {
                completion(true)
            }
        })
    }
    
    
    func readData() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotiEvent")
        let sort = NSSortDescriptor(key: "eventDate", ascending: false)
        var notiEvent : [NSManagedObject] = []
        request.sortDescriptors = [sort]
        do{
            let results = try context.fetch(request)
            notiEvent = results as! [NSManagedObject]
          
            print(notiEvent)
            
            return notiEvent
            
        }
        catch{
            print(error.localizedDescription)
            logManager().log(log: error.localizedDescription)
            return notiEvent
        }
    }
    
    func writeData(eventType : String , eventNumber : String){
       
        //그후 입력한 키워드와 날짜를 등록한다 토탈카운트는 현재 사용하지 않음
        let entity = NSEntityDescription.insertNewObject(forEntityName: "NotiEvent", into: context)
        entity.setValue(eventType, forKey: "eventType")
        entity.setValue(Date(), forKey: "eventDate")
        entity.setValue(eventNumber, forKey: "eventNumber")
        
        do{
            print("저장함?")
            try context.save()
            
        }
        catch{
            print(error.localizedDescription)
            logManager().log(log: error.localizedDescription)
            
        }
    }
    
    // SearchHistory 코어데이터를 전체삭제
    func allDelete(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotiEvent")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            
            try context.execute(batchDeleteRequest)
            try context.save()
           
        } catch {
            // Error Handling
        }
    }
    
    func getKeyword(obj : NSManagedObject) -> String {
        return obj.value(forKey: "keyword") as! String
    }
    
    
    func getDate(obj : NSManagedObject) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: obj.value(forKey: "searchDate") as! Date)
        
        return dateString
    }
    
    
}
