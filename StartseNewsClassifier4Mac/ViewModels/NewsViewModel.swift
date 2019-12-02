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

class NewsViewModel: Identifiable, Equatable {
    static func == (lhs: NewsViewModel, rhs: NewsViewModel) -> Bool {
        if lhs.id.uuidString == rhs.id.uuidString {
            return true
        }else {
            return false
        }
    }
    
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
    
    var isSelected:Bool = false
    
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
        var res = ""
        let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma, .tokenType])
        tagger.string = news.text
        let range = news.text.startIndex ..< news.text.endIndex
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: []) {
            (tag, range) in
            if let tag = tag {
                res += "\(news.text[range])"
                if tag == .punctuation {
                    let punctuation = "\(news.text[range])"
                    if punctuation == "." {
                        res += "\n\n"
                    }
                }
            }
            return true
        }

        return res
    }
}
