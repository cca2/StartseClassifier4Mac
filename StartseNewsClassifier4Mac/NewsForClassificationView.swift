//
//  NewsForClassificationView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 09/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct NewsCellView: View {
    @State var news:NewsViewModel
    @Binding var selectedNews:NewsViewModel?

    var body: some View {
        SelectedNewsCellView(news: news, selectedNews: $selectedNews)
    }
}

struct NewsBeingShown: View {
    @Binding var news:NewsViewModel?

    var body: some View {
        return VStack (alignment: .leading) {
            if news != nil {
                VStack {
                    VStack {
                        Text(news!.title).font(.system(size: 30)).bold()
                        Text(news!.subtitle).font(.system(size: 20))
                    }
                }.frame(width: 400)
                Divider()
                ScrollView {
                    Text(news!.text).font(.system(size: 16))
                }
            }else {
                Text("Não há notícias para classificar")
            }
            Spacer()
        }.padding([.top, .trailing])
    }
}

struct SelectedNewsCellView: View {
    @State var news:NewsViewModel

    @Binding var selectedNews:NewsViewModel?
    
    @State var backgroundColor = Color.white
    @State var foregroundColor = Color.black
    
    var body: some View {
        if news == selectedNews {
            return VStack (alignment: .leading) {
                VStack {
                    Text(news.title).font(.system(size: 12)).bold()
                    Text(news.subtitle).font(.system(size:10))
                }.padding()
            }.frame(width: 280).background(Color.white).foregroundColor(Color.black)
                .onTapGesture {
                    self.selectedNews = self.news
            }
        }else {
            return VStack (alignment: .leading) {
                VStack {
                    Text(news.title).font(.system(size: 12)).bold()
                    Text(news.subtitle).font(.system(size:10))
                }.padding()
            }.frame(width: 280).background(Color.black).foregroundColor(Color.white)
                .onTapGesture {
                    self.selectedNews = self.news
            }

        }
    }
}

struct NonSelectedNewsCellView: View {
    @State var news:NewsViewModel

    @Binding var selectedNews:NewsViewModel?
    
    @State var backgroundColor = Color.black
    @State var foregroundColor = Color.white
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack {
                Text(news.title).font(.system(size: 12)).bold()
                Text(news.subtitle).font(.system(size:10))
            }.padding()
        }.frame(width: 280).background(backgroundColor).foregroundColor(foregroundColor)
            .onTapGesture {
                self.selectedNews = self.news
        }
    }
}

struct NewsForClassificationView: View {
    let newsForClassification = NewsForClassificationViewModel()
    
    @State var newsList:[NewsViewModel]
    @State var selectedNewsIndex = 0
    
    @State var selectedNews:NewsViewModel?
    
    @State var isSavingForClassification:Bool = false
    
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
                        NewsCellView(news: news, selectedNews: self.$selectedNews)
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
                    if (!self.isSavingForClassification) {
                        NewsBeingShown(news: $selectedNews)
                    }else {
//                        HStack {
                            VStack (alignment: .center) {
                                Text("Salvando notícia para classificação").font(.system(size: 24))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                            .background(Color.red)
//                        }
                    }
                    Spacer()
                    Divider()
                    VStack {
                        Button(action: saveForClassification
                        , label: {Text("Classificar").frame(width:80)})
                        Button(action: {}, label: {Text("Apagar").frame(width: 80)})
                        Spacer()
                    }.padding()
                }
            }
        }
    }
    
    func saveForClassification() {
        self.isSavingForClassification = true
        newsForClassification.saveForClassification(news: selectedNews!, completion: {
            self.newsList.removeAll{
                $0 == self.selectedNews
            }
            self.selectedNews = self.newsList.first
            self.isSavingForClassification = false
        })
    }
}

struct NewsForClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        NewsForClassificationView(newsList: [NewsViewModel(newsModel: NewsModel(news_id: UUID().uuidString.uppercased(), title: "Conheça a Mission Barns, startup que está criando carne em laboratório", subtitle: "Startup foi criada em 2018, na universidade de Berkeley (EUA) e cultivo de origem animal para a produção de carne", link: "http://www.cin.ufpe.br", text: "Texto da notícia a ser classificada", links: [], links_text: []))])
    }
}
