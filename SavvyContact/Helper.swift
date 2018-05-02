//
//  Helper.swift
//  SavvyContact
//
//  Created by Tuan Anh on 21/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import Foundation
import UIKit
class Helper {
    static func roundImage(_ imageView: UIImageView) {
        imageView.layer.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.contentMode = .scaleAspectFill
        //imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.layoutIfNeeded()
    }
    
    static func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}
