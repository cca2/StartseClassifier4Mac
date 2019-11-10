//
//  FileManagement.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 09/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation
import CloudKit

class NewsFileManagement {
    var newsModels:[NewsModel] = []
    var newsFileDictionary:[String:URL] = [:]
    
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
                self.newsFileDictionary[news.news_id] = file
            }
        }catch {
            print("Error:\(error)")
        }
    }
        
    func uploadNewsForClassification(news:NewsModel, completion: @escaping  () -> ()) {
        let news = news
        let newsId = news.news_id
        guard let file = self.newsFileDictionary[newsId] else { return }
        let container = CKContainer(identifier: "iCloud.br.ufpe.cin.StartseNewsClassifier")
        let fileAsset = CKAsset(fileURL: file)
        let record = CKRecord(recordType: "News")
        record["newsFile"] = fileAsset
        
        container.privateCloudDatabase.save(record) {
            record, error in
            
            DispatchQueue.main.async {
                if (error != nil) {
                    print ("Error: \(String(describing: error))")
                }else {
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    do {
                        let unclassifiedNewsPath = documentsPath.appendingPathComponent("StartseNewsFiles/unclassified")
                        let classifiedNewspath = documentsPath.appendingPathComponent("StartseNewsFiles/toClassify")
                        
                        guard let unclassifiedFilePath = unclassifiedNewsPath?.appendingPathComponent("StartseNews-\(newsId.lowercased()).json") else { return }
                        guard let classifiedFilePath = classifiedNewspath?.appendingPathComponent("StartseNews-\(newsId.lowercased()).json") else { return }
                        
                        try FileManager.default.moveItem(at: unclassifiedFilePath, to: classifiedFilePath)
                        completion()
                        self.newsFileDictionary[news.news_id] = nil
                    }catch {
                        print("Error:\(error)")
                    }
                }
            }
        }
    }
}
