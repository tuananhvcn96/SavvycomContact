//
//  UI.swift
//  MiniShop
//
//  Created by Tuan Anh on 25/10/2017.
//  Copyright © 2017 Tuan Anh. All rights reserved.
//

import UIKit

class UI {
    static func ALert(ui: UIViewController,title:String, message: String){
        let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        ui.present(alert,animated: true,completion: nil)
        
    }
    
    static func aLert(ui: UIViewController,title:String, message: String, handler: @escaping (UIAlertAction) -> Void ){
        let okAction = UIAlertAction(title: "OK", style: .default,handler: handler)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        ui.present(alert,animated: true,completion: nil)
        
    }
    
    static func addDoneBtnForTextFiled(view: UIViewController, textFileds: [UITextField]) {
        for textFiled in textFileds {
            let keyToolbat: UIToolbar = UIToolbar()
            keyToolbat.items = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: view, action: nil),
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: textFiled, action: #selector(UITextField.resignFirstResponder))
            ]
            keyToolbat.sizeToFit()
            
            textFiled.inputAccessoryView = keyToolbat
        }
    }

    
}
