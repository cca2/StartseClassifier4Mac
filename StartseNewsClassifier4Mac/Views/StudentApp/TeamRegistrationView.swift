//
//  TeamRegistrationView.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 18/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import SwiftUI
import Combine

class TeamMember {
    var name:String
    var course:String
    
    init(name:String, course:String) {
        self.name = name
        self.course = course
    }
}

class TeamMemberViewModel:ObservableObject {
    @Published var teamList:String = ""
    @Published var dataSource:[TeamMember] = []
    
    private let teamDict:[String:TeamMember] = ["@Cristiano":TeamMember(name: "Cristiano Araújo", course: "E. Computação"), "@Warley":TeamMember(name: "Warley Costa", course: "S. Informação"), "@Múcio":TeamMember(name: "Múcio Silva", course: "Design"), "@Emmanuel":TeamMember(name: "Emmanuel Carlos", course: "C. Computação")]

    init() {
        _ = $teamList
        .dropFirst(1)
        .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: fetchTeamMembers(forMembers:))
    }
    
    func fetchTeamMembers(forMembers members:String) {
        let memberList = members.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        let filteredMembers = memberList.filter({
            $0.first == "@"
        })

        var teamList:[TeamMember] = []
        for member in filteredMembers {
            if let teamMember = teamDict[String(member)] {
                teamList.append(teamMember)
            }
        }
        self.dataSource = teamList
    }
}

struct TeamMemberCardView: View {
    @State var name:String
    @State var course:String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).frame(width: 200, height: 200)
            VStack {
                Circle().frame(width: 70, height: 70, alignment: .center)
                Text(name)
                Text(course)
            }
            .offset(x: 0, y: -20)
            .foregroundColor(.black)
        }
    }
}

struct TeamRegistrationView: View {
    @ObservedObject var teamMembers = TeamMemberViewModel()
    
    var body: some View {
        VStack {
            //rich text textfield
            searchField.padding([.top], 40)
            Spacer()
            //Team Cards
            if self.teamMembers.dataSource.isEmpty {
                emptyTeam
            }else {
                team
            }
            Spacer()
        }.frame(height: 400)
    }
}

private extension TeamRegistrationView {
    var searchField: some View {
        HStack {
            Rectangle().frame(width: 5, height: 50, alignment: .leading).background(Color.red)
            TextField("exemplo: @Cristiano", text: $teamMembers.teamList).frame(height: 50, alignment: .leading).font(.system(size:20))
        }
    }
    
    var team: some View {
        Group {
            HStack {
                TeamMemberCardView(name: self.teamMembers.dataSource[0].name, course: self.teamMembers.dataSource[0].course)
                if self.teamMembers.dataSource.count > 1 {
                    TeamMemberCardView(name: self.teamMembers.dataSource[1].name, course: self.teamMembers.dataSource[1].course)
                }
                if self.teamMembers.dataSource.count > 2 {
                    TeamMemberCardView(name: self.teamMembers.dataSource[2].name, course: self.teamMembers.dataSource[2].course)
                }
                if self.teamMembers.dataSource.count > 3 {
                    TeamMemberCardView(name: self.teamMembers.dataSource[3].name, course: self.teamMembers.dataSource[3].course)
                }
            }
        }
    }
    
    var emptyTeam: some View {
        VStack {
            Text("Não há membros")
        }
    }
}

struct TeamRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        TeamRegistrationView()
    }
}
