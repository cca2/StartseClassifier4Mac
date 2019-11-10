//
//  NewsForClassificationView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 09/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct NewsCellView: View {
    @State var title:String
    @State var subtitle:String
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                Text(title).font(.system(size: 12)).bold()
                Text(subtitle).font(.system(size:10))
            }.padding()
        }.frame(width: 280)
            .onTapGesture {
                print("dei um toque")
        }
    }
}

struct NewsBeingShown: View {
    @Binding var news:NewsViewModel?

    var body: some View {
        return VStack (alignment: .leading) {
            if news != nil {
                VStack { Text(news!.title).font(.title)
                    Text(news!.subtitle).font(.subheadline)
                }.frame(width: 400)
                VStack {
                    Text(news!.text)
                }
            }else {
                Text("Não há notícias para classificar")
            }
            Spacer()
        }.padding([.top, .trailing])
    }
}

struct SelectedNewsCellView: View {
    @State var title:String
    @State var subtitle:String
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                Text(title).font(.system(size: 12)).bold()
                Text(subtitle).font(.system(size:10))
            }.padding()
        }.frame(width: 280).background(Color.white).foregroundColor(.black)
            .onTapGesture {
                print("dei um toque")
        }
    }
}

struct NewsForClassificationView: View {
    let newsForClassification = NewsForClassificationViewModel()
    
    @State var newsList:[NewsViewModel]
    @State var selectedNewsIndex = 0
    
    @State var selectedNews:NewsViewModel?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(newsList.count)").font(.system(size: 30)).bold()
                    Text("Notícias faltando").font(.system(size: 18))
                }.padding()
                Divider()
                List {
                    ForEach(newsList) {news in
                        SelectedNewsCellView(title: news.title, subtitle: news.subtitle)
                        Divider()
                    }
                }.onAppear() {
                    self.newsList = self.newsForClassification.newsList
                    self.selectedNews = self.newsList.first
                }
            }.frame(width: 300, alignment: .leading)
            Divider()
            VStack {
                HStack {
                    NewsBeingShown(news: $selectedNews)
//                    VStack (alignment: .leading) {
//                        VStack { Text(self.newsList[self.selectedNewsIndex].title).font(.title)
//                        Text(self.newsList[self.selectedNewsIndex].subtitle).font(.subheadline)
//                        }.frame(width: 400)
//                        VStack {
//                            Text(self.newsList[self.selectedNewsIndex].text)
//                        }
//                        Spacer()
//                    }.padding([.top, .trailing])
                    Spacer()
                    Divider()
                    VStack {
                        Button(action: {
                            NSOpenPanel().runModal()
                        }, label: {Text("Classificar").frame(width:80)})
                        Button(action: {}, label: {Text("Apagar").frame(width: 80)})
                        Spacer()
                    }.padding()
                }
            }
        }
    }
}

struct NewsForClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        NewsForClassificationView(newsList: [NewsViewModel(newsModel: NewsModel(news_id: UUID().uuidString.uppercased(), title: "Conheça a Mission Barns, startup que está criando carne em laboratório", subtitle: "Startup foi criada em 2018, na universidade de Berkeley (EUA) e cultivo de origem animal para a produção de carne", link: "http://www.cin.ufpe.br", text: "Texto da notícia a ser classificada", links: [], links_text: []))])
    }
}
