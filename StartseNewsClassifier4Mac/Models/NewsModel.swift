//
//  NewsModel.swift
//  StartseNewsClassifier
//
//  Created by Cristiano Araújo on 13/10/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation

struct NewsModel: Encodable, Decodable{
    let news_id: String
    let title:String
    let subtitle:String
    let link:String
    let text:String
    let links:[String]
    let links_text:[String]
//    var isClassified = false
//    var isConsolidated = false
}

struct ClassifiedNewsModel: Encodable, Decodable {
    let newsModel:NewsModel
    var classifiedSentences:[SentenceModel]
}

class Articles: Encodable {
    var articles:[NewsModel] = []
}

