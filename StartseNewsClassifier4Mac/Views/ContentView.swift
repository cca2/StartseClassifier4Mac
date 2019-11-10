//
//  ContentView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 08/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //Comentado apenas para ver o preview
    @Environment(\.managedObjectContext) var context

    @State var texts:[String] = ["Cristiano", "Coelho", "Araújo"]
    
    var body: some View {
        NewsForClassificationView(newsList: [NewsViewModel(newsModel: NewsModel(news_id: UUID().uuidString.uppercased(), title: "Conheça a Mission Barns, startup que está criando carne em laboratório", subtitle: "Startup foi criada em 2018, na universidade de Berkeley (EUA) e cultivo de origem animal para a produção de carne", link: "http://www.cin.ufpe.br", text: "Texto da notícia a ser classificada", links: [], links_text: []))])
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
