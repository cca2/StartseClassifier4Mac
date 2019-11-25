//
//  CardsComposerView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 24/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct CardsComposerView: View {
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("Notícia").font(.title).padding()
                }
                Divider()
                Spacer()
                VStack {
                    Text("Tesla revela a Cybertruck, sua picape futurista e à prova de balas").font(.body).bold()
                    Text("A picape elétrica com autonomia da Tesla terá o preço inicial de US$ 39.900 e começará a ser fabricada no fim de 2021").font(.body)
                }.padding()
                Divider()
                ScrollView {
                    Text("A Tesla revelou, na noite desta quinta-feira (21), sua picape futurista aguardada (e planejada) por anos por Elon Musk. Chamado de “Cybertruck”, o veículo é feito de aço inoxidável ultrarresistente — a carroceria levou marteladas de Franz von Holzhausen, chefe de design da Tesla, no evento de lançamento. Musk, CEO da Tesla, afirmou que a carcaça é à prova de balas. \n O vidro também foi projetado para conter grandes impactos — no evento, Holzhausen jogou uma bola de metal para comprovar, mas o vidro acabou trincando. Elon Musk afirmou que o vidro seria aprimorado até o lançamento — a fabricação do veículo iniciará no fim de 2021. \n O veículo foi criado para unir resistência e rapidez. Com versões de um, dois ou três motores elétricos, o Cybertruck poderá ter tração traseira ou integral. A aceleração irá de 0 a 96 km/h em 2,9 segundos. Na versão completa, com três motores, a autonomia é de 800 km, com velocidade máxima de 209 km/h.")
                }.padding()
                Spacer()
            }.frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 600, maxHeight: .infinity, alignment: .center)
            Divider()
            VStack {
                Text("Segmentos de Consumidor").font(.title).padding()
                Divider()
                HStack {
                    VStack{
                        Text("Sentença").font(.title)
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
                            CardView()
                            CardView()
                        }
                        HStack {
                            CardView()
                            CardView()
                        }
                        HStack {
                            CardView()
                            CardView()
                        }
                        Spacer()

                    }.frame(minWidth: 0, maxWidth: .infinity)
                }
                Spacer()
            }.frame(minWidth: 1200, maxWidth: .infinity)
        }
    }
}

struct CardView: View {
    var body: some View {
        HStack (alignment: .center){
            HStack (alignment: .center, spacing: 0){
                Image("fotoCris")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                
                ZStack {
                    Text("Consumidor de medicamentos")
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
