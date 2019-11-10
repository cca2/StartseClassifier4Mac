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
    let fileManagement = NewsFileManagement()
    @Published var selectedNews:NewsViewModel?
    
    init() {
        fileManagement.getNewsFromDocumentsDirectory()
        
        let newsModels = fileManagement.newsModels
        newsModels.forEach{
            model in
            let newsViewModel = NewsViewModel(newsModel: model)
            self.newsList.append(newsViewModel)
        }
    }
    
    func saveForClassification(news: NewsViewModel, completion: @escaping () -> ()) {
        fileManagement.uploadNewsForClassification(news: news.news) {
            self.newsList.removeAll {
                $0 == news
            }
            completion()
        }
    }
}
