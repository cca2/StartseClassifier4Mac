//
//  StudentView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 19/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct MoodBoardCardView: View {
    let text:String
    let backgroundColor:Color
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .padding()
            .frame(width: 200, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(backgroundColor)
            )
    }
}

struct StudentView: View {
    let bigIdea:String = "Educação do Futuro"
    
    var body: some View {
        HStack {
            VStack {
                Rectangle()
                    .frame(width: 100, height: 80, alignment: .center)
                Group {
                    Text("Cristiano Araújo")
                    Text("E. Computação")
                }.frame(alignment: .leading)
                Spacer()
            }.frame(width: 100)
            Divider()
            VStack {
                HStack {
                    Text("Mood Board:").font(.title)
                    Text(bigIdea).font(.title).bold()
                }.padding([.bottom], 30)
                HStack {
                    VStack (spacing: 10) {
                        Text("Investimentos")
                        MoodBoardCardView(text:"A Arco Educação, empresa brasileira de soluções para educação, anunciou nesta terça-feira (7) a aquisição do Sistema Positivo de Ensino por R$ 1,65 bilhão.", backgroundColor: .orange)
                        Spacer()
                    }.frame(minHeight: 0, maxHeight: .infinity)
                    VStack (spacing: 10) {
                        Text("Consumidores")
                        MoodBoardCardView(text:"Em junho deste ano, a Udemy, marketplace global de cursos online, abriu o seu primeiro escritório focado em negócios. O local escolhido foi São Paulo. O motivo? O Brasil começou a despontar como um mercado promissor em educação online.", backgroundColor: .red)
                        MoodBoardCardView(text:"Joystreet recebe R$ 50 milhões em investimento", backgroundColor: .red)
                            Spacer()
                    }.frame(minHeight: 0, maxHeight: .infinity)
                    VStack (spacing: 10) {
                        Text("Job to be done")
                        MoodBoardCardView(text:"Alguns problemas no Brasil permanecem. Em educação, as pessoas têm menos alternativas. Quando você está no interior, às vezes não tem uma escola perto, e o ensino à distância, por meio das edtechs, te dá uma ponte muito mais forte", backgroundColor: .green)
                        Spacer()
                    }.frame(minHeight: 0, maxHeight: .infinity)
                    VStack (spacing: 10) {
                        Text("Resultados")
                        MoodBoardCardView(text:"Ambiente gamificado de cursos para formação inovadora no ensino técnico, no superior e nas corporações. Inovamos o EaD através de uma arquitetura de missões e desafios, estruturados a partir de um design instrucional baseado em competências e habilidades.", backgroundColor: .blue)
                        Spacer()
                    }.frame(minHeight: 0, maxHeight: .infinity)
                    VStack (spacing: 10) {
                        Text("Tecnologias")
                        MoodBoardCardView(text:"É o caso da Woolf University, considerada a primeira universidade do mundo baseada na tecnologia Blockchain. “Tive um estudante em 2017 que me sugeriu, brincando, evitar toda a burocracia da universidade e me pagar diretamente em criptomoedas. Isso me interessou! Comecei a estudar alguns dos protocolos usados pela tecnologia Blockchain e fiquei fascinado”, diz Joshua Broggi, fundador e diretor da instituição em reportagem no site Revista do Ensino Superior.", backgroundColor: .yellow)
                        MoodBoardCardView(text: "O resultado da aplicação dessa tecnologia é a criação de um novo ambiente de aprendizado, que torna o estudo mais divertido e interessante. Com isso, os alunos se engajam mais nos estudos, e além disso memorizam e entendem melhor os propostos.", backgroundColor: .yellow)
                        Spacer()
                    }.frame(minHeight: 0, maxHeight: .infinity)
                    VStack (spacing: 10) {
                        Text("Solução & Features")
                        MoodBoardCardView(text:"É o caso da Woolf University, considerada a primeira universidade do mundo baseada na tecnologia Blockchain. “Tive um estudante em 2017 que me sugeriu, brincando, evitar toda a burocracia da universidade e me pagar diretamente em criptomoedas. Isso me interessou! Comecei a estudar alguns dos protocolos usados pela tecnologia Blockchain e fiquei fascinado”, diz Joshua Broggi, fundador e diretor da instituição em reportagem no site Revista do Ensino Superior.", backgroundColor: .purple)
                        MoodBoardCardView(text: "O resultado da aplicação dessa tecnologia é a criação de um novo ambiente de aprendizado, que torna o estudo mais divertido e interessante. Com isso, os alunos se engajam mais nos estudos, e além disso memorizam e entendem melhor os propostos.", backgroundColor: .purple)
                        Spacer()
                    }.frame(minHeight: 0, maxHeight: .infinity)
                }
                Spacer()
            }
        }.padding()
    }
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView()
    }
}
