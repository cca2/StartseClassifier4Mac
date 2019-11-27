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
    private var context:NSManagedObjectContext!
    private var newsModel:NewsModel!
    
    var managedObjectContext:NSManagedObjectContext {
        get {
            return self.context
        }
        
        set (context) {
            self.context = context
            loadNews() {
                newsViewModel in
                self.news = newsViewModel
                self.hasLoadedNews = true
            }
        }
    }
    
    @Published var news:NewsViewModel?
    @Published var hasLoadedNews:Bool = false
    
    var sentences:[SentenceViewModel] {
        let sentences = fetchSentences()
        return sentences
    }
    
    init() {}
    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//        loadNews() {
//            newsViewModel in
//            self.news = newsViewModel
//            self.hasLoadedNews = true
//        }
//    }
    
    private func loadNews(completion: @escaping (NewsViewModel) -> ()) {
        self.hasLoadedNews = false
        var newsRecord:CKRecord?
        let container = CKContainer(identifier: "iCloud.br.ufpe.cin.StartseNewsClassifier")
        let database = container.privateCloudDatabase
        
        let predicate = NSPredicate(format: "isClassified == true")
        
        let query = CKQuery(recordType: "News", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        
        operation.recordFetchedBlock = {
            record in
            newsRecord = record
        }
        
        operation.queryCompletionBlock = {
            cursor, error in
            
            DispatchQueue.main.async {
                if (error == nil) {
                    print(">>> Finalizou com Sucesso <<<")
                    do {
                        let newsViewModel = try NewsViewModel(record: newsRecord!)
                        completion(newsViewModel)
                    }catch {
                        print ("Error: \(error)")
                    }
                }else {
                    print (">>> FINALIZOU QUERY <<<")
                    print("Error:\(String(describing: error))")
                }
            }
        }
        database.add(operation)
    }
    
    private func fetchNews() -> NewsModel? {
        var result:NewsModel?
        let request = NSFetchRequest<ClassifiedNewsData>(entityName: "ClassifiedNewsData")
        var predicate:NSPredicate!
        predicate = NSPredicate(value: true)
        request.predicate = predicate
        
        do {
            let classifiedNewsData = try context.fetch(request)
            
//            classifiedNewsData.forEach{
//                classifiedNews in
//                context.delete(classifiedNews)
//            }
//            try context.save()

            if classifiedNewsData.count > 0 {
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
            }else {
                //Buscar baixar novas Notícias do iCloud (Cloudkit)
            }
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
