import SwiftUI
import WebKit

//uikit의 uiview를 사용할수 있도록 한다.
//UIViewControllerRepresetable
struct webViewModel: UIViewRepresentable {
   
    
    var urlToLoad : String
    
    //WKWebView를리턴 한다 <-웹뷰
    func makeUIView(context: Context) -> WKWebView {
        
         let encodedString = urlToLoad.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        guard let url = URL(string: encodedString) else{
            return WKWebView()
        }
        
        let webview = WKWebView()
        
       
        //변수로 받은 URL에 해당하는 웹뷰를 띄어준다.
        webview.load(URLRequest(url : url))
        return webview
    }
    
    
    // 업데이트 ui view
   
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webViewModel>) {
      
    }
    
}
