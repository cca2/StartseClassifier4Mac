//
//  NewsViewModel.swift
//  StartseNewsClassifier
//
//  Created by Cristiano Araújo on 13/10/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CloudKit

import NaturalLanguage

class NewsViewModel: Identifiable {
    let news:NewsModel
    
    init(newsModel:NewsModel) {
        self.news = newsModel
    }
    
    init(record:CKRecord) throws {
        recordName = record.recordID.recordName
        do {
            let newsFile = record["newsFile"] as! CKAsset
            let decoder = JSONDecoder()
            let json = try Data(contentsOf: newsFile.fileURL!)
            let news = try decoder.decode(NewsModel.self, from: json)
            self.news = news
        }catch {
            throw error
        }
    }
    
    var recordName: String?
    
    var isClassified: Bool = false
    
    var id: UUID {
        return UUID(uuidString: news.news_id.uppercased())!
    }
    
    var title: String {
        return news.title
    }
    
    var subtitle: String {
        return news.subtitle
    }
    
    var link: String {
        return news.link
    }
    
    var text:String {
        return news.text
    }
}
