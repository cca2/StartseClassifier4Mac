//
//  FileManagement.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 09/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation

class FileManagement {
    var newsModels:[NewsModel] = []
    
    func getNewsFromDocumentsDirectory() {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        do {
            let unclassifiedNewspath = documentsPath.appendingPathComponent("StartseNewsFiles/unclassified")
            let files = try FileManager.default.contentsOfDirectory(at: unclassifiedNewspath!, includingPropertiesForKeys: [], options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

            let decoder = JSONDecoder()
            
            try files.forEach {
                file in
                let json = try Data(contentsOf: file)
                let news = try decoder.decode(NewsModel.self, from: json)
                self.newsModels.append(news)
            }
        }catch {
            print("Error:\(error)")
        }
    }
}
