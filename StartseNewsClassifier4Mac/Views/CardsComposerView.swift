//
//  CardsComposerView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 24/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct CardsComposerView: View {
    @ObservedObject var news2Compose:ComposingCardsViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var title:String = "Título"
    @State var subtitle:String = "Subtítulo"
    @State var text:String = "texto"
    
    @State var sentences:[SentenceViewModel] = [SentenceViewModel(sentenceModel: SentenceModel(id: UUID(), text: "Esta é uma sentença muito legal", classifications: [.segment])), SentenceViewModel(sentenceModel: SentenceModel(id: UUID(), text: "Esta é uma sentença muito legal", classifications: [.segment]))]
    
    init() {
//        self.news2Compose = nil
        self.news2Compose = ComposingCardsViewModel()
        let sentence1 = SentenceViewModel(sentenceModel: SentenceModel(id: UUID(), text: "Esta é uma sentença muito legal", classifications: [.segment]))
        self.sentences.append(sentence1)
    }
    
//    init(context:NSManagedObjectContext) {
//        self.news2Compose = ComposingCardsViewModel(context: context)
//    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Notícia").font(.title).padding()
                }
                Divider()
                Spacer()
                VStack {
                    if (!self.news2Compose.hasLoadedNews) {
                        Text(title).font(.body).bold()
                        Text(subtitle).font(.body)
                    }else {
                        Text(self.news2Compose.news!.title)
                        Text(self.news2Compose.news!.subtitle)
                    }
                }.padding()
                Divider()
                ScrollView {
                    if (self.news2Compose.hasLoadedNews) {
                        Text(self.news2Compose.news!.text)
                    }else {
                        Text(text)
                    }
//                    Text(text)
                }.padding()
                Spacer()
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 600, maxHeight: .infinity, alignment: .center)
            Divider()
            VStack {
                VStack {
                    if self.news2Compose.classificationFilter == .segment {
                        Text("Segmentos de Consumidor").font(.title).padding()
                    }else if self.news2Compose.classificationFilter == .job {
                        Text("Job to be done").font(.title).padding()
                    }else if self.news2Compose.classificationFilter == .outcome {
                        Text("Resultado Desejado").font(.title).padding()
                    }else if self.news2Compose.classificationFilter == .solution {
                        Text("Solução & Features").font(.title).padding()
                    }else if self.news2Compose.classificationFilter == .technology {
                        Text("Tecnologia").font(.title).padding()
                    }else if self.news2Compose.classificationFilter == .investment {
                        Text("Investimento").font(.title).padding()
                    }
                    HStack {
                        Button(action: {self.news2Compose.classificationFilter = .segment}, label: {Text("segmentos")})
                        Button(action: {self.news2Compose.classificationFilter = .job}, label: {Text("job to be done")})
                        Button(action: {self.news2Compose.classificationFilter = .outcome}, label: {Text("resultado")})
                        Button(action: {self.news2Compose.classificationFilter = .solution}, label: {Text("solução & features")})
                        Button(action: {self.news2Compose.classificationFilter = .technology}, label: {Text("tecnologia")})
                        Button(action: {self.news2Compose.classificationFilter = .investment}, label: {Text("investimento")})
                    }
                }
                Divider()
                HStack {
                    VStack{
                        Text("Sentenças").font(.title)
                        if self.news2Compose.classificationFilter == .segment {
                            List {
                                ForEach(self.news2Compose.segmentSentences) {
                                    sentence in
                                    VStack {
                                        Text(sentence.text)
                                            .frame(width:190)
                                        Divider()
                                    }
                                }
                            }
                        }else if self.news2Compose.classificationFilter == .job {
                            List {
                                ForEach(self.news2Compose.jobSentences) {
                                    sentence in
                                    VStack {
                                        Text(sentence.text)
                                            .frame(width:190)
                                        Divider()
                                    }
                                }
                            }
                        }else if self.news2Compose.classificationFilter == .outcome {
                            List {
                                ForEach(self.news2Compose.outcomeSentences) {
                                    sentence in
                                    VStack {
                                        Text(sentence.text)
                                            .frame(width:190)
                                        Divider()
                                    }
                                }
                            }
                        }else if self.news2Compose.classificationFilter == .solution {
                            List {
                                ForEach(self.news2Compose.solutionSentences) {
                                    sentence in
                                    VStack {
                                        Text(sentence.text)
                                            .frame(width:190)
                                        Divider()
                                    }
                                }
                            }
                        }else if self.news2Compose.classificationFilter == .technology {
                            List {
                                ForEach(self.news2Compose.technologySentences) {
                                    sentence in
                                    VStack {
                                        Text(sentence.text)
                                            .frame(width:190)
                                        Divider()
                                    }
                                }
                            }
                        }else if self.news2Compose.classificationFilter == .investment {
                            List {
                                ForEach(self.news2Compose.investmentSentences) {
                                    sentence in
                                    VStack {
                                        Text(sentence.text)
                                            .frame(width:190)
                                        Divider()
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(minWidth: 200, idealWidth: 100, maxWidth: 200, alignment: .center)
                    Divider()
                    VStack{
                        Text("Termos").font(.title)
                        Spacer()
                    }
                    .frame(minWidth: 200, idealWidth: 100, maxWidth: 200, alignment: .center)
                    Divider()
                    Spacer()
                    VStack (alignment: .center){
                        Text("Cartões").font(.title)
                        HStack {
                            CardView(text: "Farmácias", imageName: "segmento-farmacia")
                            CardView(text: "Clínicas", imageName: "segmento-clinica-medica")
                        }
                        HStack {
                            CardView(text: "Distribuidor de medicamento", imageName: "segmento-distribuidora")
                            CardView(text: "Fabricante de medicamentos", imageName: "segmento-fabricante")
                        }
                        HStack {
                            CardView(text: "Consumidor de medicamentos", imageName: "fotoCris")
                            EmptyCardView()
                        }
                        Spacer()
                    }.frame(minWidth: 0, maxWidth: .infinity)
                }
                Spacer()
            }.frame(minWidth: 1200, maxWidth: .infinity)
        }.onAppear() {
            self.news2Compose.managedObjectContext = self.context
//            if let news2Compose = self.news2Compose {
//                self.title = news2Compose.news.title
//                self.subtitle = news2Compose.news.subtitle
//                self.text = news2Compose.news.text
//                self.sentences = news2Compose.sentences
//            }
        }
    }
}

struct EmptyCardView: View {
    var body: some View {
        HStack (alignment: .center) {
            Text("novo segmento")
                .frame(width:300, height: 150)
                .background(Color.white)
                .foregroundColor(.black)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, alignment: .center)
    }
}
struct CardView: View {
    @State var text:String
    @State var imageName:String
    
    var body: some View {
        HStack (alignment: .center){
            HStack (alignment: .center, spacing: 0){
                Image(imageName)
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                
                ZStack {
                    Text(text)
                        .foregroundColor(.black)
                    .frame(width: 150, height: 150)
                    .background(Color.white)
                    
                    Text("Segmento").foregroundColor(.gray).font(.system(size: 11))
                    .frame(width: 150, height: 150, alignment: .leading)
                    .offset(x: 10, y: -60)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, alignment: .center)
    }
}

struct CardsComposerView_Previews: PreviewProvider {
    static var previews: some View {
        CardsComposerView()
    }
}
