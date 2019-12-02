//
//  JobToBeDoneCardViewModel.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 01/12/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation
import NaturalLanguage

class JobToBeDoneCardViewModel: Identifiable {
    let id:UUID!
    let category:SentenceModel.Classification
    let sentence:SentenceModel!
    
    var verb:(NLTag, String)!
    var noum:(NLTag, String)!
    var contextClarifier:[(NLTag,String)] = []

    var text:String {
        var res = ""
        res += verb.1
        res += " \(noum.1)"
        contextClarifier.forEach {
            tag in
            if tag.0 == .punctuation {
                res += tag.1
            }else {
                res += " \(tag.1)"
            }
        }
        return res
    }
    
    init(sentence:SentenceModel, category:SentenceModel.Classification) {
        self.category = category
        self.sentence = sentence
        self.id = sentence.id
    }
}

class JobToBeDoneCardCreator {
    let verbsToIgnore = ["utilizar", "poder", "ser", "permitir", "possuir", "ter", "estar", "aumentar", "melhorar", "existir", "usar", "ajudar"]
    let notAPortugueseVerb = ["item", "similar"]
    let name2VerbDict:[String:String] = ["verificação de": "verificar", "verificação da": "verificar a", "verificação do": "verificar o"]
    
    let notAVerb = ["IA"]
    var cards:[JobToBeDoneCardViewModel] = []
    
    
    func extractCards(from sentence:SentenceModel) -> [JobToBeDoneCardViewModel] {
        var res:[JobToBeDoneCardViewModel] = []

        let text = self.replaceGerunds(sentence: sentence.text)

        Swift.print(">>> 10 \(text)")
        let sequences = self.separateByPunctuation(sentence: text)
        Swift.print(">>> 20 \(sequences)")

        var sequencesByVerb:[String] = []
        sequences.forEach {
            sequence in
            let sequenceByVerb = self.separateByVerb(sentence: sequence)
            sequencesByVerb.append(contentsOf: sequenceByVerb)
        }
        Swift.print(">>> 30 \(sequencesByVerb)")

        let sequencesWithVerb = self.eliminateSentencesWithNoVerbs(sentences: sequencesByVerb)
        Swift.print(">>> 40 \(sequencesWithVerb)")

        let sequencesWithOtherThanVerb = self.eliminateSentenceWithOnlyVerbs(sentences: sequencesWithVerb)
        Swift.print(">>> 50 \(sequencesWithOtherThanVerb)")

        let sentencesWithSequenceVerbNoun = self.eliminateSentenceWithNoSequenceVerbNoum(sentences: sequencesWithOtherThanVerb)
        Swift.print(">>> 60 \(sentencesWithSequenceVerbNoun)")


        sentencesWithSequenceVerbNoun.forEach {
            text in
            let card = self.identifyVerbObjectContextClarifier(originalSentence: sentence, refinedText: text)
            
            if let card = card {
                Swift.print(card.text)
                res.append(card)
            }
        }
        return res
    }

    private func processSentence(sentence:String) -> String {
        var res = ""
        res = sentence.replacingOccurrences(of: "verificação da", with: name2VerbDict["verificação da"]!)
        return res
    }
    
    private func identifyVerbObjectContextClarifier(originalSentence:SentenceModel, refinedText:String) -> JobToBeDoneCardViewModel? {
        var card:JobToBeDoneCardViewModel? = JobToBeDoneCardViewModel(sentence: originalSentence, category: .job)
        var tags:[(NLTag, String)] = []
        
        let sentence = refinedText
        
        let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma, .nameType])
        tagger.string = sentence
        let range = sentence.startIndex ..< sentence.endIndex

        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: [.omitWhitespace]) {
            (tag, range) in

            if let tag = tag {
                if tag != .determiner {
                    tags.append((tag, String(sentence[range])))
                }
            }
            return true
        }
        //procura verbo
        var verbTag:(NLTag, String)?
        var nounTag:(NLTag, String)?
        var contextClarifierTags:[(NLTag, String)] = []
        tags.forEach {
            tag in
            if verbTag == nil {
                if tag.0 == .verb {
                    verbTag = tag
                }
            }else if nounTag == nil {
                if tag.0 == .noun {
                    nounTag = tag
                }
//                else {
//                    verbTag = nil
//                }
            }else {
                contextClarifierTags.append(tag)
            }
        }
        if let verbTag = verbTag {
            card!.verb = verbTag
            if let nounTag = nounTag {
                card!.noum = nounTag
            }else {
                card = nil
            }
            card!.contextClarifier = contextClarifierTags
        }else {
            card = nil
        }
        
        if let card = card {
            let ignoreCharacters:[NLTag] = [.punctuation, .whitespace, .sentenceTerminator, .openQuote, .conjunction, .pronoun, .preposition]
            if card.contextClarifier.count != 0 {
                while (ignoreCharacters.contains(card.contextClarifier.last!.0)) {
                    card.contextClarifier.removeLast()
                    if card.contextClarifier.count == 0 {
                        break
                    }
                }
            }
        }

        return card
    }

    private func eliminateDeterminers(sentence:String) -> String {
        var res = ""
        let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
        tagger.string = sentence
        let range = sentence.startIndex ..< sentence.endIndex
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass) {
            (tag, range) in
            if let tag = tag {
                if tag != .determiner && tag != .adverb && tag != .pronoun {
                    res += sentence[range]
                }
            }
            return true
        }
        res = res.replacingOccurrences(of: "  ", with: " ")
        return res
    }
    
    private func replaceGerunds(sentence:String) -> String {
        var res = ""
        res = sentence.replacingOccurrences(of: "ando", with: "ar")
        return res
    }
    
    private func separateByPunctuation(sentence:String) -> [String] {
        var res:[String] = []
        let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
        tagger.string = sentence
        let range = sentence.startIndex ..< sentence.endIndex
        var s:String = ""
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass) {
            (tag, range) in
            if let tag = tag {
                if tag != .punctuation && tag != .sentenceTerminator {
                    s += sentence[range]
                }else {
                    let sequenceElement = ("\(s)").trimmingCharacters(in: .whitespacesAndNewlines)
                    res.append(sequenceElement)
                    s = ""
                }
            }
            return true
        }
        
        if s != "" {
            let sequenceElement = ("\(s)").trimmingCharacters(in: .whitespacesAndNewlines)
            res.append(sequenceElement)
        }
        return res
    }
    
    private func separateByVerb(sentence:String) -> [String] {
        var res:[String] = []
        let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
        tagger.string = sentence
        let range = sentence.startIndex ..< sentence.endIndex
        var s:String = ""
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass) {
            (tag, range) in
            if let tag = tag {
                if tag == .verb {
                    if s != "" {
                        res.append("\(s.trimmingCharacters(in: .whitespacesAndNewlines))")
                    }
                    s = "\(sentence[range])"
                    s = lemmatizeVerb(word: s)
                }else {
                    s += "\(sentence[range])"
                }
            }
            return true
        }
        if s != "" {
            res.append("\(s.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
        return res
    }
    
    private func joinToBeVerbs(sentences:[String]) -> [String] {
        var res:[String] = []
        
        return res
    }
    
    private func eliminateSentencesWithNoVerbs(sentences:[String]) -> [String] {
        var res:[String] = []
        sentences.forEach {
            sentence in
            let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
            tagger.string = sentence
            let range = sentence.startIndex ..< sentence.endIndex
            var containsVerb = false
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass) {
                (tag, range) in
                if let tag = tag {
                    if tag == .verb {
                        containsVerb = true
                    }
                }
                return true
            }
            if containsVerb {
                res.append(sentence)
            }
        }
        return res
    }
    
    func eliminateSentenceWithOnlyVerbs(sentences:[String]) -> [String] {
        var res:[String] = []
        sentences.forEach {
            sentence in
            let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
            tagger.string = sentence
            let range = sentence.startIndex ..< sentence.endIndex
            var containsOtherThanVerb = false
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass) {
                (tag, range) in
                if let tag = tag {
                    if tag != .verb {
                        containsOtherThanVerb = true
                    }
                }
                return true
            }
            if containsOtherThanVerb {
                res.append(sentence)
            }
        }
        return res
    }
    
    private func eliminateSentenceWithNoSequenceVerbNoum(sentences:[String]) -> [String] {
        var res:[String] = []
        sentences.forEach {
            sentence in
            var tags:[(NLTag, String)] = []
            let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
            tagger.string = sentence
            let range = sentence.startIndex ..< sentence.endIndex
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: [.omitWhitespace, .omitPunctuation, .joinNames, .joinContractions]) {
                (tag, range) in
                if let tag = tag {
                    tags.append((tag, String(sentence[range])))
                }
                return true
            }
            
            if (tags[0].0 == .verb) {
                let containsTag = tags.contains {
                    tag in
                    if tag.0 == .noun {
                        return true
                    }else {
                        return false
                    }
                }
                
                if containsTag {
                    res.append(sentence)
                }
            }
        }
        return res
    }
    
    private func lemmatizeVerb(word:String) -> String {
        let word = word
        var res = ""
        let tagger = NLTagger(tagSchemes: [.nameTypeOrLexicalClass, .lexicalClass, .lemma])
        tagger.string = word
        let range = word.startIndex ..< word.endIndex
        tagger.setLanguage(.portuguese, range: range)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: [.omitWhitespace, .omitPunctuation]) {
            (tag, range) in
            if let tag = tag {
                res = tag.rawValue
            }else {
                res = word
            }
            return true
        }
        if let last = res.last {
            if last != "r" {
                res.append("r")
            }
        }
        return res
    }
    
    func print() {
        var index = 1
        cards.forEach {
            card in
            Swift.print("\(index): \(card.text)")
            index += 1
        }
    }
}
