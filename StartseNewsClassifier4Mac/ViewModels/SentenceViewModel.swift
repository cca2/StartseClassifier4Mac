//
//  SentenceViewModel.swift
//  StartseNewsClassifier
//
//  Created by Cristiano Araújo on 24/10/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation

class SentenceViewModel: ObservableObject, Identifiable {
    @Published var sentence:SentenceModel
    
    var text: String {
        return sentence.text
    }
    
    var id: UUID {
        return sentence.id
    }
    
    var containsSegment: Bool {
        return sentence.classifications.contains(.segment)
    }
    
    var containsProblem: Bool {
        return sentence.classifications.contains(.problem)
    }
    
    var containsSolution: Bool {
        return sentence.classifications.contains(.solution)
    }
    
    var containsTechnology: Bool {
        return sentence.classifications.contains(.technology)
    }
    
    var containsInvestment: Bool {
        return sentence.classifications.contains(.investment)
    }
    
    init(sentenceModel:SentenceModel) {
        self.sentence = sentenceModel
    }

    func removeClassification(classification: SentenceModel.Classification) {
        guard let index = sentence.classifications.firstIndex(of: classification) else { return }
        sentence.classifications.remove(at: index)
    }
    
    func classifySentenceAs(tag:SentenceModel.Classification) {
        if sentence.classifications.contains(tag) {
            //aqui: parece não fazer sentido remover todas as classificações
            sentence.classifications.removeAll() {
                classification in
                print (classification)
                return true
            }
        }else {
            sentence.classifications.append(tag)
        }
    }
}
