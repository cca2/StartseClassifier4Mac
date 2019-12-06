//
//  CardView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 03/12/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @State var card:JobToBeDoneCardViewModel
    @State var imageName:String
    @State var isCoreJob:Bool = false
    
    var body: some View {
        HStack (alignment: .center){
            HStack (alignment: .center, spacing: 0){
                Image(imageName)
                .resizable()
                .frame(width: 150, height: 100, alignment: .center)
                
                
                ZStack {
                    VStack (alignment: .leading) {
                        Text(card.verbText).frame(width: 300, alignment: .leading).padding([.leading])
                        Text(card.objectText).frame(width: 300, alignment: .leading).padding([.leading])
                        Text(card.contextClarifierText).frame(width: 300, alignment: .leading).padding([.leading])
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: 300, height: 100)
                    .background(Color.white)

                    Text("Segmento").foregroundColor(.gray).font(.system(size: 11))
                    .frame(width: 300, height: 100, alignment: .leading)
                    .offset(x: 10, y: -40)
                    
                    Button(action: self.toggleIsCoreJob, label: {Text("Core")}).foregroundColor(.black).offset(x: 100, y: -30)
                    
                    if isCoreJob {
                        Text("Core Job").padding([.bottom, .trailing], 5).foregroundColor(.pink).font(.system(size: 10))
                            .frame(width: 300, height: 100,  alignment: .bottomTrailing)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, alignment: .center)
    }
    
    func toggleIsCoreJob() {
        self.isCoreJob.toggle()
    }
}

struct CardView_Previews: PreviewProvider {
//    @State static var card = JobToBeDoneCardViewModel(sentence: SentenceModel(text: "teste", classifications: [.job]), category: .job)
    static var previews: some View {
        CardView(card: JobToBeDoneCardViewModel(), imageName: "segmento-clinica-medica")
    }
}
