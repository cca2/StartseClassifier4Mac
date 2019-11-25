//
//  ConsolidationViewModel.swift
//  StartseNewsClassifier
//
//  Created by Cristiano Araújo on 05/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation
import CoreData

class ConsolidationViewModel: ObservableObject {
    private var context:NSManagedObjectContext
    
    @Published var filterSelection:Int = 0
    
    var filteredSentences:[SentenceViewModel] {
        return fetchSentences()
    }
    
    var title:String {
        var title = ""
        if self.filterSelection == 0 {
            title = "Segmento de Clientes"
        }else if self.filterSelection == 1 {
            title = "Dor ou Desejo"
        }
        
        return title
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchSentences() -> [SentenceViewModel]{
        var result:[SentenceViewModel] = []
        let request = NSFetchRequest<SentenceData>(entityName: "SentenceData")
        var predicate:NSPredicate!
        if filterSelection == 0 {
            predicate = NSPredicate(format: "containsSegment == true")
        }else if filterSelection == 1 {
            predicate = NSPredicate(format: "containsJob == true")
        }else if filterSelection == 2 {
            predicate = NSPredicate(format: "containsOutcome == true")
        }else if filterSelection == 3 {
            predicate = NSPredicate(format: "containsSolution == true")
        }else if filterSelection == 4 {
            predicate = NSPredicate(format: "containsTechnology == true")
        }else if filterSelection == 5 {
            predicate = NSPredicate(format: "containsInvestment == true")
        }
        request.predicate = predicate
        
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
