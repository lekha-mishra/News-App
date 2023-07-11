//
//  APICaller.swift
//  NewsApp
//
//  Created by Deep Chaturvedi on 5/18/22.
//

import Foundation

final class APICcaller{
    static let shared = APICcaller()
    
    struct Constants {
        static let topHeadlines =  URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=4b75c5b193a140a187e2297f4a16392c")
    }
    
    private init(){
}
    
    public func getToStories(completion:@escaping (Result<[Article], Error>) -> Void) {
    
        
        guard let url = Constants.topHeadlines else {
        return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                
             do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                print("Article: \(result.articles.count)")
                completion(.success(result.articles))

                
            }
            catch{
                completion(.failure(error))
            }
        }
    }
        task.resume()
   }

}

