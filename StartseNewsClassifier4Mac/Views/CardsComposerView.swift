//
//  CardsComposerView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 24/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct CardsComposerView: View {
    private let news2Compose:ComposingCardsViewModel?
  
    @State var title:String = "Título"
    @State var subtitle:String = "Subtítulo"
    @State var text:String = "texto"
    
    @State var sentences:[SentenceViewModel] = [SentenceViewModel(sentenceModel: SentenceModel(id: UUID(), text: "Esta é uma sentença muito legal", classifications: [.segment])), SentenceViewModel(sentenceModel: SentenceModel(id: UUID(), text: "Esta é uma sentença muito legal", classifications: [.segment]))]
    
    init() {
        self.news2Compose = nil
        
        let sentence1 = SentenceViewModel(sentenceModel: SentenceModel(id: UUID(), text: "Esta é uma sentença muito legal", classifications: [.segment]))
        self.sentences.append(sentence1)
    }
    
    init(context:NSManagedObjectContext) {
        self.news2Compose = ComposingCardsViewModel(context: context)
    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Notícia").font(.title).padding()
                }
                Divider()
                Spacer()
                VStack {
                    Text(title).font(.body).bold()
//                    Text(subtitle).font(.body)
                }.padding()
                Divider()
                ScrollView {
                    Text(text)
                }.padding()
                Spacer()
            }.frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 600, maxHeight: .infinity, alignment: .center)
            Divider()
            VStack {
                Text("Segmentos de Consumidor").font(.title).padding()
                Divider()
                HStack {
                    VStack{
                        Text("Sentenças").font(.title)
                        List {
                            ForEach(sentences) {
                                sentence in
                                VStack {
                                    Text(sentence.text)
                                        .frame(width:190)
                                    Divider()
                                }
                            }
                        }
                        Spacer()
                    }.frame(minWidth: 200, idealWidth: 100, maxWidth: 200, alignment: .center)
                    Divider()
                    VStack{
                        Text("Termos").font(.title)
                        Spacer()
                    }.frame(minWidth: 200, idealWidth: 100, maxWidth: 200, alignment: .center)
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
                        }
                        Spacer()
                    }.frame(minWidth: 0, maxWidth: .infinity)
                }
                Spacer()
            }.frame(minWidth: 1200, maxWidth: .infinity)
        }.onAppear() {
            if let news2Compose = self.news2Compose {
                self.title = news2Compose.news.title
                self.subtitle = news2Compose.news.subtitle
                self.text = news2Compose.news.text
                self.sentences = news2Compose.sentences
            }
        }
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
                    
                    Text("Segmento").bold().foregroundColor(.black)
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
