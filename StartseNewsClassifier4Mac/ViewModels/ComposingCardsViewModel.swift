//
//  ComposingCardsViewModel.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 24/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class ComposingCardsViewModel: ObservableObject {
    private var filterSelection:Int = 0
    private var context:NSManagedObjectContext
    private var newsModel:NewsModel? = nil
    
    var news: NewsViewModel {
        var res:NewsViewModel!
        newsModel = fetchNews()
        res = NewsViewModel(newsModel: newsModel!)
        return res
    }
    
    var sentences:[SentenceViewModel] {
        let sentences = fetchSentences()
        return sentences
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchNews() -> NewsModel? {
        var result:NewsModel?
        let request = NSFetchRequest<ClassifiedNewsData>(entityName: "ClassifiedNewsData")
        var predicate:NSPredicate!
        predicate = NSPredicate(value: true)
        request.predicate = predicate
        
        do {
            let classifiedNewsData = try context.fetch(request)
            let firstClassifiedNews = classifiedNewsData[0]
            let newsId = firstClassifiedNews.id!
            let title = firstClassifiedNews.title!
//            let subtitle = firstClassifiedNews.subtitle!
            let subtitle = "teste subtitle"
            let link = firstClassifiedNews.link!
            let text = firstClassifiedNews.text!
            let links:[String] = []
            let linksTexts:[String] = []
            result = NewsModel(news_id: newsId, title: title, subtitle: subtitle, link: link, text: text, links: links, links_text: linksTexts)
        }catch {
            print("Error: \(error)")
        }
        return result
    }
    
    private func fetchSentences() -> [SentenceViewModel]{
        var result:[SentenceViewModel] = []
        let request = NSFetchRequest<SentenceData>(entityName: "SentenceData")
        var predicate1:NSPredicate!
        var predicate2:NSPredicate!
        
        if filterSelection == 0 {
            predicate1 = NSPredicate(format: "containsSegment == true")
        }else if filterSelection == 1 {
            predicate1 = NSPredicate(format: "containsJob == true")
        }else if filterSelection == 2 {
            predicate1 = NSPredicate(format: "containsOutcome == true")
        }else if filterSelection == 3 {
            predicate1 = NSPredicate(format: "containsSolution == true")
        }else if filterSelection == 4 {
            predicate1 = NSPredicate(format: "containsTechnology == true")
        }else if filterSelection == 5 {
            predicate1 = NSPredicate(format: "containsInvestment == true")
        }
        
        let news = self.newsModel!
        predicate2 = NSPredicate(format: "ofNews.id == %@", news.news_id)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        
        do {
            let sentenceData = try context.fetch(request)
            let sentences = sentenceData
            
            sentences.forEach{sentence in
                let sentenceViewModel = SentenceViewModel(sentenceModel: SentenceModel(id: UUID(uuidString: sentence.id!)!, text: sentence.text!, classifications: []))
                result.append(sentenceViewModel)
            }
        }catch {
            print("Error: \(error)")
        }
        return result
    }
}
