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
//        Text("Hello World")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        ConsolidationView(consolidationViewModel: ConsolidationViewModel(context: context))
//        List(texts, id: \.self) {
//            text in
//            Text(text)
//        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
