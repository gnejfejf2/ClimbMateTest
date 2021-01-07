import SwiftUI
import CoreData


class searchHistoryModel : ObservableObject {
    @Published var searchHistorys : [NSManagedObject] = []
   
    let context = persistenteContainer.viewContext
    
    
    init(){
        readData()
    }
    
    func readData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        let sort = NSSortDescriptor(key: "searchDate", ascending: false)
       
        
      
       
        
       
        
        request.sortDescriptors = [sort]
        do{
            let results = try context.fetch(request)
            
            self.searchHistorys = results as! [NSManagedObject]
        }
        catch{
            logManager().log(log: error.localizedDescription)
            

        }
    }
    
    func writeData(keyword : String , totalCount : Int16){
       
        
        // 검색기록 코어데이터를 먼저 확인하고
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        let sort = NSSortDescriptor(key: "searchDate", ascending: false)
       
        request.sortDescriptors = [sort]
        do{
            let results = try context.fetch(request)
            
            self.searchHistorys = results as! [NSManagedObject]
        }
        catch{
            logManager().log(log: error.localizedDescription)
            

        }
        //코어데이터에서 현재들어온 키워드랑 같이값이 있다면 삭제한다.
        for index in self.searchHistorys{
            do{
                if(self.getKeyword(obj: index) == keyword){
                    context.delete(index)
                    
                    try context.save()
                    
                    let index = self.searchHistorys.firstIndex(of: index)
                    
                    self.searchHistorys.remove(at: index!)
                }
            }catch{
                
                logManager().log(log: error.localizedDescription)
                
            }
        }
        //그후 입력한 키워드와 날짜를 등록한다 토탈카운트는 현재 사용하지 않음
        let entity = NSEntityDescription.insertNewObject(forEntityName: "SearchHistory", into: context)
        entity.setValue(keyword, forKey: "keyword")
        entity.setValue(Date(), forKey: "searchDate")
        entity.setValue(totalCount, forKey: "totalCount")
        
        do{
            try context.save()
            self.searchHistorys.append(entity)
        }
        catch{
            logManager().log(log: error.localizedDescription)
            
        }
    }
    
    //외부에서 index를 받아와
    //히스토리 배열에서 삭제하고
    //코어데이터에서도 삭제해준다.
    func deleteData(indexSet : IndexSet){
        for index in indexSet{
            do{
                let obj = self.searchHistorys[index]
                
                context.delete(obj)
                
                try context.save()
                
                let index = self.searchHistorys.firstIndex(of: obj)
                
                self.searchHistorys.remove(at: index!)
                
            }catch{
                
                logManager().log(log: error.localizedDescription)
                
            }
        }
        
    }
    
    // SearchHistory 코어데이터를 전체삭제
    func allDelete(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            
            try context.execute(batchDeleteRequest)
            try context.save()
            self.searchHistorys.removeAll()
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
