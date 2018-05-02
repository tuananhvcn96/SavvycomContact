//
//  ConnectDB.swift
//  SavvyContact
//
//  Created by Tuan Anh on 19/04/2018.
//  Copyright © 2018 Tuan Anh. All rights reserved.
//

import Foundation

import Foundation


class ConnectDB {
    
    private let dataFileName: String
    // connectDB
    private var dataSourcePath: String? {
        guard let sourcePath = Bundle.main.path(forResource: self.dataFileName, ofType: "plist") else { return .none }
        return sourcePath
    }
    // doc tiep DL tu duong dan URL
    private var dataSavedPath: String? {
        if dataSourcePath == .none {
            return .none
        }
        let documentDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/\(dataFileName)")
        return String(describing: documentDirPath)
        // subject
    }
    
    init?(dataFileName: String) {
        self.dataFileName = dataFileName
        let fileManager = FileManager.default
        guard let sourcePath = dataSourcePath else {return nil}
        guard let destinationPath = dataSavedPath else {return nil}
        if !fileManager.fileExists(atPath: destinationPath) {
            do {
                // copy duong dan hien tai den duong dan can ban sao
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            } catch let err {
                print("Can't copy file! \(err)")
                return nil
            }
        }
    }
    
    // khoi tao mang cac gia tri tu duong dan davaSavedpath
    func getDataToNSMutableArr() ->  NSMutableArray?{
        let fileManager = FileManager.default
        guard let destinationPath = dataSavedPath else {return nil}
        if !fileManager.fileExists(atPath: destinationPath) {
            return nil
        }
        let items = NSMutableArray(contentsOfFile: destinationPath)
        return items
    }
    
    func getDataSavedPath() -> String?{
        return self.dataSavedPath
    }
    
}
