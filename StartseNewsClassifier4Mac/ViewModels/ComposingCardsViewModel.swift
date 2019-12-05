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
    private var newsRecord:CKRecord?
    var sentences:[SentenceViewModel] = []
    
    var segmentSentences:[SentenceViewModel] = []
    var jobSentences:[SentenceViewModel] = []
    var outcomeSentences:[SentenceViewModel] = []
    var solutionSentences:[SentenceViewModel] = []
    var technologySentences:[SentenceViewModel] = []
    var investmentSentences:[SentenceViewModel] = []
    
    var jobToBeDoneCardCreator:JobToBeDoneCardCreator = JobToBeDoneCardCreator()
    @Published var jobToBeDoneCards:[JobToBeDoneCardViewModel] = []

    var managedObjectContext:NSManagedObjectContext {
        get {
            return self.context
        }
        
        set (context) {
            self.context = context
            self.hasLoadedNews = false
            loadNews() {
                newsViewModel in
                self.news = newsViewModel
                self.loadSentences() {
                    sentences in
                    self.sentences = sentences
                    self.hasLoadedNews = true
                }
            }
        }
    }
    
    @Published var news:NewsViewModel?
    @Published var hasLoadedNews:Bool = false
    @Published var classificationFilter:SentenceModel.Classification = .job
        
    init() {}
    
    func nextNews() {
        
    }
    
    func remove(at offsets:IndexSet) {
        self.jobToBeDoneCards.remove(atOffsets: offsets)
    }
    
    private func loadSentences(completion: @escaping ([SentenceViewModel]) -> ()) {
        var sentencesRecords:[CKRecord] = []
        let container = CKContainer(identifier: "iCloud.br.ufpe.cin.StartseNewsClassifier")
        let database = container.privateCloudDatabase
        
        let predicate = NSPredicate(format: "news == %@", CKRecord.Reference(record: self.newsRecord!, action: .none))
        //Aqui: precisa definir qual o filtro de classificação aplicar
//        let predicate2:NSPredicate!
//        if classificationFilter == .segment {
//            predicate2 = NSPredicate(format: "containsSegment == 1")
//        }else if classificationFilter == .job {
//            predicate2 = NSPredicate(format: "containsJob == 1")
//        }else if classificationFilter == .outcome {
//            predicate2 = NSPredicate(format: "containsOutcome == 1")
//        }else if classificationFilter == .solution {
//            predicate2 = NSPredicate(format: "containsSolution == 1")
//        }else if classificationFilter == .technology {
//            predicate2 = NSPredicate(format: "containsTechnology == 1")
//        }else if classificationFilter == .investment {
//            predicate2 = NSPredicate(format: "containsInvestment == 1")
//        }else {
//            predicate2 = NSPredicate(format: "containsSegment == 1")
//        }
        let query = CKQuery(recordType: "ClassifiedSentence", predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [predicate]))
                
        let operation = CKQueryOperation(query: query)
        
        operation.recordFetchedBlock = {
            record in
            sentencesRecords.append(record)
        }
        
        operation.queryCompletionBlock = {
            cursor, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    print(">>> Finalizou com Sucesso <<<")
                    var sentences:[SentenceViewModel] = []
                    sentencesRecords.forEach {
                        sentence in
                        let id = sentence["id"] as! String
                        let text = sentence["text"] as! String

                        var classifications:[SentenceModel.Classification] = []
                        let containsInvestment = sentence["containsInvestment"] as! Bool
                        let containsSegment = sentence["containsSegment"] as! Bool
                        let containsJob = sentence["containsJob"] as! Bool
                        let containsOutcome = sentence["containsOutcome"] as! Bool
                        let containsTechnology = sentence["containsTechnology"] as! Bool
                        let containsSolution = sentence["containsSolution"] as! Bool
                        
                        if containsSegment {
                            classifications.append(.segment)
                        }
                        if containsJob {
                            classifications.append(.job)
                        }
                        if containsOutcome {
                            classifications.append(.outcome)
                        }
                        if containsSolution {
                            classifications.append(.solution)
                        }
                        if containsTechnology {
                            classifications.append(.technology)
                        }
                        if containsInvestment {
                            classifications.append(.investment)
                        }
                        let sentenceModel = SentenceModel(id: UUID(uuidString: id)!, text: text, classifications: classifications)
                        let sentenceViewModel = SentenceViewModel(sentenceModel: sentenceModel)
                        sentences.append(sentenceViewModel)
                    }
                    
                    sentences.forEach {
                        sentence in
                        if sentence.containsSegment {
                            self.segmentSentences.append(sentence)
                        }
                        if sentence.containsJob {
                            self.jobSentences.append(sentence)
                            let sentenceCards = self.jobToBeDoneCardCreator.extractCards(from: sentence.sentence)
                            sentenceCards.forEach {
                                card in
                                self.jobToBeDoneCards.append(card)
                            }
                        }
                        if sentence.containsOutcome {
                            self.outcomeSentences.append(sentence)
                        }
                        if sentence.containsSolution {
                            self.solutionSentences.append(sentence)
                        }
                        if sentence.containsTechnology {
                            self.technologySentences.append(sentence)
                        }
                        if sentence.containsInvestment {
                            self.investmentSentences.append(sentence)
                        }
                    }
                    completion(sentences)
                }else {
                    print (">>> FINALIZOU QUERY <<<")
                    print("Error:\(String(describing: error))")
                }
            }
        }
        database.add(operation)
    }
    
    private func loadNews(completion: @escaping (NewsViewModel) -> ()) {
        let container = CKContainer(identifier: "iCloud.br.ufpe.cin.StartseNewsClassifier")
        let database = container.privateCloudDatabase
        
        let predicate = NSPredicate(format: "isClassified == true")
        
        let query = CKQuery(recordType: "News", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        
        operation.recordFetchedBlock = {
            record in
            self.newsRecord = record
        }
        
        operation.queryCompletionBlock = {
            cursor, error in
            
            DispatchQueue.main.async {
                if (error == nil) {
                    print(">>> Finalizou com Sucesso <<<")
                    do {
                        let newsViewModel = try NewsViewModel(record: self.newsRecord!)
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
