//
//  pickerTextField.swift
//  Climbmate
//
//  Created by kang jiyoun on 2020/11/10.
// https://www.youtube.com/watch?v=dPSYU8Bcd14 유튜브참고

import SwiftUI

struct pickerTextField: UIViewRepresentable {
    
    private let textField = UITextView()
    private let pickerView = UIPickerView()
    
    var data : [String]
   
    @Binding var lastSelectedIndex : Int?
    
    func makeUIView(context: Context) -> UITextView {
        self.pickerView.delegate = context.coordinator
        self.pickerView.dataSource = context.coordinator
        
        //self.textField.placeholder = self.placeholder
        self.textField.inputView = self.pickerView
        self.textField.text = "히위"
        
        return self.textField
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if let lastSelectedIndex = self.lastSelectedIndex {
            uiView.text = self.data[lastSelectedIndex]
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: self.data){ index in
            self.lastSelectedIndex = index
        }
    }
    
    class Coordinator : NSObject , UIPickerViewDelegate , UIPickerViewDataSource{
        
        private var data : [String]
        private var didSelectItem : ((Int) -> Void)?
        
        init(data : [String] , didSelectItem : ((Int) -> Void)?){
            self.data = data
            self.didSelectItem = didSelectItem
        }
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.data[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.didSelectItem?(row)
        }
    }
}

