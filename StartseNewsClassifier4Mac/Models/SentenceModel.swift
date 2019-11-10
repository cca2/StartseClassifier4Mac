//
//  SentenceModel.swift
//  StartseNewsClassifier
//
//  Created by Cristiano Araújo on 18/10/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation

class SentenceModel: Identifiable, Decodable {
    let id:UUID
    var text:String
    
    var classifications:[Classification]
    
    enum Classification:String, Decodable, Encodable, CaseIterable {
        case none = "#None"
        case segment = "#Segment"
        case problem = "#Problem"
        case solution = "#Features"
        case technology = "#Technology"
        case investment = "#Investment"
        case partnership = "#Partnership"
        
        init?(id: Int) {
            switch id {
            case 1: self = .segment
            case 2: self = .problem
            case 3: self = .solution
            case 4: self = .technology
            case 5: self = .investment
            case 6: self = .partnership
            default:
                self = .none
            }
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case classifications
    }
    
    
    init(text:String, classifications:[SentenceModel.Classification]) {
        self.id = UUID()
        self.text = text
        self.classifications = classifications
    }
    
    init (id:UUID, text:String, classifications:[SentenceModel.Classification]) {
        self.text = text
        self.classifications = classifications
        self.id = id
    }
}

extension SentenceModel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(classifications, forKey: .classifications)
    }
}
