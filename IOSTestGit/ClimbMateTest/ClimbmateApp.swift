import SwiftUI
import CoreData
import KakaoSDKAuth


@main
struct ClimbmateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        
        //만들어놓은 코어데이터 컨테이너를 어디서든사용할수있도록 선언
        WindowGroup {
            mainView()
                .environment(\.managedObjectContext, persistenteContainer.viewContext)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}




//코어데이터 사용하기위한 컨테이너
var persistenteContainer : NSPersistentContainer = {
    let container = NSPersistentContainer(name: "userCoreData")
    container.loadPersistentStores(completionHandler: {
        (storeDescription , error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error) , \(error.userInfo)")
            
        }
    })
   
    return container
}()
//코어데이터 저장코드
func saveContext(){
    let context = persistenteContainer.viewContext
    if context.hasChanges{
        do{
            try context.save()
        }catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror) , \(nserror.userInfo)")
        }
    }
}

