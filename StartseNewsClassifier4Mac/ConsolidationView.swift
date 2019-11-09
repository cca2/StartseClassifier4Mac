//
//  ConsolidationView.swift
//  StartseNewsClassifier
//
//  Created by Cristiano Araújo on 05/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct ConsolidationView: View {
    //Comentado apenas para ver o preview
    @Environment(\.managedObjectContext) var context
    
    let consolidationViewModel:ConsolidationViewModel
    @State var title:String = ""
    @State var sentences:[SentenceViewModel] = []

    @State var selection:Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                List (self.sentences) { sentence in
                    Text(sentence.text).font(.body)
                }
                .onAppear() {
                    if self.selection == 0 {
                        self.title = "Segmento de Clientes"
                    }else if self.selection == 1 {
                        self.title = "Dor ou Desejo"
                    }else if self.selection == 2 {
                        self.title = "Solução & Features"
                    }else if self.selection == 3 {
                        self.title = "Tecnologias"
                    }else {
                        self.title = "Investimento"
                    }
                    self.consolidationViewModel.filterSelection = self.selection
                    self.sentences = self.consolidationViewModel.filteredSentences
                }
            }
        }
    }
}

//struct ConsolidationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConsolidationView(
//    }
//}
