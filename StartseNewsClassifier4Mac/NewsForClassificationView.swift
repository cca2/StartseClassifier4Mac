//
//  NewsForClassificationView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 09/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct NewsForClassificationView: View {
    @State var title:String = "Conheça a Mission Barns, startup que está criando carne em laboratório"
    @State var subtitle:String = "Startup foi criada em 2018, na universidade de Berkeley (EUA) e cultivo de origem animal para a produção de carne"
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("95").font(.system(size: 30)).bold()
                    Text("Notícias faltando").font(.system(size: 18))
                }.padding()
                Divider()
                List {
                    ForEach(0..<10) {_ in
                        VStack (alignment: .leading) {
                            Text(self.title).font(.system(size: 16)).bold()
                            Text(self.subtitle).font(.body)
                        }.frame(width: 290)
                        Divider()
                    }
                }
            }.frame(width: 300, alignment: .leading)
            Divider()
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        VStack {
                            Text(self.title).font(.title)
                            Text(self.subtitle).font(.subheadline)
                        }.frame(width: 400)
                        VStack {
                            Text("Texto da notícia a ser classificada")
                        }
                        Spacer()
                    }.padding([.top, .trailing])
                    Spacer()
                    Divider()
                    VStack {
                        Button(action: {}, label: {Text("Classificar").frame(width:80)})
                        Button(action: {}, label: {Text("Apagar").frame(width: 80)})
                        Spacer()
                    }.padding()
                }
            }.background(Color.red)
        }
    }
}

struct NewsForClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        NewsForClassificationView()
    }
}
