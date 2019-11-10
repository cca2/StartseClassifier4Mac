//
//  NewsForClassificationViewModel.swift
//  StartseNewsClassifier4Mac
//
//  Created by Cristiano Araújo on 09/11/19.
//  Copyright © 2019 Cristiano Araújo. All rights reserved.
//

import Foundation

class NewsForClassificationViewModel: ObservableObject {
    var newsList:[NewsViewModel] = []
    
    init() {
        let fileManagement = FileManagement()
        fileManagement.getNewsFromDocumentsDirectory()
        
        let newsModels = fileManagement.newsModels
        newsModels.forEach{
            model in
            let newsViewModel = NewsViewModel(newsModel: model)
            self.newsList.append(newsViewModel)
        }
    }
}
