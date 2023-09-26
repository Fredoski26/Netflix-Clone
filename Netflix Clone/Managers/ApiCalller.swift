//
//  ApiCalller.swift
//  Netflix Clone
//
//  Created by Fredrick on 23/09/2023.
//

import Foundation

struct Constants{
    static let API_KEY = "000bb41711ea808dfc477bbdca3c49d3"
    static let baseURl = "https://api.themoviedb.org"
}

enum ApiError: Error{
    case failedtogetData
}

class ApiCaller{
    static let shared = ApiCaller()
    
    
    
    func getTrendingMovie(completion: @escaping (Result<[Title], Error>)-> Void){
        guard let url = URL(string: "\(Constants.baseURl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _, error in guard let data = data, error == nil else{
            return
        }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
              //  print(results)
                
            }catch {
                completion(.failure(ApiError.failedtogetData))
            }
        }
        task.resume()
    }
    
    
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>)-> Void){
//        guard let url = URL(string: "\(Constants.baseURl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        guard let url = URL(string: "\(Constants.baseURl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _, error in guard let data = data, error == nil else{
            return
        }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
              //  print(results)
                
            }catch {
                completion(.failure(ApiError.failedtogetData))
            }
        }
        task.resume()
    }
    
    
    
    
    func getMovieUpcoming(completion: @escaping (Result<[Title], Error>)-> Void){
        guard let url = URL(string: "\(Constants.baseURl)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _, error in guard let data = data, error == nil else{
            return
        }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
              //  print(results)
                
            }catch {
                completion(.failure(ApiError.failedtogetData))
            }
        }
        task.resume()
    }
    
    
    
    
    
    func getMoviePopular(completion: @escaping (Result<[Title], Error>)-> Void){
        guard let url = URL(string: "\(Constants.baseURl)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _, error in guard let data = data, error == nil else{
            return
        }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
                
            }catch {
                completion(.failure(ApiError.failedtogetData))
            }
        }
        task.resume()
    }
    
    
    
    func getMovieTopRated(completion: @escaping (Result<[Title], Error>)-> Void){
        guard let url = URL(string: "\(Constants.baseURl)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){data, _, error in guard let data = data, error == nil else{
            return
        }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
               // print(results)
                
            }catch {
                completion(.failure(ApiError.failedtogetData))
            }
        }
        task.resume()
    }
    
    
    
    
  
    
    
}


