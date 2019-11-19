//
//  CommonInterstStudentsView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 19/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI

struct StudentCardView: View {
    let name:String
    let course:String
    let backgroundColor:Color
    let foregroundColor:Color
    
    var body: some View {
        VStack (alignment: .center){
            VStack {
                Image("fotoCris").resizable()
                .frame(width: 100)
                .offset(x: 0, y: 0)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: 100, alignment: .center)
            Text(name).bold()
            Text(course)
                
        }.foregroundColor(foregroundColor)
        .frame(width: 200, height: 300, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(backgroundColor)
        )
    }
}

struct CommonInterstStudentsView: View {
    var body: some View {
        VStack (spacing: 20){
            HStack (spacing: 20){
                StudentCardView(name: "Cristiano Araújo", course: "E. Computação", backgroundColor: .black, foregroundColor: .white)
                StudentCardView(name: "Warley Soares", course: "S. Informação", backgroundColor: .white, foregroundColor: .black)
                StudentCardView(name: "Cristiano Araújo", course: "E. Computação", backgroundColor: .black, foregroundColor: .white)
                StudentCardView(name: "Warley Soares", course: "S. Informação", backgroundColor: .white, foregroundColor: .black)
            }
            HStack (spacing: 20) {
                StudentCardView(name: "Warley Soares", course: "S. Informação", backgroundColor: .white, foregroundColor: .black)
                StudentCardView(name: "Cristiano Araújo", course: "E. Computação", backgroundColor: .black, foregroundColor: .white)
                StudentCardView(name: "Warley Soares", course: "S. Informação", backgroundColor: .white, foregroundColor: .black)
                StudentCardView(name: "Cristiano Araújo", course: "E. Computação", backgroundColor: .black, foregroundColor: .white)
            }
//            HStack (spacing: 20)     {
//                StudentCardView(name: "Cristiano Araújo", backgroundColor: .green)
//                StudentCardView(name: "Cristiano Araújo", backgroundColor: .green)
//                StudentCardView(name: "Cristiano Araújo", backgroundColor: .green)
//                StudentCardView(name: "Cristiano Araújo", backgroundColor: .green)
//            }
        }
    }
}

struct CommonInterstStudentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommonInterstStudentsView()
    }
}
